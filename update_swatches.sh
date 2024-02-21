#!/bin/bash

rm -rf illustrator/palette-in/*.swatches
rm -rf procreate/*/*.swatches

cd procreate/
ruby generate_procreate_swatches.rb
