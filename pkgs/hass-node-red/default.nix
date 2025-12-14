{ lib, fetchFromGitHub, buildHomeAssistantComponent }:

buildHomeAssistantComponent rec {
  owner = "zachowj";
  domain = "nodered";
  version = "4.1.5";

  src = fetchFromGitHub {
    owner = "zachowj";
    repo = "hass-node-red";
    rev = "v${version}";
    sha256 = "sha256-0x4BgWpWcIShVch9JgzYrzvGfe05UIz1rqiekpvtT4s=";
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