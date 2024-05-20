#!/bin/bash

if [ -z "$OUTPUT_DIR" ]; then
    echo "OUTPUT_DIR is not set. Please set OUTPUT_DIR environment variable."
    exit 1
fi

if [ -z "$SOURCE_FILE_PATH" ]; then
    echo "SOURCE_FILE_PATH is not set. Please set SOURCE_FILE_PATH environment variable."
    exit 1
fi

TEMP_DIR=$(mktemp -d)
SOURCE_FILENAME=$(basename "$SOURCE_FILE_PATH" | cut -d. -f1)
OUTPUT_FILENAME=${OUTPUT_FILENAME:-"${SOURCE_FILENAME}"}

# Reduce the number of colors and create a color palette
convert $SOURCE_FILE_PATH -colors 16 -format %c histogram:info:- | sort -nr | head -n 4 | awk '{print $NF}' > $TEMP_DIR/colors.txt

# Read the color list and generate masks
i=0
while read color; do
    convert "$SOURCE_FILE_PATH" -alpha off +dither -colors 256 -clamp -fuzz 10% -fill black +opaque "$color" -fill white -opaque "$color" "$TEMP_DIR/mask_${i}.bmp"
    ((i++))
done < $TEMP_DIR/colors.txt

for file in $TEMP_DIR/mask_*.bmp; do
    potrace -s -C "#000000" --flat -i -t 4 -o "${file%.png}.svg" $file
done

hex_colors=()
while IFS= read -r line; do
    hex_colors+=( "$line" )
done < <( convert $SOURCE_FILE_PATH -colors 16 -format %c histogram:info:- | sort -nr | head -n 4 | awk '{print $3}' )

i=0
for file in $TEMP_DIR/mask_*.svg; do
    sed -i "s/fill=\"#000000\"/fill=\"#${hex_colors[i]:1:6}\"/" "${file%.svg}.svg"
    ((i++))
done

width=$(identify -ping -format "%w" $SOURCE_FILE_PATH)
height=$(identify -ping -format "%h" $SOURCE_FILE_PATH)

echo "<svg version=\"1.0\" xmlns=\"http://www.w3.org/2000/svg\" width=\"${width}.000000pt\" height=\"${height}.000000pt\" viewBox=\"0 0 ${width}.000000 ${height}.000000\" preserveAspectRatio=\"xMidYMid meet\">" > $OUTPUT_DIR/${OUTPUT_FILENAME}_dark.svg

# Loop over each SVG file and append its contents
for svg in $TEMP_DIR/mask_*.svg; do
    # Extract contents between <svg> tags
    sed -n '/<svg/,/<\/svg>/p' $svg | grep -v '<svg' | grep -v '</svg' >> $OUTPUT_DIR/${OUTPUT_FILENAME}_dark.svg
done

echo '</svg>' >> $OUTPUT_DIR/${OUTPUT_FILENAME}_dark.svg

cp $OUTPUT_DIR/${OUTPUT_FILENAME}_dark.svg $OUTPUT_DIR/${OUTPUT_FILENAME}_light.svg

sed -i "s/fill=\"#F9F8FD\"/fill=\"#000000\"/" "$OUTPUT_DIR/${OUTPUT_FILENAME}_light.svg"
sed -i "s/fill=\"#161E2D\"/fill=\"#F9F8FD\"/" "$OUTPUT_DIR/${OUTPUT_FILENAME}_light.svg"