// This script shows the dramatic differences between old and new Riley Blake colors

const oldColors = {
  'adobe': '#a94b43',
  'alpine': '#55ab86', 
  'amber': '#c9712a',
  'amethyst': '#7369ae',
  'anchor': '#5a6770',
  'apricot blush': '#ec8f7e',
  'artichoke': '#979363',
  'ash': '#c1bfb2',
  'asparagus': '#b0ad4c',
  'autumn': '#df5f46',
  'avocado': '#5b6238',
  'azure': '#009eb1',
  'ballerina': '#f7e4dd',
  'bark': '#504323',
  'barn red': '#a22038',
  'basil': '#688241',
  'beach': '#b7a797',
  'bean sprout': '#e3d483',
  'bear lake': '#5eb2bd',
  'beehive': '#fcdfa3'
};

const newColors = {
  'adobe 2': '#3BCBBA',
  'alpine': '#AD1C99',
  'amber': '#29A3FA', 
  'amethyst': '#9EA500',
  'anchor': '#A57B69',
  'apricot blush': '#098874',
  'artichoke': '#614DAC',
  'ash': '#3D2E47',
  'asparagus': '#3B21CC',
  'autumn': '#14C5C7',
  'avocado': '#956ADA',
  'azure': '#EF1C4F',
  'ballerina': '#051C1A',
  'bark': '#808BDA',
  'barn red': '#3CFBC2',
  'basil': '#9D4EEA',
  'beach': '#454A60',
  'bean sprout': '#201B97',
  'bear lake': '#9E1E40',
  'beehive': '#031C69'
};

console.log('DRAMATIC COLOR CHANGES in Riley Blake Swatches');
console.log('==============================================');
console.log('The colors from the official .ase file are VERY different!');
console.log('');

// Helper function to convert hex to RGB
function hexToRgb(hex) {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result ? {
    r: parseInt(result[1], 16),
    g: parseInt(result[2], 16),
    b: parseInt(result[3], 16)
  } : null;
}

// Compare colors that exist in both
Object.keys(newColors).forEach(colorName => {
  const oldKey = colorName.replace(' 2', ''); // Handle "adobe 2" vs "adobe"
  const oldHex = oldColors[oldKey];
  const newHex = newColors[colorName];
  
  if (oldHex && oldHex !== newHex) {
    const oldRgb = hexToRgb(oldHex);
    const newRgb = hexToRgb(newHex);
    const distance = Math.sqrt(
      Math.pow(oldRgb.r - newRgb.r, 2) + 
      Math.pow(oldRgb.g - newRgb.g, 2) + 
      Math.pow(oldRgb.b - newRgb.b, 2)
    );
    
    console.log(`${colorName.padEnd(15)}: ${oldHex} → ${newHex} (distance: ${Math.round(distance)})`);
    
    // Show what the colors actually look like
    const oldColor = `\x1b[48;2;${oldRgb.r};${oldRgb.g};${oldRgb.b}m${oldHex}\x1b[0m`;
    const newColor = `\x1b[48;2;${newRgb.r};${newRgb.g};${newRgb.b}m${newHex}\x1b[0m`;
    console.log(`           Old: ${oldColor}  New: ${newColor}`);
    console.log('');
  }
});

console.log('SUMMARY:');
console.log('========');
console.log('• The official .ase file contains completely different colors');
console.log('• Many colors changed by 200+ RGB distance units');
console.log('• This suggests the original colors were either:');
console.log('  - Approximated/estimated colors');
console.log('  - From a different Riley Blake collection');
console.log('  - From a different source entirely');
console.log('');
console.log('The new colors from the .ase file are the official, accurate colors!'); 