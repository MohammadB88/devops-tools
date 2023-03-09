resource "aws_security_group" "k8s-controlplane" {
  name = "k8s-controlplane"
  description = "allow connection for k8s-controlplane"
  vpc_id = aws_vpc.kubernetes.id

  // 1. TCP 6443      → For Kubernetes API server
  // 2. TCP 2379–2380 → For etcd server client API
  // 3. TCP 10250     → For Kubelet API
  // 4. TCP 10259     → For kube-scheduler
  // 5. TCP 10257     → For kube-controller-manager
  // 6. TCP 22        → For remote access with ssh
  // 7. UDP 8472      → Cluster-Wide Network Comm. — Flannel VXLAN
  ingress {
    from_port = 6443
    protocol = "tcp"
    to_port = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 2379
    protocol = "tcp"
    to_port = 2380
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 10250
    protocol = "tcp"
    to_port = 10250
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 10257
    protocol = "tcp"
    to_port = 10257
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 10259
    protocol = "tcp"
    to_port = 10259
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8472
    protocol = "udp"
    to_port = 8472
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allow outbound connection
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
  lifecycle {
    create_before_destroy = true
  }

  tags = {
      Name = "k8s-controlplane-${var.environment}"
      Managed = "IAC"
  }
}

resource "aws_security_group" "k8s-worker" {
  name = "k8s-worker"
  description = "allow connection for k8s-worker"
  vpc_id = aws_vpc.kubernetes.id

  // 1. TCP 10250       → For Kubelet API
  // 2. TCP 30000–32767 → NodePort Services†
  // 3. TCP 22          → For remote access with ssh
  // 4. UDP 8472        → Cluster-Wide Network Comm. — Flannel VXLAN
  ingress {
    from_port = 10250
    protocol = "tcp"
    to_port = 10250
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 30000
    protocol = "tcp"
    to_port = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8472
    protocol = "udp"
    to_port = 8472
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  // Allow outbound connection
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
      Name = "k8s-worker-${var.environment}"
      Managed = "IAC"
  }
}