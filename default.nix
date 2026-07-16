{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  packages = rec {
    ttrpg-convert-cli = callPackage ./pkgs/ttrpg-convert-cli {};
    notesmd-cli = callPackage ./pkgs/notesmd-cli {};
    hass-node-red = callPackage ./pkgs/hass-node-red {};
    truenas-mcp = callPackage ./pkgs/truenas-mcp {};
    tn5250j = callPackage ./pkgs/tn5250j {};

    inherit pkgs; # similar to `pkgs = pkgs;` This lets callers use the nixpkgs version defined in this file.
  };
in
  packages
