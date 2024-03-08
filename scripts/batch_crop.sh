#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Please install it first."
    exit 1
fi

# Check if the directory is provided
if [ -z "$1" ]; then
    echo "Usage: $0 input_directory output_directory"
    exit 1
fi

input_directory="$1"
output_directory="$2"

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Loop through each image in the input directory
for input_image in "$input_directory"/*.jpg; do
    if [ -f "$input_image" ]; then
        filename=$(basename "$input_image")
        output_image="$output_directory"/"$filename"

        # Get the dimensions of the input image
        width=$(identify -format "%w" "$input_image")
        height=$(identify -format "%h" "$input_image")

        # Calculate the cropping dimensions
        crop_width=$((width))
        crop_height=$((height))
        crop_x=$((width / 2 - 40))
        crop_y=$((height / 2 - 40))

        # Perform the cropping
        convert "$input_image" -crop 80x80+"$crop_x"+"$crop_y" "$output_image"

        ./average_color.sh $output_image
    fi
done

