import fs from 'fs';
import aseUtils from 'ase-utils';
import convert from 'color-convert';

const { decode } = aseUtils;

// Read the .ase file
const aseFilePath = './Riley Blake Designs 300 Confetti Cotton Soilds.ase';
const aseData = fs.readFileSync(aseFilePath);

// Decode the .ase file
const decoded = decode(aseData);

// Read the current fabricSwatches.js file
const fabricSwatchesPath = './outputs/fabricSwatches.js';
const lines = fs.readFileSync(fabricSwatchesPath, 'utf8').split('\n');

// Convert the new colors from CMYK to RGB properly
const newSwatches = {};
decoded.colors.forEach(color => {
  let rgb;
  
  if (color.model === 'CMYK') {
    // Convert CMYK to RGB
    const cmyk = [
      Math.round(color.color[0] * 100), // Cyan
      Math.round(color.color[1] * 100), // Magenta  
      Math.round(color.color[2] * 100), // Yellow
      Math.round(color.color[3] * 100)  // Key/Black
    ];
    rgb = convert.cmyk.rgb(cmyk);
  } else {
    // Fallback for other color models
    rgb = [
      Math.round(color.color[0] * 255),
      Math.round(color.color[1] * 255),
      Math.round(color.color[2] * 255)
    ];
  }
  
  const hex = `#${convert.rgb.hex(rgb)}`;
  const key = color.name.toLowerCase().replace(/\s+/g, ' ');
  newSwatches[key] = hex;
});

// Find the start and end of the rileyBlake section
let rileyBlakeStart = -1;
let rileyBlakeEnd = -1;
let braceCount = 0;
let inRileyBlake = false;

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];
  
  if (line.includes('rileyBlake: {')) {
    rileyBlakeStart = i;
    inRileyBlake = true;
    braceCount = 1;
  } else if (inRileyBlake) {
    if (line.includes('{')) braceCount++;
    if (line.includes('}')) braceCount--;
    
    if (braceCount === 0) {
      rileyBlakeEnd = i;
      break;
    }
  }
}

if (rileyBlakeStart === -1 || rileyBlakeEnd === -1) {
  console.error('Could not find rileyBlake section boundaries');
  process.exit(1);
}

// Create the new rileyBlake section lines
const newRileyBlakeLines = [
  '  rileyBlake: {',
  "    brand: 'Riley Blake Designs',",
  "    line: 'Confetti Cottons',",
  '    swatches: {',
  ...Object.entries(newSwatches).map(([name, hex]) => `      '${name}': '${hex}',`),
  '    }',
  '  },'
];

// Replace the old section with the new one
const newLines = [
  ...lines.slice(0, rileyBlakeStart),
  ...newRileyBlakeLines,
  ...lines.slice(rileyBlakeEnd + 1)
];

// Write the updated content back to the file
fs.writeFileSync(fabricSwatchesPath, newLines.join('\n'));

console.log('Successfully updated Riley Blake section with corrected CMYK→RGB colors');
console.log(`Updated ${Object.keys(newSwatches).length} colors`);
console.log('Sample of updated colors:');
Object.entries(newSwatches).slice(0, 10).forEach(([name, hex]) => {
  console.log(`  ${name}: ${hex}`);
}); 