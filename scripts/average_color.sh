#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Please install it first."
    exit 1
fi

# Check if the input image is provided
if [ -z "$1" ]; then
    echo "Usage: $0 input_image"
    exit 1
fi

input_image="$1"

# Get the average color in hex format
average_color_hex=$(convert "$input_image" -scale 1x1\! txt:- | awk 'NR==2{print $3}')

echo "$input_image $average_color_hex"
