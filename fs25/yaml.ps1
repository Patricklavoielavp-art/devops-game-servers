param(
    [string]$Path = "C:\devops-game-servers\config.yaml"
)

function Load-Yaml {
    param([string]$FilePath)
    return (Get-Content $FilePath -Raw | ConvertFrom-Yaml)
}

$config = Load-Yaml -FilePath $Path
return $config