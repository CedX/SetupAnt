namespace Belin.SetupAnt.Cmdlets

open Belin.SetupAnt
open System.Management.Automation

/// Finds a release that matches the specified version constraint.
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
