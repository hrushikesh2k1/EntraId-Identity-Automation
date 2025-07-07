$tenantId=""
$clientId=""
$clientSecret=""

$body=@{
  client_id=$clientId
  client_secret=$clientSecret
}

$tokenResponse= Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Body $body
$accessToken=$tokenResponse.access_token

$headers= @{
  Authorization="Bearer $accessToken"
  "Content-Type"="application/json"
}

$disableBody =@{
  accountEnabled=$false
  } | ConvertTo-Json

Invoke-RestMethod -Method Patch -Uri "https://graph.microsoft.com/v1.0/users/userPrincipalName" -Headers $header -Body $disableBody
