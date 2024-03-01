{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "RobotoMono" "Iosevka" ]; })
    ibm-plex
    iosevka
    ripgrep
    unzip
    jq
    miller
    entr
    fd
    md-tangle
  ];

  programs.bat = {
    enable = true;
    config = {
      theme = "embark";
    };
    themes = {
      catppuccin-mocha = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "main";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "Catppuccin-mocha.tmTheme";
      };
      embark = {
        src = pkgs.fetchFromGitHub {
          owner = "embark-theme";
          repo = "bat";
          rev = "fae7e23";
          sha256 = "sha256-7xKdf5IRwRQo7nVc9hXb+ziULBtwhAn3pbOy4FiRbiQ=";
        };
        file = "Embark.tmTheme";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    cdpath = [ "." "/home/orlando" "/home/orlando/Public" "/home/orlando/Documents" "/home/orlando/Notes" ];
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    plugins = [
      { name = "fzf-tab"; src = "${pkgs.zsh-fzf-tab}/share/fzf-tab"; }
    ];
    shellGlobalAliases = {
      E = "| entr -c";
      F = "| fzf";
      R = "| rg";
    };
    shellAliases = {
      t = "task";
      cat = "bat --paging=never";
      mv = "mv -iv";
      cp = "cp -iv";
      rm = "rm -v";
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
      KEYTIMEOUT=5
    '';
    initExtra = ''
      autoload -Uz edit-command-line
      zle -N edit-command-line
      bindkey -M viins '^f' edit-command-line
      bindkey -M vicmd '^i' edit-command-line

      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    
      color=$(( ( RANDOM % 6 ) + 1 ))
      tput setaf $color && ${pkgs.toilet}/bin/toilet -F border -t -f pagga "Bit by Bit"

      function w() {
        fd $1 | entr -c "''${@:2}"
      }

      function ew() {
        fd "\.exs?$" | entr -c "$@"
      }
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      format = "$character$jobs$directory$git_branch$git_status ";
      character = {
        format = "$symbol";
        error_symbol = "[  ](bold fg:red bg:#19172C)";
        success_symbol = "[  ](bold fg:green bg:#19172C)";
        vimcmd_symbol = "[  ](bold fg:purple bg:#19172C)";
      };

      directory = {
        format = "[   $path ](bg:#2D2B40 fg:bright-white)[](fg:#2D2B40)";
      };

      git_branch = {
        format = "[  $branch ](fg:bright-white)";
      };

      git_status = {
        style = "bold purple";
      };

      jobs = {
        symbol = " 󰠜 ";
        style = "bright-white";
      };

      status = {
        format = "[ $symbol$status ](fg:bright-white bg:#2D2B40)";
        disabled = false;
        symbol = " ";
      };

      hostname = {
        ssh_only = false;
        format = "[ $hostname ](italic fg:bright-white bg:#19172C)";
      };
    };
  };

  programs.nnn = {
    package = pkgs.nnn.override ({ withNerdIcons = true; extraMakeFlags = [ "O_NAMEFIRST=1" ]; });
    enable = true;
    bookmarks = {
      d = "~/Documents";
      o = "~/Downloads";
      n = "~/50-59-Reference/";
      f = "~/10-19-Life/10-Finance/10.12-Statements/$(date +%Y)";
      w = "~/80-89-Media/80-Pictures/80.10-Wallpapers";
    };
    plugins = {
      mappings = {
        p = "preview-tui";
      };
      src = (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "master";
        sha256 = "sha256-VVVHbRsml/2ugQnp/WL828S8ODwskg9uajaR2D7Q7G8=";
      }) + "/plugins";
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        ratio = [ 1 3 4 ];
        show_hidden = true;
        linemode = "mtime";
        sort_dir_first = true;
      };
    };
    theme = {
      manager = {
        hovered = { bg = "green"; fg = "black"; };
        tab_active = { bg = "green"; fg = "black"; };
        tab_inactive = { bg = "black"; fg = "lightwhite"; };
      };
      status = {
        separator_open = "";
        separator_close = "";
        mode_normal = { fg = "black"; bg = "green"; };
      };
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

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "embark";
      vim_keys = true;
    };
  };

  xdg.configFile."btop/themes/embark.theme".source = pkgs.fetchFromGitHub
    {
      owner = "embark-theme";
      repo = "bashtop";
      rev = "master";
      sha256 = "sha256-HHoCVdCH4jCIK0JzoYagURcU722sBARtFkNeGPXuCNM=";
    } + "/embark.theme";
}
