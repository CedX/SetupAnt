using namespace System.Diagnostics.CodeAnalysis
using module ../Sources/Release.psm1

<#
.SYNOPSIS
	Tests the features of the `Release` class.
#>
Describe "Release" {
	BeforeAll {
		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "existingRelease")]
		$existingRelease = [Release] "1.10.17"

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "latestRelease")]
		$latestRelease = [Release]::Latest()

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "nonExistingRelease")]
		$nonExistingRelease = [Release] "666.6.6"
	}

	Context "Exists" {
		It "should return `$true if the release exists" {
			Should-BeTrue $existingRelease.Exists()
		}

		It "should return `$false if the release does not exist" {
			Should-BeFalse $nonExistingRelease.Exists()
		}
	}

	Context "Url" {
		It "should return the URL of the Ant archive" {
			Should-BeString "https://downloads.apache.org/ant/binaries/apache-ant-1.10.17-bin.zip" $existingRelease.Url().ToString() -CaseSensitive
			Should-BeString "https://archive.apache.org/dist/ant/binaries/apache-ant-666.6.6-bin.zip" $nonExistingRelease.Url().ToString() -CaseSensitive
		}
	}

	Context "Find" {
		It "should return `$null if no release matches the version constraint" {
			Should-BeNull ([Release]::Find($nonExistingRelease.Version.ToString()))
			Should-BeNull ([Release]::Find("2"))
			Should-BeNull ([Release]::Find(">1.10.17"))
		}

		It "should return the release corresponding to the version constraint if it exists" {
			Should-BeSame $latestRelease ([Release]::Find("latest"))
			Should-BeSame $latestRelease ([Release]::Find("*"))
			Should-BeSame $latestRelease ([Release]::Find("1"))

			Should-Be ([Release] "1.8.2") ([Release]::Find("=1.8.2"))
			Should-Be ([Release] "1.9.16") ([Release]::Find("<1.10"))
			Should-Be ([Release] "1.10.0") ([Release]::Find("<=1.10"))
		}

		It "should throw if the version constraint is invalid" -ForEach "abc", "?1.10" {
			Should-Throw -ScriptBlock { [Release]::Find($_) }
		}
	}

	Context "Get" {
		It "should return `$null if no release matches to the version number" {
			Should-BeNull ([Release]::Get($nonExistingRelease.Version))
		}

		It "should return the release corresponding to the version number if it exists" {
			Should-Be ([semver] "1.8.2") ([Release]::Get("1.8.2")?.Version)
		}
	}
}

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
