#!/usr/bin/ruby

gem 'activesupport'
require './mod_procreate/swatches'

f = open('../fabricSwatches.js', 'r')
swatch_data = eval(f.read.gsub(/\n/, '').gsub(/var /, ''))

swatch_data.each do |key, fabric_line|
  zipfile_name = "#{key}.zip"
  swatches_filenames = []
  swatches_filenames = fabric_line[:swatches].each_slice(30).map.with_index do |set, index|
    Procreate::Swatches.export("#{key}-#{index}", set)
  end
  exec 'mkdir #{key}'
  swatches_filenames.each do |filename|
    exec 'mv #{key}* #{key}'
  end
end

exec 'rm ./*.swatches'
