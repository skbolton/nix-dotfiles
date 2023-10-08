{ pkgs, config, lib, ... }:

{
  home.sessionVariables = {
    BROWSER = "firefox";
  };

  home.packages = with pkgs; [ 
    bat
    (nerdfonts.override { fonts = [ "RobotoMono" "Iosevka" ]; })
    ibm-plex
    iosevka
    ripgrep
    unzip
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
      t = "task";
      cat = "bat --paging=never";
      mv = "mv -iv";
      cp = "cp -iv";
      rm = "rm -v";
      mux = "tmux";
      muxa = "tmux a";
      muxk = "tmux kill-server";
      v = "nvim";
      m = "iex -S mix";
      ms = "iex -S mix phx.server";
      mdg = "mix deps.get";
      mdc = "mix deps.clean --all";
    };
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      expireDuplicatesFirst = true;
      ignoreDups = true;
      extended = true;
      ignoreSpace = true;
    };
    envExtra = ''
    export MANPAGER="nvim +Man!"
    export PAGER=bat
    BLK="00" CHAR="00" DIR="0C" EXE="DE" REG="00" HLI="00" SLI="00" MIS="00" ORP="00" FIF="00" SOC="00" UNK="00"
    export NNN_FCOLORS="$BLK$CHAR$DIR$EXE$REG$HLI$SLI$MIS$ORP$FIF$SOC$UNK"
    export NNN_COLORS="6666"
    export NNN_OPTS=Hd
    export NNN_FIFO=/tmp/nnn.fifo
    export ZK_NOTEBOOK_DIR=$HOME/Documents/Ares
    export TIMEWARRIORDB="$HOME/Documents/Ares/Time"
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
    initExtra = ''
    color=$(( ( RANDOM % 6 ) + 1 ))
    tput setaf $color && ${pkgs.toilet}/bin/toilet -F border -t -f pagga "Bit by Bit"
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$character$directory$git_branch ";
      right_format = "$jobs$status$hostname";
      character = {
        format = "[ $symbol ](bold fg:bright-white bg:#19172C)";
        error_symbol = "INSERT";
        success_symbol = "INSERT";
        vimcmd_symbol = "NORMAL";
      };
      directory = {
        format = "[   $path ](bg:#2D2B40 fg:bright-white)[](fg:#2D2B40)";
      };
      git_branch = {
        format = "[  $branch ](fg:bright-white)";
      };
      jobs = {
        symbol = " 󰠜 ";
        style = "bright-white";
      };
      status = {
        format = "[](fg:#2D2B40)[ $symbol$status ](fg:bright-white bg:#2D2B40)";
        disabled = false;
        symbol = " ";
        success_symbol = " ";
      };
      hostname = {
        ssh_only = false;
        format = "[ $hostname ](italic fg:bright-white bg:#19172C)";
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
    plugins = {
        mappings = {
        p = "preview-tui";
      };
      src = (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "v4.0";
        sha256 = "sha256-Hpc8YaJeAzJoEi7aJ6DntH2VLkoR6ToP6tPYn3llR7k=";
      }) + "/plugins";
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
      "fg" = "-1";
      "fg+" = "-1";
      "prompt" = "6";
      "header" = "5";
      "pointer" = "2";
      "hl" = "2";
      "hl+" = "2";
      "spinner" = "05";
      "info" = "15";
      "border" = "15";
    };
    defaultCommand = "rg --files --hidden -g !.git";
    defaultOptions = [ "--reverse" "--ansi" ];
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
    icons = true;
    extraOptions = [ "--group-directories-first" "--header" ];
    git = true;
  };

  programs.btop.enable = true;
}
