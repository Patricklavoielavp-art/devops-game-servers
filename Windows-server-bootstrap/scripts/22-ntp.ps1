w32tm /config /manualpeerlist:"time.windows.com,0x9" /syncfromflags:manual /update
w32tm /resync
Write-Host "✅ NTP configured."
