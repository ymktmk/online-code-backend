## ECRを作成する

```
terraform apply -target={aws_ecr_repository.ecr_repository,aws_ecr_lifecycle_policy.ecr_lifecycle_policy}
```

## デプロイ後にやること
* コンテナ名を変更する
* 言語別のコンテナイメージをPull

## リクエスト

```
curl -X POST http://localhost:8080/api/v1/python \
-H 'Content-Type: application/json' \
-d '{"code": "print(1)"}'
```