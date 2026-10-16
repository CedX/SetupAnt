using namespace System.Diagnostics.CodeAnalysis
using module ../SetupAnt.psd1

<#
.SYNOPSIS
	Tests the features of the `Release` class.
#>
Describe "Release" -Skip {
	BeforeAll {
		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "existingRelease")]
		$existingRelease = [Belin.SetupAnt.Release]::new("1.10.18")

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "latestRelease")]
		$latestRelease = [Belin.SetupAnt.Release]::Latest

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "nonExistingRelease")]
		$nonExistingRelease = [Belin.SetupAnt.Release]::new("666.6.6")
	}

	Context "Url" {
		It "should return the URL of the Ant archive" {
			$existingRelease.Url.ToString() | Should-BeString "https://downloads.apache.org/ant/binaries/apache-ant-1.10.18-bin.zip" -CaseSensitive
			$nonExistingRelease.Url.ToString() | Should-BeString "https://archive.apache.org/dist/ant/binaries/apache-ant-666.6.6-bin.zip" -CaseSensitive
		}
	}
}

<#
.SYNOPSIS
	Tests the features of the `Find-Release` cmdlet.
#>
Describe "Find-Release" -Skip { # TODO Unskip
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$null if no release matches the version constraint" {
		Should-BeNull (Find-AntRelease $nonExistingRelease.Version)
	}

	It "should return the release corresponding to the version constraint if it exists" {
		Should-BeSame $latestRelease (Find-AntRelease "latest")
		Should-BeSame $latestRelease (Find-AntRelease "*")
		Should-BeSame $latestRelease (Find-AntRelease "1")
		Should-BeNull (Find-AntRelease "2")
		Should-BeNull (Find-AntRelease ">1.10.18")?.Version
		Should-Be "1.8.2" (Find-AntRelease "=1.8.2")?.Version
		Should-Be "1.9.16" (Find-AntRelease "<1.10")?.Version
		Should-Be "1.10.0" (Find-AntRelease "<=1.10")?.Version
	}

	It "should throw if the version constraint is invalid" -ForEach "abc", "?1.10" {
		Should-Throw -ScriptBlock { Find-AntRelease $_ -ErrorAction Stop }
	}
}

<#
.SYNOPSIS
	Tests the features of the `Get-LatestRelease` cmdlet.
#>
Describe "Get-LatestRelease" {
	It "should always return the latest available release" {
		$latestRelease = Get-AntLatestRelease
		$latestRelease | Should-BeSame (Get-AntLatestRelease)

		$releases = Get-Content "$PSScriptRoot/../Resources/Releases.json" -Raw | ConvertFrom-Json
		$latestRelease.Version | Should-Be $releases[0].Version
	}
}

<#
.SYNOPSIS
	Tests the features of the `Get-Release` cmdlet.
#>
Describe "Get-Release" -Skip {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$null if no release matches to the version number" {
		Should-BeNull (Get-AntRelease $nonExistingRelease.Version)
	}

	It "should return the release corresponding to the version number if it exists" {
		Should-Be "1.8.2" (Get-AntRelease "1.8.2")?.Version
	}
}

<#
.SYNOPSIS
	Tests the features of the `New-Release` cmdlet.
#>
Describe "New-Release" {
	Context "Url" {
		It "should return the URL of the Ant archive" {
			(New-AntRelease "1.10.18").Url.ToString() | Should-BeString "https://downloads.apache.org/ant/binaries/apache-ant-1.10.18-bin.zip" -CaseSensitive
			(New-AntRelease "666.6.6").Url.ToString() | Should-BeString "https://archive.apache.org/dist/ant/binaries/apache-ant-666.6.6-bin.zip" -CaseSensitive
		}
	}
}

<#
.SYNOPSIS
	Tests the features of the `Test-Release` cmdlet.
#>
Describe "Test-Release" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$true for the latest release" {
		$latestRelease = Get-AntLatestRelease
		$latestRelease | Test-AntRelease | Should-BeTrue
		Test-AntRelease $latestRelease.Version | Should-BeTrue
	}

	It "should return `$true if the release exists" {
		$existingRelease = New-AntRelease "1.10.18"
		$existingRelease | Test-AntRelease | Should-BeTrue
		Test-AntRelease $existingRelease.Version | Should-BeTrue
	}

	It "should return `$false if the release does not exist" {
		$nonExistingRelease = New-AntRelease "666.6.6"
		$nonExistingRelease | Test-AntRelease | Should-BeFalse
		Test-AntRelease $nonExistingRelease.Version | Should-BeFalse
	}
}
