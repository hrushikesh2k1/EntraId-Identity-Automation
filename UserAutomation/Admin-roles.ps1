#Adding sharepoint Admin, Teams Admin to users

Connect-MgGraph -Scopes 'RoleManagement.ReadWrite.Drectory', 'User.read.All'

$users = @('user1@contoso.com')
$sharePointRole = Get-MgDirectoryRole | Where-Object {$_.DisplayName -eq "SharePoint Administrator"}

foreach($user in $users){
    try{
        $userId = Get-Mguser -UserId $user

        New-MgDirectoryRoleMemberByRef -DirectoryRoleId $sharePointRole.Id -BodyParameter @{"@odata.id"="https://graph.microsoft.com/v1.0/users/$($user.Id)"}     

        Write-Host "Assigned SharePoint admin role to user"
    }  
    catch{
        Write-Host "Unable to assign admin role $_"
    }
}

