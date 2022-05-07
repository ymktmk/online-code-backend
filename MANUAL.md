## Key

```
ssh-keygen -t rsa -f online-code -N ''
```
* ssh -i ./online-code ec2-user@52.199.17.202

## ECRを作成する

```
terraform apply -target={aws_ecr_repository.ecr_repository,aws_ecr_lifecycle_policy.ecr_lifecycle_policy}
```

## ECRにPush

```
docker build -t online-code .
```

```
docker tag online-code:latest 009554248005.dkr.ecr.ap-northeast-1.amazonaws.com/online-code:latest
```

```
docker push 009554248005.dkr.ecr.ap-northeast-1.amazonaws.com/online-code:latest
```

```
docker push 009554248005.dkr.ecr.ap-northeast-1.amazonaws.com/online-code:latest
```

## Terraform

```
terraform apply
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