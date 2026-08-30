{ lib, rustPlatform, fetchFromGitHub, tzdata }:

rustPlatform.buildRustPackage rec {
  pname = "mirador";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "jchultarsky";
    repo = "mirador";
    rev = "v${version}";
    sha256 = "sha256-6G69zihj7zv00Av5vhl+FKY7B4mY0vUXSC5R7ZAAKE4=";
  };

  cargoHash = "sha256-KkezCtaNb/yKeGkNYG7+1/Kp/B1EeZJKUxESGeS4/G8=";

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
