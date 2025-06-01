{
description = "first flake";

inputs = {
  nixpkgs.url = "nixpkgs/nixos-24.11";
  nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  nixpkgs-playwright.url = "github:NixOS/nixpkgs/979daf34c8cacebcd917d540070b52a3c2b9b16e";
  home-manager.url = "github:nix-community/home-manager/release-24.11";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
};

outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-playwright, home-manager, ... }@inputs:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    specialArgs = {
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-playwright = import nixpkgs-playwright {
        inherit system;
      };
      inherit system;
      inherit inputs;
    };
  in {
  nixosConfigurations = {
    nixos = lib.nixosSystem {
      inherit system;
      inherit specialArgs;
      modules = [ ./configuration.nix ];
    };
  };
  homeConfigurations = {
    shawnc = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = specialArgs;
      modules = [ ./home.nix ];
    };
  };
  };
}
