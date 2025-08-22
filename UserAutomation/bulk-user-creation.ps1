#Import Microsoft graph module (if not imported)
Import-Module Microsoft.Graph.Users

Connect-MgGraph -Scopes User.ReadWrite.All

$Users = Import-Csv -Path "./users.csv"

$passwordProfile = @{ForceChangePasswordNextSignIn = $true; Password = 'Password@123'}

foreach($user in $users){
  try{
      New-MgUser -DisplayName $user.DisplayName `
                 -AccountEnabled $true `
                 -MailNickname $user.MailNickname `
                 -UserPrincipalName $user.UserPrincipalName `
                 -PasswordProfile @passwordProfile
      Write-Host "Cretaed user: $($user.DisplayName)"  
  }
  catch{
      Write-Host "Failed to create user $($user.DisplayName): $_"
  }
}
