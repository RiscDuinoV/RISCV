ThisBuild / organization := "test"

ThisBuild / scalaVersion := "2.11.12"
lazy val vexriscv = (project in file("."))
  .settings(
    name := "vexriscv",
    version := "0.1",
    libraryDependencies += "org.scalatest" %% "scalatest" % "3.0.5" % "test",
    run / connectInput := true,
    outputStrategy := Some(StdoutOutput),
  ).dependsOn(vexRiscv)

lazy val vexRiscv = RootProject(uri("git://github.com/SpinalHDL/VexRiscv#68e704f3092be640aa92c876cf78702a83167f94"))

fork := true