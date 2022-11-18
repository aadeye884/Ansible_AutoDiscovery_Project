# Declare Key Pair
resource "aws_key_pair" "USTeam1Keypair" {
  key_name   = var.key_name
  public_key = file(var.path_to_public_key)
}