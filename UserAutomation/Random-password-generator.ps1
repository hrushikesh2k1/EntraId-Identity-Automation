function Get-RandomPassword{
  [CmdletBinding()]
  param(
      [Parameter(Mandatory=$false)]
      [int] $length = 16

      [Parameter(Mandatory=$false)]
      [switch]$IncludeSpecialCharacters = $true
      )

      $lower = 'abcdefghijklmnopqrstuvwxyz'
      $uppoer = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      $numbers = '0123456789'
      $special = '!@#$%^&*()_-[]{};:<>?/'
      
      $charSet = $lower + $upper + $numbers
      if($IncludeSpecialCharacters){
          $charSet += $special
      }

      $charArray = $charSet.ToCharArray

      $passwordChars = for($i=0;$i -lt $length; $i++){
            $charArray | Get-Random
      }

      -join $passwordChars
}

Export-ModuleMember -Function Get-RandomPassword
