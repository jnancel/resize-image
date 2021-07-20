#############################################
# Using packaged function from Lambda module
#############################################

data "aws_iam_policy_document" "s3_access" {
  statement {
    effect    = "Allow"
    resources = [aws_s3_bucket.resize_images.bucket]
    actions   = ["s3:*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["xray:*"]
    resources = ["*"]
  }
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "${random_pet.this.id}-lambda"
  description   = "My catching up on the intern's work"
  handler       = "index.response"
  runtime       = "nodejs14.x"

  publish = true

  source_path = "./resize_app"

  environment_variables = {
    S3_BUCKET = aws_s3_bucket.resize_images.bucket
  }

  cloudwatch_logs_retention_in_days = 14
  attach_tracing_policy             = true
  tracing_mode                      = "PassThrough"

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.s3_access.json

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.apigateway-v2.apigatewayv2_api_execution_arn}/*/*"
    }
  }

  tags = merge(
    {
      Name = "${random_pet.this.id}-lambda"
    },
    local.tags
  )
}