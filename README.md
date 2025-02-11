# Endo-Stack

A collection of setup scripts to clone and manage the endomorphosis development stack repositories.

## Repositories Included

- voice_kit_webgpu_cjs
- ipfs_accelerate_py
- ipfs_transformers_py
- ipfs_parquet_to_car_js
- hallucinate_app

## Usage

### For Linux/Mac Users:
```bash
chmod +x setup.sh
./setup.sh
```

### For Windows Users:
```cmd
setup.bat
```

Both scripts will:
1. Create a workspace directory
2. Clone all required repositories if they don't exist
3. Update existing repositories
4. Display the workspace contents when complete

## Requirements

- Git must be installed and available in your system's PATH
- Internet connection to access GitHub repositories

## License

MIT License 