{
    description = "Wayland development shell";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
    };

    outputs = { self, nixpkgs }:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; };
        in
            {
            devShells.${system}.default = pkgs.mkShell {
                packages = with pkgs; [
                    wayland
                    wayland-scanner
                    libxkbcommon
                    libxkbcommon.dev
                    xorg.libxcb
                    xorg.libX11
                    libGL
                    sdl3
                ];
            };
            packages.${system}.default = pkgs.stdenv.mkDerivation {
                src = pkgs.lib.cleanGit ./.;
            };
        };
}
