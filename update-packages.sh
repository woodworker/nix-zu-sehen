#!/usr/bin/env bash

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

# Function to update package file
update_package() {
    local package_name="$1"
    local package_file="$2"
    
    echo -e "${YELLOW}Updating ${package_name}...${NC}"
    
    # Extract version and sha256 from generated.json
    local version=$(jq -r ".\"$package_name\".version" _sources/generated.json)
    local sha256
    
    if [[ "$package_name" == "ttrpg-convert-cli" ]]; then
        # For ttrpg-convert-cli, get SHA256 from the JAR file fetch
        sha256=$(jq -r ".\"$package_name\".src.sha256" _sources/generated.json)
    else
        # For other packages, get SHA256 from GitHub source
        sha256=$(jq -r ".\"$package_name\".src.sha256" _sources/generated.json)
    fi
    
    if [[ "$version" == "null" || "$sha256" == "null" ]]; then
        echo -e "${RED}❌ Failed to extract version/sha256 for $package_name${NC}"
        return 1
    fi
    
    echo "  Version: $version"
    echo "  SHA256: $sha256"
    
    # Update the package file
    if [[ "$package_name" == "ttrpg-convert-cli" ]]; then
        # Update version line
        sed -i "s/version = \".*\";/version = \"$version\";/" "$package_file"
        # Update sha256 line - escape special characters in sha256
        escaped_sha256=$(printf '%s\n' "$sha256" | sed 's/[[\.*^$()+?{|]/\\&/g')
        sed -i "s/sha256 = \".*\";/sha256 = \"$escaped_sha256\";/" "$package_file"
    elif [[ "$package_name" == "obsidian-cli" ]]; then
        # Remove 'v' prefix from version for obsidian-cli package file
        clean_version=${version#v}
        # Update version line
        sed -i "s/version = \".*\";/version = \"$clean_version\";/" "$package_file"
        # Update sha256 line - escape special characters in sha256
        escaped_sha256=$(printf '%s\n' "$sha256" | sed 's/[[\.*^$()+?{|]/\\&/g')
        sed -i "s/sha256 = \".*\";/sha256 = \"$escaped_sha256\";/" "$package_file"
        # Note: rev is not updated as it uses the variable: rev = "v${version}"
    fi
    
    echo -e "${GREEN}✅ Updated $package_name to version $version${NC}"
}

# Update each package
if jq -e '.["ttrpg-convert-cli"]' _sources/generated.json > /dev/null; then
    update_package "ttrpg-convert-cli" "pkgs/ttrpg-convert-cli/default.nix"
fi

if jq -e '.["obsidian-cli"]' _sources/generated.json > /dev/null; then
    update_package "obsidian-cli" "pkgs/obsidian-cli/default.nix"
fi

echo -e "${GREEN}🎉 Package updates completed!${NC}"
echo -e "${YELLOW}💡 Don't forget to test the packages with: nix-build -A <package-name>${NC}"