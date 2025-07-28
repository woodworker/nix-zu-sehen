{ lib, fetchFromGitHub, buildHomeAssistantComponent }:

buildHomeAssistantComponent rec {
  owner = "zachowj";
  domain = "nodered";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "zachowj";
    repo = "hass-node-red";
    rev = "v${version}";
    sha256 = "sha256-qRQ4NMKmZUQ9wSYR8i8TPbQc3y69Otp7FSdGuwph14c=";
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