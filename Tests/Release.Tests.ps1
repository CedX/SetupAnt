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
			$existingRelease.Exists() | Should-BeTrue
		}

		It "should return `$false if the release does not exist" {
			$nonExistingRelease.Exists() | Should-BeFalse
		}
	}

	Context "Url" {
		It "should return the URL of the Ant archive" {
			$existingRelease.Url() | Should -BeExactly "https://downloads.apache.org/ant/binaries/apache-ant-1.10.17-bin.zip"
			$nonExistingRelease.Url() | Should -BeExactly "https://archive.apache.org/dist/ant/binaries/apache-ant-666.6.6-bin.zip"
		}
	}

	Context "Find" {
		It "should return `$null if no release matches the version constraint" {
			[Release]::Find($nonExistingRelease.Version.ToString()) | Should -BeNullOrEmpty
			[Release]::Find("2") | Should -BeNullOrEmpty
			[Release]::Find(">1.10.17") | Should -BeNullOrEmpty
		}

		It "should return the release corresponding to the version constraint if it exists" {
			[Release]::Find("latest") | Should -Be $latestRelease
			[Release]::Find("*") | Should -Be $latestRelease
			[Release]::Find("1") | Should -Be $latestRelease

			[Release]::Find("=1.8.2") | Should -Be ([Release] "1.8.2")
			[Release]::Find("<1.10") | Should -Be ([Release] "1.9.16")
			[Release]::Find("<=1.10") | Should -Be ([Release] "1.10.0")
		}

		It "should throw if the version constraint is invalid" -ForEach "abc", "?1.10" {
			{ [Release]::Find($_) } | Should -Throw
		}
	}

	Context "Get" {
		It "should return `$null if no release matches to the version number" {
			[Release]::Get($nonExistingRelease.Version) | Should -BeNullOrEmpty
		}

		It "should return the release corresponding to the version number if it exists" {
			[Release]::Get("1.8.2")?.Version | Should -Be ([semver] "1.8.2")
		}
	}
}
