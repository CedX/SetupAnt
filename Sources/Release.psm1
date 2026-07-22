<#
.SYNOPSIS
	Represents an Apache Ant release.
#>
class Release {

	<#
	.SYNOPSIS
		The list of all releases.
	#>
	hidden static [Release[]] $Data

	<#
	.SYNOPSIS
		The version number.
	#>
	[ValidateNotNull()]
	[semver] $Version

	<#
	.SYNOPSIS
		Creates a new release.
	.PARAMETER Version
		The version number.
	#>
	Release([string] $Version) {
		$this.Version = [semver] $Version
	}

	<#
	.SYNOPSIS
		Creates a new release.
	.PARAMETER Version
		The version number.
	#>
	Release([semver] $Version) {
		$this.Version = $Version
	}

	<#
	.SYNOPSIS
		Initializes the class.
	#>
	static Release() {
		[Release]::Data = (Import-PowerShellDataFile "$PSScriptRoot/ReleaseData.psd1").Releases.ForEach{ [Release]::new($_) }
	}

	<#
	.SYNOPSIS
		Determines whether the two specified objects are equal.
	.PARAMETER Object1
		The first object.
	.PARAMETER Object2
		The second object.
	.OUTPUTS
		`$true` if `$Object1` equals `$Object2`, otherwise `$false`.
	#>
	static [bool] op_Equality([Release] $Object1, [Release] $Object2) {
		return [object]::ReferenceEquals($Object1, $Object2) -or ${Object1}?.Equals($Object2)
	}

	<#
	.SYNOPSIS
		Determines whether the two specified objects are not equal.
	.PARAMETER Object1
		The first object.
	.PARAMETER Object2
		The second object.
	.OUTPUTS
		`$true` if `$Object1` does not equal `$Object2`, otherwise `$false`.
	#>
	static [bool] op_Inequality([Release] $Object1, [Release] $Object2) {
		return -not ($Object1 -eq $Object2)
	}

	<#
	.SYNOPSIS
		Gets a value indicating whether this release exists.
	.OUTPUTS
		`$true` if this release exists, otherwise `$false`.
	#>
	[bool] Exists() {
		return [Release]::Data.Where({ $_ -eq $this }, "First").Count
	}

	<#
	.SYNOPSIS
		Gets the download URL.
	.OUTPUTS
		The download URL.
	#>
	[uri] Url() {
		$baseUrl = $this -eq [Release]::Latest() ? "https://downloads.apache.org/ant/binaries/" : "https://archive.apache.org/dist/ant/binaries/"
		return [uri]::new([uri] $baseUrl, "apache-ant-$($this.Version)-bin.zip")
	}

	<#
	.SYNOPSIS
		Finds a release that matches the specified version constraint.
	.PARAMETER Constraint
		The version constraint.
	.OUTPUTS
		The release corresponding to the specified constraint, or `$null` if not found.
	#>
	static [Release] Find([string] $Constraint) {
		$operator, [semver] $semver = switch -Regex ($Constraint) {
			"^(\*|latest)$" { "=", [Release]::Latest().Version.ToString(); break }
			"^([^\d]+)\d" { $Matches[1], ($Constraint -replace "^([^\d]+)"); break }
			"^\d" { ">=", $Constraint; break }
			default { throw [FormatException]::new("The version constraint is invalid.") }
		}

		$predicate = switch ($operator) {
			">" { { [semver] $_.Version -gt $semver }; break }
			">=" { { [semver] $_.Version -ge $semver }; break }
			"=" { { [semver] $_.Version -eq $semver }; break }
			"<=" { { [semver] $_.Version -le $semver }; break }
			"<" { { [semver] $_.Version -lt $semver }; break }
			default { throw [FormatException]::new("The version constraint is invalid.") }
		}

		$releases = [Release]::Data.Where($predicate, "First")
		return $releases ? $releases[0] : $null
	}

	<#
	.SYNOPSIS
		Gets the release corresponding to the specified version.
	.PARAMETER Version
		The version number of a release.
	.OUTPUTS
		The release corresponding to the specified version, or `$null` if not found.
	#>
	static [Release] Get([semver] $Version) {
		$releases = [Release]::Data.Where({ $_.Version -eq $Version }, "First")
		return $releases ? $releases[0] : $null
	}

	<#
	.SYNOPSIS
		Gets the latest release.
	.OUTPUTS
		The latest release.
	#>
	static [Release] Latest() {
		return [Release]::Data[0]
	}

	<#
	.SYNOPSIS
		Determines whether the specified object is equal to this object.
	.PARAMETER Other
		An object to compare with this object.
	.OUTPUTS
		`$true` if the specified object is equal to this object, otherwise `$false`.
	#>
	[bool] Equals([object] $Other) {
		return ($Other -is [Release]) -and ($this.Version -eq $Other.Version)
	}

	<#
	.SYNOPSIS
		Gets the hash code for this object.
	.OUTPUTS
		The hash code for this object.
	#>
	[int] GetHashCode() {
		return [HashCode]::Combine($this.Version)
	}
}
