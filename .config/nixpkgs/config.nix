{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        coreutils
        ctags
        findutils
        gcc
        gdb
        gfortran
        git
        irssi
        jq
        neovim
        nmap
        nodejs
        nixUnstable
        openssl
        postgresql
        "protobuf-2"
        pstree
        python2.7
        "python2.7-pip"
        python3
        reattach-to-user-namespace
        ripgrep
        snappy
        tmux
        zsh
      ];
    };
  };
}
