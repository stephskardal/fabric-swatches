#!/bin/bash

for f in ./*.jpg
do
  echo "$f"
  convert "$f" -resize 1x1 txt:-  # yields parseable data to get hex
done
