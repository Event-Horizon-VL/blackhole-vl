#!/usr/bin/env bash
set -euo pipefail

ARCH="$1"
MIRROR_PATH="$2"

REPO="${MIRROR_PATH}/${ARCH}"
INCOMING="${HOME}/INCOMING/${ARCH}"
PRIVKEY="${MIRROR_PATH}/private.pem"

SIGNEDBY="Nizarjh <chel773@tutamail.com>"

export PATH="/opt/xbps/usr/bin:$PATH"

mkdir -p "$REPO"
mkdir -p "$INCOMING"

exec 9>"/tmp/xbps-repo-${ARCH}.lock"

flock -n 9 || {
    echo "repository is locked"
    exit 1
}

cd "$REPO"

shopt -s nullglob

echo "==> removing old versions of incoming packages"

for f in "$INCOMING"/*.xbps; do
    base=$(basename "$f")

    pkgname=$(xbps-uhelper binpkgver "$base")

    echo "   - cleaning old package: $pkgname"

    rm -f "${pkgname}-"*.xbps
    rm -f "${pkgname}-"*.xbps.sig2
done

if [ -f "$INCOMING/removed.txt" ]; then
    echo "==> removing deleted packages"

    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue

        echo "   - removing: $pkg"

        rm -f "${pkg}-"*.xbps
        rm -f "${pkg}-"*.xbps.sig2
    done < "$INCOMING/removed.txt"
fi

echo "==> moving new packages"

xbps_files=("$INCOMING"/*.xbps)

if ((${#xbps_files[@]})); then
    mv "${xbps_files[@]}" .
fi

sig_files=("$INCOMING"/*.xbps.sig2)

if ((${#sig_files[@]})); then
    mv "${sig_files[@]}" .
fi

echo "==> indexing repository"

repo_files=(./*.xbps)

if ((${#repo_files[@]})); then
    xbps-rindex -a "${repo_files[@]}"
fi

xbps-rindex -r "$PWD"

echo "==> signing repository index"

xbps-rindex \
    -s \
    --signedby "$SIGNEDBY" \
    --privkey "$PRIVKEY" \
    "$PWD"

if compgen -G "$PWD/*.xbps" > /dev/null; then
    echo "==> signing packages"

    xbps-rindex \
        -S \
        --privkey "$PRIVKEY" \
        "$PWD"/*.xbps
fi

echo "==> compressing repository index"

xbps-rindex -c "$PWD"

echo "==> cleaning incoming directory"

find "$INCOMING" -type f -delete

echo "==> repository deployment completed"
