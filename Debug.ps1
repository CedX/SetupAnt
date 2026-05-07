#!/usr/bin/env pwsh
using module ./SetupAnt.psd1

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

try { <# Insert the command to be debugged here. #> }
catch { Write-Error "$_`n$($_.ScriptStackTrace)" }
