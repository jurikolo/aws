#!/bin/bash

if [[ "$1" == "--help" ]]; then
  echo "To use the script, provide following parameters:
  --domain - domain to be updated with current IP address
  --zone - hosted zone name
  --profile - AWS profile configured for aws-cli (uses default if omitted)

Example: /bin/bash dns.sh --domain my-ip.example.com --zone example.com --profile route53"
  exit 0;
fi

# read arguments
opts=$(getopt --longoptions "domain:,zone:,profile:," --name "$(basename "$0")" --options "" -- "$@")
eval set --"$opts"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --domain) DOMAIN=$2; shift 2;;
        --zone) ZONE=$2; shift 2;;
        --profile) PROFILE=$2; shift 2;;
        *) break;;
    esac
done

if [[ -z "$PROFILE" ]]; then
  PROFILE="default"
fi

# Get current source IP:
export SOURCE_IP=$(http -b POST https://source-ip.jurikolo.name)

# Get DNS record
export DNS_IP=$(dig +short +nocookie "$DOMAIN")

# Compare results and update Route53
if [ "$DNS_IP" = "$SOURCE_IP" ]; then
    echo "Actual IP address is different than in Route53. Going to update Route53 with new IP address...";
    echo "{ \"Changes\": [{ \"Action\" : \"UPSERT\", \"ResourceRecordSet\" : { \"Name\" : \"$DOMAIN\", \"Type\" : \"A\", \"TTL\" : 120, \"ResourceRecords\" : [{\"Value\" : \"$SOURCE_IP\"}] }}]}" > dns.json;
    export HOSTED_ZONE_ID=$(aws --profile "$PROFILE" route53 list-hosted-zones-by-name --dns-name "$ZONE" | jq -r '.HostedZones[0].Id');
    aws --profile "$PROFILE" route53 change-resource-record-sets --hosted-zone-id "$HOSTED_ZONE_ID" --change-batch file://dns.json;
    echo "... done!"
else
    echo "Route53 is up to date. Nothing to do."
fi