import { readFileSync, writeFileSync } from 'fs';
import { parse } from 'toml';

const tomlFilePath = '../contracts/manifests/deployments/KATANA.toml'; // Update this path
const jsonFilePath = './manifest.json'; // Update this path

// Read the TOML file
const tomlContent = readFileSync(tomlFilePath, 'utf-8');

// Parse the TOML content
const parsedData = parse(tomlContent);

// Convert the parsed data to a JSON string
const jsonData = JSON.stringify(parsedData, null, 2); // Pretty print the JSON

// Write the JSON data to a file
writeFileSync(jsonFilePath, jsonData);

console.log(`Converted ${tomlFilePath} to JSON and saved as ${jsonFilePath}`);
