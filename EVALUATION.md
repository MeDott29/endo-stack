# Repository Evaluation Guide

This guide helps you evaluate the repositories in the agentic workspace on your Windows machine.

## Prerequisites

1. Python 3.x installed and in PATH
2. Node.js installed and in PATH
3. npm installed and in PATH
4. Git installed and in PATH

## Setup

1. Clone the repository and run setup:
```bash
git clone https://github.com/endomorphosis/endo-stack.git
cd endo-stack
./setup.sh  # or setup.bat on Windows
```

## Running Evaluation

### On Windows
Simply double-click `evaluate.bat` or run it from the command prompt:
```bash
evaluate.bat
```

### On Unix-like Systems
Run the Python script directly:
```bash
python evaluate.py
```

## What Gets Evaluated

The script checks the following for each repository:

1. **Repository Structure**
   - Verifies repository exists
   - Checks basic directory structure

2. **Python Repositories**
   - Checks for requirements.txt
   - Verifies Python package dependencies can be imported

3. **JavaScript/Node.js Repositories**
   - Checks for package.json
   - Attempts to install npm dependencies

## Repositories Checked

1. voice_kit_webgpu_cjs
   - WebGPU-accelerated voice processing
   - Node.js/JavaScript

2. ipfs_accelerate_py
   - Model acceleration backend
   - Python

3. ipfs_transformers_py
   - Hugging Face transformers integration
   - Python

4. ipfs_parquet_to_car_js
   - IPFS data conversion utilities
   - Node.js/JavaScript

5. hallucinate_app
   - Main application
   - Mixed Python/JavaScript

## Troubleshooting

If you encounter issues:

1. **Python Import Errors**
   - Ensure Python 3.x is installed
   - Install missing packages: `pip install -r requirements.txt`

2. **Node.js/npm Errors**
   - Ensure Node.js and npm are installed
   - Run `npm install` in JavaScript repository directories

3. **Path Issues**
   - Verify Python, Node.js, and npm are in your system PATH
   - Restart your terminal after PATH changes 