namespace Belin.SetupAnt.Cmdlets

open Belin.SetupAnt
open System.Management.Automation

/// Finds a release that matches the specified version constraint.
/// Returns `null` if not found.
[<Cmdlet(VerbsCommon.Find, "Release"); OutputType(typeof<Release>)>]
type FindReleaseCommand() =
  inherit Cmdlet()

  /// The version number. Use `*` or `Latest` to get the latest release.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val Constraint = "" with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    let release = Release.find this.Constraint
    this.WriteObject (release |> Option.toObj)
