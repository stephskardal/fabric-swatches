#!/bin/bash

# Array with data mapping color name to retrievable image
declare -A array
array['color name']=imageURL

for i in "${!array[@]}"
do
  echo "$i"
  wget -O result.jpg ${array[$i]}
  convert result.jpg -resize 1x1 txt:-  # yields parseable data to get hex
done
