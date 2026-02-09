Param()
Write-Host "Running PSScriptAnalyzer..."
if (-not (Get-Command Invoke-ScriptAnalyzer -ErrorAction SilentlyContinue)) {
  Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser
}
$files = Get-ChildItem -Recurse -Filter *.ps1 | Select-Object -ExpandProperty FullName
if ($files.Length -eq 0) { Write-Host "No .ps1 files found"; exit 0 }
$exit = 0
foreach ($f in $files) {
  Write-Host "Analyzing $f"
  $result = Invoke-ScriptAnalyzer -Path $f -Recurse -Severity Error
  if ($result) {
    $exit = 1
    $result | Format-Table -AutoSize
  }
}
exit $exit
