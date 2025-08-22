Connect-MgGraph -Scopes 'RoleManagement.ReadWrite.Directory', 'User.Read.All'

$userRoleMap = @{
        'user1@contoso.com'='Teams Administrator'
        'user2@contoso.com'='SharePoint Administrator'
        'user3@contoso.com'='User Administrator'
  }

foreach($userPrincipalName in $userRoleMap.Keys){
      try{
          $user = Get-MgUser -UserId $userPrincipalName

          $role = Get-MgDirectoryRole | Where-Object {$_.DisplayName -eq $userRoleMap[$userPrincipalName]}

          New-MgDirectoryRoleMemberByRef -DirectoryRoleId $role.Id -BodyParameter @{ "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($$user.Id)"}

          Write-Host "Assigned role " -ForegroundColor Green
      }
      catch{
          write-Host "Failed to assign role $_" -ForegroundColor Red
      }
}

