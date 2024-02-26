#!/usr/bin/ruby

gem 'activesupport'
require './src/swatches'

# Opening fabric swatches and reading from them
f = open('../outputs/fabricSwatches.json', 'r')
swatch_data = eval(f.read.gsub(/\n/, ''))

PROCREATE_SWATCH_SIZE = 30.freeze
ILLUSTRATOR_SWATCH_SIZE = 5000.freeze

swatch_data.each do |key, fabric_line|
  next if key == :pantone

  fabric_line[:swatches].each_slice(PROCREATE_SWATCH_SIZE).map.with_index do |set, index|
    name = "#{key.capitalize} Set ##{index + 1}"
    mapped_set = set.map { |z| [z[:label], z[:hex]] }
    Procreate::Swatches.export(name, mapped_set, PROCREATE_SWATCH_SIZE, { export_directory: key.to_s, file_name: "#{key}-#{index + 1}" })
  end

  mapped_set = fabric_line[:swatches].map { |z| [z[:label], z[:hex]] }
  name = key.to_s.capitalize
  Procreate::Swatches.export(name, mapped_set, 600, { export_directory: "../illustrator/palette-in/", file_name: key })
end
  
p "Did the thing."
