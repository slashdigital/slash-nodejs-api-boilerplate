terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.45.0"
    }
  }

  required_version = "~> 1.0"
}

module api_gateway {
  source = "../../modules/api_gateway"

  general = {
    region = "ap-southeast-1"
  }
  application = {
    name = "slash-assessment"
  }
  protocol = "HTTP"
  stage = "dev"
}

module serverless_deploy {
  source = "../../modules/serverless_deploy"

  general = {
    region = "ap-southeast-1"
    runtime = "nodejs14.x"
  }
  application = {
    name = "slash-assessment"
    path = "admin-questionaires"
    uri = "v1"
  }
  function = {
    name = "manageQuestionaires",
    handler = "index.handler"
  }
  apigateway = {
    arn = module.api_gateway.apigateway_arn
    count = 1
    restid = module.api_gateway.apigateway_id
    root_resource_id = module.api_gateway.apigateway_root_resource_id
    stage = "dev"
  }
}