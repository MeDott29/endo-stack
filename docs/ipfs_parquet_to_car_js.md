# IPFS Parquet to CAR (JavaScript)

## Overview

The IPFS Parquet to CAR component provides utilities for converting between Apache Parquet and Content Addressable aRchive (CAR) formats in the IPFS ecosystem. This enables efficient storage and retrieval of structured data on IPFS.

## Features

- Bidirectional conversion between Parquet and CAR formats
- Streaming support for large datasets
- Data validation and integrity checks
- Compression optimization
- Schema preservation
- IPFS integration

## Requirements

- Node.js 14+
- npm or yarn
- IPFS daemon (optional)

## Installation

The component is automatically installed when running the main setup script. To install manually:

```bash
cd agentic_workspace/ipfs_parquet_to_car_js
npm install
```

## Usage

```javascript
const { ParquetConverter } = require('ipfs-parquet-car');

// Convert Parquet to CAR
const converter = new ParquetConverter();
await converter.parquetToCAR('data.parquet', 'output.car');

// Convert CAR to Parquet
await converter.CARToParquet('data.car', 'output.parquet');
```

## API Reference

### Class: ParquetConverter

#### Constructor Options
- `compression` (string): Compression type (snappy, gzip, none)
- `chunkSize` (number): Size of processing chunks in bytes
- `validateData` (boolean): Enable data validation

#### Methods
- `parquetToCAR(input, output)`: Convert Parquet to CAR
- `CARToParquet(input, output)`: Convert CAR to Parquet
- `validateSchema(schema)`: Validate Parquet schema
- `getStats()`: Get conversion statistics

## Streaming API

For handling large datasets:

```javascript
const { ParquetStream } = require('ipfs-parquet-car');

// Create streaming converter
const stream = new ParquetStream({
    chunkSize: 1024 * 1024 // 1MB chunks
});

// Stream conversion
stream.pipe(outputStream);
stream.write(inputData);
stream.end();
```

## Data Validation

The component includes comprehensive data validation:

```javascript
const { SchemaValidator } = require('ipfs-parquet-car');

// Validate schema
const validator = new SchemaValidator();
const isValid = validator.validateSchema(parquetSchema);

// Custom validation rules
validator.addRule('column_name', (value) => {
    return typeof value === 'string';
});
```

## IPFS Integration

Direct integration with IPFS:

```javascript
const { IPFSParquetStore } = require('ipfs-parquet-car');

// Store Parquet on IPFS
const store = new IPFSParquetStore();
const cid = await store.storeParquet('data.parquet');

// Retrieve from IPFS
await store.retrieveParquet(cid, 'retrieved.parquet');
```

## Performance Optimization

### 1. Compression Settings

```javascript
const converter = new ParquetConverter({
    compression: 'snappy',
    compressionLevel: 9
});
```

### 2. Memory Management

```javascript
const converter = new ParquetConverter({
    chunkSize: 1024 * 1024, // 1MB chunks
    maxMemory: '2GB'
});
```

## Error Handling

The component provides detailed error handling:

```javascript
try {
    await converter.parquetToCAR('input.parquet', 'output.car');
} catch (error) {
    if (error.code === 'SCHEMA_ERROR') {
        console.error('Invalid schema:', error.details);
    } else if (error.code === 'CONVERSION_ERROR') {
        console.error('Conversion failed:', error.message);
    }
}
```

## Monitoring and Metrics

```javascript
// Get conversion statistics
const stats = converter.getStats();
console.log(`Processed ${stats.rowCount} rows`);
console.log(`Compression ratio: ${stats.compressionRatio}`);
```

## Troubleshooting

Common issues and solutions:

1. Memory Issues
   - Adjust chunk size
   - Enable streaming mode
   - Monitor memory usage

2. Performance Issues
   - Optimize compression settings
   - Use appropriate chunk sizes
   - Enable parallel processing

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## License

MIT License - see the [LICENSE](../LICENSE) file for details. 