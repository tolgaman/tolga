resource "aws_secretsmanager_secret" "example" {
  name = "examplea"
  description = "DESCRIPTIOPN4Example"
  kms_key_id = "KMS_KEY_ID"
}
