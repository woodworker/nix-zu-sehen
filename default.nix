{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  packages = rec {
    ttrpg-convert-cli = callPackage ./pkgs/ttrpg-convert-cli {};
    obsidian-cli = callPackage ./pkgs/obsidian-cli {};

    inherit pkgs; # similar to `pkgs = pkgs;` This lets callers use the nixpkgs version defined in this file.
  };
in
  packages
