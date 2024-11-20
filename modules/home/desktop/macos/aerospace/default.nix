{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.desktop.macos.aerospace;
in
{
  options.delta.desktop.macos.aerospace = with types; {
    enable = mkEnableOption "Aerospace Window Manager";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ aerospace ];

    xdg.configFile."aerospace/aerospace.toml".text = /* toml */ ''
      # Place a copy of this config to ~/.aerospace.toml
      # After that, you can edit ~/.aerospace.toml to your liking

      # You can use it to add commands that run after login to macOS user session.
      # 'start-at-login' needs to be 'true' for 'after-login-command' to work
      # Available commands: https://nikitabobko.github.io/AeroSpace/commands
      after-login-command = []

      # You can use it to add commands that run after AeroSpace startup.
      # 'after-startup-command' is run after 'after-login-command'
      # Available commands : https://nikitabobko.github.io/AeroSpace/commands
      after-startup-command = []

      # Start AeroSpace at login
      start-at-login = true

      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = true
      enable-normalization-opposite-orientation-for-nested-containers = true

      # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
      # The 'accordion-padding' specifies the size of accordion padding
      # You can set 0 to disable the padding feature
      accordion-padding = 30

      # Possible values: tiles|accordion
      default-root-container-layout = 'tiles'

      # Possible values: horizontal|vertical|auto
      # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
      #               tall monitor (anything higher than wide) gets vertical orientation
      default-root-container-orientation = 'auto'

      # Mouse follows focus when focused monitor changes
      # Drop it from your config, if you don't like this behavior
      # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
      # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
      # Fallback value (if you omit the key): on-focused-monitor-changed = []
      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']
      on-focus-changed = ['move-mouse window-lazy-center']

      # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
      # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
      # Also see: https://nikitabobko.github.io/AeroSpace/goodness#disable-hide-app
      automatically-unhide-macos-hidden-apps = true

      # Possible values: (qwerty|dvorak)
      # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      [key-mapping]
      preset = 'qwerty'

      # Gaps between windows (inner-*) and between monitor edges (outer-*).
      # Possible values:
      # - Constant:     gaps.outer.top = 8
      # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
      #                 In this example, 24 is a default value when there is no match.
      #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
      #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
      [gaps]
      inner.horizontal = 4
      inner.vertical =   4
      outer.left =       4
      outer.bottom =     4
      outer.top =        4
      outer.right =      4

      # 'main' binding mode declaration
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # 'main' binding mode must be always presented
      # Fallback value (if you omit the key): mode.main.binding = {}
      [mode.main.binding]

      # All possible keys:
      # - Letters.        a, b, c, ..., z
      # - Numbers.        0, 1, 2, ..., 9
      # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
      # - F-keys.         f1, f2, ..., f20
      # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
      #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
      # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
      #                   keypadMinus, keypadMultiply, keypadPlus
      # - Arrows.         left, down, up, right

      # All possible modifiers: cmd, alt, ctrl, shift

      # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

      # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
      # You can uncomment the following lines to open up terminal with alt + enter shortcut (like in i3)
      # alt-enter = '''exec-and-forget osascript -e '
      # tell application "Terminal"
      #     do script
      #     activate
      # end tell'
      # '''

      # See: https://nikitabobko.github.io/AeroSpace/commands#layout
      alt-slash = 'layout tiles horizontal vertical'
      alt-comma = 'layout accordion horizontal vertical'

      alt-f = 'fullscreen'

      # See: https://nikitabobko.github.io/AeroSpace/commands#focus
      alt-h = 'focus left'
      alt-j = 'focus down'
      alt-k = 'focus up'
      alt-l = 'focus right'

      # See: https://nikitabobko.github.io/AeroSpace/commands#move
      cmd-ctrl-h = 'move left'
      cmd-ctrl-j = 'move down'
      cmd-ctrl-k = 'move up'
      cmd-ctrl-l = 'move right'

      # See: https://nikitabobko.github.io/AeroSpace/commands#resize
      alt-shift-minus = 'resize smart -50'
      alt-shift-equal = 'resize smart +50'

      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
      cmd-1 = 'workspace 1'
      cmd-2 = 'workspace 2'
      cmd-3 = 'workspace 3'
      cmd-4 = 'workspace 4'
      cmd-5 = 'workspace 5'
      cmd-6 = 'workspace 6'
      cmd-7 = 'workspace 7'
      cmd-8 = 'workspace 8'
      cmd-9 = 'workspace 9'

      # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
      cmd-alt-1 = ['move-node-to-workspace 1', 'workspace 1']
      cmd-alt-2 = ['move-node-to-workspace 2', 'workspace 2']
      cmd-alt-3 = ['move-node-to-workspace 3', 'workspace 3']
      cmd-alt-4 = ['move-node-to-workspace 4', 'workspace 4'] 
      cmd-alt-5 = ['move-node-to-workspace 5', 'workspace 5']
      cmd-alt-6 = ['move-node-to-workspace 6', 'workspace 6']
      cmd-alt-7 = ['move-node-to-workspace 7', 'workspace 7']
      cmd-alt-8 = ['move-node-to-workspace 8', 'workspace 8']
      cmd-alt-9 = ['move-node-to-workspace 9', 'workspace 9'] 

      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
      alt-tab = 'workspace-back-and-forth'
      # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
      alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

      # See: https://nikitabobko.github.io/AeroSpace/commands#mode
      alt-shift-semicolon = 'mode service'

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      [mode.service.binding]
      esc = ['reload-config', 'mode main']
      r = ['flatten-workspace-tree', 'mode main'] # reset layout
      f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
      backspace = ['close-all-windows-but-current', 'mode main']

      # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
      #s = ['layout sticky tiling', 'mode main']

      # TODO: Don't know what these do yet
      cmd-alt-h = ['join-with left', 'mode main']
      cmd-alt-j = ['join-with down', 'mode main']
      cmd-alt-k = ['join-with up', 'mode main']
      cmd-alt-l = ['join-with right', 'mode main']

      [[on-window-detected]]
      if.app-id = 'net.kovidgoyal.kitty'
      run = ['move-node-to-workspace 1']

      [[on-window-detected]]
      if.app-id = 'org.mozilla.firefox'
      run = ['move-node-to-workspace 2']

      [[on-window-detected]]
      if.app-id = 'com.tinyspeck.slackmacgap'
      run = ['move-node-to-workspace 3']

      # Colemak binds. Uncomment and rebuild when using laptop keyboard
      # [key-mapping.key-notation-to-key-code]
      # q = 'q'
      # w = 'w'
      # f = 'e'
      # p = 'r'
      # g = 't'
      # j = 'y'
      # l = 'u'
      # u = 'i'
      # y = 'o'
      # semicolon = 'p'
      # leftSquareBracket = 'leftSquareBracket'
      # rightSquareBracket = 'rightSquareBracket'
      # backslash = 'backslash'
      #
      # a = 'a'
      # r = 's'
      # s = 'd'
      # t = 'f'
      # d = 'g'
      # h = 'h'
      # n = 'j'
      # e = 'k'
      # i = 'l'
      # o = 'semicolon'
      # quote = 'quote'
      #
      # z = 'z'
      # x = 'x'
      # c = 'c'
      # v = 'v'
      # b = 'b'
      # k = 'n'
      # m = 'm'
      # comma = 'comma'
      # period = 'period'
      # slash = 'slash'
    '';
  };
}
