#!/usr/bin/env pwsh
using module ./SetupAnt.psd1

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

$release = Find-AntRelease ($Env:SETUP_ANT_VERSION ? $Env:SETUP_ANT_VERSION : "Latest")
if (-not $release) { throw "No release matches the specified version constraint." }

$optionalTasks = $Env:SETUP_ANT_OPTIONAL_TASKS -eq "true"
$path = Install-AntRelease -InputObject $release -OptionalTasks:$optionalTasks

$installed = $optionalTasks ? "installed with optional tasks" : "installed"
"Apache Ant $($release.Version) successfully $installed in ""$path""."
