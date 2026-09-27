namespace Belin.SetupAnt

open System
open System.Management.Automation
open System.Text.RegularExpressions

/// Represents an Apache Ant release.
type Release =
  {
    /// The version number.
    Version: SemanticVersion
  }

  /// The list of all Apache Ant releases.
  static member internal Data: Release list = ReleaseData.Versions |> List.map (fun semver -> { Version = semver })

  /// The latest release.
  static member Latest: Release = Release.Data.Head

  /// The download URL.
  member this.Url: Uri =
    let baseUrl = if this = Release.Latest then "https://downloads.apache.org/ant/binaries/" else "https://archive.apache.org/dist/ant/binaries/"
    Uri(Uri baseUrl, $"apache-ant-{this.Version}-bin.zip")

/// Contains operations for working with Apache Ant releases.
module Release =

  /// The regular expression used to check if a version constraint represents the latest release.
  let internal LatestReleasePattern = Regex(@"^(\*|Latest)$", RegexOptions.IgnoreCase)

  /// Gets a value indicating whether a release with the specified version exists.
  let exists (version: SemanticVersion): bool =
    Release.Data |> List.exists (fun release -> release.Version = version)

  /// Gets the release corresponding to the specified version.
  let get (version: SemanticVersion): Release option =
    Release.Data |> List.tryFind (fun release -> release.Version = version)
