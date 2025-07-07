#=======================AUTH.PS1=========================
#authentication with Microsoft Graph API Using client credentials

$tenantId=d8a273cb-b8f0-4115-a901-952fd91fada3
$clientId=
$clientSecret=

#This is the body of the Authentication request
#This is used to request an OAuth 2.0 token from Azure
$body=@(
        grant_type="client_credentials"
        scope= "https://graph.microsoft.com/.default"
        client_id=
        client_secret=
        }

#Make a POST request to the Micrsoft Identity Platform endpoint
#This endpoint returns an access tokenif your app is authenticated successfully
$tokenResponse=Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Body $body

#Extract the access token from the response
#This access token will be used in the authentication header in the future graph API requests.
$accessToken= $tokenResponse.access_token


#print the access token to the console.
Write-Host "Access token received:"
Write-Host $accessToken
