#!/bin/bash

rm -rf illustrator/palette-in/*.swatches
rm -rf procreate/*/*.swatches

cd procreate/
ruby generate_procreate_swatches.rb

cd ../
yarn run illustrator_convert

['americanMade', 'andoverSolids', 'artGallery', 'aurifilThread',
'devonstone', 'freeSpirit', 'glide', 'kona', 'michaelMiler', 'modaBella', 'northcott', 'paintBrushStudio',
'rileyBlake', 'rjrCottonSupreme', 'spoonflower', 'tilda', 'wonderful'].each do |line|
   zip -er #{line}.zip procreate/#{line}/*.swatches  
   mkdir tmp/
   cp illustrator/palette-out/#{line}-*.ase tmp/
   zip -er #{line}-ase.zip tmp/*
   mv #{line}*.zip outputs/
   rm tmp/*
end