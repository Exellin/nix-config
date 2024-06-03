{
 description = "first flake";

 inputs = {
  nixpkgs.url = "nixpkgs/nixos-24.05";
  home-manager = {
    url = "github:nix-community/home-manager/release-24.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  plasma-manager = {
    url = "github:pjones/plasma-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };
 };

 outputs = inputs@ { self, nixpkgs, home-manager, plasma-manager, ... }:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
   nixosConfigurations = {
     nixos = lib.nixosSystem {
      inherit system;
      modules = [ ./configuration.nix ];
     };
   };
   homeConfigurations = {
    shawnc = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ./home.nix ];
     };
   };
  };
}
