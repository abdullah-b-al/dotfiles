{ config, pkgs,  ... } @inputs:

let
    hdd = {
        device = "/dev/disk/by-uuid/44f16107-3ca4-4739-b2a3-b4dab98d8cc3";
        fsType = "ext4";
    };

in
    {
    imports =
        [
            /etc/nixos/hardware-configuration.nix
        ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    # boot.kernelParams = if inputs.is_laptop then [] else [
    #     # "amdgpu.reset_method=none"
    #     "amdgpu.lockup_timeout=10000"
    # ];

    networking.hostName = inputs.host_name;
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


    # systemd.user.services.corectrl-helper = {
    #     description = "CoreCtrl Helper";
    #     wantedBy = [ "default.target" ];
    #     serviceConfig = {
    #         ExecStart = "${pkgs.corectrl}/bin/corectrl-helper";
    #         Restart = "on-failure";
    #     };
    # };
    #
    # security.polkit.extraConfig = ''
    # polkit.addRule(function(action, subject) {
    #   if (action.id.indexOf("org.corectrl.helper") === 0 &&
    #       subject.isInGroup("video")) {
    #     return polkit.Result.YES;
    #   }
    # });
    # '';
    #
    # services.udev.packages = [ pkgs.corectrl ];

    users.users.ab = {
        isNormalUser = true;
        description = "ab";
        extraGroups = [ "networkmanager" "wheel" "dialout" "video" ];
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



    # programs.nix-ld = {
    #     enable = true;
    #     libraries = with pkgs; [
    #         alsa-lib
    #     ];
    # };



    services = {
        openssh.enable = true;
        gnome.gnome-keyring.enable = true;
        kanata.enable = true;
        xserver.videoDrivers = ["amdgpu"];

        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };

        xserver.xkb = {
            layout = "us";
            variant = "";
        };

        locate = {
            enable = true;
            package = pkgs.plocate;
        };
    };

    security = {
        rtkit.enable = true;
        sudo = {
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

    };


    system.activationScripts.ensureMnt = {
        text = ''
            mkdir -p /mnt
            chown root:root /mnt
            chmod 0755 /mnt
        '';
    };
    fileSystems."/mnt/linuxHDD" = if builtins.pathExists hdd.device then hdd else {};


    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
    system.stateVersion = "25.05";

    security.polkit.enable = true;

    programs = {
        zsh.enable = true;
        sway.enable = true;
        gamemode.enable = true;
        gamescope.enable = true;

        # corectrl = {
        #     enable = true;
        #     gpuOverclock = {
        #         enable = true;
        #         ppfeaturemask = "0xffffffff";
        #     };
        # };
        #
        steam = {
            enable = true;
            gamescopeSession.enable = true;
        };
    };

    fonts.packages = with pkgs; [
        jetbrains-mono
        nerd-fonts.jetbrains-mono
        font-awesome
        noto-fonts
    ];

    environment.systemPackages = with pkgs; [
        helix
        neovim
        alacritty
        firefox
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
        zellij
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
        gnumake
        kdePackages.breeze
        ddcutil
        libnotify
        cmus
        libqalculate
        nvd
        newsboat
        unzip
        protonup-ng
        tree

        # LSP
        zls
        nil
        nixd
    ];
}
