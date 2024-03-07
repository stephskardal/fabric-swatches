#!/bin/bash

rm -rf illustrator/palette-in/*.swatches
rm -rf procreate/*/*.swatches

cd procreate/
ruby generate_procreate_swatches.rb

cd ../
yarn run illustrator_convert

mkdir tmp/

declare -a arr=("rubyBee" "dmc" "americanMade" "andoverCenturySolids" "artGallery" "aurifilThread"
"devonstone" "freeSpirit" "glide" "kona" "michaelMiller" "modaBella"
"northcott" "paintBrushStudio" "rileyBlake" "rjrCottonSupreme"
"spoonflower" "tilda" "wonderfil")
for line in "${arr[@]}"
do
   mkdir tmp/${line}_procreate/
   cp procreate/${line}/*.swatches tmp/${line}_procreate/
   zip -j ${line}-swatches.zip tmp/${line}_procreate/*

   mkdir tmp/${line}_illustrator/
   cp illustrator/palette-out/${line}* tmp/${line}_illustrator/
   zip -j ${line}-ase.zip tmp/${line}_illustrator/*
done

mv *.zip outputs
rm -rf tmp/