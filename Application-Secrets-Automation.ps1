Connect-MgGraph -Scopes "Application.ReadWrite.All"

$applications = Get-MgApplication -property "passwordCredentials"

foreach($app in $applications){
  $secret = $app.passwordCredentials | Sort-Object startDateTime -Descending | select-object -First 1

  $expiryDate = [datetime]$secret.endDateTime 
  if(($expiryDate-(Get-Date)).Days -le 30){
      write-Host "App name : $($app.DisplayName), secret is expiring on $expiryDate

      $passwordCredential = @{
        displayName = "Auto-Generated-Secret"
        endDateTime = (Get-Date).AddMonths(6)
      }
      $newSecret = Add-MgApplicationPassword -ApplicationId $app.Id -PasswordCredential $passwordCredential

      Write-Host "New secret for app $($app.DisplayName) : $($newSecret.SecretText)" -foregroundColor Green
  }
}

