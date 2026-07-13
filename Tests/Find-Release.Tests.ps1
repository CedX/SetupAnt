<#
.SYNOPSIS
	Tests the features of the `Find-Release` cmdlet.
#>
Describe "Find-Release" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$null if no release matches the version constraint" {
		Should-BeNull (Find-AntRelease $nonExistingRelease.Version)
	}

	It "should return the release corresponding to the version constraint if it exists" {
		Should-BeSame $latestRelease (Find-AntRelease "latest")
		Should-BeSame $latestRelease (Find-AntRelease "*")
		Should-BeSame $latestRelease (Find-AntRelease "1")
		Should-BeNull (Find-AntRelease "2")
		Should-BeNull (Find-AntRelease ">1.10.17")?.Version
		Should-Be "1.8.2" (Find-AntRelease "=1.8.2")?.Version
		Should-Be "1.9.16" (Find-AntRelease "<1.10")?.Version
		Should-Be "1.10.0" (Find-AntRelease "<=1.10")?.Version
	}

	It "should throw if the version constraint is invalid" -ForEach "abc", "?1.10" {
		Should-Throw -ScriptBlock { Find-AntRelease $_ -ErrorAction Stop }
	}
}
