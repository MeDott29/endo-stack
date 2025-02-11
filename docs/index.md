# Endo-Stack Documentation

Welcome to the Endo-Stack documentation. This documentation provides detailed information about each component in the stack and how they work together.

## Components

### 1. [Voice Kit WebGPU (CJS)](./voice_kit_webgpu_cjs.md)
WebGPU-accelerated voice processing component implemented in Node.js/JavaScript. This component handles real-time voice processing using hardware acceleration.

### 2. [IPFS Accelerate (Python)](./ipfs_accelerate_py.md)
Model acceleration backend implemented in Python. This component optimizes and accelerates machine learning models for deployment.

### 3. [IPFS Transformers (Python)](./ipfs_transformers_py.md)
Hugging Face transformers integration component. This handles the integration with transformer-based models and IPFS.

### 4. [IPFS Parquet to CAR (JavaScript)](./ipfs_parquet_to_car_js.md)
IPFS data conversion utilities for converting between Parquet and CAR formats, implemented in Node.js.

### 5. [Hallucinate App](./hallucinate_app.md)
The main application that integrates all components, using both Python and JavaScript.

## System Requirements

- Python 3.x
- Node.js
- npm
- Git
- WebGPU-compatible hardware/drivers (for voice processing)

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/endomorphosis/endo-stack.git
   cd endo-stack
   ```

2. Run the setup script:
   - Windows: `setup.bat`
   - Linux/Mac: `./setup.sh`

3. Verify installation:
   - Windows: `evaluate.bat`
   - Linux/Mac: `python evaluate.py`

## Architecture Overview

The Endo-Stack is a distributed system that combines WebGPU acceleration, IPFS storage, and transformer models. Here's how the components interact:

1. Voice Kit WebGPU processes audio input using hardware acceleration
2. IPFS Accelerate optimizes model performance
3. IPFS Transformers handles ML model operations
4. IPFS Parquet to CAR manages data format conversion
5. Hallucinate App coordinates all components

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on contributing to any of the components.

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details. 