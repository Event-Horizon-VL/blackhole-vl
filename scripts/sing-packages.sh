#!/usr/bin/env bash
set -euo pipefail

ARCH="$1"
MIRROR_PATH="$2"

REPO="${MIRROR_PATH}/${ARCH}"
INCOMING="~/INCOMING/${ARCH}"
PRIVKEY="${MIRROR_PATH}/private.pem"

SIGNEDBY="Nizarjh <chel773@tutamail.com>"

export PATH="/opt/xbps/usr/bin:$PATH"

mkdir -p "$REPO"
mkdir -p "$INCOMING"

exec 9>/tmp/xbps-repo-${ARCH}.lock
flock -n 9 || {
    echo "repository is locked"
    exit 1
}

cd "$REPO"

shopt -s nullglob

for f in "$INCOMING"/*.xbps; do
    base=$(basename "$f")
    pkgname=$(printf "%s\n" "$base" | sed -E 's/-[0-9].*$//')

    rm -f "${pkgname}-"*.xbps
    rm -f "${pkgname}-"*.xbps.sig2
done

if [ -f "$INCOMING/removed.txt" ]; then
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue

        rm -f "${pkg}-".xbps
        rm -f "${pkg}-".xbps.sig2
    done < "$INCOMING/removed.txt"
fi

mv "$INCOMING"/*.xbps . 2>/dev/null || true
mv "$INCOMING"/*.xbps.sig2 . 2>/dev/null || true

xbps-rindex -a ./*.xbps || true
xbps-rindex -r "$PWD"

xbps-rindex \
    -s \
    ----signedby  "$SIGNEDBY" \
    --privkey "$PRIVKEY" \
    "$PWD"

if compgen -G "$PWD/*.xbps" > /dev/null; then
    xbps-rindex \
        -S \
        --privkey "$PRIVKEY" \
        "$PWD"/*.xbps
fi

xbps-rindex -c "$PWD"

find "$INCOMING" -type f -delete
