resource "aws_key_pair" "key_pair" {
  key_name   = "aws-test-keypair"
  public_key = file("~/.ssh/aws-test-keypair-public.pem")

  tags = {
    Purpose = "test"
  }
}
