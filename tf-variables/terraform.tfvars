aws_instance_type = "t2.micro"
ec2_config  = {
    v_size="30"
    v_type="gp2"
}

additional_tags = {
    DEPT="QA"
    PROJECT="MyProject"
}