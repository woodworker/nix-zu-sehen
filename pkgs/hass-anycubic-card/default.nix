{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "anycubic-card";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "ljschmitt";
    repo = "hass-anycubic_card";
    rev = "v${version}";
    sha256 = "sha256-d6h03rxJBGYwzm3ERBgIfIic7bfIiC72t9b9n6sub5w=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    install -m0644 anycubic-card.js $out

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/ljschmitt/hass-anycubic_card/releases/tag/v${version}";
    description = "Home Assistant Lovelace card for Anycubic printers";
    homepage = "https://github.com/ljschmitt/hass-anycubic_card";
    license = licenses.gpl3Only;
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}
