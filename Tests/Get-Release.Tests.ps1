<#
.SYNOPSIS
	Tests the features of the `Get-Release` cmdlet.
#>
Describe "Get-Release" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$null if no release matches to the version number" {
		Should-BeNull (Get-AntRelease $nonExistingRelease.Version)
	}

	It "should return the release corresponding to the version number if it exists" {
		Should-Be "1.8.2" (Get-AntRelease "1.8.2")?.Version
	}
}
