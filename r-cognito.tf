########################
# AWS Cognito User Pool
########################

resource "aws_cognito_user_pool" "this" {
  name = "user-pool-${random_pet.this.id}"

  tags = merge(
    {
      Name = "user-pool-${random_pet.this.id}"
    },
    local.tags
  )
}