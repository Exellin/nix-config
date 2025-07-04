{ config, pkgs, pkgs-playwright, ... }:

let
  browsers = (builtins.fromJSON (builtins.readFile "${pkgs-playwright.playwright-driver}/browsers.json")).browsers;
  chromium-rev = (builtins.head (builtins.filter (x: x.name == "chromium") browsers)).revision;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "shawnc";
  home.homeDirectory = "/home/shawnc";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/shawnc/etc/profile.d/hm-session-vars.sh
  #
    home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.file.".config/Code/User/settings.json".text = ''
    {
      "terminal.integrated.defaultProfile.linux": "zsh",
      "window.restoreFullscreen": true,
      "window.newWindowDimensions": "fullscreen",
      "editor.tabSize": 2,
      "files.trimTrailingWhitespace": true,
      "files.insertFinalNewline": true,
      "editor.codeActionsOnSave": {
        "source.fixAll.eslint": "explicit"
      },
    }
  '';

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dbaeumer.vscode-eslint
      eamodio.gitlens
      cweijan.vscode-database-client2
      bbenoist.nix
      denoland.vscode-deno
    ];
  };

  programs = {
    zsh = {
      enable = true;
      initExtra = "path+=/home/shawnc/.local/bin";
      shellAliases = {
        "17lands" = "seventeenlands -l '.local/share/Steam/steamapps/compatdata/2141910/pfx/drive_c/users/steamuser/AppData/LocalLow/Wizards Of The Coast/MTGA/Player.log'";
      };
      # Based on https://nixos.wiki/wiki/Playwright
      envExtra = ''
        export PLAYWRIGHT_BROWSERS_PATH="${pkgs-playwright.playwright.browsers}"
        export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS="true"
        export PLAYWRIGHT_NODEJS_PATH="${pkgs.nodejs}/bin/node"
        export PLAYWRIGHT_LAUNCH_OPTIONS_EXECUTABLE_PATH="${pkgs-playwright.playwright.browsers}/chromium-${chromium-rev}/chrome-linux/chrome"
      '';
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
