using module ./Cmdlets.psm1
& "$PSScriptRoot/Default.ps1"

"Publishing the package..."
$version = (Import-PowerShellDataFile SetupAnt.psd1).ModuleVersion
New-GitTag "v$version"
