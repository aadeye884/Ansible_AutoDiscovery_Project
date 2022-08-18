# Declare Key Pair
resource "aws_key_pair" "key" {
  key_name   = var.keypair
  public_key = file(var.path_to_public_key)
}