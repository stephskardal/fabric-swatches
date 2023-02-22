import fs from 'fs';
import { fabricSwatches } from '../outputs/fabricSwatches.js'
import chroma from 'chroma-js'

const capitalize = (str) => {
  return str.toLowerCase()
    .split(' ')
    .map((s) => s.charAt(0).toUpperCase() + s.substring(1))
    .join(' ');
};

const filters = (key, label) => {
  let updatedLabel = label;
  if(key == "devonstone") {
    let a = label.split(' - ');
    updatedLabel = `${capitalize(a[1])} - ${a[0]}`;
  } else if(key == "northcott") {
    let a = label.split('9000');
    updatedLabel = `${capitalize(a[0])}- 9000${a[1]}`;
  } else if(key == "aurifilThread") {
    updatedLabel = label.replace(/ [0-9]/, ` - ${1}`);
  } else if(["americanMade", "paintBrushStudio", "tilda", "artGallery"].includes(key)) {
    let z = label.split(" ");
    let color = z.shift();
    updatedLabel = `${capitalize(z.join(' '))} - ${color}`;
  } else if(key == "modaBella") {
    updatedLabel = label.replace(/ 99/, ' - 99')
  } else if(key == "pantone") {
    if(label.match(/^[0-9][0-9]-/)) {
      let z = label.split(" ");
      let color = z.shift();
      updatedLabel = `${capitalize(z.join(' ').replace(/\-/, ' '))} - ${color}`;
    }
  } else if(["freeSpirit", "rileyBlake", "kona", "michaelMiller", "rjrCottonSupreme"].includes(key)) {
    updatedLabel = capitalize(label)
  }
  return updatedLabel;
};

const generate = async () => {
  let newSwatches = {}
  Object.keys(fabricSwatches).forEach((key) => {
    const newSwatchSet = Object.keys(fabricSwatches[key].swatches).map(
      (swatch) => {
        let hex = fabricSwatches[key].swatches[swatch]
        let color = chroma(hex)
        let hsv = color.hsl().map((z) => parseFloat(z.toFixed(2)))
        return {
          label: filters(key, swatch),
          hex: hex,
          rgb: color.rgb(),
          hsl: hsv // tricky
        }
      }
    )
    newSwatches[key] = {
      label: fabricSwatches[key].label,
      swatchLabel: fabricSwatches[key].swatchLabel,
      swatches: newSwatchSet
    }
  })
  return newSwatches;
}

generate().then((r) => {
  fs.writeFile('./outputs/fabricSwatches.json', JSON.stringify(r), function(err, result) {
    if(err) console.log('error', err);
  });
});

export {};