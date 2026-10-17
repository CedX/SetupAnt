using module ../SetupAnt.psd1

<#
.SYNOPSIS
	Tests the features of the `Install-Release` class.
#>
Describe "Install-Release" {
	BeforeAll {
		if (-not (Test-Path Env:GITHUB_ENV)) { $Env:GITHUB_ENV = Join-Path Temp GitHub-Env.txt }
		if (-not (Test-Path Env:GITHUB_PATH)) { $Env:GITHUB_PATH = Join-Path Temp GitHub-Path.txt }
	}

	It "should properly download and extract Apache Ant" {
		$path = Install-AntRelease "*" -OptionalTasks
		Join-Path "$path/bin" ($IsWindows ? "ant.cmd" : "ant") | Test-Path | Should-BeTrue

		$jars = Get-ChildItem (Join-Path $path lib) -File -Filter *.jar
		$jars | Where-Object { $_.BaseName.StartsWith("ivy-") } | Should-BeCollection -Count 1
	}

	It "should add the Ant directory to the PATH environment variable" {
		$path = Install-AntRelease "latest"
		$Env:ANT_HOME | Should-BeString $path -CaseSensitive
		$Env:PATH | Should-BeLikeString "*$path*" -CaseSensitive
	}
}
