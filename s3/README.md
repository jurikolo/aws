# S3
This CFN template creates S3 bucket for a website.

To create CFN stack, execute following:
```bash
aws --profile $PROFILE cloudformation create-stack --stack-name website-s3 --template-body file://s3/website-s3.yaml --parameters file://s3/params/website-s3.json
```