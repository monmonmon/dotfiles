#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const program = require('commander');

program
  .name('wordle.js')
  .description('cheet wordle!')
  .option('-y, --yellow <n><c>[,<n><c>,...]', 'yellow')
  .option('-g, --green <n><c>[,<n><c>,...]', 'green')
  .option('-b, --black <c>[<c>...]', 'black')
  .option('-h, --help', 'help')
  .parse();
const options = program.opts();

// if (options.help) {
//   const name = path.basename(process.argv[1])
//   console.log(`Usage: ${name}`)
//   process.exit()
// }

// check format
const argFormat = /^[1-5][a-z](,[1-5][a-z]){0,4}$/;
if (!options.yellow && options.green && options.black) {
  console.log(`either yellow or green are required`);
  process.exit(1);
} else if (options.yellow && !argFormat.test(options.yellow)) {
  console.log(`invalid format: ${options.yellow}`);
  process.exit(1);
} else if (options.green && !argFormat.test(options.green)) {
  console.log(`invalid format: ${options.yellow}`);
  process.exit(1);
} else if (options.black && !/^[a-z]+$/.test(options.black)) {
  console.log(`invalid format: ${options.black}`);
  process.exit(1);
}

const dictFilePath = path.join(process.env.HOME, 'lib', 'wordle.txt');
const dictContent = fs.readFileSync(dictFilePath, { encoding: 'utf-8' });
let words = dictContent.split('\n');

if (options.green) {
  let arr = (new Array(5)).fill('.')
  options.green.split(',').forEach(pair => {
    const pos = parseInt(pair[0]);
    const char = pair[1];
    arr[pos - 1] = char;
  });
  const regexp = new RegExp(`^${arr.join('')}$`)
  words = words.filter(word => regexp.test(word))
}

if (options.black) {
  const regexp = new RegExp(`[${options.black}]`)
  words = words.filter(word => !regexp.test(word))
}

if (options.yellow) {
  let regexps = []
  let arr = (new Array(5)).fill('.')
  options.yellow.split(',').forEach(pair => {
    const pos = parseInt(pair[0]);
    const char = pair[1];
    arr[pos - 1] = `[^${char}]`;
    regexps.push(new RegExp(char))
  });
  const regexp = new RegExp(`^${arr.join('')}$`)
  words = words.filter(word =>
    regexps.every(r => r.test(word)) && regexp.test(word)
  )
}

words.forEach(word => {
  console.log(word)
})
