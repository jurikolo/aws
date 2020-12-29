# AWS
Sources and AWS CFN templates for my AWS resources, including static website in S3

## Templates
* billing-alarm - setup a billing alarm to email / sms when particular threshold reached
* static-website - S3 bucket for website, CloudFront distribution and Route53 recordset
* lambda - various lambdas

## Website
Website is built using Bootstrap 4 and [startbootstrap resume theme](https://startbootstrap.com/theme/resume)

Sources are located under `html` directory

## Lambda
### Source IP
It's possible to retrieve public source IP by invoking following command:
```bash
curl -X POST https://static-ip.jurikolo.name
```
