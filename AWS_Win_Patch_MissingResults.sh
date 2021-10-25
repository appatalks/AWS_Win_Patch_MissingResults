#!/bin/bash
#
# This script will spit out a report of Last Patch Date, Last Patch Installed, and Missing Patches for Windows EC2 as reported by AWS PatchManager Compliance. 
# Version: 0.01
#
# 1) Download Patching Compliance Report and Filter out non-compliant EC2 ID's into a 'list-<region>.out' file. 
#    (Note: This has to be done for each Region)
#
# AWS Console --> AWS Systems Manager --> Patch Manager --> Reporting Tab: "Export to S3" -->
# a) Report Name: "AccountName-<Region>_<Month><Day>-Compliance_Report" 
# b) On Demand
# c) Target S3 Bucket: <Target S3 Bucket Name>
# d) Submit
# e) Compile All Reports into Single Spreadsheet Tabbed By Region.

# 2) Iterate through the List using SSM Run Commands to get last patch installed:

# us-east-1
for i in $(cat list-us-east-1.out); do echo $i >> patch_results-us-east-1.txt && ./aws-run-ps.sh us-east-1 $i "(Get-HotFix | Sort-Object -Property InstalledOn)[-1]" >> patch_results-us-east-1.txt; done
cat patch_results-us-east-1.txt | grep -v "i-" | grep KB | sed -e 's/Update/ /g' | sed -e 's/Security//g' | sed -e 's/NT//g' | awk '{print $4,$2}' > patch_results-us-east-1-AWKd.txt
rm patch_results-us-east-1.txt

# 3) Iterate through the List using SSM Run Commands to Find the Missing Patches

# us-east-1
for i in $(cat list-us-east-1.out); do echo $i >> missing_results-us-east-1.txt && aws ssm describe-instance-patches --instance-id $i --filters Key=State,Values=Missing --region us-east-1 >> missing_results-us-east-1.txt; done 
cat missing_results-us-east-1.txt | egrep "i-|KBId" | sed -e 's/ //g' | sed -e 's/KBId//g' | sed -e 's/""://g' | sed -e 's/"//g' | sed -e 's/,//g' > missing_filtered-us-east-1.txt
awk '/^[K]/ {printf(" %s", $0);next} {printf("%s%s", NR > 1 ? "\n" : "", $0)} END{print ""}' missing_filtered-us-east-1.txt > missing_filtered-us-east-1-corrected.txt
cat missing_filtered-us-east-1-corrected.txt | awk '{print $2,$3,$4,$5,$6}' > missing_filtered-us-east-1-corrected-AWKd.txt
rm missing_results-us-east-1.txt
rm missing_filtered-us-east-1.txt
rm missing_filtered-us-east-1-corrected.txt

# 4) Update Spreadsheet with Last Patch Date, Last Patch and Missing Patches information

echo "Patch Results - us-east-1 - Last Patch Date - Last Patch - Missing Patches"
paste -d" " patch_results-us-east-1-AWKd.txt missing_filtered-us-east-1-corrected-AWKd.txt


