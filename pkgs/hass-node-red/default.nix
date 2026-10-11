{ lib, fetchFromGitHub, buildHomeAssistantComponent }:

buildHomeAssistantComponent rec {
  owner = "zachowj";
  domain = "nodered";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "zachowj";
    repo = "hass-node-red";
    rev = "v${version}";
    sha256 = "sha256-Cc1qd7TRCHiRXVIvkirtln4L8R2VwR/2xbIxnuwd7Kk=";
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