#!/bin/bash

# Change to input file directory
INPUT_DIR="~/Path/to/gpx/directory/this/checked/in/recursion"

CSV_DIR="~/Heatmap/csv_output"
COMBINED="~/Heatmap/combined.csv"

# Start fresh
rm -rf "$CSV_DIR"
mkdir -p "$CSV_DIR"
rm -f "$COMBINED"

# Function to convert files to CSV
convert_to_csv() {
    local file="$1"
    local base=$(basename "$file" | sed 's/\.[^.]*$//')
    local ext="${file##*.}"

    if [[ "$ext" == "fit" ]]; then
        gpsbabel -i garmin_fit -f "$file" -o csv -F "$CSV_DIR/${base}.csv"
    elif [[ "$ext" == "gpx" ]]; then
        gpsbabel -i gpx -f "$file" -o csv -F "$CSV_DIR/${base}.csv"
    fi
}

# Convert all .fit and .gpx files recursively
find "$INPUT_DIR" -type f \( -iname "*.fit" -o -iname "*.gpx" \) | while read -r file; do
    convert_to_csv "$file"
done

# Combine CSVs
first_file=$(ls "$CSV_DIR"/*.csv | head -n1)
if [[ -n "$first_file" ]]; then
    # Copy header
    head -n 1 "$first_file" > "$COMBINED"
    # Append all files without headers
    for f in "$CSV_DIR"/*.csv; do
        tail -n +2 "$f" >> "$COMBINED"
    done
fi

