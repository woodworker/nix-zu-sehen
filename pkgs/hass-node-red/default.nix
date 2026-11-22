{ lib, fetchFromGitHub, buildHomeAssistantComponent }:

buildHomeAssistantComponent rec {
  owner = "zachowj";
  domain = "nodered";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "zachowj";
    repo = "hass-node-red";
    rev = "v${version}";
    sha256 = "sha256-t5vhJLrP74/7aTyawM3mTo5hGnd0NnY/gYWDDFotHSE=";
  };

  dependencies = [];

  meta = with lib; {
    changelog = "https://github.com/zachowj/hass-node-red/releases/tag/v${version}";
    description = "Node-RED Companion integration for Home Assistant";
    homepage = "https://github.com/zachowj/hass-node-red";
    license = licenses.mit;
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}