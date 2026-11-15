{ pkgs, go, lib }:

let
  # truenas-mcp >= 1.0.0 requires go >= 1.27.4, nixpkgs only ships 1.27.3 so far.
  # Falls back to the nixpkgs Go as soon as it has caught up.
  # (goVersion is deliberately not a `version = "..."` literal, update-packages.sh seds those.)
  goVersion = "1.27.4";
  go_1_27 =
    if lib.versionOlder pkgs.go_1_27.version goVersion then
      pkgs.go_1_27.overrideAttrs (old: {
        version = goVersion;
        src = pkgs.fetchurl {
          url = "https://go.dev/dl/go${goVersion}.src.tar.gz";
          hash = "sha256-c8+4VxrsDAEXdofbhxY9Rqog6XeWcncokaoXZU2aYJk=";
        };
      })
    else
      pkgs.go_1_27;
in
(pkgs.buildGo127Module.override { go = go_1_27; }) rec {
  name = "truenas-mcp-${version}";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "truenas";
    repo = "truenas-mcp";
    rev = "v${version}";
    sha256 = "sha256-iZS6hqzTQQfCWsdK6f6jf/ItYPU3XNj3NJJNht6DtAM=";
  };

  vendorHash = "sha256-RCcyGLepRB1YMTb6hvAyskYTzHrKlwqjRdnRLfdydls=";

  meta = {
    description = "A Model Context Protocol (MCP) server for TrueNAS that lets AI models interact with the TrueNAS API";
    homepage = "https://github.com/truenas/truenas-mcp";
    license = lib.licenses.gpl3Only;
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}
