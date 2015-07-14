#!/bin/bash

trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

[ -z "${PS1:-}" ] && . "$DOTPATH"/etc/lib/vital.sh

is_osx || die "osx only"

if has "brew"; then
    exit
else
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &&
        brew doctor
fi
