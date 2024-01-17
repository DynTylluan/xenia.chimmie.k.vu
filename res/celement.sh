#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
TARGET="${TARGET:-xenia_drawing0.png}"
ERASE_PATH="${ERASE_PATH:-$SCRIPT_PATH}"
SRC_PATH="${SRC_PATH:-$SCRIPT_PATH/../art/bin}"
OUT_PATH="${OUT_PATH:-/tmp}"

TARGET="${TARGET%.*}"

if ! [ -f "$SRC_PATH/${TARGET}.png" ]; then
	echo 'File not found!'
	exit 1
fi

cd "$SRC_PATH"

rm -f "$OUT_PATH/${TARGET}.png.c.html"
rm -f "$OUT_PATH/${TARGET}.png.c.conf"

echo '<div class="filedoc" id="%FILENAME%">' > "$OUT_PATH/${TARGET}.png.c.html"
cat "$SCRIPT_PATH/element.html" >> "$OUT_PATH/${TARGET}.png.c.html"
echo '%FILESRC%='"${SRC_PATH/$ERASE_PATH/}/${TARGET}.png" > "$OUT_PATH/${TARGET}.png.c.conf"
echo '%FILENAME%='"${TARGET}" >> "$OUT_PATH/${TARGET}.png.c.conf"

if [ -f "$SRC_PATH/../svg/${TARGET}.svg" ]; then
	echo '<a href="'"${SRC_PATH/$ERASE_PATH/}/../svg/${TARGET}.svg"'"><img src="res/img/svg.svg" alt=":svg_download:" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.png.c.html"
fi

if [ -f "$SRC_PATH/../gimp/${TARGET}.xcf" ]; then
	echo '<a href="'"${SRC_PATH/$ERASE_PATH/}/../gimp/${TARGET}.xcf"'"><img src="res/img/gimp.svg" alt=":xcf_download:" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.png.c.html"
fi

if [ -f "$SRC_PATH/../license/${TARGET}.txt" ]; then
	echo '<a href="'"${SRC_PATH/$ERASE_PATH/}/../license/${TARGET}.txt"'"><img src="res/img/license.svg" alt=":license:" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.png.c.html"
fi

if [ -f "$SRC_PATH/../links/${TARGET}.conf" ]; then
	for conf_line in $(cat "$SRC_PATH/../links/${TARGET}.conf"); do
		echo '<a href="'"$(echo "$conf_line" | cut -d '|' -f 2)"'"><img src="res/img/'"$(echo "$conf_line" | cut -d '|' -f 1)"'.svg" alt=":'"$(echo "$conf_line" | cut -d '|' -f 1)"':" width="35" height="35"/></a>' >> "$OUT_PATH/${TARGET}.png.c.html"
	done
fi

echo '</div></div><hr/>' >> "$OUT_PATH/${TARGET}.png.c.html"

echo 'Configuring "'"${TARGET}.png.c.html"'"...'

sh "$SCRIPT_PATH/scripts/set.sh" "$OUT_PATH/${TARGET}.png.c.conf" "$OUT_PATH/${TARGET}.png.c.html"

if [ -f "$SRC_PATH/../desc/${TARGET}.md" ]; then
	sed -i "s/%DESCRIPTION%/$(markdown "$SRC_PATH/../desc/${TARGET}.md")/g" "$OUT_PATH/${TARGET}.png.c.html"
else
	sed -i 's/%DESCRIPTION%/No description provided./g' "$OUT_PATH/${TARGET}.png.c.html"
fi
