using namespace System.Diagnostics.CodeAnalysis
using module ../Sources/Release.psm1

<#
.SYNOPSIS
	Tests the features of the `Release` class.
#>
Describe "Release" {
	BeforeAll {
		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$existingRelease = [Release] "1.10.17"

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
		$latestRelease = [Release]::Latest()

		[SuppressMessage("PSUseDeclaredVarsMoreThanAssignments", "")]
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
