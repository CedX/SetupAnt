using namespace System.Diagnostics.CodeAnalysis
using module ../SetupAnt.psd1

[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "existingRelease")]
$existingRelease = New-AntRelease "1.10.17"

[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "latestRelease")]
$latestRelease = Get-AntRelease "Latest"

[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "nonExistingRelease")]
$nonExistingRelease = New-AntRelease "666.6.6"
