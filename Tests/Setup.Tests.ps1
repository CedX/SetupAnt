using namespace System.Diagnostics.CodeAnalysis
using module ../Sources/Release.psm1
using module ../Sources/Setup.psm1

<#
.SYNOPSIS
	Tests the features of the `Setup` class.
#>
Describe "Setup" {
	BeforeAll {
		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$latestRelease = [Release]::Latest()

		if (-not (Test-Path Env:GITHUB_ENV)) { $Env:GITHUB_ENV = Join-Path var GitHub-Env.txt }
		if (-not (Test-Path Env:GITHUB_PATH)) { $Env:GITHUB_PATH = Join-Path var GitHub-Path.txt }
	}

	Context "Download" {
		It "should properly download and extract Apache Ant" {
			$path = [Setup]::new($latestRelease).Download($true)
			Should-BeTrue (Join-Path $path "bin/$($IsWindows ? "ant.cmd" : "ant")" | Test-Path)

			$jars = Get-ChildItem (Join-Path $path lib) -File -Filter *.jar
			Should-Be 1 $jars.Where{ $_.BaseName.StartsWith("ivy-") }.Count
		}
	}

	Context "Install" {
		It "should add the Ant directory to the PATH environment variable" {
			$path = [Setup]::new($latestRelease).Install($false)
			Should-BeString $path $Env:ANT_HOME -CaseSensitive
			Should-BeLikeString "*$path*" $Env:PATH -CaseSensitive
		}
	}
}
