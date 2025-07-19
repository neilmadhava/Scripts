Import-Csv "attributes_emptype.csv" |  ForEach-Object{
    $attribute = $_.EmpType     # Change this value to the relevant attribute
    $grpname = "SG_" + $attribute.replace("-","").replace(" ", "_").replace("__","_")

    try {
        Write-Host "Creating DL for all $attribute" -ForegroundColor Blue
        $rule = "user.physicalDeliveryOfficeName -eq ""$attribute"""  # change "Office" to relevant attribute
        # Write-Output $rule $grpname
        
        New-AzureADMSGroup -Description "Group for all $attribute" -DisplayName "$grpname" -MailEnabled $false -SecurityEnabled $true -MailNickname "Foo" -GroupTypes "DynamicMembership" -MembershipRule $rule -MembershipRuleProcessingState "On"

        Write-Host "Successfully created group for $attribute" -ForegroundColor Blue
    }
    catch {
        Write-Host "!!! Could not create $grpname" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }
}