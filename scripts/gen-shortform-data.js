import fs from 'fs';
import { fabricSwatches } from '../outputs/fabricSwatches.js'
import chroma from 'chroma-js'

const capitalize = (str) => {
  return str.toLowerCase()
    .split(' ')
    .map((s) => s.charAt(0).toUpperCase() + s.substring(1))
    .join(' ');
};

export const colorColorSorting = {
  sortColorsBy: function (colors, key) {
    return colors.sort(function (a, b) {
      return b[key] - a[key]
    })
  },
}

const filters = (key, label) => {
  let updatedLabel = label;
  if(key == "devonstone") {
    let a = label.split(' - ');
    updatedLabel = `${capitalize(a[1])} - ${a[0]}`;
  } else if(key == "northcott") {
    let a = label.split('9000');
    updatedLabel = `${capitalize(a[0])}- 9000${a[1]}`;
  } else if(key == "aurifilThread") {
    let z = label.split(" ");
    let colorId = z.pop();
    updatedLabel = `${capitalize(z.join(' '))} - ${colorId}`;
  } else if(["americanMade", "paintBrushStudio", "tilda", "artGallery"].includes(key)) {
    let z = label.split(" ");
    if(z.length == 1) {
      updatedLabel = label;
    } else {
      let color = z.shift();
      updatedLabel = `${capitalize(z.join(' '))} - ${color}`;
    }
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
        let hsv = color.hsl().map((z) => parseFloat(z.toFixed(2)) || 0)
        return {
          label: filters(key, swatch),
          hex: hex,
          hsl: hsv // tricky
        }
      }
    ).sort(function(a, b) {
      return a.hsl[0] - b.hsl[0];
    }).map((i) => {
      return {
        label: i.label,
        hex: i.hex,
      }
    })
    let label = fabricSwatches[key].line;
    if(fabricSwatches[key].brand !== "") {
      label = `${fabricSwatches[key].brand} ${label}`
    }
    newSwatches[key] = {
      brand: fabricSwatches[key].brand,
      line: fabricSwatches[key].line,
      label: label,
      swatches: newSwatchSet
    }
  })
  return newSwatches;
}

generate().then((r) => {
  fs.writeFile('./outputs/fabricSwatchesShortform.json', JSON.stringify(r), function(err, result) {
    if(err) console.log('error', err);
  });
});

export {};