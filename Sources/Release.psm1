<#
.SYNOPSIS
	Represents an Apache Ant release.
#>
class Release {

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
}
