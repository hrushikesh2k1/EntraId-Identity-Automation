$tenantId=""
$clientId=""
$clientSecret=""

$body=@{
    grant_type="client_credentials"
    scope= "https://graph.microsoft.com/.default"
    client_id=$clientId
    client_secret=$clientSecret
}

$tokenResponse= Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/auth2/v2.0/token" -Body $body
$accessToken=$tokenResponse.access_token

$headers=@{
  Authorization="Brearer $accessToken"
  "Content-Type"="application/json"
}

$updateData=@{
  jobTitle="Security Engineer"
}
$jsonUpdate= $updateData | ConvertTo-Json

Invoke-RestMethod -Method Patch -Uri "https://graph.microsoft.com/v1.0/users/$userPrincipleName" -Body $jsonUpdate
