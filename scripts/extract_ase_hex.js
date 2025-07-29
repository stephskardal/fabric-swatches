import aseUtils from 'ase-utils';
import fs from 'fs';
import convert from 'color-convert';

const { decode } = aseUtils;

// Get the .ase file path from command line arguments, or use default
const aseFilePath = process.argv[2] || './Riley Blake Designs 300 Confetti Cotton Soilds.ase';

// Check if file exists
if (!fs.existsSync(aseFilePath)) {
  console.error(`Error: File not found: ${aseFilePath}`);
  console.log('Usage: node scripts/extract_ase_hex.js [path/to/file.ase]');
  console.log('Example: node scripts/extract_ase_hex.js ./my-colors.ase');
  process.exit(1);
}

// Read the .ase file
const aseData = fs.readFileSync(aseFilePath);

// Decode the .ase file
const decoded = decode(aseData);

// Extract filename for display and output files
const fileName = aseFilePath.split('/').pop().replace('.ase', '');

console.log('ASE File Information:');
console.log('=====================');
console.log(`File: ${fileName}.ase`);
console.log(`Number of color groups: ${decoded.groups?.length || 0}`);
console.log(`Number of colors: ${decoded.colors?.length || 0}`);
console.log('');

// Extract colors and convert to hex
if (decoded.colors && decoded.colors.length > 0) {
  console.log('Colors with Hex Codes:');
  console.log('======================');
  
  decoded.colors.forEach((color, index) => {
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
    
    // Convert RGB to hex
    const hex = `#${convert.rgb.hex(rgb)}`;
    
    console.log(`${index + 1}. ${color.name || `Color ${index + 1}`}`);
    console.log(`   Model: ${color.model}`);
    console.log(`   Hex: ${hex}`);
    console.log(`   RGB: (${rgb[0]}, ${rgb[1]}, ${rgb[2]})`);
    if (color.model === 'CMYK') {
      const cmyk = color.color.map(v => Math.round(v * 100));
      console.log(`   CMYK: (${cmyk[0]}%, ${cmyk[1]}%, ${cmyk[2]}%, ${cmyk[3]}%)`);
    }
    console.log('');
  });
  
  // Also save to a JSON file for easy access
  const colorData = decoded.colors.map((color, index) => {
    let rgb;
    
    if (color.model === 'CMYK') {
      const cmyk = [
        Math.round(color.color[0] * 100),
        Math.round(color.color[1] * 100),
        Math.round(color.color[2] * 100),
        Math.round(color.color[3] * 100)
      ];
      rgb = convert.cmyk.rgb(cmyk);
    } else {
      rgb = [
        Math.round(color.color[0] * 255),
        Math.round(color.color[1] * 255),
        Math.round(color.color[2] * 255)
      ];
    }
    
    const hex = `#${convert.rgb.hex(rgb)}`;
    
    return {
      index: index + 1,
      name: color.name || `Color ${index + 1}`,
      hex: hex,
      rgb: rgb,
      model: color.model,
      type: color.type || 'global'
    };
  });
  
  fs.writeFileSync(`${fileName}_colors.json`, JSON.stringify(colorData, null, 2));
  console.log(`Color data saved to ${fileName}_colors.json`);
  
} else {
  console.log('No colors found in the .ase file.');
}

// If there are groups, show them too
if (decoded.groups && decoded.groups.length > 0) {
  console.log('\nColor Groups:');
  console.log('=============');
  decoded.groups.forEach((group, index) => {
    console.log(`${index + 1}. ${group.name}`);
  });
} 