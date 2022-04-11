# API Gateway
resource "aws_api_gateway_rest_api" "api" {
    name                         = "online-code-proxy"
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

# python POSTメソッド
resource "aws_api_gateway_method" "python_post_method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "POST"
    resource_id          = aws_api_gateway_resource.python.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# python OPTIONSメソッド
resource "aws_api_gateway_method" "python_options_method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "OPTIONS"
    resource_id          = aws_api_gateway_resource.python.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# python統合リクエスト
resource "aws_api_gateway_integration" "python_integration" {
    http_method             = "POST"
    integration_http_method = "POST"
    resource_id             = aws_api_gateway_resource.python.id
    rest_api_id             = aws_api_gateway_rest_api.api.id
    type                    = "HTTP_PROXY"
    uri                     = "http://${aws_eip.eip.public_ip}:10000/api/v1/python"
}

# nodeリソース
resource "aws_api_gateway_resource" "node" {
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "node"
    rest_api_id = aws_api_gateway_rest_api.api.id
}

# nodeメソッド
resource "aws_api_gateway_method" "node_post_method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "POST"
    resource_id          = aws_api_gateway_resource.node.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# node OPTIONSメソッド
resource "aws_api_gateway_method" "node_options_method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "OPTIONS"
    resource_id          = aws_api_gateway_resource.node.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# node統合リクエスト
resource "aws_api_gateway_integration" "node_integration" {
    http_method             = "POST"
    integration_http_method = "POST"
    resource_id             = aws_api_gateway_resource.node.id
    rest_api_id             = aws_api_gateway_rest_api.api.id
    type                    = "HTTP_PROXY"
    uri                     = "http://${aws_eip.eip.public_ip}:10000/api/v1/node"
}

# rubyリソース
resource "aws_api_gateway_resource" "ruby" {
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "ruby"
    rest_api_id = aws_api_gateway_rest_api.api.id
}

# rubyメソッド
resource "aws_api_gateway_method" "ruby_post_method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "POST"
    resource_id          = aws_api_gateway_resource.ruby.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# ruby OPTIONSメソッド
resource "aws_api_gateway_method" "ruby_options_method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "OPTIONS"
    resource_id          = aws_api_gateway_resource.ruby.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# ruby統合リクエスト
resource "aws_api_gateway_integration" "ruby_integration" {
    http_method             = "POST"
    integration_http_method = "POST"
    resource_id             = aws_api_gateway_resource.ruby.id
    rest_api_id             = aws_api_gateway_rest_api.api.id
    type                    = "HTTP_PROXY"
    uri                     = "http://${aws_eip.eip.public_ip}:10000/api/v1/ruby"
}

# dartリソース
resource "aws_api_gateway_resource" "dart" {
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    path_part   = "dart"
    rest_api_id = aws_api_gateway_rest_api.api.id
}

# dartメソッド
resource "aws_api_gateway_method" "dart_post_method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "POST"
    resource_id          = aws_api_gateway_resource.dart.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# dart OPTIONSメソッド
resource "aws_api_gateway_method" "dart_options_method" {
    api_key_required     = false
    authorization        = "NONE"
    http_method          = "OPTIONS"
    resource_id          = aws_api_gateway_resource.dart.id
    rest_api_id          = aws_api_gateway_rest_api.api.id
}

# dart統合リクエスト
resource "aws_api_gateway_integration" "dart_integration" {
    http_method             = "POST"
    integration_http_method = "POST"
    resource_id             = aws_api_gateway_resource.dart.id
    rest_api_id             = aws_api_gateway_rest_api.api.id
    type                    = "HTTP_PROXY"
    uri                     = "http://${aws_eip.eip.public_ip}:10000/api/v1/dart"
}

# デプロイ これはimportできない
resource "aws_api_gateway_deployment" "deployment" {
    depends_on  = [aws_api_gateway_rest_api.api]
    rest_api_id = aws_api_gateway_rest_api.api.id
    stage_name  = "api"
    # 次回デプロイするときはv0.2とする
    triggers = {
        redeployment = "v0.1"
    }
    lifecycle {
        # 既存のリソースがあった場合に、先に削除してから作り直す
        create_before_destroy = true
    }
}