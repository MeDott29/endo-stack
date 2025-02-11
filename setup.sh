#!/bin/bash

# Create a directory for all the repositories
WORKSPACE_DIR="agentic_workspace"
mkdir -p $WORKSPACE_DIR
cd $WORKSPACE_DIR

echo "Setting up development workspace in $(pwd)"

# Function to clone a repository if it doesn't exist
clone_repo() {
    local repo_name=$1
    if [ ! -d "$repo_name" ]; then
        echo "Cloning $repo_name..."
        git clone "https://github.com/endomorphosis/$repo_name.git"
    else
        echo "$repo_name already exists, updating..."
        cd $repo_name
        git pull
        cd ..
    fi
}

# Clone all repositories
clone_repo "voice_kit_webgpu_cjs"
clone_repo "ipfs_accelerate_py"
clone_repo "ipfs_transformers_py"
clone_repo "ipfs_parquet_to_car_js"
clone_repo "hallucinate_app"

echo "Setup complete! All repositories have been cloned to $(pwd)"

# List the contents of the workspace
echo -e "\nWorkspace contents:"
ls -la 