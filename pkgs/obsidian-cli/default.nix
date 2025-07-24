{ pkgs, go, lib }:

pkgs.buildGoModule rec {
  name = "obsidian-cli-${version}";
  version = "0.1.8"; # replace with the package version

  src = pkgs.fetchFromGitHub {
    owner = "Yakitrak"; # replace with the GitHub username
    repo = "obsidian-cli"; # replace with the package repository name
    rev = "v${version}"; # replace with the package version tag
    sha256 = "sha256-W3QdWklO39W0wI1kt2M14QYmcc8AqxhqXROctMV4zQU="; # replace with the source code checksum
  };

  vendorHash = null;#lib.fakeHash;

  # If the package has dependencies outside of Go, list them here
  # For example:
  # buildInputs = [ go pkgconfig zlib ];

  # If the package is a command-line tool, you can specify the output binaries
  # For example:
  # meta.installable = true;
  # meta.installable.bin = ["my-go-package"];

  meta = {
    description = "Interact with Obsidian in the terminal. Open, search, create, update, move and delete notes!";
    homepage = "https://github.com/Yakitrak/obsidian-cli";
    license = lib.licenses.mit; # replace with the appropriate license
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}