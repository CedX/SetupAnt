#!/usr/bin/env pwsh
using module ./SetupAnt.psd1

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$release = $Env:SETUP_ANT_VERSION ? $Env:SETUP_ANT_VERSION : "Latest" | Find-AntRelease
if (-not $release) { Write-Error "No release matches the specified version constraint."; exit 1 }

$optionalTasks = $Env:SETUP_ANT_OPTIONAL_TASKS -eq "true"
$path = $release | Install-AntRelease -OptionalTasks:$optionalTasks

$installed = $optionalTasks ? "installed with optional tasks" : "installed"
"Apache Ant $($release.Version) successfully $installed in ""$path""."
