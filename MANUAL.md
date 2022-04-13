## 課題
## Terraform apply と ECS task更新の順序

## 環境構築手順
## S3とDynamoDBでterraform.tfstateをS3を管理するように設定

```
terraform apply -target={aws_s3_bucket.terraform_state,aws_dynamodb_table.terraform_state_lock}
```

## ECRを作成する

```
terraform apply -target={aws_ecr_repository.ecr_repository,aws_ecr_lifecycle_policy.ecr_lifecycle_policy}
```

## デプロイ後にやること
## 言語別のコンテナイメージをPull
## コンテナ名を変更する