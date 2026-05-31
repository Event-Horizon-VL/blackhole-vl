#!/bin/bash

set -e

pkg="$1"
arch="$2"
template_dir="$3"

template="${template_dir}/${pkg}/template"

case "$pkg" in
    *-devel|*-dbg) exit 0 ;;
esac

[ -f "$template" ] || { echo "ERROR: template not found: $template" >&2; exit 2; }

archs=$(awk -F= '/^archs=/ {
    gsub(/^archs=/, "");
    gsub(/^["\047]/, "");
    gsub(/["\047]$/, "");
    print;
    exit;
}' "$template")

[ -z "$archs" ] && exit 0

for a in $archs; do
    [ "$a" = "~$arch" ] && exit 1
done

has_positive=0
for a in $archs; do
    case "$a" in ~*) ;; *) has_positive=1; break ;; esac
done

if [ "$has_positive" -eq 1 ]; then
    for a in $archs; do
        case "$a" in ~*) ;; *) [ "$a" = "$arch" ] && exit 0 ;; esac
    done
    exit 1
fi

exit 0
