Install-WindowsFeature -Name Containers
Install-WindowsFeature -Name Hyper -V -IncludeManagementTools

Write-Host "Containers feature installed."