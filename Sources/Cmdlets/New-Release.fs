namespace Belin.SetupAnt.Cmdlets

open Belin.SetupAnt
open System
open System.Management.Automation

/// Creates a new release.
[<Cmdlet(VerbsCommon.New, "Release"); OutputType(typeof<Release>)>]
type NewRelease() =
  inherit Cmdlet()

  /// The version number.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val Version: Version | null = null with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    this.WriteObject { Version = nonNull this.Version }
