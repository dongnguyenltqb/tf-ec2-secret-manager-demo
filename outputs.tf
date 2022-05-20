output "scecret_id" {
  value = aws_secretsmanager_secret.app.id
}

output "scecret_version" {
  value = tolist(aws_secretsmanager_secret_version.current.version_stages)[0]
}

output "ip" {
  value = aws_instance.web.public_ip
}
