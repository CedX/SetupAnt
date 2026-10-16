using module ../SetupAnt.psd1

<#
.SYNOPSIS
	Tests the features of the `Find-Release` cmdlet.
#>
Describe "Find-Release" {
	It "should return `$null if no release matches the version constraint" {
		"666.6.6" | Find-AntRelease | Should-BeNull
	}

	It "should return the release corresponding to the version constraint if it exists" {
		$latestRelease = Get-AntLatestRelease
		"*", "latest" | ForEach-Object { $_ | Find-AntRelease | Should-BeSame $latestRelease }
		"2", ">1.10.18", "?1.10", "abc" | ForEach-Object { $_ | Find-AntRelease | Should-BeNull }
		("=1.8.2", "1.8.2"), ("<1.10", "1.9.16"), ("<=1.10", "1.10.0") | ForEach-Object { (Find-AntRelease $_[0])?.Version | Should-Be ([version] $_[1]) }
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
Describe "Get-Release" {
	It "should return `$null if no release matches to the version number" {
		"666.6.6" | Get-AntRelease | Should-BeNull
	}

	It "should return the release corresponding to the version number if it exists" {
		(Get-AntRelease "1.8.2")?.Version | Should-Be ([version] "1.8.2")
	}

	It "should return the latest release when '*' is used as version number" {
		$latestRelease = Get-AntLatestRelease
		"*", "latest" | ForEach-Object { $_ | Get-AntRelease | Should-BeSame $latestRelease }
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
