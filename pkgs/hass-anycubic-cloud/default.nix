{ lib, fetchFromGitHub, buildHomeAssistantComponent, home-assistant }:

buildHomeAssistantComponent rec {
  owner = "ljschmitt";
  domain = "anycubic_ha_integration";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ljschmitt";
    repo = "hass-anycubic_cloud_v3";
    rev = "v${version}";
    sha256 = "sha256-HjI4EO7LPMr8H6kRzWVxGncOIprNuSXXe1UXRblZ3Zg=";
  };

  dependencies = with home-assistant.python3Packages; [
    paho-mqtt
  ];

  meta = with lib; {
    changelog = "https://github.com/ljschmitt/hass-anycubic_cloud_v3/releases/tag/v${version}";
    description = "Anycubic Cloud integration for Home Assistant";
    homepage = "https://github.com/ljschmitt/hass-anycubic_cloud_v3";
    license = licenses.gpl3Only;
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}
