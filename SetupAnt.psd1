@{
	ModuleVersion = "6.3.0"
	PowerShellVersion = "7.4"
	RootModule = "Sources/Main.psm1"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Set up your GitHub Actions workflow with a specific version of Apache Ant."
	GUID = "30b52520-21cd-44c4-aa11-b1f0dc085686"

	AliasesToExport = @()
	CmdletsToExport = @()
	VariablesToExport = @()

	FunctionsToExport = @(
		"Find-AntRelease"
		"Get-AntRelease"
		"Install-AntRelease"
		"New-AntRelease"
		"Test-AntRelease"
	)

	PrivateData = @{
		PSData = @{
			LicenseUri = "https://github.com/CedX/SetupAnt/blob/main/License.md"
			ProjectUri = "https://github.com/CedX/SetupAnt"
			ReleaseNotes = "https://github.com/CedX/SetupAnt/releases"
			Tags = "actions", "ant", "ci", "ivy", "java"
		}
	}
}
