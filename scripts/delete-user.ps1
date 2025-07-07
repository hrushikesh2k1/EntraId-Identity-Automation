$tenantId=""
$clientId=""
$clientSecret=""

$body=@{
  client_id=$clientId
  client_secret=$clientSecret
}

$tokenRepsonse= Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/auth2/v2.0/token" -Body $body
$accessToken=$tokenResponse.access_token

$header=@{
  Authorization="Bearer $accessToken"
}

Invoke-Method -Method Delete -Uri "https://graph.microsoftonline.com/v1.0/users/$userPrincipalName" -Headers $header

