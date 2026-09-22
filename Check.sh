#!/bin/bash

# ==========================================
# VISUALS & LOGGING
# ==========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper to print info messages
msg_info() { echo -e "${BLUE}[*]${NC} $1"; }
msg_ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
msg_warn() { echo -e "${YELLOW}[!]${NC} $1"; }
msg_err()  { echo -e "${RED}[X]${NC} $1"; }

# ==========================================
# CONFIGURATION
# ==========================================

BASE_DIR="$PWD"
MY_TEMPLATES_DIR="$BASE_DIR/blackhole-vl/srcpkgs"
XBPS_DIR="$BASE_DIR/void-packages"
message=""

# ==========================================
# Functions
# ==========================================
# Helper to use native xbps-src update-check functionality

update_package() {
    local pkg=$1
    local target="$MY_TEMPLATES_DIR/srcpkgs/$pkg/template"
    local current

    current=$(grep "^version=" "$target" | cut -d= -f2)

    # Print a small indicator that we are checking
    echo -ne "${BLUE}[*]${NC} Checking upstream for $pkg... "

    # Run update-check.
    local latest=$(cd "$XBPS_DIR" && ./xbps-src update-check $pkg \
    | awk '{print $3}' \
    | sed 's/.*-//' \
    | sort -V \
    | tail -n1)

    if [ -z "$latest" ]; then
        echo "no update"
        return 1
    fi

    if [ "$latest" != "$current" ]; then
        echo "$pkg: $current to $latest"
        message="$pkg: update to $latest"
        sed -i "s/^version=.*/version=$latest/" "$target"
        sed -i "s/^revision=.*/revision=1/" "$target"

        (cd "$XBPS_DIR" && xgensum -fi "$pkg")

        return 0
    else
        echo "up-to-date"
        return 1
    fi
}

# ==========================================
# MAIN LOOP
# ==========================================

TARGET_PKGS=()

    for d in "$MY_TEMPLATES_DIR"/*; do
        [ -d "$d" ] && TARGET_PKGS+=("$(basename "$d")")
    done

for pkg in "${TARGET_PKGS[@]}"; do
    if update_package "$pkg"; then
        cd "$MY_TEMPLATES_DIR" || exit 1
        git checkout -B "auto-update-$pkg" master
        git add .
        git commit -m "$message"
    fi
done
