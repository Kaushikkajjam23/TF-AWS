resource "aws_security_group" "nginx-sg" {  # Fixed: changed from ngnix-sg to nginx-sg
    vpc_id = aws_vpc.my_vpc.id

    # Inbound rule for HTTP
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    # Outbound rule for all traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "nginx-sg"  # Fixed: changed to nginx-sg
    }
}