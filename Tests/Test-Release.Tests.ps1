<#
.SYNOPSIS
	Tests the features of the `Test-Release` cmdlet.
#>
Describe "Test-Release" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$true for the latest release" {
		Test-AntRelease $latestRelease.Version | Should-BeTrue
		$latestRelease | Test-AntRelease | Should-BeTrue
	}

	It "should return `$true if the release exists" {
		Test-AntRelease $existingRelease.Version | Should-BeTrue
		$existingRelease | Test-AntRelease | Should-BeTrue
	}

	It "should return `$false if the release does not exist" {
		Test-AntRelease $nonExistingRelease.Version | Should-BeFalse
		$nonExistingRelease | Test-AntRelease | Should-BeFalse
	}
}
