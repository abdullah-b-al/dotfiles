{
    inputs = {
        # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    };


    outputs = inputs:
        let
            system = "x86_64-linux";
            is_laptop = builtins.pathExists "/sys/class/power_supply/BAT0";
            host_name = if is_laptop then "nixos-laptop" else "nixos-desktop";
        in
            {

            nixosConfigurations.${host_name} = inputs.nixpkgs.lib.nixosSystem {
                modules = [
                    ./configuration.nix
                ];
                specialArgs = {
                    unstable = import inputs.unstable {
                        inherit system;
                    };
                    host_name = host_name;
                    is_laptop = is_laptop;
                };
            };
        };
}
