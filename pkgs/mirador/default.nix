{ lib, rustPlatform, fetchFromGitHub, tzdata }:

rustPlatform.buildRustPackage rec {
  pname = "mirador";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "jchultarsky";
    repo = "mirador";
    rev = "v${version}";
    sha256 = "sha256-XaEEfG92M3kTHy1qe7/ACPPWYq54IEzHCdNbwrknXRk=";
  };

  cargoHash = "sha256-04Qi5WULpE6dj6oyF8do8Mtc1RRpyHetVBHbcV2vBNM=";

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
