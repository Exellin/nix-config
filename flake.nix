{
 description = "first flake";

 inputs = {
  nixpkgs.url = "nixpkgs/nixos-24.05";
  nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager.url = "github:nix-community/home-manager/release-24.05";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
 };

 outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    specialArgs = {
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
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
      modules = [ ./home.nix ];
     };
   };
  };
}
