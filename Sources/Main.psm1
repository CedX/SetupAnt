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
function Find-AntRelease {
	[CmdletBinding()]
	[OutputType([Release])]
	param (
		# The version constraint.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
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
function Get-AntRelease {
	[CmdletBinding()]
	[OutputType([Release])]
	param (
		# The version number. Use `*` or `Latest` to get the latest release.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
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
function Install-AntRelease {
	[CmdletBinding(DefaultParameterSetName = "Constraint")]
	[OutputType([string])]
	param (
		# The version constraint of the release to be installed.
		[Parameter(Mandatory, ParameterSetName = "Constraint", Position = 0, ValueFromPipeline)]
		[string] $Constraint,

		# The instance of the release to be installed.
		[Parameter(Mandatory, ParameterSetName = "InputObject", ValueFromPipeline)]
		[Release] $InputObject,

		# Value indicating whether to fetch the Ant optional tasks.
		[switch] $OptionalTasks
	)

	process {
		$release = $PSCmdlet.ParameterSetName -eq "InputObject" ? $InputObject : [Release]::Find($Constraint)
		if (${release}?.Exists()) { [Setup]::new($release).Install($OptionalTasks) }
		else { Write-Error "No release matches the specified version constraint." -Category ObjectNotFound }
	}
}

<#
.SYNOPSIS
	Creates a new release.
.INPUTS
	The version number.
.OUTPUTS
	The newly created release.
#>
function New-AntRelease {
	[CmdletBinding()]
	[OutputType([Release])]
	[SuppressMessage("PSUseShouldProcessForStateChangingFunctions", "")]
	param (
		# The version number.
		[Parameter(Mandatory, Position = 0, ValueFromPipeline)]
		[semver] $Version
	)

	process {
		[Release] $Version
	}
}

<#
.SYNOPSIS
	Gets a value indicating whether a release with the specified version exists.
.INPUTS
	[string] The version number of the release to be tested.
.INPUTS
	[Release] The release to be tested.
.OUTPUTS
	`$true` if a release with the specified version exists, otherwise `$false`.
#>
function Test-AntRelease {
	[CmdletBinding(DefaultParameterSetName = "Version")]
	[OutputType([bool])]
	param (
		# The version number of the release to be tested.
		[Parameter(Mandatory, ParameterSetName = "Version", Position = 0, ValueFromPipeline)]
		[semver] $Version,

		# The release to be tested.
		[Parameter(Mandatory, ParameterSetName = "InputObject", ValueFromPipeline)]
		[Release] $InputObject
	)

	process {
		$release = $PSCmdlet.ParameterSetName -eq "InputObject" ? $InputObject : [Release] $Version
		$release.Exists()
	}
}
