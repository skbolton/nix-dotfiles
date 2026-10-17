{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./pam.nix
  ];

  fonts.fontconfig.enable = true;
  xdg.autostart.enable = true;

  delta = {
    ai.enable = true;
    sops.enable = true;
    gpg.enable = true;
    zsh.enable = true;
    cli_apps.enable = true;
    tmux.enable = true;
    finance.enable = true;
    passwords.enable = true;
    tasks.enable = true;
    tasks.sync = true;
    timetracking = {
      enable = true;
      timesheets = "$HOME/Documents/new-journals/tracking/time";
    };
    habits.enable = true;
    neovim.enable = true;
    theme = {
      enable = true;
      palette = "evergloom";
    };
    rally = {
      enable = true;
      rallypoints = [
        "$HOME"
        "$HOME/c"
      ];
    };
    kitty.enable = true;
    lang = {
      elixir.enable = true;
      nodejs.enable = true;
      lua.enable = true;
      nix.enable = true;
      go.enable = true;
      json.enable = true;
      cpp.enable = true;
      bash.enable = true;
    };
    notes = {
      enable = true;
      notebook_dir = "$HOME/Documents/Reference";
    };
    desktop.wayland.mango.enable = true;
    desktop.nm-applet.enable = true;
    desktop.ui_applications.enable = true;
    synology.enable = true;
    cloud.gcloud.enable = true;
  };

  programs.dank-material-shell = {
    enable = true;

    systemd.enable = true;
    settings = {
      screenPreferences.wallpaper = [ ];
      useFahrenheit = true;
      dwlShowAllTags = true;
      fontFamily = lib.mkForce "Inter";
      monoFontFamily = lib.mkForce "IBM Plex Mono";
      textRenderQuality = 3;
      clocFormat = "24h";
      firstDayOfWeek = 1;
      workspaceColorMode = "primaryContainer";
      workspaceOccupiedColorMode = "primary";
      workspaceUnfocusedColorMode = "s";
      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [
            "all"
          ];
          showOnLastDisplay = true;
          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "focusedWindow"
          ];
          centerWidgets = [
            {
              id = "music";
              enabled = true;
              mediaSize = 3;
            }
            "music"
            "clock"
            "weather"
            "colorPicker"
          ];
          rightWidgets = [
            "systemTray"
            "cpuUsage"
            "cpuTemp"
            "memUsage"
            "gpuTemp"
            "notificationButton"
            "powerMenuButton"
          ];
          spacing = 0;
          innerPadding = 4;
          bottomGap = 0;
          transparency = 0.68;
          followInterfaceStyle = true;
          surfaceColor = "default";
          surfaceCustomColor = "#6750A4";
          widgetTransparency = 0.67;
          widgetFollowInterfaceStyle = true;
          squareCorners = true;
          noBackground = false;
          widgetStyle = "pills";
          maximizeWidgetIcons = false;
          maximizeWidgetText = false;
          widgetPadding = 12;
          barInsetPadding = 12;
          batteryColorMode = "theme";
          gothCornersEnabled = false;
          gothCornerRadiusOverride = false;
          gothCornerRadiusValue = 12;
          borderEnabled = false;
          borderColor = "surfaceText";
          borderOpacity = 1;
          borderThickness = 1;
          widgetOutlineEnabled = false;
          widgetOutlineColor = "primary";
          widgetOutlineOpacity = 1.0;
          widgetOutlineThickness = 1;
          fontScale = 1;
          iconScale = 1.0;
          autoHide = false;
          autoHideStrict = false;
          autoHideDelay = 250;
          showOnWindowsOpen = false;
          openOnOverview = false;
          visible = true;
          popupGapsAuto = true;
          popupGapsManual = 4;
          maximizeDetection = true;
          useOverlayLayer = false;
          scrollEnabled = true;
          scrollXBehavior = "focusWindow";
          scrollYBehavior = "workspace";
          middleClickAction = "none";
          rightClickAction = "none";
          clickActionFollowMouse = false;
          shadowIntensity = 0;
          shadowOpacity = 60;
          shadowColorMode = "default";
          shadowCustomColor = "#000000";
          shadowDirectionMode = "inherit";
          shadowDirection = "top";
          clickThrough = false;
          hoverPopouts = false;
          hoverPopoutDelay = 150;
          attachToScreenEdge = false;
          barLengthPadding = 0;
          barLengthMode = "full";
          barLengthPercent = 80;
        }
      ];
    };
  };

  programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch --flake '${config.home.homeDirectory}/c/nix-dotfiles#trinity'";

  programs.man.generateCaches = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings.cypher = {
      HostName = "cypher.home.arpa";
      User = "nixos";
      RemoteForward = [
        {
          host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
          bind.address = "/run/user/1000/gnupg/S.gpg-agent";
        }
        {
          host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
          bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
        }
      ];
    };

    settings.contra = {
      HostName = "construct.home.arpa";
      User = "contra";
      RemoteForward = [
        {
          host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
          bind.address = "/run/user/1001/gnupg/S.gpg-agent";
        }
        {
          host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
          bind.address = "/run/user/1001/gnupg/S.gpg-agent.ssh";
        }
      ];
    };

  };

  services.syncthing = {
    enable = true;
  };

  home = {
    username = "orlando";
    homeDirectory = "/home/orlando";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = with pkgs; [
      plexamp
      mpv
      docker-compose
      firefox
      handbrake
      delta.quantified-self
    ];
  };

  monitors = [
    {
      name = "DP-1";
      width = 5120;
      height = 2160;
      x = 2560;
      y = 0;
      refreshRate = 165;
      scale = "1";
      workspaces = [
        "1"
        "3"
        "5"
      ];
      enabled = true;
    }
    {
      name = "DP-5";
      enabled = false;
    }
  ];

  keyboard = {
    variant = "colemak";
    options = "lv3:ralt_alt";
  };

  # TODO: Find a way to automate this in themes
  # switching constructs theme should update this
  xdg.configFile."kitty/ssh.conf".text = ''
    hostname construct
    color_scheme ${../../../modules/home/dev-null-theme/kitty-dev-null.conf}
  '';

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
