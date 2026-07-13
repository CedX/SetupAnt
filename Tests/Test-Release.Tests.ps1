<#
.SYNOPSIS
	Tests the features of the `Test-Release` cmdlet.
#>
Describe "Test-Release" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$true for the latest release" {
		Should-BeTrue (Test-AntRelease $latestRelease.Version)
		Should-BeTrue ($latestRelease | Test-AntRelease)
	}

	It "should return `$true if the release exists" {
		Should-BeTrue (Test-AntRelease $existingRelease.Version)
		Should-BeTrue ($existingRelease | Test-AntRelease)
	}

	It "should return `$false if the release does not exist" {
		Should-BeFalse (Test-AntRelease $nonExistingRelease.Version)
		Should-BeFalse ($nonExistingRelease | Test-AntRelease)
	}
}
