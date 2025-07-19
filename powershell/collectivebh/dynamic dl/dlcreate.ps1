Import-Csv "attributes_emptype.csv" |  ForEach-Object{
    $attribute = $_.EmpType        # Change this value to the relevant attribute
    $grpname = "SOL_" + $attribute.replace("-","").replace(" ", "_").replace("__","_")

    try {
        Write-Host "Creating DL for all $attribute" -ForegroundColor Blue
        $rule = "(RecipientType -eq 'UserMailbox') -and (Office -eq '$attribute')"  # change "Office" to relevant attribute
        $email = $grpname + "@domain.com"
        # Write-Output $rule $email $grpname
        
        New-DynamicDistributionGroup -Name $grpname -PrimarySmtpAddress $email -RecipientFilter $rule

        Write-Host "Successfully created group for $attribute" -ForegroundColor Blue
    }
    catch {
        Write-Host "!!! Could not create $grpname" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }

    try {
        Write-Host "Setting delivery params for $grpname" -ForegroundColor Blue
        
        Set-DynamicDistributionGroup -Identity "$grpname" -AcceptMessagesOnlyFromDLMembers "SOL_Leadership"
                    
        Write-Host "Successfully set delivery params for $grpname" -ForegroundColor Blue
    }
    catch {
        Write-Host "!!! Could not set delivery params for grp: $grpname" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }
}