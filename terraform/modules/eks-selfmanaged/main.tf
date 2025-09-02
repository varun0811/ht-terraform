provider "aws" {
  region = var.region
}

# 1️⃣ Fetch EKS cluster info
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# 2️⃣ Latest EKS-optimized AMI
data "aws_ami" "eks_worker" {
  most_recent = true
  owners      = ["602401143452"]

  filter {
    name   = "name"
    values = ["amazon-eks-node-1.32-v*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# 3️⃣ IAM role for worker nodes
resource "aws_iam_role" "node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# 4️⃣ Security Group for worker nodes
resource "aws_security_group" "node_sg" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group for EKS self-managed nodes"
  vpc_id      = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
  tags        = var.tags
}

# Allow nodes to communicate with cluster control plane
resource "aws_security_group_rule" "node_to_cluster" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node_sg.id
  source_security_group_id = data.aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}



# 5️⃣ IAM Instance Profile
resource "aws_iam_instance_profile" "node_profile" {
  name = "${var.cluster_name}-node-profile"
  role = aws_iam_role.node_role.name
}

# 6️⃣ Launch Template
resource "aws_launch_template" "node_lt" {
  name_prefix   = "${var.cluster_name}-lt-"
  image_id      = data.aws_ami.eks_worker.id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.node_profile.name
  }
  # ✅ User data to automatically bootstrap the node
  user_data = base64encode(<<-EOF
              #!/bin/bash
              /etc/eks/bootstrap.sh ${var.cluster_name} \
                --kubelet-extra-args "--node-labels=role=worker,env=prod"
              EOF
  )
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.node_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

# 7️⃣ Auto Scaling Group
resource "aws_autoscaling_group" "node_asg" {
  name                = "${var.cluster_name}-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.node_lt.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# 8️⃣ Kubernetes provider for aws-auth
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# 9️⃣ Add worker node IAM role to aws-auth ConfigMap
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = jsonencode([
      {
        rolearn  = aws_iam_role.node_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ])
  }

  depends_on = [aws_autoscaling_group.node_asg]
}
