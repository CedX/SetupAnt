namespace Belin.SetupAnt

open System
open System.Management.Automation
open System.Text.RegularExpressions

/// Describes an error that occurs while parsing a version constraint.
type FindError =
  | InvalidFormat
  | UnsupportedOperator of operator: string

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

  /// Finds a release that matches the specified version constraint.
  let find (versionConstraint: string): Result<Release, FindError> =
    let parsedConstraint =
      if LatestReleasePattern.IsMatch versionConstraint then Ok ("=", string Release.Latest.Version)
      elif Regex.IsMatch(versionConstraint, @"^\d") then Ok (">=", versionConstraint)
      else
        let constraintMatch = Regex.Match(versionConstraint, @"^([^\d]+)\d")
        if constraintMatch.Success then Ok (constraintMatch.Groups[1].Value, Regex.Replace(versionConstraint, @"^[^\d]+", ""))
        else Error InvalidFormat

    let zazz =
      match parsedConstraint with
      | Error constraintError -> constraintError
      | Ok (operator, version) ->
        let semver = SemanticVersion.Parse version
        Release.Data |> List.tryFind (fun _ -> true) |> Erro

    let matches =
      if LatestReleasePattern.IsMatch versionConstraint then Some ("=", string Release.Latest.Version)
      elif Regex.IsMatch(versionConstraint, @"^\d") then Some (">=", versionConstraint)
      else
        let constraintMatch = Regex.Match(versionConstraint, @"^([^\d]+)\d")
        if constraintMatch.Success then Some (constraintMatch.Groups[1].Value, Regex.Replace(versionConstraint, @"^[^\d]+", "")) else None

    let tryParseSemver (version: string) =
      match SemanticVersion.TryParse version with
      | true, semver -> Some semver
      | false, _ -> None

    // let titi =
    //   match matches with
    //   | None -> None
    //   | Some (operator, version) ->
    //     let semver = SemanticVersion.Parse version


    // if operator.IsNone || version.IsNone then None
    // else
    //   match operator, version with
    //   | ">", _ ->

    // let toto =
    //   match SemanticVersion.TryParse version with
    //   | false, _ -> None
    //   | true, semver ->
    //     Release.Data |> List.tryFind (fun _ -> true)



    // let semver =
    // let predicate =
    //   match operator with
    //   | ">" -> Some (fun release -> release.Version > version)
    //   | ">=" -> Some (fun release -> release.Version >= version)
    //   | "=" -> Some (fun release -> release.Version = version)
    //   | "<=" -> Some (fun release -> release.Version <= version)
    //   | "<" -> Some (fun release -> release.Version < version)
    //   | _ -> None

    // None


    // let semver = SemanticVersion.Parse(version)
    // return data.FirstOrDefault operator switch {
    //   ">" -> release -> new SemanticVersion(release.Version) > semver
    //   ">=" -> release -> new SemanticVersion(release.Version) >= semver
    //   "=" -> release -> new SemanticVersion(release.Version) == semver
    //   "<=" -> release -> new SemanticVersion(release.Version) <= semver
    //   "<" -> release -> new SemanticVersion(release.Version) < semver
    //   _ -> None
    Error InvalidFormat


  /// Gets the release corresponding to the specified version.
  let get (version: SemanticVersion): Release option =
    Release.Data |> List.tryFind (fun release -> release.Version = version)
