Connect-MgGraph -Scopes AuditLog.Read.All, User.Read.All

$users = Get-MgUser -All

$report = foreach($user in $users){
      $signIns = Get-MgAuditLogSignIn -Filter "UserPrincipalName eq '$($user.UserPricipalName)'" -Top 1
      $lastSignIn = if($signIns) { $signIns.CreatedDateTime } else { $null }
      [PSCustomObject]@{
            DisplayName = $user.DisplayName
            UserPrincipalName = $user.UserPricipalName
            LastSignIn = $lastSignIn
      }
}

$report | Export-Csv -Path "./AzureADUserLastSignInReport.Csv" -NoTypeInformation

Write-Host "Last Sign-In report is generated" -Foregroundcolor Green

<#
Fetching the Last Sign-In report of users has uses, especially
1. Identifying the Inactive users
2. License Optimization
3. Compliance and Auditing purposes
4. Cost Optimization by removing licenses for stale accounts
5. Improve security Posture by removing permissions of disabled or offboarded users
#>
