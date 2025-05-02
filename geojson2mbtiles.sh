#!/bin/bash

# geojsonを全て結合してmbtilesに変換するスクリプト

# Check if tippecanoe is installed
if ! command -v tippecanoe &> /dev/null
then
    echo "Tippecanoe could not be found. Please install it first."
    exit 1
fi

# Directory containing GeoJSON files
GEOJSON_DIR="./geojson"

# Directory to store the output MBTiles file
MBTILES_DIR="./mbtiles"

# Ensure the MBTiles directory exists
if [ ! -d "$MBTILES_DIR" ]; then
    mkdir -p "$MBTILES_DIR"
    echo "Created directory: $MBTILES_DIR"
fi

# Output MBTiles file
OUTPUT_FILE="$MBTILES_DIR/output.mbtiles"

# Check if there are any GeoJSON files in the directory
geojson_files=("$GEOJSON_DIR"/*.geojson)
if [ ! -e "${geojson_files[0]}" ]; then
    echo "No GeoJSON files found in $GEOJSON_DIR."
    exit 1
fi

# Prompt user for layer names
declare -A LAYER_NAMES
TIPPECANOE_ARGS=""

for file in "${geojson_files[@]}"; do
    echo "Found GeoJSON file: $file"
    if [ -e "$file" ]; then
        filename=$(basename -- "$file")
        echo "Enter layer name for $filename:"
        read layer_name
        TIPPECANOE_ARGS+=" -L ${layer_name}:$file"
    fi
done

# Combine all GeoJSON files into MBTiles with separate layers
tippecanoe -o "$OUTPUT_FILE" --force --no-feature-limit --drop-rate=0 --no-tile-size-limit --read-parallel $TIPPECANOE_ARGS

echo "Conversion complete. MBTiles file created: $OUTPUT_FILE"
