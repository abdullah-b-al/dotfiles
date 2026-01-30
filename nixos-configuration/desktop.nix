{ pkgs,  ... }:
{
    boot.kernelPackages = pkgs.linuxPackages_zen;

    programs.corectrl = {
         enable = true;
    };

    programs = {
        gamemode.enable = true;
        gamescope.enable = true;
        steam = {
            enable = true;
            gamescopeSession.enable = true;
        };
    };
    environment.systemPackages = with pkgs; [
        lutris
        mangohud
        protonup-ng
    ];
        
    hardware.amdgpu.overdrive = {
        ppfeaturemask = "0xffffffff";
        enable = true;
    };

     systemd.user.services.corectrl-helper = {
         description = "CoreCtrl Helper";
         wantedBy = [ "default.target" ];
         serviceConfig = {
             ExecStart = "${pkgs.corectrl}/bin/corectrl-helper";
             Restart = "on-failure";
         };
     };
    
     security.polkit.extraConfig = ''
     polkit.addRule(function(action, subject) {
       if (action.id.indexOf("org.corectrl.helper") === 0 &&
           subject.isInGroup("video")) {
         return polkit.Result.YES;
       }
     });
     '';
    
    services.udev.packages = [ pkgs.corectrl ];

    system.activationScripts.ensureMnt = {
        text = ''
            mkdir -p /mnt
            chown root:root /mnt
            chmod 0755 /mnt
        '';
    };

    fileSystems."/mnt/linuxHDD" = {
        device = "/dev/disk/by-uuid/44f16107-3ca4-4739-b2a3-b4dab98d8cc3";
        fsType = "ext4";
    };

}
