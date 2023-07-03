{ pkgs, config, lib, ... }:

{

  home.packages = with pkgs; [ 
    asdf-vm
    (nerdfonts.override { fonts = [ "RobotoMono" ]; })
    ripgrep
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    cdpath = [ "." "/home/orlando" "/home/orlando/Public" "/home/orlando/Documents" "/home/orlando/Notes" ];
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    shellAliases = {
      mux = "tmux";
      muxa = "tmux a";
      muxk = "tmux kill-server";
      v = "nvim";
    };
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      expireDuplicatesFirst = true;
      ignoreDups = true;
      extended = true;
      ignoreSpace = true;
    };
    envExtra = ''
    BLK="00" CHAR="00" DIR="0C" EXE="DE" REG="00" HLI="00" SLI="00" MIS="00" ORP="00" FIF="00" SOC="00" UNK="00"
    export NNN_FCOLORS="$BLK$CHAR$DIR$EXE$REG$HLI$SLI$MIS$ORP$FIF$SOC$UNK"
    export NNN_COLORS="6666"
    '';

    # how to see where a package ends up in the store
    # source ${pkgs.asdf-vm.outPath}/bin/asdf

    initExtraBeforeCompInit = ''
    setopt AUTO_PUSHD           # Push the old directory onto the stack on cd
    setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
    setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd
    setopt CORRECT              # Spelling Corrections
    setopt CDABLE_VARS          # Change directory to a path stored in a variable
    setopt EXTENDED_GLOB        # Use extended globbing syntax
    '';
  };

  # This was needed so that home manager session vars 
  # where available to desktop environment
  # TODO: What to do on Wayland? Maybe SDDM still sources?
  home.file.".xprofile".text = ''
  source $HOME/.config/zsh/.zshenv
  '';

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$jobs"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$line_break"
        "$character"
      ];
      hostname = {
        ssh_symbol = "󰐻 ";
  style = "bold bright-yellow";
      };
      git_branch = {
        symbol = "󰊢 ";
  style = "purple";
  format = "on [$symbol$branch]($style) ";
      };
      directory = {
  style = "italic cyan";
  format = "[$path]($style) ";
      };
      character = {
        success_symbol = "[󰇂 ](green)";
        error_symbol = "[󰇂 ](yellow)";
        vicmd_symbol = "[󰇂 ](green)";
      };
      jobs = {
  symbol = " ";
  style = "bold bright-black";
      };
    };
  };

  programs.nnn = {
    package = pkgs.nnn.override ({ withNerdIcons = true; });
    enable = true;
    bookmarks = {
      a = "~/Documents/Archive";
      d = "~/Documents/Delta";
      h = "~/Documents/Delta/Areas/Home";
      D = "~/Documents";
      n = "~/Documents/Notes";
      o = "~/Downloads";
      f = "~/Documents/Delta/Areas/Finances/statements/$(date +%Y)";
      w = "~/Pictures/Wallpapers";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    colors = {
      "bg+" = "-1";
      "fg" = "15";
      "fg+" = "-1";
      "prompt" = "6";
      "header" = "5";
      "pointer" = "2";
      "hl" = "3";
      "hl+" = "3";
      "spinner" = "05";
      "info" = "15";
      "border" = "15";
    };
    defaultCommand = "rg --files --hidden -g !.git";
    defaultOptions = [ "--reverse" "--ansi" ];
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
    icons = true;
    extraOptions = [ "--group-directories-first" "--header" ];
    git = true;
  };
}
