#!/bin/bash
# Get current source IP:
export SOURCE_IP=`http -b POST https://source-ip.jurikolo.name`

# Get DNS record
export DNS_IP=`dig +short +nocookie home.jurikolo.name`

# Compare results and update Route53
if [ "$DNS_IP" != "$SOURCE_IP" ]; then
    echo "Actual IP address is different than in Route53. Going to update Route53 with new IP address...";
    echo "{ \"Changes\": [{ \"Action\" : \"UPSERT\", \"ResourceRecordSet\" : { \"Name\" : \"home.jurikolo.name\", \"Type\" : \"A\", \"TTL\" : 120, \"ResourceRecords\" : [{\"Value\" : \"$SOURCE_IP\"}] }}]}" > dns.json;
    export HOSTED_ZONE_ID=`aws --profile route53 route53 list-hosted-zones-by-name --dns-name jurikolo.name | jq -r '.HostedZones[0].Id'`;
    aws --profile route53 route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file://dns.json;
    echo "... done!"
else
    echo "Route53 is up to date. Nothing to do."
fi