using module PSScriptAnalyzer

"Performing the static analysis of source code..."
$PSScriptRoot, "Sources", "Tests" | Invoke-ScriptAnalyzer -Recurse
Test-ModuleManifest SetupAnt.psd1 | Out-Null
