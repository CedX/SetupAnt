<#
.SYNOPSIS
	Tests the features of the `Find-AntRelease` cmdlet.
#>
Describe "Find-AntRelease" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$null if no release matches the version constraint" {
		Find-AntRelease $nonExistingRelease.Version | Should -BeNullOrEmpty
	}

	It "should return the release corresponding to the version constraint if it exists" {
		Find-AntRelease "latest" | Should -Be $latestRelease
		Find-AntRelease "*" | Should -Be $latestRelease
		Find-AntRelease "1" | Should -Be $latestRelease
		Find-AntRelease "2" | Should -BeNullOrEmpty
		(Find-AntRelease ">1.10.17")?.Version | Should -BeNullOrEmpty
		(Find-AntRelease "=1.8.2")?.Version | Should -Be "1.8.2"
		(Find-AntRelease "<1.10")?.Version | Should -Be "1.9.16"
		(Find-AntRelease "<=1.10")?.Version | Should -Be "1.10.0"
	}

	It "should throw if the version constraint is invalid" -ForEach "abc", "?1.10" {
		{ Find-AntRelease $_ -ErrorAction Stop } | Should -Throw
	}
}

<#
.SYNOPSIS
	Tests the features of the `Get-AntRelease` cmdlet.
#>
Describe "Get-AntRelease" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$null if no release matches to the version number" {
		Get-AntRelease $nonExistingRelease.Version | Should -BeNullOrEmpty
	}

	It "should return the release corresponding to the version number if it exists" {
		(Get-AntRelease "1.8.2")?.Version | Should -Be "1.8.2"
	}
}

<#
.SYNOPSIS
	Tests the features of the `Test-AntRelease` cmdlet.
#>
Describe "Test-AntRelease" {
	BeforeAll { . "$PSScriptRoot/BeforeAll.ps1" }

	It "should return `$true for the latest release" {
		Test-AntRelease $latestRelease.Version | Should -BeTrue
		$latestRelease | Test-AntRelease | Should -BeTrue
	}

	It "should return `$true if the release exists" {
		Test-AntRelease $existingRelease.Version | Should -BeTrue
		$existingRelease | Test-AntRelease | Should -BeTrue
	}

	It "should return `$false if the release does not exist" {
		Test-AntRelease $nonExistingRelease.Version | Should -BeFalse
		$nonExistingRelease | Test-AntRelease | Should -BeFalse
	}
}
