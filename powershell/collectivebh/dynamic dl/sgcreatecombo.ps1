Import-Csv "attributes_market_roles.csv" |  ForEach-Object{
    $market = $_.Market
    $role = $_.Role
    $grpname = "SG_" + $market.replace("-","").replace(" ", "_").replace("__","_") + "_" + $role.replace("-","").replace(" ", "_").replace("__","_") + "s"

    try {
        Write-Host "Creating SG for $market - $role" -ForegroundColor Blue
        if ($role -eq "Clinician"){
            $rule = "(user.State -eq ""$market"") -and ((user.companyName -eq ""Psychiatrist"") -or (user.companyName -eq ""Therapist""))"
        }
        else {
            $rule = "(user.State -eq ""$market"") -and (user.companyName -eq ""$role"")"
        }
        # Write-Output $rule $grpname
        
        New-AzureADMSGroup -Description "Group for all $market - $role" -DisplayName "$grpname" -MailEnabled $false -SecurityEnabled $true -MailNickname "Foo" -GroupTypes "DynamicMembership" -MembershipRule $rule -MembershipRuleProcessingState "On"

        Write-Host "Successfully created group for $market - $role" -ForegroundColor Blue
    }
    catch {
        Write-Host "!!! Could not create $grpname" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }
}