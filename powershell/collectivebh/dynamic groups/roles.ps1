Import-Csv "roles.csv" |  ForEach-Object{
    $roles = $_.Roles
    $grpname = "All_" + $roles
    $grpmail = $grpname.ToLower()
    
    # Write-Output "$grpmail"

    try {
        Write-Host "Creating group for all $roles" -ForegroundColor Blue
        $rule = "(user.companyName -eq ""$roles"")" 
        # Write-Output $rule

        New-AzureADMSGroup -DisplayName "$grpname" `
            -Description "Team for all $roles" `
            -MailEnabled $true `
            -MailNickName "$grpmail" `
            -GroupTypes 'DynamicMembership','Unified' `
            -SecurityEnabled $true `
            -MembershipRule $rule `
            -MembershipRuleProcessingState 'On' `
            -Visibility 'Private'
        
        Write-Host "Successfully created group for $roles" -ForegroundColor Blue
    }
    catch {
        Write-Host "!!! Could not create $grpname" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }
}