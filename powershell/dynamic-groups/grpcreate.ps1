# -----------------------------------------------------------------
# This script is used to create dynamic groups.
# The script takes a csv file as input with the following columns -
#   - team_mail, manager_name, team_name, manager_upn
# The script creates a dynamic group for managers specified in csv 
# (group contains direct reports of manager)
# -----------------------------------------------------------------

$file_location = 'sample.csv'
$csv = Import-Csv $file_location 
$record_index = 0                   # stores current record index

foreach($record in $csv) {
    $record_index = $record_index + 1
    $mail = $record.team_mail        # team email that should be set
    $manager = $record.manager_name  # display name of manager
    $grpname = $record.team_name     # team name that should be set for grp
    $upn = $record.manager_upn       # UserPrincipalName (email) of manager - used to get object_id of manager
    
    # ------------------------    
    # Input Validation section
    # ------------------------

    if (($mail.Length -eq 0) `
        -or ($manager.Length -eq 0) `
        -or ($grpname.Length -eq 0) `
        -or ($upn.Length -eq 0)){
            Write-Host "One of the required parameters is empty for record number $record_index. Skipping ..." -ForegroundColor Red
            continue;
    }

    # --------------------------------------------------
    # get manager object id - used in dynamic group rule
    # --------------------------------------------------

    $usr_obj_id = Get-AzureADUser -Filter "UserPrincipalName eq '$upn'" | Select-Object -ExpandProperty ObjectId
    
    # ------------------------------------------------------------------
    # Validate usr_obj_id variable. Possible reasons for check failure -
    # Multiple object ids stores in variable
    # No users returned for given UserPrincipalName
    # ------------------------------------------------------------------

    if ($usr_obj_id.Length -ne 36){
        Write-Host "!!! Invalid obj id. Possible issues - invalid or multiple users for $upn. Skipping ..." -ForegroundColor Red
        continue;
    }

    # ---------------------------------------
    # This section creates the dynamic group.
    # ---------------------------------------
    try {
        Write-Host "Creating group for $manager" -ForegroundColor Blue
        $rule = "Direct Reports for ""$usr_obj_id""" 
        
        New-AzureADMSGroup -DisplayName "$grpname" `
            -Description "Team of $manager" `
            -MailEnabled $true `
            -MailNickName "$mail" `
            -GroupTypes 'DynamicMembership','Unified' `
            -SecurityEnabled $true `
            -MembershipRule $rule `
            -MembershipRuleProcessingState 'On' `
            -Visibility 'Private'
        
        Write-Host "Successfully created group for $manager" -ForegroundColor Blue
    }
    catch {
        Write-Host "!!! Could not create $grpname" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }
}