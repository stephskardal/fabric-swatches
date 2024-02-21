#!/usr/bin/ruby

gem 'activesupport'
require './mod_procreate/swatches'

f = open('../outputs/fabricSwatches.js', 'r')
swatch_data = eval(f.read.gsub(/\n/, '').gsub(/export const fabricSwatches = /, ''))
ILLUSTRATOR_SWATCH_SIZE = 32.freeze

swatch_data.each do |key, fabric_line|
  next if key == :pantone

  fabric_line[:swatches].each_slice(30).map.with_index do |set, index|
    name = "#{key.capitalize} Set ##{index + 1}"
    Procreate::Swatches.export(name, set, { export_directory: key.to_s, file_name: "#{key}-#{index + 1}" })
  end

  # fabric_line[:swatches].each_slice(ILLUSTRATOR_SWATCH_SIZE).map.with_index do |set, index|
  #   name = "#{key.capitalize} Set ##{index + 1}"
  #  Procreate::Swatches.export(name, set, { export_directory: "../illustrator/palette-in/", file_name: "#{key}-#{index + 1}" })
  # end
end
  
p "Did the thing. To generate illustrator files, copy *.swatches to illustrator/palette-in/"
