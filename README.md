# AWS_Win_Patch_MissingResults
Spit out a report of Last Patch Date, Last Patch Installed, and Missing Patches for Windows EC2 as reported by AWS PatchManager Compliance.

# This script will spit out a report of Last Patch Date, Last Patch Installed, and Missing Patches for Windows EC2 as reported by AWS PatchManager Compliance. 
# Version: 0.01
#
# 1) Download Patching Compliance Report and Filter out non-compliant EC2 ID's into a 'list-<region>.out' file. 
#    (Note: This has to be done for each Region)
# AWS Console --> AWS Systems Manager --> Patch Manager --> Reporting Tab: "Export to S3" -->
# a) Report Name: "AccountName-<Region>_<Month><Day>-Compliance_Report" 
# b) On Demand
# c) Target S3 Bucket: <Target S3 Bucket Name>
# d) Submit
# e) Compile All Reports into Single Spreadsheet Tabbed By Region.
# 2) Iterate through the List using SSM Run Commands to get last patch installed
# 3) Iterate through the List using SSM Run Commands to Find the Missing Patches
# 4) Update Spreadsheet with Last Patch Date, Last Patch and Missing Patches information
