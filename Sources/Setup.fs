namespace Belin.SetupAnt

open System.Diagnostics
open System.Management.Automation
open System.Net.Http

/// Contains operations for working with `Setup` objects.
module Setup =

  /// Defines the options of a `Setup` instance.
  type Options = WithOptionalTasks

/// Manages the download and installation of Apache Ant.
type Setup(release: Release) =

  /// The release to download and install.
  member val Release = release

  /// Downloads and extracts the ZIP archive of Apache Ant.
  /// Returns the path to the extracted directory.
  member this.Download(?options: Setup.Options) = task {
    return ""
  }

  /// Installs Apache Ant, after downloading it.
  /// Returns the path to the installation directory.
  member this.Install(?options: Setup.Options) = task {
    return ""
  }

  /// Fetches the external libraries required by Ant optional tasks.
  /// Returns the path to the Ant directory.
  member private _.FetchOptionalTasks(antHome: string) =
    let startInfo = ProcessStartInfo(
      Arguments = "-jar lib/ant-launcher.jar -buildfile fetch.xml -noinput -silent -Ddest=system",
      CreateNoWindow = true,
      FileName = "java",
      WorkingDirectory = antHome
    )

    startInfo.Environment["ANT_HOME"] <- antHome

    use javaProcess = Process.Start startInfo
    match javaProcess with
    | null ->
        raise (ApplicationFailedException startInfo.FileName)
    | startedProcess ->
        startedProcess.WaitForExit()
        if startedProcess.ExitCode <> 0 then raise (ApplicationFailedException startInfo.FileName)
