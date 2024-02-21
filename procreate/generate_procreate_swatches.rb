#!/usr/bin/ruby

gem 'activesupport'
require './mod_procreate/swatches'

f = open('../outputs/fabricSwatches.js', 'r')
swatch_data = eval(f.read.gsub(/\n/, '').gsub(/export const fabricSwatches = /, ''))

swatch_data.each do |key, fabric_line|
  next if key == :pantone
  # name = "#{key.capitalize} Full Set"
  # Procreate::Swatches.export(name, fabric_line[:swatches], { export_directory: key.to_s, file_name: "#{key}-full" })

  fabric_line[:swatches].each_slice(30).map.with_index do |set, index|
    name = "#{key.capitalize} Set ##{index + 1}"
    Procreate::Swatches.export(name, set, { export_directory: key.to_s, file_name: "#{key}-#{index + 1}" })
  end
end
  
p "Did the thing"
