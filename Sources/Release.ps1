using namespace System.Diagnostics.CodeAnalysis
using module ./Release.psm1
using module ./Setup.psm1

<#
.SYNOPSIS
	Finds a release that matches the specified version constraint.
.INPUTS
	The version constraint.
.OUTPUTS
	The release corresponding to the specified constraint, or `$null` if not found.
#>
function Find-Release {
	[CmdletBinding()]
	[OutputType([Release])]
	param (
		# The version constraint.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline)]
		[string] $Constraint
	)

	process {
		[Release]::Find($Constraint)
	}
}

<#
.SYNOPSIS
	Gets the release corresponding to the specified version.
.INPUTS
	A string that contains a version number.
.OUTPUTS
	The release corresponding to the specified version, or `$null` if not found.
#>
function Get-Release {
	[CmdletBinding()]
	[OutputType([Release])]
	param (
		# The version number. Use `*` or `Latest` to get the latest release.
		[Parameter(Mandatory, Position = 1, ValueFromPipeline)]
		[string] $Version
	)

	process {
		$Version -in "*", "Latest" ? [Release]::Latest() : [Release]::Get($Version)
	}
}

<#
.SYNOPSIS
	Installs Apache Ant, after downloading it.
.INPUTS
	[string] The version constraint of the release to be installed.
.INPUTS
	[Release] The release to be installed.
.OUTPUTS
	The path to the installation directory.
#>
function Install-Release {
	[CmdletBinding(DefaultParameterSetName = "Constraint")]
	[OutputType([string])]
	param (
		# The version constraint of the release to be installed.
		[Parameter(Mandatory, ParameterSetName = "Constraint", Position = 1, ValueFromPipeline)]
		[string] $Constraint,

		# The instance of the release to be installed.
		[Parameter(Mandatory, ParameterSetName = "InputObject", ValueFromPipeline)]
		[Release] $InputObject,

		# Value indicating whether to fetch the Ant optional tasks.
		[switch] $OptionalTasks
	)

	process {
		$release = $InputObject ? $InputObject : [Release]::Find($Constraint)
		if (${release}?.Exists()) { [Setup]::new($release).Install($OptionalTasks) }
		else { Write-Error "No release matches the specified version constraint." -Category ObjectNotFound }
	}
}
