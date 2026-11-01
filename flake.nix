{
  description = "Maximalist Task Manager: an icons-only Plasma task manager with per-window icons";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.callPackage ./package.nix { };
      });

      overlays.default = final: prev: {
        plasma-maximalist-task-manager = final.callPackage ./package.nix { };
      };
    };
}
