Import-Csv "attributes_market_roles.csv" |  ForEach-Object{
    $market = $_.Market
    $role = $_.Role
    $grpname = "SOL_" + $market.replace("-","").replace(" ", "_").replace("__","_") + "_" + $role.replace("-","").replace(" ", "_").replace("__","_") + "s"

    try {
        Write-Host "Creating DL for all $market - $role" -ForegroundColor Blue
        if ($role -eq "Clinician"){
            $rule = "(RecipientType -eq 'UserMailbox') -and (StateOrProvince -eq '$market') -and ((Company -eq 'Psychiatrist') -or (Company -eq 'Therapist'))" 
        }
        else{
            $rule = "(RecipientType -eq 'UserMailbox') -and (StateOrProvince -eq '$market') -and (Company -eq '$role')" 
        }
        # $email = $grpname + "@domain.com"
        
        Set-DynamicDistributionGroup -Identity $grpname -RecipientFilter $rule

        Write-Host "Successfully updated group for $market - $role" -ForegroundColor Blue
    }
    catch {
        Write-Host "!!! Could not update $grpname" -ForegroundColor Red
        Write-Host $Error.Exception.Message
    }
}