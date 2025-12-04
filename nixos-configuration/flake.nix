{
    inputs = {
        # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
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
                    host_name = host_name;
                    is_laptop = is_laptop;
                };
            };
        };
}
