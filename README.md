## Commands

- Grab latest versions of packages to update flake.lock: `nix flake update`
- Rebuild NixOs from within dotfiles: `sudo nixos-rebuild switch --flake .`
- Rebuild home manager from within dotfiles: `home-manager switch --flake .`
- Run `home-manager generations` followed by one of the /nix/store generations in `/nix/store/generation/activate` to rollback to a previous version

## Resources

- Search for packages and config options at https://mynixos.com/

