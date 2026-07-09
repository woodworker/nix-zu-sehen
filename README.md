# nix-zu-sehen

> *Bitte gehen Sie weiter, hier gibt es nix zu sehen* 🚧

A private Nix package collection for packages I wanted but weren't available in the main nixpkgs channels. This repository follows Nix packaging conventions and provides derivations for external tools.

## Quick Start

```bash
# Build a specific package
nix-build -A ttrpg-convert-cli
nix-build -A notesmd-cli
nix-build -A hass-node-red

# Build all packages
nix-build

# Enter development shell
nix-shell helper/ttrpg-shell.nix
```

## Available Packages

### CLI Tools
- **`ttrpg-convert-cli`** - Java-based tool for converting TTRPG content (JAR from GitHub releases)
- **`notesmd-cli`** - Go-based tool for interacting with markdown notes/vaults from the terminal, formerly obsidian-cli (built from GitHub source)

### Home Assistant Components  
- **`hass-node-red`** - Node-RED Companion integration for Home Assistant

## Architecture

The repository follows standard Nix packaging patterns:

```
├── default.nix              # Main entry point exposing all packages
├── pkgs/                    # Individual package definitions
│   ├── ttrpg-convert-cli/   # Java JAR package
│   ├── notesmd-cli/         # Go source package  
│   └── hass-node-red/       # Home Assistant component
├── helper/                  # Development shells and utilities
├── nvfetcher.toml          # Package update configuration
└── update-packages.sh      # Automated update script
```

### Package Types

- **Java packages**: Use `fetchurl` to download JAR files and `makeWrapper` to create executable scripts
- **Go packages**: Use `buildGoModule` with `fetchFromGitHub` for source-based builds  
- **Home Assistant components**: Use `buildHomeAssistantComponent` for Python-based integrations

## Development

### Testing Packages

```bash
# Test that a package builds and installs correctly
nix-build -A <package-name> && result/bin/<binary-name> --help

# Test all packages
nix-build
```

### Adding New Packages

1. **Create package directory**: `pkgs/<package-name>/`
2. **Write derivation**: `pkgs/<package-name>/default.nix` following existing patterns
3. **Add to default.nix**: Include in packages attribute set
4. **Configure updates**: Add entry to `nvfetcher.toml`
5. **Add to CI**: Update `.github/workflows/build-packages.yml` matrix

## Automated Updates

The repository includes an automated package update system using `nvfetcher`:

### Update Configuration

Package updates are configured in `nvfetcher.toml` with optional override keys:

```toml
[package-name]
src.github = "owner/repo"
fetch.github = "owner/repo"
# Optional overrides with nixzusehen.* prefix
nixzusehen.version_transform = "strip_v"  # or "none" 
nixzusehen.sha256_source = "src"          # or "fetch_url"
```

### Available Override Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `nixzusehen.version_transform` | `"none"`, `"strip_v"` | `"none"` | How to process version strings |
| `nixzusehen.sha256_source` | `"src"`, `"fetch_url"` | `"src"` | Which hash to use from nvfetcher output |

### Manual Updates

```bash
# Check for and apply package updates
./update-packages.sh

# After updates, test the packages
nix-build -A <package-name>
```

The update script is self-contained using `nix-shell` and automatically:
- Discovers all packages from `nvfetcher.toml`
- Applies appropriate version transformations
- Updates package definitions with new versions and hashes
- Requires no maintenance when adding new packages

### Examples

```toml
# JAR package with direct URL fetch
[ttrpg-convert-cli]
src.github = "ebullient/ttrpg-convert-cli"
fetch.url = "https://github.com/ebullient/ttrpg-convert-cli/releases/download/$ver/ttrpg-convert-cli-$ver-runner.jar"
nixzusehen.sha256_source = "fetch_url"

# Standard source package with version prefix
[notesmd-cli]
src.github = "Yakitrak/notesmd-cli"
fetch.github = "Yakitrak/notesmd-cli"
nixzusehen.version_transform = "strip_v"

# Home Assistant component
[hass-node-red]
src.github = "zachowj/hass-node-red"  
fetch.github = "zachowj/hass-node-red"
nixzusehen.version_transform = "strip_v"
```

## CI/CD

The repository includes GitHub Actions workflows:

### Build Packages (`build-packages.yml`)
- Builds and tests all packages on every push/PR
- Ensures packages work correctly across changes
- Tests package installation and binary execution

### Update Packages (`update-packages.yml`)  
- Weekly automated package updates (Sundays 6:00 AM UTC)
- Uses nvfetcher to check for new versions
- Updates package definitions automatically
- Tests updated packages build successfully
- Creates pull requests with updates for review

### Adding Packages to CI

When adding a new package:
1. **Add to build matrix**: Update `matrix.package` in `.github/workflows/build-packages.yml`
2. **Configure updates**: Add entry to `nvfetcher.toml` 
3. **No script changes needed**: Update script auto-discovers new packages

## Usage Examples

### Building Packages

```bash
# Build specific packages
nix-build -A ttrpg-convert-cli
nix-build -A notesmd-cli
nix-build -A hass-node-red

# Build all packages
nix-build

# Install to user profile
nix-env -f . -iA ttrpg-convert-cli
```

### Using Packages

```bash
# TTRPG Convert CLI
result/bin/ttrpg-convert-cli --help

# NotesMD CLI (formerly obsidian-cli)
result/bin/notesmd-cli --help

# Home Assistant Component
# Copy to Home Assistant custom_components directory:
# cp -r result/custom_components/nodered ~/.homeassistant/custom_components/
```

### Development Shells

```bash
# Enter shell with ttrpg-convert-cli available
nix-shell helper/ttrpg-shell.nix

# Use direnv for automatic shell activation (optional)
echo "use nix" > .envrc && direnv allow
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your package following existing patterns
4. Test your changes: `nix-build -A <your-package>`
5. Submit a pull request

### Package Standards

- Follow Nix packaging conventions
- Include proper metadata (homepage, description, license, maintainers)
- Add appropriate nvfetcher configuration for updates
- Test package builds and basic functionality
- Use existing patterns for similar package types

## License

Individual packages retain their original licenses. This repository's packaging code is available under the terms specified by individual package maintainers.

---

*Hier gibt es wirklich nix zu sehen, aber trotzdem danke fürs Vorbeischauen! 👋*