# Billing alarm
This CFN template creates CloudWatch billing alarm and sends email and SMS when bill reaches threshold.

To create CFN stack, execute following:
```bash
aws --profile $PROFILE cloudformation create-stack --stack-name billing-alarm --template-body file://billing-alarm/billing-alarm.yaml --parameters file://billing-alarm/params/billing-alarm.json
```