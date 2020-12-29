# Lambda
## Init
In order to prepare AWS environment for lambdas, configure your S3 bucket name in `init.json` file and provision CloudFormation template:
```bash
aws --profile $PROFILE cloudformation create-stack --stack-name lambda-init --template-body file://lambda/init.yaml --parameters file://lambda/params/init.json
```

## Source IP
This lambda allows returns requester source IP address by executing POST request against it. Usage example:
```bash
http POST https://url
```

To provision lambda, execute following:
* Create a certificate for custom domain name:
    ```bash
    aws --profile $PROFILE --region us-east-1 cloudformation create-stack --stack-name source-ip-certificate --template-body file://lambda/source-ip-certificate.yaml --parameters file://lambda/params/source-ip-certificate.json --tags Key=service,Value=acm
    ```
* Create lambda and link it with API Gateway
```bash
aws --profile $PROFILE cloudformation create-stack --stack-name lambda-source-ip --template-body file://lambda/source-ip.yaml --parameters file://lambda/params/source-ip.json --tags Key=service,Value=lambda --capabilities CAPABILITY_IAM
```