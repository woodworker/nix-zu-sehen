{ lib, rustPlatform, fetchFromGitHub, tzdata }:

rustPlatform.buildRustPackage rec {
  pname = "mirador";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "jchultarsky";
    repo = "mirador";
    rev = "v${version}";
    sha256 = "sha256-pDoECY5+IOVMTCDMLEc9PSdgxvHBi0MPbP7+vqUQXyE=";
  };

  cargoHash = "sha256-4SmRXn2ew/312MvUHkz/1erSXCvmm/qIWmY/HwVzUUE=";

  # The timezone widget's tests resolve real IANA zone names, which needs
  # tzdata present and TZDIR pointed at it inside the build sandbox.
  nativeCheckInputs = [ tzdata ];
  TZDIR = "${tzdata}/share/zoneinfo";

  meta = {
    description = "An opinionated personal dashboard for your terminal: world clocks, a calendar, weather, tasks, notes, a market watchlist, and live CPU and network graphs";
    homepage = "https://github.com/jchultarsky/mirador";
    license = lib.licenses.mit;
    mainProgram = "mirador";
    maintainers = [
      { name = "Martin Holzhauer"; email = "martin@holzhauer.eu"; }
    ];
  };
}
