@{
	DefaultCommandPrefix = "Ant"
	ModuleVersion = "7.2.0"
	PowerShellVersion = "7.6"
	RootModule = "Binaries/Belin.SetupAnt.dll"

	Author = "Cédric Belin <cedx@outlook.com>"
	CompanyName = "Cedric-Belin.fr"
	Copyright = "© Cédric Belin"
	Description = "Set up your GitHub Actions workflow with a specific version of Apache Ant."
	GUID = "30b52520-21cd-44c4-aa11-b1f0dc085686"

	AliasesToExport = @()
	FunctionsToExport = @()
	RequiredAssemblies = , "Binaries/FSharpCore.dll"
	VariablesToExport = @()

	CmdletsToExport = @(
		"Find-Release"
		"Get-Release"
		"Install-Release"
		"New-Release"
		"Test-Release"
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
