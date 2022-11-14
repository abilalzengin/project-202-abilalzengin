data "template_file" "userdata" {
  template = file("${abspath(path.module)}/userdata.sh")
  vars = {
    rds-endpoint = aws_db_instance.bilal-db.address
  }
}

resource "aws_launch_template" "bilal-lt" {
  name          = "project202-lt"
  image_id      = "ami-09d3b3274b6c5d4aa"
  instance_type = "t2.micro"
  key_name      = "firstkey"
  monitoring {
    enabled = false
  }
  vpc_security_group_ids = ["${aws_security_group.ec2-sec-group.id}"]
  user_data              = "${base64encode(data.template_file.userdata.rendered)}"
  
}

