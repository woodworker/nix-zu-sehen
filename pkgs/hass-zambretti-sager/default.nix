{ lib, fetchFromGitHub, buildHomeAssistantComponent }:

buildHomeAssistantComponent rec {
  owner = "ziffmafiya";
  domain = "zambretti_sager";
  version = "1.9.88";

  src = fetchFromGitHub {
    owner = "ziffmafiya";
    repo = "zambretti_sager";
    rev = "v${version}";
    sha256 = "sha256-BN6E9CFt6tKKjgY0C551eP5cQZlPZL5Z3iM7y24pbII=";
  };

  dependencies = [];

  meta = with lib; {
    changelog = "https://github.com/ziffmafiya/zambretti_sager/releases/tag/v${version}";
    description = "Zambretti and Sager weather forecasting integration for Home Assistant";
    homepage = "https://github.com/ziffmafiya/zambretti_sager";
    license = licenses.mit;
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}
