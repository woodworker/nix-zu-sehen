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
    local escaped_sha256=$(printf '%s\n' "$sha256" | sed 's/[[\.*^$()+?{|]/\\&/g')
    
    # Update version line
    sed -i "s/version = \".*\";/version = \"$version\";/" "$package_file"
    
    # Update sha256 line
    sed -i "s/sha256 = \".*\";/sha256 = \"$escaped_sha256\";/" "$package_file"
    
    echo -e "${GREEN}✅ Updated $package to version $version${NC}"
}

# Auto-discover packages from nvfetcher.toml and update them
echo -e "${GREEN}📋 Auto-discovering packages from nvfetcher.toml...${NC}"

# Get all package names from nvfetcher.toml
packages=$(yq eval -p toml 'keys | .[]' nvfetcher.toml)

for package in $packages; do
    # Check if package exists in generated.json
    if jq -e ".\"$package\"" _sources/generated.json > /dev/null; then
        update_package "$package"
    else
        echo -e "${YELLOW}⚠️  No updates found for $package${NC}"
    fi
done

echo -e "${GREEN}🎉 Package updates completed!${NC}"
echo -e "${YELLOW}💡 Don't forget to test the packages with: nix-build -A <package-name>${NC}"