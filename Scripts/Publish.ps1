using module ./Cmdlets.psm1

if ($Release) { & "$PSScriptRoot/Default.ps1" }
else { "The ""-Release"" switch must be set!"; exit 1 }

"Checking the status of the compiled assemblies..."
$answer = Read-Host "Have the compiled assemblies been committed to the Git repository? (yes/no)"
if ($answer -notin "Y", "Yes") { exit 2 }

"Publishing the package..."
$version = (Import-PowerShellDataFile SetupAnt.psd1).ModuleVersion
New-GitTag "v$version"
