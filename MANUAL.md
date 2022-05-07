## Key

```
ssh-keygen -t rsa -f online-code -N ''
```
* ssh -i ./online-code ec2-user@35.76.98.149

## ECRを作成する

```
terraform apply -target={aws_ecr_repository.ecr_repository,aws_ecr_lifecycle_policy.ecr_lifecycle_policy}
```

## ECRにPush

```
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 009554248005.dkr.ecr.ap-northeast-1.amazonaws.com
```

```
docker build -t online-code .
```

```
docker tag online-code:latest 009554248005.dkr.ecr.ap-northeast-1.amazonaws.com/online-code:latest
```

```
docker push 009554248005.dkr.ecr.ap-northeast-1.amazonaws.com/online-code:latest
```

## Terraform

```
terraform apply
```

## Elastic IPの関連づけ

## デプロイ後にやること

* コンテナ名を変更する
* 言語別のコンテナイメージをPull

## リクエスト


```
curl -X POST https://api.code-run.ga/api/v1/python \
-H 'Content-Type: application/json' \
-d '{"code": "print(1)"}'
```

ローカル
```
curl -X POST http://localhost:8080/api/v1/python \
-H 'Content-Type: application/json' \
-d '{"code": "print(1)"}'
```