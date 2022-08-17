# Declare Key Pair
resource "aws_key_pair" "key" {
  key_name   = "team1_key"
  public_key = file(var.path_to_public_key)
}