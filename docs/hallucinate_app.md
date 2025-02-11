# Hallucinate App

## Overview

Hallucinate App is the main application that integrates all components of the Endo-Stack. It provides a unified interface for voice processing, model acceleration, and IPFS-based storage, combining both Python and JavaScript components into a cohesive application.

## Features

- Voice processing with WebGPU acceleration
- Model optimization and acceleration
- IPFS-based model and data storage
- Real-time inference
- Modern web interface
- Cross-platform support

## Requirements

- Python 3.7+
- Node.js 14+
- WebGPU-compatible GPU
- IPFS daemon
- Modern web browser

## Installation

The application is automatically installed when running the main setup script. To install manually:

```bash
cd agentic_workspace/hallucinate_app

# Install Python dependencies
pip install -r requirements.txt

# Install Node.js dependencies
npm install
```

## Architecture

The application follows a microservices architecture:

1. Frontend (React + WebGPU)
   - User interface
   - Real-time voice processing
   - WebGPU acceleration

2. Backend (Python + Node.js)
   - Model serving
   - IPFS integration
   - Data processing

3. Model Services
   - Model optimization
   - Inference pipeline
   - Version management

## Usage

### Starting the Application

```bash
# Start the backend services
python backend/main.py

# In a separate terminal, start the frontend
npm start
```

### Configuration

The application can be configured through environment variables or config files:

```bash
# .env file
IPFS_NODE=http://localhost:5001
MODEL_CACHE_DIR=./cache
WEBGPU_ENABLED=true
```

## API Reference

### REST API

#### Model Management
- `POST /api/models/optimize`
- `GET /api/models/{model_id}`
- `DELETE /api/models/{model_id}`

#### Voice Processing
- `POST /api/voice/process`
- `GET /api/voice/status/{job_id}`

#### IPFS Operations
- `POST /api/ipfs/store`
- `GET /api/ipfs/retrieve/{cid}`

### WebSocket API

```javascript
// Connect to WebSocket
const ws = new WebSocket('ws://localhost:8080');

// Handle real-time voice data
ws.onmessage = (event) => {
    const audioData = JSON.parse(event.data);
    processAudioData(audioData);
};
```

## Component Integration

### 1. Voice Kit Integration

```javascript
import { VoiceKit } from '@endo/voice-kit-webgpu';

const voiceKit = new VoiceKit();
voiceKit.onAudioData((data) => {
    // Process audio data
    ws.send(JSON.stringify(data));
});
```

### 2. Model Acceleration

```python
from ipfs_accelerate import ModelAccelerator
from ipfs_transformers import IPFSTransformerModel

# Load and optimize model
model = IPFSTransformerModel.from_ipfs(model_hash)
accelerator = ModelAccelerator(model)
optimized_model = accelerator.optimize()
```

### 3. Data Storage

```javascript
const { ParquetConverter } = require('ipfs-parquet-car');

// Store processed data
const converter = new ParquetConverter();
await converter.parquetToCAR('processed_data.parquet', 'data.car');
```

## Development

### Project Structure

```
hallucinate_app/
├── frontend/
│   ├── src/
│   ├── public/
│   └── package.json
├── backend/
│   ├── api/
│   ├── models/
│   └── main.py
├── config/
└── tests/
```

### Running Tests

```bash
# Backend tests
python -m pytest tests/

# Frontend tests
npm test
```

### Building for Production

```bash
# Build frontend
npm run build

# Package application
python setup.py bdist_wheel
```

## Monitoring and Logging

The application includes comprehensive monitoring:

```python
# Configure logging
import logging
logging.config.fileConfig('logging.conf')
logger = logging.getLogger('hallucinate')

# Monitor performance
from monitoring import MetricsCollector
metrics = MetricsCollector()
metrics.track_inference_time()
```

## Troubleshooting

Common issues and solutions:

1. Integration Issues
   - Check component versions
   - Verify API compatibility
   - Review connection settings

2. Performance Issues
   - Monitor resource usage
   - Check GPU utilization
   - Optimize data flow

3. WebGPU Issues
   - Update GPU drivers
   - Check browser compatibility
   - Verify hardware support

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## License

MIT License - see the [LICENSE](../LICENSE) file for details. 