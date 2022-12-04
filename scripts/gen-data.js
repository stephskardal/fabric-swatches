import fs from 'fs';
import { fabricSwatches } from '../outputs/fabricSwatches.js'
import chroma from 'chroma-js'

const generate = async () => {
  let newSwatches = {}
  Object.keys(fabricSwatches).forEach((key) => {
    const newSwatchSet = Object.keys(fabricSwatches[key].swatches).map(
      (swatch) => {
        let hex = fabricSwatches[key].swatches[swatch]
        let color = chroma(hex)
        let hsv = color.hsl().map((z) => parseFloat(z.toFixed(2)))
        return {
          label: swatch,
          hex: hex,
          rgb: color.rgb(),
          hsl: hsv // tricky
        }
      }
    )
    newSwatches[key] = {
      label: fabricSwatches[key].label,
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