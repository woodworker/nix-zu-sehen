{ pkgs, go, lib }:

pkgs.buildGoModule rec {
  name = "notesmd-cli-${version}";
  version = "0.3.7"; # replace with the package version

  src = pkgs.fetchFromGitHub {
    owner = "Yakitrak"; # replace with the GitHub username
    repo = "notesmd-cli"; # replace with the package repository name
    rev = "v${version}"; # replace with the package version tag
    sha256 = "sha256-dENOPkEeKTYPFf467Isoi7kaa8Bh78PqNyzjU8Q6BEc="; # replace with the source code checksum
  };

  # The repository vendors its Go dependencies (vendor/ directory),
  # so no vendorHash is required.
  vendorHash = null;

  meta = {
    description = "Interact with markdown notes in the terminal without requiring Obsidian to be running. Open, search, create, update, move and delete notes! (formerly obsidian-cli)";
    homepage = "https://github.com/Yakitrak/notesmd-cli";
    license = lib.licenses.mit; # replace with the appropriate license
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}
