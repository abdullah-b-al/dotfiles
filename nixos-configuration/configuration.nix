{ config, pkgs, ... }:

let
    is_laptop = builtins.pathExists "/sys/class/power_supply/BAT0";
    hdd = {
        device = "/dev/disk/by-uuid/44f16107-3ca4-4739-b2a3-b4dab98d8cc3";
        fsType = "ext4";
    };
in
    {
    imports =
        [
            ./hardware-configuration.nix
        ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.kernelPackages = if is_laptop then pkgs.linuxPackages else pkgs.linuxKernel.packages.linux_zen;

    networking.hostName = if is_laptop then "nixos-laptop" else "nixos-desktop";
    networking.networkmanager.enable = true;
    time.timeZone = "Asia/Riyadh";
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "ar_SA.UTF-8";
        LC_IDENTIFICATION = "ar_SA.UTF-8";
        LC_MEASUREMENT = "ar_SA.UTF-8";
        LC_MONETARY = "ar_SA.UTF-8";
        LC_NAME = "ar_SA.UTF-8";
        LC_NUMERIC = "ar_SA.UTF-8";
        LC_PAPER = "ar_SA.UTF-8";
        LC_TELEPHONE = "ar_SA.UTF-8";
        LC_TIME = "ar_SA.UTF-8";
    };

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
            General = {
                # Shows battery charge of connected devices on supported
                # Bluetooth adapters. Defaults to 'false'.
                Experimental = true;
                # When enabled other devices can connect faster to us, however
                # the tradeoff is increased power consumption. Defaults to
                # 'false'.
                FastConnectable = false;
            };
            Policy = {
                AutoEnable = true;
            };
        };
    };
    hardware.i2c.enable = true;

    users.users.ab = {
        isNormalUser = true;
        description = "ab";
        extraGroups = [ "networkmanager" "wheel" ];
        shell = pkgs.zsh;
        packages = with pkgs;  [
            (buildFHSEnv
                (appimageTools.defaultFhsEnvArgs // {
                    name = "zed-fhs";
                    runScript = "/home/ab/.local/bin/zed";
                })
            )

        ];
    };

    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
        neovim
        alacritty
        firefox
        chromium
        brave
        sudo
        trash-cli
        gawk
        bat
        ranger
        openssh
        ripgrep
        rofi
        stow
        tmux
        btop
        nextcloud-client
        dunst
        tldr
        fzf
        fd
        xfce.thunar
        pavucontrol
        waybar
        curl
        xwayland
        git
        pipewire
        wl-clipboard
        gnome-keyring
        vulkan-tools
        vulkan-headers
        vulkan-loader
        vulkan-validation-layers
        gcc
        wayland
        jq
        nodejs_24
        kanata
        mangohud
        bottles
        gnumake
        kdePackages.breeze
        ddcutil
        libnotify
        cmus
        libqalculate
    ];

    fonts.packages = with pkgs; [
        jetbrains-mono
        nerd-fonts.jetbrains-mono
        font-awesome
        noto-fonts
    ];

    # programs.nix-ld = {
    #     enable = true;
    #     libraries = with pkgs; [
    #         alsa-lib
    #     ];
    # };


    programs.gamemode.enable = true;
    programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
    };
    programs.zsh.enable = true;

    programs.sway = {
        enable = true;
    };

    services.openssh.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    services.kanata.enable = true;
    services.xserver.videoDrivers = ["amdgpu"];
    services.locate = {
        enable = true;
        package = pkgs.plocate;
    };

    security.sudo = {
        enable = true;
        extraRules = [
            {
                groups = [ "wheel" ];
                commands = [
                    { command = "${pkgs.kanata}/bin/kanata"; options = [ "NOPASSWD" ]; }
                    { command = "${pkgs.ddcutil}/bin/ddcutil"; options = [ "NOPASSWD" ]; }
                ];
            }
        ];
        extraConfig = with pkgs; ''
    Defaults secure_path="${lib.makeBinPath [
                kanata
                ddcutil
            ]}:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
        '';
    };

    # fileSystems."/mnt/linuxHDD" = if builtins.pathExists hdd.device then hdd else {};


    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    system.stateVersion = "25.05";

}
