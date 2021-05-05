# Home IP (IPv4) address
This script regularly compares DNS record in Route53 with actual public IPv4 address of server that executes the script.
In case IP addresses doesn't match, script updates Route53 DNS record with new IP address.

# Usage
## Prerequisites (software)
### Raspbian
Install `httpie`, `dnsutils`, `jq` and `awscli`:
```bash
sudo apt-get install httpie dnsutils jq awscli
```

Configure `awscli` as explained [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html).
In my examples I use profile called `route53`

### Fedora
Install `httpie`, `bind-utils`, `jq` and `awscli`:
```bash
sudo dnf install httpie bind-utils jq awscli
```

Configure `awscli` as explained [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html).
In my examples I use profile called `route53`

### Other distros
This script uses following applications:
* httpie
* dig
* sed
* jq
* awscli

### Prerequisites (actions)
#### Checkout repository
Download repository and navigate to script directory:
```bash
git clone https://github.com/jurikolo/aws
cd aws/scripts/home-ip-address
```

#### Create initial DNS record
Get current IP address by executing following command:
```bash
http -b POST https://source-ip.jurikolo.name
```

Update initial DNS configuration file `create-dns-record.json` with following:
* Replace IP_TO_REPLACE with IP address received from command above
* Replace DNS_DOMAIN_NAME_TO_REPLACE with DNS domain name you would like to use. Root domain must be hosted by Route53

Acquire hosted zone ID of domain:
```bash
export HOSTED_ZONE_ID=`aws --profile route53 route53 list-hosted-zones-by-name --dns-name DNS_NAME_TO_REPLACE | jq -r '.HostedZones[0].Id'`;
```

Create new DNS domain name and point to current IP address:
```bash
aws --profile route53 route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file:///home/jurikolo/tmp/home-jurikolo-name-create-route53.json
```

## Script configuration
To configure script to execute periodically, use `crontab` and configure it like this:
```bash
0 * * * * /bin/bash /home/jurikolo/git/aws/scripts/home-ip-address/dns.sh
```
Record above will trigger script once in an hour at first minute.

# Notes
## Error handling
The script might fail due to missing execution privileges. To add, do:
```bash
chmod +x dns.sh
```
