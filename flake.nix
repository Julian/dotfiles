{
  description = "Julian's nix-darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin }: {
    darwinConfigurations.Airm = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ ./darwin/configuration.nix ];
    };
  };
}
