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

  programs.bat.enable = true;

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
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden -g !.git";
    defaultOptions = [ "--reverse" "--ansi" ];
  };

  programs.skim = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f --exclude '.git'";
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
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
      vim_keys = true;
    };
  };
}
