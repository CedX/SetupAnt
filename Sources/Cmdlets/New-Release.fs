namespace Belin.SetupAnt.Cmdlets

open Belin.SetupAnt
open System.Management.Automation

/// Finds a release that matches the specified version constraint.
type NewReleaseCommand() =
  inherit Cmdlet()
  // TODO
