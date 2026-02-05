$protocols = @("TLS 1.0","TLS 1.1")

foreach ($protocol in $protocols) {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server" -Force | Out-Null
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server" -Name "Enabled" -Value 0 -PropertyType "DWORD" -Force
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Server" -Name "DisabledByDefault" -Value 1 -PropertyType "DWORD" -Force

    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Client" -Force | Out-Null
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Client" -Name "Enabled" -Value 0 -PropertyType "DWORD" -Force
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\Client" -Name "DisabledByDefault" -Value 1 -PropertyType "DWORD" -Force
}


$ciphers = @(
"RC4 128/128",
"RC4 64/128",
"RC4 56/128",
"RC4 40/128",
"DES 56/56",
"Triple DES 168"
)

foreach ($cipher in $ciphers) {
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\$cipher" -Force | Out-Null
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\$cipher" -Name "Enabled" -Value 0 -PropertyType "DWORD" -Force
}
