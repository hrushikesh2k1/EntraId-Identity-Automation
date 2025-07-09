Import-Module ImportExcel
 
$users= Import-Csv "./users.csv"
$groups= Import-Csv "./groups.csv"
 
$outputPath= "/Users/BO20374933/Desktop/output.xlsx"
 
foreach($group in $groups){
    $groupId=$group.Id
    $groupMembers= Get-MgGroupMember -GroupId $groupId -All
    #Write-Host $groupId
    if(-not $groupId){
        Write-Host "GroupName $($group.groupName) not found" -ForegroundColor Red
        Continue
    }
    $result=@()
    foreach($user in $users){
        $userId=$user.id
        $isMember= $groupMembers.Id -contains $userId
        #Write-Host $isMember
        if($isMember){
            try {
                Remove-MgGroupMemberByRef -GroupId $groupId -DirectoryObjectId $userId
                $result+=[PSCustomObject]@{
                    User = $user.userPrincipalName
                    Status="Success"
                }
            }
            catch {
                $result+=[PSCustomObject]@{
                    User = $user.userPrincipalName
                    Status="Failed"
                }
            }
        }
        else{
            $result+=[PSCustomObject]@{
                User = $user.userPrincipalName
                Status="Failed"
            }
        }
 
    }
    $result | Export-Excel -Path $outputPath -WorksheetName $group.groupName
}