{ lib, fetchFromGitHub, buildHomeAssistantComponent }:

buildHomeAssistantComponent rec {
  owner = "ziffmafiya";
  domain = "zambretti_sager";
  version = "1.9.89";

  src = fetchFromGitHub {
    owner = "ziffmafiya";
    repo = "zambretti_sager";
    rev = "v${version}";
    sha256 = "sha256-nE3HqCP7A4RupAhK2R65geAQdjiy/uslA5XHYF7Euh4=";
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
