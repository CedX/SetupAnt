using module PSScriptAnalyzer
using module ./Cmdlets.psm1

"Performing the static analysis of source code..."
Invoke-FSharpLint SetupAnt.slnx -Configuration Configuration/FSharpLint.json
$PSScriptRoot, "Tests" | Invoke-ScriptAnalyzer -Recurse
Test-ModuleManifest SetupAnt.psd1 | Out-Null
