{ config, pkgs, ... }: {
  systemd.user.services."random-wallpaper" = {
    description = "Randomize wallpaper";
    serviceConfig = {
      Type = "oneshot";
      ExecStart =
        "/run/current-system/sw/bin/bash /home/chris/.config/scripts/random-wallpaper";
    };
  };

  systemd.user.timers."random-wallpaper" = {
    description = "Run wallpaper change script every hour";
    wantedBy = [ "default.target" ];
    timerConfig = {
      OnCalendar = "hourly";
      Persistent = true;
    };
  };
}

