Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Set-NetFirewallProfile -DefaultInboundAction Block
Set-NetFirewallProfile -DefaultOutboundAction Allow

# scripts/04-firewall.ps1 (extended)
$gamePorts = @{
    "FS25 UDP" = 10823
    "FS25 TCP" = 10823
}

foreach ($name in $gamePorts.Keys) {
    $port = $gamePorts[$name]
    if (-not (Get-NetFirewallRule -DisplayName $name -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName $name -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow
        New-NetFirewallRule -DisplayName "$name UDP" -Direction Inbound -LocalPort $port -Protocol UDP -Action Allow
        Write-Host "✅ Opened $name port $port TCP/UDP"
    }
}

Write-Host "Firewall baseline applied."
