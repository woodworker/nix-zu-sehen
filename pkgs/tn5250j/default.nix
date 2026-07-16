{ lib
, stdenv
, fetchurl
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, jre
}:

stdenv.mkDerivation rec {
  pname = "tn5250j";
  version = "0.8.0-beta2";

  # The release ships a tarball bundling the main jar together with all of its
  # dependency jars (jt400, log4j, jython, ...). The main jar's manifest uses a
  # relative Class-Path, so every jar has to live in the same directory.
  src = fetchurl {
    url = "https://github.com/tn5250j/tn5250j/releases/download/${version}/tn5250j-${version}.tgz";
    sha256 = "sha256-LV3RX7/XMkcC48JDjNKdgRYuc3wIp9mCQEZIsqofrco=";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  desktopItems = [
    (makeDesktopItem {
      name = "tn5250j";
      desktopName = "tn5250j";
      comment = "5250 terminal emulator for IBM i (AS/400) systems";
      exec = "tn5250j";
      icon = "tn5250j";
      categories = [ "Network" "TerminalEmulator" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    # Keep all jars together so the relative Class-Path in tn5250j.jar resolves.
    mkdir -p $out/share/tn5250j
    cp *.jar $out/share/tn5250j/

    # The tarball ships icons in a handful of sizes; wire them into hicolor.
    install -Dm644 tn5250j-16x16.png  $out/share/icons/hicolor/16x16/apps/tn5250j.png
    install -Dm644 tn5250j-32x32.png  $out/share/icons/hicolor/32x32/apps/tn5250j.png
    install -Dm644 tn5250j-48x48.png  $out/share/icons/hicolor/48x48/apps/tn5250j.png
    install -Dm644 tn5250j-128.png    $out/share/icons/hicolor/128x128/apps/tn5250j.png
    install -Dm644 tn5250j-256.png    $out/share/icons/hicolor/256x256/apps/tn5250j.png
    install -Dm644 tn5250j-512.png    $out/share/icons/hicolor/512x512/apps/tn5250j.png

    makeWrapper ${jre}/bin/java $out/bin/tn5250j \
      --add-flags "-jar $out/share/tn5250j/tn5250j.jar" \
      --set _JAVA_AWT_WM_NONREPARENTING 1 \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on'

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/tn5250j/tn5250j";
    description = "Java 5250 terminal emulator for IBM i (AS/400) systems";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "tn5250j";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}
