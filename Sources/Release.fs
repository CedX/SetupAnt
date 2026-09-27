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

  /// The latest release.
  // static member Latest: Release = { Version = ReleaseData.Versions.Head }

  /// Value indicating whether this release exists. // TODO a module function ????
  // member this.Exists = ReleaseData.Versions |> List.exists (fun semver -> semver = this.Version)

  /// The download URL.
  // member this.Url: Uri =
  //   let baseUrl = if this = Release.Latest then "https://downloads.apache.org/ant/binaries/" else "https://archive.apache.org/dist/ant/binaries/"
  //   Uri(Uri baseUrl, $"apache-ant-{this.Version}-bin.zip")

/// Contains operations for working with Apache Ant releases.
module Release =

  /// The regular expression used to check if a version constraint represents the latest release.
  let private latestReleasePattern = Regex @"^(\*|latest)$"

  /// The list of all Apache Ant releases.
  let private releaseData: Release list = ReleaseData.Versions |> List.map (fun semver -> { Version = semver })

  /// The latest release.
  let Latest: Release = releaseData.Head

  /// Gets the release corresponding to the specified version.
  let get (version: SemanticVersion): Release option =
    ReleaseData.Versions |> List.tryFind (fun semver -> semver = version) |> Option.map (fun semver -> { Version = semver })

  /// Gets the release corresponding to the specified version.
  // let get (version: string): Release option =
  //   get (SemanticVersion version)
