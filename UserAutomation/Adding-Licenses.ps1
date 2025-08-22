#Adding the Office E3 license suite to the users.

Connect-MgGraph -Scopes "User.ReadWrite.All", "Organization.Read.All"

#Get the license SKU Object for the license you want to assign
$license = Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -eq "Enterprise Office E3"}

$users = @('user1@contoso.com','user2@contoso.com')

foreach($userPrincipalName in $users){
    try{
        #Get the User object
        $user = Get-MgUser -UserId $userPrincipalName

        #Check if the user already has license
        $userLicense = Get-MgUserLicenseDetail -UserId $user.Id | Where-Object {$_.SkuId -eq $license.SkuId}

        if($userLicense){
            Write-Host "User $userPrincipalName already has the license $($license.SkuPartNumber)" -Foregroundcolor Yellow
        }
        else{
            #Assign the license
            Set-MgUserLicense -UserId $user.Id -AddLicenses @{SkuId = $license.SkuId} -RemoveLicenses @()

            Write-Host "assigned license $($license.SkuPartNumber) to $userPrincipalName" -Foregroundcolor Green
        }
    }
    catch{
          write-host "Failed to assign license to $userPrincipalName: $_" -ForegroundColor Red
    }
}
