# Voice Kit WebGPU (CJS)

## Overview

The Voice Kit WebGPU component provides hardware-accelerated voice processing capabilities using WebGPU technology. It's implemented in Node.js using CommonJS modules.

## Features

- Real-time voice processing using WebGPU acceleration
- Low-latency audio processing
- Hardware-optimized DSP operations
- Integration with other Endo-Stack components

## Technical Specifications

### WebGPU Pipeline

The voice processing pipeline consists of the following stages:

1. **Audio Input Buffer**
   - Format: 32-bit float PCM
   - Sample Rate: 44.1kHz/48kHz configurable
   - Buffer Size: 4096 samples (configurable)
   - Channels: Mono/Stereo support

2. **GPU Compute Pipeline**
   ```javascript
   const pipeline = device.createComputePipeline({
     layout: 'auto',
     compute: {
       module: device.createShaderModule({
         code: VOICE_PROCESSING_SHADER
       }),
       entryPoint: 'main'
     }
   });
   ```

3. **Shader Implementation**
   ```wgsl
   @compute @workgroup_size(256)
   fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {
     // Audio processing shader code
     let index = global_id.x;
     if (index >= uniforms.bufferSize) {
       return;
     }
     
     // Process audio sample
     var sample = audioBuffer[index];
     // Apply processing effects
     audioBuffer[index] = processed_sample;
   }
   ```

### Memory Management

1. **Buffer Allocation**
   ```javascript
   const audioBuffer = device.createBuffer({
     size: BUFFER_SIZE * Float32Array.BYTES_PER_ELEMENT,
     usage: GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC,
   });
   ```

2. **Memory Layout**
   - Input Buffer: Float32Array aligned to 4 bytes
   - Processing Buffer: Multiple of workgroup size (256)
   - Output Buffer: Same format as input

### Performance Optimizations

1. **Workgroup Configuration**
   - Size: 256 threads per workgroup
   - Multiple workgroups for parallel processing
   - Dynamic dispatch based on buffer size

2. **Pipeline Optimizations**
   ```javascript
   const optimizedPipeline = {
     bufferAlignment: 256, // Optimal for most GPUs
     workgroupSize: 256,
     maxBufferSize: 1024 * 1024, // 1MB
     useBindGroups: true
   };
   ```

## Testing

### Unit Tests

Create file: `tests/voice_kit/unit.test.js`
```javascript
const { VoiceKit } = require('../../voice_kit_webgpu_cjs/src/voice_kit');
const { expect } = require('chai');

describe('VoiceKit', () => {
  let voiceKit;

  beforeEach(() => {
    voiceKit = new VoiceKit({
      sampleRate: 44100,
      bufferSize: 4096
    });
  });

  it('should initialize with correct parameters', () => {
    expect(voiceKit.sampleRate).to.equal(44100);
    expect(voiceKit.bufferSize).to.equal(4096);
  });

  it('should process audio data correctly', async () => {
    const testBuffer = new Float32Array(4096).fill(0.5);
    const processed = await voiceKit.processAudio(testBuffer);
    expect(processed).to.be.an.instanceOf(Float32Array);
    expect(processed.length).to.equal(4096);
  });

  it('should handle WebGPU device creation', async () => {
    const deviceInfo = await voiceKit.getDeviceInfo();
    expect(deviceInfo).to.have.property('adapter');
    expect(deviceInfo).to.have.property('device');
  });
});
```

### Integration Tests

Create file: `tests/voice_kit/integration.test.js`
```javascript
const { VoiceKit } = require('../../voice_kit_webgpu_cjs/src/voice_kit');
const { IPFSClient } = require('../../voice_kit_webgpu_cjs/src/ipfs');
const { expect } = require('chai');

describe('VoiceKit Integration', () => {
  let voiceKit;
  let ipfsClient;

  beforeEach(async () => {
    voiceKit = new VoiceKit({
      sampleRate: 44100,
      bufferSize: 4096
    });
    ipfsClient = new IPFSClient();
  });

  it('should process and store audio in IPFS', async () => {
    const testBuffer = new Float32Array(4096).fill(0.5);
    const processed = await voiceKit.processAudio(testBuffer);
    const cid = await ipfsClient.store(processed);
    expect(cid).to.be.a('string');
    expect(cid).to.match(/^Qm/);
  });
});
```

### Performance Tests

Create file: `tests/voice_kit/performance.test.js`
```javascript
const { VoiceKit } = require('../../voice_kit_webgpu_cjs/src/voice_kit');
const { expect } = require('chai');

describe('VoiceKit Performance', () => {
  let voiceKit;

  beforeEach(() => {
    voiceKit = new VoiceKit({
      sampleRate: 44100,
      bufferSize: 4096
    });
  });

  it('should process audio within latency requirements', async () => {
    const testBuffer = new Float32Array(4096).fill(0.5);
    const startTime = performance.now();
    await voiceKit.processAudio(testBuffer);
    const endTime = performance.now();
    const processingTime = endTime - startTime;
    expect(processingTime).to.be.below(16.67); // Target: 60fps (16.67ms)
  });

  it('should handle large buffers efficiently', async () => {
    const largeBuffer = new Float32Array(1024 * 1024).fill(0.5);
    const startTime = performance.now();
    await voiceKit.processAudio(largeBuffer);
    const endTime = performance.now();
    const throughput = (largeBuffer.length / (endTime - startTime)) * 1000;
    expect(throughput).to.be.above(44100); // Min throughput: 44.1kHz
  });
});
```

## Advanced Usage Examples

### Custom Audio Effects

```javascript
const voiceKit = new VoiceKit({
  effects: [
    {
      type: 'reverb',
      params: {
        roomSize: 0.8,
        dampening: 3000,
        wet: 0.5
      }
    },
    {
      type: 'compression',
      params: {
        threshold: -24,
        ratio: 4,
        attack: 0.003,
        release: 0.25
      }
    }
  ]
});
```

### Real-time Parameter Control

```javascript
voiceKit.setParameters({
  gain: 0.8,
  filterCutoff: 2000,
  filterResonance: 0.7
});

// Subscribe to parameter changes
voiceKit.onParameterChange((params) => {
  console.log('Parameters updated:', params);
});
```

## Requirements

- Node.js 16+
- WebGPU-compatible GPU
- Updated GPU drivers
- Chrome/Chromium browser with WebGPU enabled (for web interface)

## Installation

The component is automatically installed when running the main setup script. To install manually:

```bash
cd agentic_workspace/voice_kit_webgpu_cjs
npm install
```

## Usage

```javascript
const VoiceKit = require('./voice_kit');

// Initialize the voice kit with WebGPU context
const voiceKit = new VoiceKit({
    sampleRate: 44100,
    bufferSize: 4096
});

// Process audio data
voiceKit.processAudio(audioBuffer);
```

## API Reference

### Class: VoiceKit

#### Constructor Options
- `sampleRate` (number): Audio sample rate (default: 44100)
- `bufferSize` (number): Processing buffer size (default: 4096)
- `channels` (number): Number of audio channels (default: 1)

#### Methods
- `processAudio(buffer)`: Process audio data using WebGPU
- `setParameters(params)`: Update processing parameters
- `getDeviceInfo()`: Get WebGPU device information

## Integration with IPFS Components

The Voice Kit WebGPU component can send processed audio data to IPFS components for storage or further processing:

```javascript
// Example integration with IPFS
const processedData = voiceKit.processAudio(audioBuffer);
await ipfsClient.store(processedData);
```

## Performance Considerations

- WebGPU operations are asynchronous
- Buffer sizes affect latency and processing efficiency
- GPU memory usage scales with buffer size

## Troubleshooting

Common issues and solutions:

1. WebGPU Not Available
   - Ensure GPU drivers are up to date
   - Check browser WebGPU support
   - Verify hardware compatibility

2. Performance Issues
   - Adjust buffer size
   - Monitor GPU memory usage
   - Check for competing GPU tasks

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## License

MIT License - see the [LICENSE](../LICENSE) file for details. 