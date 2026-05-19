using namespace System.IO
using module ./Release.psm1

<#
.SYNOPSIS
	Manages the download and installation of Apache Ant.
#>
class Setup {

	<#
	.SYNOPSIS
		The release to download and install.
	#>
	[ValidateNotNull()]
	[Release] $Release

	<#
	.SYNOPSIS
		Creates a new setup.
	.PARAMETER Release
		The release to download and install.
	#>
	Setup([Release] $Release) {
		$this.Release = $Release
	}

	<#
	.SYNOPSIS
		Downloads and extracts the ZIP archive of Apache Ant.
	.OUTPUTS
		The path to the extracted directory.
	#>
	[string] Download() {
		return $this.Download($false)
	}

	<#
	.SYNOPSIS
		Downloads and extracts the ZIP archive of Apache Ant.
	.PARAMETER OptionalTasks
		Value indicating whether to fetch the Ant optional tasks.
	.OUTPUTS
		The path to the extracted directory.
	#>
	[string] Download([bool] $OptionalTasks) {
		$file = New-TemporaryFile
		Invoke-WebRequest $this.Release.Url() -OutFile $file

		$directory = Join-Path ([Path]::GetTempPath()) (New-Guid)
		Expand-Archive $file -DestinationPath $directory -Force

		$folders = Get-ChildItem $directory -Directory
		if ($folders.Count -ne 1) { throw [DirectoryNotFoundException] "No subfolders or multiple subfolders found in: $directory" }

		$antHome = Join-Path $directory $folders[0].BaseName
		if ($OptionalTasks) { $this.FetchOptionalTasks($antHome) }
		return $antHome
	}

	<#
	.SYNOPSIS
		Installs Apache Ant, after downloading it.
	.OUTPUTS
		The path to the installation directory.
	#>
	[string] Install() {
		return $this.Install($false)
	}

	<#
	.SYNOPSIS
		Installs Apache Ant, after downloading it.
	.PARAMETER OptionalTasks
		Value indicating whether to fetch the Ant optional tasks.
	.OUTPUTS
		The path to the installation directory.
	#>
	[string] Install([bool] $OptionalTasks) {
		$antHome = $this.Download($OptionalTasks)

		$binFolder = Join-Path $antHome bin
		$Env:PATH += "$([Path]::PathSeparator)$binFolder"
		Add-Content $Env:GITHUB_PATH $binFolder

		$Env:ANT_HOME = $antHome
		Add-Content $Env:GITHUB_ENV "ANT_HOME=$Env:ANT_HOME"
		return $antHome
	}

	<#
	.SYNOPSIS
		Fetches the external libraries required by Ant optional tasks.
	.PARAMETER AntHome
		The path to the Ant directory.
	#>
	hidden [void] FetchOptionalTasks([string] $AntHome) {
		$argumentList = "-jar", "lib/ant-launcher.jar", "-buildfile", "fetch.xml", "-noinput", "-silent", "-Ddest=system"
		Start-Process java -ArgumentList $argumentList -Environment @{ ANT_HOME = $AntHome } -NoNewWindow -Wait -WorkingDirectory $AntHome
	}
}
