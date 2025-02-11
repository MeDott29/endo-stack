# IPFS Transformers (Python)

## Overview

IPFS Transformers provides seamless integration between Hugging Face transformers and IPFS, allowing for distributed storage and retrieval of transformer models, tokenizers, and their artifacts. This component enables efficient model sharing and versioning through IPFS.

## Features

- IPFS-based model storage and retrieval
- Hugging Face Transformers integration
- Distributed model sharing
- Version control for models
- Automatic model caching
- Support for custom model architectures

## Requirements

- Python 3.7+
- transformers
- torch
- ipfs-http-client
- datasets (optional)

## Installation

The component is automatically installed when running the main setup script. To install manually:

```bash
cd agentic_workspace/ipfs_transformers_py
pip install -r requirements.txt
```

## Usage

```python
from ipfs_transformers import IPFSTransformerModel

# Load model from IPFS
model = IPFSTransformerModel.from_ipfs(
    ipfs_hash="Qm...",
    model_type="bert-base-uncased"
)

# Run inference
outputs = model.predict("Hello, world!")

# Save model to IPFS
ipfs_hash = model.save_to_ipfs()
```

## API Reference

### Class: IPFSTransformerModel

#### Constructor Parameters
- `model_name` (str): Name or path of the model
- `cache_dir` (str, optional): Directory for caching models
- `revision` (str, optional): Model revision/version
- `use_auth_token` (bool): Use Hugging Face auth token

#### Methods
- `from_ipfs(ipfs_hash)`: Load model from IPFS
- `save_to_ipfs()`: Save model to IPFS
- `predict(text)`: Run inference on input
- `train(dataset)`: Fine-tune the model
- `push_to_hub()`: Push model to Hugging Face Hub

## Integration Examples

### 1. Loading Pre-trained Models

```python
# Load BERT model from IPFS
model = IPFSTransformerModel.from_ipfs(
    ipfs_hash="Qm...",
    model_type="bert-base-uncased"
)

# Fine-tune on custom dataset
model.train(
    dataset=custom_dataset,
    learning_rate=2e-5,
    num_epochs=3
)

# Save fine-tuned model
new_hash = model.save_to_ipfs()
```

### 2. Custom Model Architecture

```python
from ipfs_transformers import IPFSTransformerConfig

# Define custom configuration
config = IPFSTransformerConfig(
    hidden_size=768,
    num_attention_heads=12,
    num_hidden_layers=6
)

# Create custom model
model = IPFSTransformerModel.from_config(config)
```

## Model Management

### Versioning

Models in IPFS are immutable and versioned by their content hash:

```python
# Load specific version
model_v1 = IPFSTransformerModel.from_ipfs("Qm...v1")
model_v2 = IPFSTransformerModel.from_ipfs("Qm...v2")

# Compare versions
diff = model_v1.compare_with(model_v2)
```

### Caching

The component implements intelligent caching:

```python
# Configure caching
model = IPFSTransformerModel(
    cache_dir="./cache",
    max_cache_size="10GB"
)
```

## Performance Optimization

1. Batch Processing
   ```python
   outputs = model.batch_predict(
       texts=["Hello", "World"],
       batch_size=32
   )
   ```

2. Memory Management
   ```python
   model.to_device("cuda")  # GPU acceleration
   model.enable_gradient_checkpointing()  # Memory optimization
   ```

## Troubleshooting

Common issues and solutions:

1. IPFS Connection Issues
   - Check IPFS daemon status
   - Verify network connectivity
   - Validate IPFS hashes

2. Model Loading Issues
   - Clear cache directory
   - Check model compatibility
   - Verify dependencies

## Contributing

See the main [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

## License

MIT License - see the [LICENSE](../LICENSE) file for details. 