# Static website
## CloudFront distribution
If you would like to use CloudFront distribution, you need to execute following steps:
* Create a certificate in `us-east-1` region:
    ```bash
    aws --profile $PROFILE --region us-east-1 cloudformation create-stack --stack-name static-website-certificate --template-body file://static-website/static-website-certificate.yaml --parameters file://static-website/params/static-website-certificate.json
    ```
  Note you might need to go to Certificate Manager in `us-east-1` region and click "Add CNAME record in Route53" to validate domain ownership
* Set `CLOUDFRONT` to `true` in static-website.json
This CFN template creates all the necessary resources for static website hosting in S3, including CloudFront and Route53.
* Set `CLOUDFRONTARN` by copying certificate ARN value from CloudFront outputs in `us-east-1` region

## Static website in S3
To create CFN stack, execute following:
```bash
aws --profile $PROFILE cloudformation create-stack --stack-name static-website --template-body file://static-website/static-website.yaml --parameters file://static-website/params/static-website.json
```