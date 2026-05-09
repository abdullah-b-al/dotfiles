{
  description = "Wayland development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      runtimeLibs = with pkgs; lib.makeLibraryPath [
          glfw
          libGL
          xorg.libX11
          xorg.libXcursor
          xorg.libXext
          xorg.libXrandr
          xorg.libXxf86vm
        ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        shellHook = ''
          export LD_LIBRARY_PATH=${runtimeLibs}:$LD_LIBRARY_PATH
        '';

        packages = [
          pkgs.cmake
          pkgs.glfw
          pkgs.libGL
          pkgs.xorg.libX11
          pkgs.xorg.libXcursor
          pkgs.xorg.libXext
          pkgs.xorg.libXrandr
          pkgs.xorg.libXxf86vm
          pkgs.libxinerama
          pkgs.libxi
        ];
      };
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        src = pkgs.lib.cleanGit ./.;
      };
    };
}
