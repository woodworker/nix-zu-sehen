{ lib, rustPlatform, fetchFromGitHub, tzdata }:

rustPlatform.buildRustPackage rec {
  pname = "mirador";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "jchultarsky";
    repo = "mirador";
    rev = "v${version}";
    sha256 = "sha256-bn3SQEgNHzH/NdnTdQkqmMlzASNqMIuUTJM/1qZRpMM=";
  };

  cargoHash = "sha256-2RM1HBw1C6k0VU/1U55gD8q3rlEO+KLiLKsyyCh/Frs=";

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
