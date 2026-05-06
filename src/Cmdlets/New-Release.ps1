using namespace System.Diagnostics.CodeAnalysis
using module ../Release.psm1

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
		[version] $Version
	)

	process {
		[Release] $Version
	}
}
