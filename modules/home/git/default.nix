{ pkgs, ... }:

{
  home.packages = [
    pkgs.delta.git-get
  ];

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
    };
    extensions = with pkgs; [ gh-dash ];
  };

  programs.git = {
    enable = true;
    userName = "Stephen Bolton";
    userEmail = "stephen@bitsonthemind.com";

    signing = {
      key = "0x60410414D406AF1D";
      signByDefault = true;
    };

    aliases = {
      l = "log --date=short --decorate --pretty=format:'%C(yellow)%h %C(green)%ad%C(magenta)%d %Creset%s%C(brightblue) [%cn]'";
      branches = "!git --no-pager branch --format '%(refname:short)' --sort=-committerdate | ${pkgs.fzf}/bin/fzf-tmux $1 --preview 'git log --color=always --decorate {}'";
      dog = "log --all --decorate --oneline --graph";
      to = "!git checkout $(git branches --no-multi)";
      drop = "!git branch -d $(git branches --multi)";
      st = "status";
      p = "pull";
      pp = "push";
      c = "commit";
      cm = "commit -m";
      can = "commit --amend --no-edit";
      co = "checkout";
      default-branch = "!git remote show origin | grep 'HEAD branch' | cut -d ' ' -f5";
      back = "reset HEAD~1";
      backk = "reset HEAD~1 --hard";
      files = "!git diff --name-only $(git merge-base HEAD \"$REVIEW_BASE\")";
      stat = "!git diff --stat $(git merge-base HEAD \"$REVIEW_BASE\")";
      what = "!git config --get-regexp alias";
    };

    ignores = [ "steve_queries" ".envrc.private" ".direnv" ".vim" ];

    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
    };

    extraConfig = {
      init = { defaultBranch = "main"; };
      core = { editor = "nvim"; };
      diff = { algorithm = "histogram"; };
      status = { showUntrackedFiles = "all"; };
      blame = { date = "relative"; };
      rebase = { autosquash = true; };
      merge = { conflictStyle = "diff3"; };
      pull = { ff = "only"; };
      checkout = { defaultRemote = "origin"; };
      commit = {
        verbose = true;
        template = "~/.config/git/commit-template";
      };
    };
  };

  xdg.configFile."git/commit-template" = {
    text = ''
      # Title: Summary, imperative, Capital starting, don't end with period
      # No more than 50 chars. Which is less than this  |
      
      # Remember the blank between the title and body
      
      # Body: Explain *what* and *why* not *how*
      
      # Space between Body and Footer
      
      # Footer: Project metadata (area, ticket hash, related)
      
      # Great example commit
      # Capitalized, short (50 chars or less) summary
      # 
      # More detailed explanatory text, if necessary.  Wrap it to about 72
      # characters or so.  In some contexts, the first line is treated as the
      # subject of an email and the rest of the text as the body.  The blank
      # line separating the summary from the body is critical (unless you omit
      # the body entirely); tools like rebase can get confused if you run the
      # two together.
      # 
      # Write your commit message in the imperative: "Fix bug" and not "Fixed bug"
      # or "Fixes bug."  This convention matches up with commit messages generated
      # by commands like git merge and git revert.
      # 
      # Further paragraphs come after blank lines.
      # 
      # - Bullet points are okay, too
      # 
      # - Typically a hyphen or asterisk is used for the bullet, followed by a
      #   single space, with blank lines in between, but conventions vary here
      # 
      # - Use a hanging indent
      # 
      # If you use an issue tracker, add a reference(s) to them at the bottom,
      # like so:
      # 
      # Resolves: #123
    '';
  };
}
