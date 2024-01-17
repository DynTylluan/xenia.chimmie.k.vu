#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
TARGET="${1:-xenia_drawing0}"
ERASE_PATH="${ERASE_PATH:-$SCRIPT_PATH}"
SRC_PATH="${SRC_PATH:-$SCRIPT_PATH/../art/bin}"
OUT_PATH="${OUT_PATH:-/tmp}"

if ! [ -f "$SRC_PATH/${TARGET}.png" ]; then
	echo 'File not found!'
	exit 1
fi

cd "$SRC_PATH/$TARGET"

rm -f "$OUT_PATH/${TARGET}.c.html"
rm -f "$OUT_PATH/${TARGET}.c.conf"

exec >"$OUT_PATH/${TARGET}.c.html"
exec 2>"$OUT_PATH/${TARGET}.c.conf"

echo '<div class="filedoc" id="%FILENAME%">'
cat "$SCRIPT_PATH/element.html"
echo '%FILESRC%='"${SRC_PATH/$ERASE_PATH/}/${TARGET}.png" >&2
echo '%FILENAME%='"${TARGET}" >&2
if [ -f "$SRC_PATH/../svg/${TARGET}.svg" ]; then
	echo '<a href="'"${SRC_PATH/$ERASE_PATH/}/../svg/${TARGET}.svg"'"><img src="res/img/svg.svg" alt=":svg_download:" width="35" height="35"/></a>'
fi

if [ -f "$SRC_PATH/../license/${TARGET}.txt" ]; then
	echo '<a href="'"${SRC_PATH/$ERASE_PATH/}/../license/${TARGET}.txt"'"><img src="res/img/license.svg" alt=":license:" width="35" height="35"/></a>'
fi

if [ -f "$SRC_PATH/../desc/${TARGET}.conf" ]; then
	for conf_line in $(cat "$SRC_PATH/../desc/${TARGET}.conf"); do
		echo '<a href="'"$(echo "$conf_line" | cut -d '|' -f 2)"'"><img src="res/img/'"$(echo "$conf_line" | cut -d '|' -f 1)"'.svg" alt=":'"$(echo "$conf_line" | cut -d '|' -f 1)"':" width="35" height="35"/></a>'
	done
fi

echo ' ' >&2
echo '</div>'

exec >&-

sh "$SCRIPT_PATH/scripts/set.sh" "$OUT_PATH/${TARGET}.c.conf" "$OUT_PATH/${TARGET}.c.html"
