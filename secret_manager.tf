// Secret
resource "aws_secretsmanager_secret" "app" {
  name = "testsecret4"
}

resource "aws_secretsmanager_secret_version" "current" {
  // want to manage secret version
  // set tag to this attributes
  //version_stages = ["v1.0.5"]
  secret_id     = aws_secretsmanager_secret.app.id
  secret_string = file("./secret.txt")
}
