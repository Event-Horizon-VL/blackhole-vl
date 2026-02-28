#!/bin/sh

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

if [ -f "$XDG_CONFIG_HOME/blockbench-flags.conf" ]; then
    BLOCKBENCH_USER_FLAGS="$(grep -v '^#' "$XDG_CONFIG_HOME/blockbench-flags.conf")"
fi

exec /usr/lib/blockbench/Blockbench $BLOCKBENCH_USER_FLAGS "$@"


