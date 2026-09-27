using module PSScriptAnalyzer
using module ./Cmdlets.psm1

"Performing the static analysis of source code..."
$PSScriptRoot, "Tests" | Invoke-ScriptAnalyzer -Recurse
Invoke-FSharpLint SetupAnt.slnx -Configuration Configuration/FSharpLint.json
Test-ModuleManifest SetupAnt.psd1 | Out-Null
