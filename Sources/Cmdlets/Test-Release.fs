namespace Belin.SetupAnt.Cmdlets

open Belin.SetupAnt
open System.Management.Automation

/// Gets a value indicating whether a release with the specified version exists.
[<Cmdlet(VerbsDiagnostic.Test, "Release", DefaultParameterSetName = "Version")>]
[<OutputType(typeof<bool>)>]
type TestReleaseCommand() =
  inherit PSCmdlet()

  /// The release to be tested.
  [<Parameter(Mandatory = true, ParameterSetName = "InputObject", ValueFromPipeline = true)>]
  member val InputObject: Release | null = null with get, set

  /// The version number of the release to be tested.
  [<Parameter(Mandatory = true, ParameterSetName = "Version", Position = 1, ValueFromPipeline = true)>]
  member val Version: SemanticVersion | null = null with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    let semver = if this.ParameterSetName = "InputObject" then (nonNull this.InputObject).Version else nonNull this.Version
    this.WriteObject (Release.exists semver)
