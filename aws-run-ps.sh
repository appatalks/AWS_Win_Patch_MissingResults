#/usr/bin/env bash -x
# Script to run Bash script on the Linux instance.
#
#### Crazy Powershell escapes #####   
#### aws-run-ps.sh us-east-1 i-xxxxxxx "get-service -name splunkforwarderrax ; select-string -path \"c:/program files/splunkforwarderrax/var/log/splunk/splunkd.log\" -pattern \"connected\" | select-object -last 1"
#
#
#
instanceId="$2"
region="$1"
cmdId=$(aws ssm send-command --region "$region" --instance-ids "$instanceId" --document-name "AWS-RunPowerShellScript" --query "Command.CommandId" --output text --parameters commands="'${@:3}'")
[ $? -ne 0 ] && { echo "Usage: $0 region instance_id command"; exit 1; }
while [ "$(aws ssm list-command-invocations --command-id "$cmdId" --query "CommandInvocations[].Status" --output text --region $region)" == "InProgress" ]; do sleep 1; done
aws ssm list-command-invocations --command-id "$cmdId" --details --query "CommandInvocations[*].CommandPlugins[*].Output[]" --output text --region $region
