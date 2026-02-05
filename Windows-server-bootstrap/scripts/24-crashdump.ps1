# Configure full memory dump
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 1 /f
Write-Host "✅ Crash dump configured."
