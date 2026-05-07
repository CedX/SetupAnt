<#
.SYNOPSIS
	Tests the features of the `Get-Release` cmdlet.
#>
Describe "Get-Release" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$null if no release matches to the version number" {
		Get-AntRelease $nonExistingRelease.Version | Should -BeNullOrEmpty
	}

	It "should return the release corresponding to the version number if it exists" {
		(Get-AntRelease "1.8.2")?.Version | Should -Be "1.8.2"
	}
}
