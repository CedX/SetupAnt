namespace Belin.SetupAnt

open System
open System.Diagnostics
open System.IO
open System.IO.Compression
open System.Management.Automation
open System.Net.Http
open System.Threading.Tasks

/// Manages the download and installation of Apache Ant.
type Setup(release: Release) =

  /// The assembly version.
  static let version = nonNull (typeof<Setup>.Assembly.GetName().Version)

  /// The release to download and install.
  member val Release = release

  /// Downloads and extracts the ZIP archive of Apache Ant.
  /// Returns the path to the extracted directory.
  member this.Download(?withOptionalTasks: bool): Task<string> = task {
    use httpClient = new HttpClient(Timeout = TimeSpan.FromMinutes 1L)
    httpClient.DefaultRequestHeaders.Add("User-Agent", $".NET/{Environment.Version} | Belin.SetupAnt/{version.ToString 3}")

    let! bytes = httpClient.GetByteArrayAsync release.Url
    let file = Path.GetTempFileName()
    do! File.WriteAllBytesAsync(file, bytes)

    let directory = Path.Join(Path.GetTempPath(), string (Guid.CreateVersion7()))
    do! ZipFile.ExtractToDirectoryAsync(file, directory)

    let antHome = Directory.EnumerateDirectories directory |> Seq.exactlyOne |> Path.GetFileName |> fun name -> Path.Join(directory, name)
    if withOptionalTasks |> Option.defaultValue false then do! this.FetchOptionalTasks antHome
    return antHome
  }

  /// Installs Apache Ant, after downloading it.
  /// Returns the path to the installation directory.
  member this.Install(?withOptionalTasks: bool): Task<string> = task {
    let! antHome = this.Download(?withOptionalTasks = withOptionalTasks)

    let binFolder = Path.Join(antHome, "bin")
    Environment.SetEnvironmentVariable("PATH", $"""{Environment.GetEnvironmentVariable "PATH"}{Path.PathSeparator}{binFolder}""")
    do! File.AppendAllTextAsync(nonNull (Environment.GetEnvironmentVariable "GITHUB_PATH"), binFolder)

    Environment.SetEnvironmentVariable("ANT_HOME", antHome)
    do! File.AppendAllTextAsync(nonNull (Environment.GetEnvironmentVariable "GITHUB_ENV"), $"ANT_HOME={antHome}")

    return antHome
  }

  /// Fetches the external libraries required by Ant optional tasks.
  member private _.FetchOptionalTasks(antHome: string): Task = task {
    let startInfo = ProcessStartInfo(
      Arguments = "-jar lib/ant-launcher.jar -buildfile fetch.xml -noinput -silent -Ddest=system",
      CreateNoWindow = true,
      FileName = "java",
      WorkingDirectory = antHome
    )

    startInfo.Environment["ANT_HOME"] <- antHome

    let message = $"{startInfo.FileName} {startInfo.Arguments}"
    match Process.Start startInfo with
    | null -> raise (ApplicationFailedException message)
    | startedProcess ->
      use command = startedProcess
      do! command.WaitForExitAsync()
      if command.ExitCode <> 0 then raise (ApplicationFailedException message)
  }
