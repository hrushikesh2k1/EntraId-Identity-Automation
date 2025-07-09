$invitations = import-csv "./bulkusers.csv"
 
$messageInfo = New-Object Microsoft.Graph.PowerShell.Models.MicrosoftGraphInvitedUserMessageInfo
 
$messageInfo.customizedMessageBody = "Hello. You are invited to the Contoso organization."
 
foreach ($email in $invitations) {
    New-MgInvitation -InvitedUserEmailAddress $email.emailAddress `
                        -InvitedUserDisplayName $email.Name `
                        -InviteRedirectUrl https://myapplications.microsoft.com/?tenantid=d8a273cb-b8f0-4115-a901-952fd91fada3 `
                        #-InvitedUserMessageInfo $messageInfo `
                        #-SendInvitationMessage
}