# API Gateway
resource "aws_api_gateway_rest_api" "api" {
    name                         = "TestAPI"
    endpoint_configuration {
        types            = [
            "REGIONAL",
        ]
    }
}

# pythonリソース
resource "aws_api_gateway_resource" "python" {
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "python"
    rest_api_id = aws_api_gateway_rest_api.api.id
}

# pythonメソッド
resource "aws_api_gateway_method" "python-method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "POST"
    resource_id          = aws_api_gateway_resource.python.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# python統合リクエスト
resource "aws_api_gateway_integration" "python-integration" {
    http_method             = "POST"
    integration_http_method = "POST"
    resource_id             = aws_api_gateway_resource.python.id
    rest_api_id             = aws_api_gateway_rest_api.api.id
    type                    = "HTTP_PROXY"
    uri                     = "http://52.198.52.213:10000/api/v1/python"
}

# nodeリソース
resource "aws_api_gateway_resource" "node" {
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "node"
    rest_api_id = aws_api_gateway_rest_api.api.id
}

# nodeメソッド
resource "aws_api_gateway_method" "node-method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "POST"
    resource_id          = aws_api_gateway_resource.node.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# node統合リクエスト
resource "aws_api_gateway_integration" "node-integration" {
    http_method             = "POST"
    integration_http_method = "POST"
    resource_id             = aws_api_gateway_resource.node.id
    rest_api_id             = aws_api_gateway_rest_api.api.id
    type                    = "HTTP_PROXY"
    uri                     = "http://52.198.52.213:10000/api/v1/node"
}

# rubyリソース
resource "aws_api_gateway_resource" "ruby" {
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "ruby"
    rest_api_id = aws_api_gateway_rest_api.api.id
}

# rubyメソッド
resource "aws_api_gateway_method" "ruby-method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "POST"
    resource_id          = aws_api_gateway_resource.ruby.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# ruby統合リクエスト
resource "aws_api_gateway_integration" "ruby-integration" {
    http_method             = "POST"
    integration_http_method = "POST"
    resource_id             = aws_api_gateway_resource.ruby.id
    rest_api_id             = aws_api_gateway_rest_api.api.id
    type                    = "HTTP_PROXY"
    uri                     = "http://52.198.52.213:10000/api/v1/ruby"
}