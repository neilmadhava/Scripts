Import-Csv "emptype.csv" |  ForEach-Object{
    $emptype = $_.EmpType
    $grpname = "All_" + $emptype
    $grpmail = $grpname.ToLower()
    
    # Write-Output $grpmail

    try {
        Write-Host "Creating group for all $emptype" -ForegroundColor Blue
        $rule = "(user.physicalDeliveryOfficeName -eq ""$emptype"")" 
        # Write-Output $rule
        
        New-AzureADMSGroup -DisplayName "$grpname" `
            -Description "Team for all $emptype" `
            -MailEnabled $true `
            -MailNickName "$grpmail" `
            -GroupTypes 'DynamicMembership','Unified' `
            -SecurityEnabled $true `
            -MembershipRule $rule `
            -MembershipRuleProcessingState 'On' `
            -Visibility 'Private'
        
        Write-Host "Successfully created group for $emptype" -ForegroundColor Blue
    }
    catch {
        Write-Host "!!! Could not create $grpname" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }
}