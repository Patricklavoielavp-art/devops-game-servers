Invoke-WebRequest `
  https://github.com/prometheus-community/windows_exporter/releases/latest/download/windows_exporter.msi
  -OutFile windows_exporter.msi 

Start-Process msiexec.exe -Wait -ArgumentList "/i windows_exporter.msi /quiet"