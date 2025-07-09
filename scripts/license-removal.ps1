Connect-MgGraph
Import-Module ImportExcel
 
$users= Import-Csv "./users1.csv"
$groups= Import-Csv "./groups.csv"
 
$outputPath= "/Users/BO20374933/Desktop/output.xlsx"
$CombinedOutput=@()
$totalUsersCount=$users.Length
 
foreach($group in $groups){
    $successCount=0
    $failedCount=0
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
                $successCount+=1
            }
            catch {
                $result+=[PSCustomObject]@{
                    User = $user.userPrincipalName
                    Status="Failed"
                }
                $failedCount+=1
            }
        }
        else{
            $result+=[PSCustomObject]@{
                User = $user.userPrincipalName
                Status="Failed"
                Reason="user is not a member of the group"
            }
            $failedCount++
        }
    }
    $result | Export-Excel -Path $outputPath -WorksheetName $group.groupName
    $CombinedOutput+=[PSCustomObject]@{groupName=$group.groupName
                                        Success=$successCount
                                        Failed=$failedCount
                                        TotalCount=$totalUsersCount
                                    }
Write-Host $successCount
write-Host $failedCount
}
$CombinedOutput | Export-Excel -Path $outputPath -WorksheetName "license removal status"