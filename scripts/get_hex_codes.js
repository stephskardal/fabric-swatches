import aseUtils from 'ase-utils';
import fs from 'fs';
import convert from 'color-convert';

const { decode } = aseUtils;

// Get the .ase file path from command line arguments, or use default
const aseFilePath = process.argv[2] || './Riley Blake Designs 300 Confetti Cotton Soilds.ase';

// Check if file exists
if (!fs.existsSync(aseFilePath)) {
  console.error(`Error: File not found: ${aseFilePath}`);
  console.log('Usage: node scripts/get_hex_codes.js [path/to/file.ase]');
  console.log('Example: node scripts/get_hex_codes.js ./my-colors.ase');
  process.exit(1);
}

// Read the .ase file
const aseData = fs.readFileSync(aseFilePath);

// Decode the .ase file
const decoded = decode(aseData);

// Extract filename for display
const fileName = aseFilePath.split('/').pop().replace('.ase', '');

console.log(`${fileName} - Hex Codes`);
console.log('='.repeat(fileName.length + 15));
console.log('');

if (decoded.colors && decoded.colors.length > 0) {
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
    
    console.log(`${color.name}: ${hex}`);
  });
  
  console.log('');
  console.log(`Total colors extracted: ${decoded.colors.length}`);
} else {
  console.log('No colors found in the .ase file.');
} 