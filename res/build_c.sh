#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
DATA_PATH="${DATA_PATH:-$SCRIPT_PATH/../art}"
TMP_PATH="${TMP_PATH:-/tmp}"
OUT_FILE="${OUT_FILE:-$TMP_PATH/files.html}"

cd "$SCRIPT_PATH"

rm -f "$OUT_FILE"

# Install ImageMagick
apk add --no-cache imagemagick

echo '<div class="files">' > "$OUT_FILE"

for file_path in $(find "$DATA_PATH/bin" -maxdepth 1 -type f); do
	echo 'Parsing ART file "'"$(basename "$file_path")"'"...'
	export OUT_PATH="$TMP_PATH"
	export SRC_PATH="$DATA_PATH/bin"
	export ERASE_PATH="$SCRIPT_PATH/../"
	export TARGET="$(basename "$file_path")"
	sh "$SCRIPT_PATH/celement.sh"
	cat "$TMP_PATH/${TARGET}.c.html" >> "$OUT_FILE"
done

echo '</div>' >> "$OUT_FILE"
