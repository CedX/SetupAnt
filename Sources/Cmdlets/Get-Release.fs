namespace Belin.SetupAnt.Cmdlets

open Belin.SetupAnt
open System.Management.Automation

/// Gets the release corresponding to the specified version.
[<Cmdlet(VerbsCommon.Get, "Release")>]
[<OutputType(typeof<Release>)>]
type GetReleaseCommand() =
  inherit Cmdlet()

  /// The version number. Use `*` or `Latest` to get the latest release.
  [<Parameter(Mandatory = true, Position = 1, ValueFromPipeline = true)>]
  member val Version = "" with get, set

  /// Performs execution of this command.
  override this.ProcessRecord() =
    let release: Release | null =
      if Release.LatestReleasePattern.IsMatch this.Version then
        Release.Latest
      else
        match SemanticVersion.TryParse this.Version with
        | false, _ -> null
        | true, semver -> Release.get semver |> Option.toObj

    this.WriteObject release
