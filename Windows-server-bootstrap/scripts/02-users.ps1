params($Username , $Password)

$secure = ConvertTo-SecureString $Password -AsPlainText -Force

New-LocalUser $Username -Password $secure -FullName $Username -ErrorAction SilentlyContinue
Add-LocalGroupMember -Group "Administrators" -Member $Username

Write-Host "Admin user ensured: $Username"