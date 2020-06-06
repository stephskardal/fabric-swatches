require 'procreate/swatches'
require 'zip'

f = open('../fabricSwatches.js', 'r')
swatch_data = eval(f.read.gsub(/\n/, '').gsub(/var /, ''))

swatch_data.each do |key, fabric_line|
  zipfile_name = "#{key}.zip"
  swatches_filenames = []
  fabric_line[:swatches].values.each_slice(30).each_with_index do |set, index|
    swatches_filenames << Procreate::Swatches.export("#{key}-#{index}", set)
  end
  Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
    swatches_filenames.each do |filename|
      zipfile.add(File.basename(filename), filename)
    end
  end
end

exec 'rm *.swatches'
