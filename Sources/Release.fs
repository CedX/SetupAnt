namespace rec Belin.SetupAnt

open System
open System.IO
open System.Text.Json
open System.Text.RegularExpressions

/// Represents an Apache Ant release.
type Release =
  {
    /// The version number.
    Version: Version
  }

  /// The download URL.
  member this.Url: Uri =
    let baseUrl = if this = Release.latest then "https://downloads.apache.org/ant/binaries/" else "https://archive.apache.org/dist/ant/binaries/"
    Uri(Uri baseUrl, $"apache-ant-{this.Version}-bin.zip")

/// Contains operations for working with Apache Ant releases.
module Release =

  /// The list of all Apache Ant releases.
  let internal data: Release list =
    let location = Path.GetDirectoryName typeof<Release>.Assembly.Location
    Path.Join(location, "../Resources/Releases.json") |> File.ReadAllText |> JsonSerializer.Deserialize<Release list> |> nonNull

  /// The regular expression used to check if a version constraint represents the latest release.
  let internal latestReleasePattern = Regex(@"^(\*|Latest)$", RegexOptions.IgnoreCase)

  /// The latest release.
  let latest = data.Head

  /// Gets a value indicating whether a release with the specified version exists.
  let exists (version: Version): bool =
    data |> List.exists (fun release -> release.Version = version)

  /// Gets the release corresponding to the specified version.
  let get (version: Version): Release option =
    data |> List.tryFind (fun release -> release.Version = version)
