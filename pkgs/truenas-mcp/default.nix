{ pkgs, go, lib }:

pkgs.buildGoModule rec {
  name = "truenas-mcp-${version}";
  version = "0.0.6";

  src = pkgs.fetchFromGitHub {
    owner = "truenas";
    repo = "truenas-mcp";
    rev = "v${version}";
    sha256 = "sha256-xEiEyUShMVO6OO1/c1sUhhamXjjb+Bss4eNCEil7d4c=";
  };

  vendorHash = "sha256-0A+zS5N+LZ7yRabl6BvovpZPq9NErroW21sRfiMTA+c=";

  meta = {
    description = "A Model Context Protocol (MCP) server for TrueNAS that lets AI models interact with the TrueNAS API";
    homepage = "https://github.com/truenas/truenas-mcp";
    license = lib.licenses.gpl3Only;
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}
