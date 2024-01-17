#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

cd "$SCRIPT_PATH"

echo 'Executing setup...'
sh index.sh
sh res/scripts/set.sh res/parser.conf index.html
sh res/scripts/set.sh res/parser.conf README.md

apk add --no-cache sed

sed -i 's/index.html//g' .gitignore
