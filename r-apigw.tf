module "apigateway-v2" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "1.1.0"

  name          = "resize-image"
  description   = "Redoing what the intern did"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  domain_name                 = local.domain_name
  domain_name_certificate_arn = module.acm.acm_certificate_arn

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.logs.arn
  default_route_settings = {
    detailed_metrics_enabled = true
    throttling_burst_limit   = 100
    throttling_rate_limit    = 100
  }

  integrations = {
    "POST /image" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      authorization_type     = "JWT"
      authorizer_id          = aws_apigatewayv2_authorizer.some_authorizer.id
    }
  }

  tags = merge(
    {
      Name = "resize-image"
    },
    local.tags
  )
}


######
# ACM
######

data "aws_route53_zone" "this" {
  name = local.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = local.domain_name
  zone_id     = data.aws_route53_zone.this.id

  tags = merge(
    {
      Name = "resize-image"
    },
    local.tags
  )
}

#############################
# AWS API Gateway Authorizer
#############################

resource "aws_apigatewayv2_authorizer" "some_authorizer" {
  api_id           = module.apigateway-v2.apigatewayv2_api_id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = random_pet.this.id

  jwt_configuration {
    audience = ["example"]
    issuer   = "https://${aws_cognito_user_pool.this.endpoint}"
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

resource "aws_cloudwatch_log_group" "logs" {
  name = random_pet.this.id
}

