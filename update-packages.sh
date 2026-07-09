#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nvfetcher jq yq-go git coreutils gnused gnugrep

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔍 Checking for package updates with nvfetcher...${NC}"

# Run nvfetcher to check for updates
if ! nvfetcher --verbose; then
    echo -e "${RED}❌ nvfetcher failed to fetch updates${NC}"
    exit 1
fi

# Check if _sources directory was created and contains updates
if [[ ! -d "_sources" ]]; then
    echo -e "${YELLOW}⚠️  No _sources directory found. No updates available.${NC}"
    exit 0
fi

if [[ ! -f "_sources/generated.json" ]]; then
    echo -e "${YELLOW}⚠️  No generated.json found. No updates available.${NC}"
    exit 0
fi

echo -e "${GREEN}📦 Processing package updates...${NC}"

# Function to get override value from nvfetcher.toml
get_override() {
    local package="$1"
    local key="$2"
    local default="$3"
    
    # Use yq to extract the override value, fallback to default if not found
    yq eval -p toml ".\"$package\".nixzusehen.\"$key\" // \"$default\"" nvfetcher.toml 2>/dev/null || echo "$default"
}

# Function to update package file generically
update_package() {
    local package="$1"
    local package_file="pkgs/$package/default.nix"
    
    if [[ ! -f "$package_file" ]]; then
        echo -e "${RED}❌ Package file not found: $package_file${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Updating ${package}...${NC}"
    
    # Get override configuration
    local version_transform=$(get_override "$package" "version_transform" "none")
    local sha256_source=$(get_override "$package" "sha256_source" "src")
    
    # Extract version and sha256 from generated.json
    local raw_version=$(jq -r ".\"$package\".version" _sources/generated.json)
    local sha256
    
    if [[ "$sha256_source" == "fetch_url" ]]; then
        # For packages with direct fetch (like JAR files)
        sha256=$(jq -r ".\"$package\".src.sha256" _sources/generated.json)
    else
        # For standard source packages
        sha256=$(jq -r ".\"$package\".src.sha256" _sources/generated.json)
    fi
    
    if [[ "$raw_version" == "null" || "$sha256" == "null" ]]; then
        echo -e "${RED}❌ Failed to extract version/sha256 for $package${NC}"
        return 1
    fi
    
    # Apply version transformation
    local version="$raw_version"
    case "$version_transform" in
        "strip_v")
            version=${raw_version#v}
            ;;
        "none")
            version="$raw_version"
            ;;
        *)
            echo -e "${RED}❌ Unknown version_transform: $version_transform${NC}"
            return 1
            ;;
    esac
    
    echo "  Raw version: $raw_version"
    echo "  Processed version: $version"
    echo "  SHA256: $sha256"
    echo "  Version transform: $version_transform"
    echo "  SHA256 source: $sha256_source"
    
    # Update the package file
    # Escape special characters in sha256 for sed
    # Escape & for sed replacement
    escaped_sha256=${sha256//&/\\&}
    
    # Use # as delimiter to avoid conflicts
    sed -i "s#sha256 = \".*\";#sha256 = \"$escaped_sha256\";#" "$package_file"
    
    sed -i "s#version = \".*\";#version = \"$version\";#" "$package_file"
    
    echo -e "${GREEN}✅ Updated $package to version $version${NC}"
}

# Refresh the Go module vendorHash for buildGoModule packages.
#
# nvfetcher only tracks the source hash, not the Go-specific vendorHash that
# buildGoModule requires. A release that changes Go dependencies therefore
# leaves a stale vendorHash and the build fails. This builds the package with
# its current vendorHash: if it still builds, the Go dependencies are unchanged;
# if it fails with a fixed-output hash mismatch, we capture the correct hash
# from the error and patch it in. Non-Go packages, and Go packages with no
# dependencies (vendorHash = null), have no literal vendorHash and are skipped.
update_go_vendor_hash() {
    local package="$1"
    local package_file="pkgs/$package/default.nix"

    if ! grep -qE 'vendorHash = "sha256-' "$package_file"; then
        return 0
    fi

    echo -e "${YELLOW}Checking Go vendorHash for ${package}...${NC}"

    local build_output build_status=0
    build_output=$(nix-build -A "$package" --no-out-link 2>&1) || build_status=$?

    if [[ "$build_status" -eq 0 ]]; then
        echo -e "${GREEN}✅ Go vendorHash for $package is still valid${NC}"
        return 0
    fi

    # Extract the correct hash from the "got: sha256-..." line of the mismatch.
    local new_hash
    new_hash=$(printf '%s\n' "$build_output" \
        | grep -oE 'got:[[:space:]]+sha256-[A-Za-z0-9+/=]+' \
        | grep -oE 'sha256-[A-Za-z0-9+/=]+' \
        | head -1)

    if [[ -z "$new_hash" ]]; then
        echo -e "${RED}❌ $package failed to build for a reason other than a Go vendorHash mismatch:${NC}"
        printf '%s\n' "$build_output" | tail -n 20
        return 1
    fi

    local escaped_hash=${new_hash//&/\\&}
    sed -i "s#vendorHash = \"sha256-[^\"]*\";#vendorHash = \"$escaped_hash\";#" "$package_file"

    echo -e "${GREEN}✅ Updated Go vendorHash for $package to $new_hash${NC}"
}

# Auto-discover packages from nvfetcher.toml and update them
echo -e "${GREEN}📋 Auto-discovering packages from nvfetcher.toml...${NC}"

# Get all package names from nvfetcher.toml
packages=$(yq eval -p toml 'keys | .[]' nvfetcher.toml)

for package in $packages; do
    # Check if package exists in generated.json
    if jq -e ".\"$package\"" _sources/generated.json > /dev/null; then
        update_package "$package"
        update_go_vendor_hash "$package"
    else
        echo -e "${YELLOW}⚠️  No updates found for $package${NC}"
    fi
done

echo -e "${GREEN}🎉 Package updates completed!${NC}"
echo -e "${YELLOW}💡 Don't forget to test the packages with: nix-build -A <package-name>${NC}"
