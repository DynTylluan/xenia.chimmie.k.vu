#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
TARGET="${TARGET:-xenia_drawing0}"
ERASE_PATH="${ERASE_PATH:-$SCRIPT_PATH}"
SRC_PATH="${SRC_PATH:-$SCRIPT_PATH/../art/bin}"
OUT_PATH="${OUT_PATH:-/tmp}"

if ! [ -f "$SRC_PATH/${TARGET}.png" ]; then
	echo 'File not found!'
	exit 1
fi

cd "$SRC_PATH"

rm -f "$OUT_PATH/${TARGET}.c.html"
rm -f "$OUT_PATH/${TARGET}.c.conf"

echo '<div class="filedoc" id="%FILENAME%">' > "$OUT_PATH/${TARGET}.c.html"
cat "$SCRIPT_PATH/element.html" >> "$OUT_PATH/${TARGET}.c.html"
echo '%FILESRC%='"${SRC_PATH/$ERASE_PATH/}/${TARGET}.png" > "$OUT_PATH/${TARGET}.c.conf"
echo '%FILENAME%='"${TARGET}" >> "$OUT_PATH/${TARGET}.c.conf"

if [ -f "$SRC_PATH/../svg/${TARGET}.svg" ]; then
	echo '<a href="'"${SRC_PATH/$ERASE_PATH/}/../svg/${TARGET}.svg"'"><img src="res/img/svg.svg" alt=":svg_download:" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.c.html"
fi

if [ -f "$SRC_PATH/../license/${TARGET}.txt" ]; then
	echo '<a href="'"${SRC_PATH/$ERASE_PATH/}/../license/${TARGET}.txt"'"><img src="res/img/license.svg" alt=":license:" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.c.html"
fi

if [ -f "$SRC_PATH/../desc/${TARGET}.conf" ]; then
	for conf_line in $(cat "$SRC_PATH/../desc/${TARGET}.conf"); do
		echo '<a href="'"$(echo "$conf_line" | cut -d '|' -f 2)"'"><img src="res/img/'"$(echo "$conf_line" | cut -d '|' -f 1)"'.svg" alt=":'"$(echo "$conf_line" | cut -d '|' -f 1)"':" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.c.html"
	done
fi

echo '</div>' >> "$OUT_PATH/${TARGET}.c.html"

echo 'Configuring "'"${TARGET}.c.html"'"...'

sh "$SCRIPT_PATH/scripts/set.sh" "$OUT_PATH/${TARGET}.c.conf" "$OUT_PATH/${TARGET}.c.html"
