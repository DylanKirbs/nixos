{ ... }:
{
  flake.modules.homeManager.warpShell =
    { pkgs, ... }:
    let
      scriptName = "warp-shell";
      scriptText = builtins.readFile ./warp-shell.sh;
    in
    {
      home.packages = [ (pkgs.writeScriptBin scriptName scriptText) ];
    };
}
