output "tls_private_key_id" {
  value = tls_private_key.example_ssh.id
}

output "public_key_openssh" {
  value = tls_private_key.example_ssh.public_key_openssh
}