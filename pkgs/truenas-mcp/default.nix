{ pkgs, go, lib }:

pkgs.buildGo127Module rec {
  name = "truenas-mcp-${version}";
  version = "0.0.7";

  src = pkgs.fetchFromGitHub {
    owner = "truenas";
    repo = "truenas-mcp";
    rev = "v${version}";
    sha256 = "sha256-2gUcvUQFHO3H1GmZsJton86v0NaRuLRsWrEbcs0X5TI=";
  };

  vendorHash = "sha256-L7+NJP3SAL0fNvxH12E8Ak8tf6oKe5zUVHdXXteUIh8=";

  meta = {
    description = "A Model Context Protocol (MCP) server for TrueNAS that lets AI models interact with the TrueNAS API";
    homepage = "https://github.com/truenas/truenas-mcp";
    license = lib.licenses.gpl3Only;
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}
