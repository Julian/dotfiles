{ pkgs, ... }:

{
  system.stateVersion = 5;
  system.primaryUser = "julian";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.julian = {
    name = "julian";
    home = "/Users/julian";
  };

  environment.systemPackages = with pkgs; [
    bat
    bottom
    btop
    cloc
    cmake
    delta
    difftastic
    djview
    dust
    duf
    elan
    enchant
    expect
    eza
    fd
    fdupes
    flamegraph
    (fortune.override { withOffensive = true; })
    fx
    fzy
    gcc
    gh
    git
    git-bug
    git-filter-repo
    glow
    gnugrep
    gnupg
    gnused
    gnutar
    graphite2
    gron
    htop
    hyperfine
    imagemagick
    inetutils
    irssi
    jq
    just
    libraw
    libxml2
    libxslt
    llama-cpp
    luajit
    luarocks
    mas
    moreutils
    mtr
    ncdu
    ncurses
    neovim
    nmap
    nodejs
    num-utils
    openssl
    pandoc
    par
    parallel
    pnpm
    podman
    postgresql_15
    prek
    presenterm
    procps
    protobufc
    pstree
    pv
    pypy
    ripgrep
    rlwrap
    rustfmt
    rustup
    skim
    socat
    sqlite
    terminal-notifier
    time
    tmux
    tokei
    tree
    tree-sitter
    universal-ctags
    util-linux
    uutils-coreutils
    uutils-diffutils
    uutils-findutils
    uv
    vhs
    w3m
    wait4x
    wget
    which
    xz
    yt-dlp
    zizmor
    zsh

    # Audio
    chromaprint

    # Language servers
    beancount-language-server
    clojure-lsp
    gopls
    lua-language-server
    marksman
    rust-analyzer
    taplo
    texlab
    tinymist
    ts_query_ls
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };

    taps = [ ];

    brews = [
      "cgdb"
      "trash"
    ];

    casks = [
      "container"
      "cyberduck"
      "firefox@beta"
      "kitty"
      "macpass"
      "netnewswire"
      "obsidian"
      "vlc"
      "yubico-authenticator"

      # Audio
      "cycling74-max"
      "guitar-pro"
      "vcv-rack"

      # Fonts
      "font-bitter-ht"
      "font-cooper-hewitt"
      "font-fira-mono"
      "font-fira-sans"
      "font-ibm-plex-math"
      "font-ibm-plex-mono"
      "font-ibm-plex-sans"
      "font-ibm-plex-sans-arabic"
      "font-ibm-plex-sans-condensed"
      "font-ibm-plex-sans-hebrew"
      "font-ibm-plex-serif"
      "font-inconsolata"
      "font-monaspace"
      "font-playfair-display"
      "font-raleway"
      "font-source-sans-3"
      "font-source-serif-4"

      # More
      "anki"
      "keycastr"
      "lulu"
      "obs"
      "openttd"
      "signal"
      "tailscale"
      "voiceink"

      # Photo
      "blender"
      "darktable"
      "inkscape"
      "phoenix-slides"
      "processing"
    ];

    masApps = {
      "GarageBand" = 682658836;
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "reMarkable Desktop" = 1276493162;
    };
  };
}
