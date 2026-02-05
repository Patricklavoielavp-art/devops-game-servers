Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
Set-NetFirewallProfile -DefaultInboundAction Block
Set-NetFirewallProfile -DefaultOutboundAction Allow

Write-Host "Firewall baseline applied."
