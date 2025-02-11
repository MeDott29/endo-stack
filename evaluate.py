#!/usr/bin/env python3
import os
import sys
import subprocess
import importlib.util
from pathlib import Path

def check_repository(repo_path):
    """Check if a repository exists and has the expected structure"""
    path = Path(repo_path)
    if not path.exists():
        return False, f"{repo_path} does not exist"
    if not path.is_dir():
        return False, f"{repo_path} is not a directory"
    return True, f"{repo_path} exists and is a directory"

def check_python_imports(repo_path):
    """Check if required Python packages can be imported"""
    requirements_path = Path(repo_path) / "requirements.txt"
    if not requirements_path.exists():
        return False, f"No requirements.txt found in {repo_path}"
    
    try:
        with open(requirements_path, 'r') as f:
            requirements = f.readlines()
        
        missing_packages = []
        for req in requirements:
            package = req.strip().split('==')[0]
            try:
                importlib.import_module(package)
            except ImportError:
                missing_packages.append(package)
        
        if missing_packages:
            return False, f"Missing packages in {repo_path}: {', '.join(missing_packages)}"
        return True, f"All packages in {repo_path} can be imported"
    except Exception as e:
        return False, f"Error checking imports in {repo_path}: {str(e)}"

def check_node_imports(repo_path):
    """Check if required Node.js packages can be imported"""
    package_path = Path(repo_path) / "package.json"
    if not package_path.exists():
        return False, f"No package.json found in {repo_path}"
    
    try:
        result = subprocess.run(['npm', 'install'], cwd=repo_path, capture_output=True, text=True)
        if result.returncode != 0:
            return False, f"npm install failed in {repo_path}: {result.stderr}"
        return True, f"All npm packages in {repo_path} can be installed"
    except Exception as e:
        return False, f"Error checking npm packages in {repo_path}: {str(e)}"

def main():
    workspace_dir = "agentic_workspace"
    repositories = [
        "voice_kit_webgpu_cjs",
        "ipfs_accelerate_py",
        "ipfs_transformers_py",
        "ipfs_parquet_to_car_js",
        "hallucinate_app"
    ]
    
    results = []
    
    print("Starting repository evaluation...")
    print("-" * 50)
    
    for repo in repositories:
        repo_path = os.path.join(workspace_dir, repo)
        print(f"\nEvaluating {repo}...")
        
        # Check repository existence
        exists, msg = check_repository(repo_path)
        print(msg)
        if not exists:
            continue
        
        # Check dependencies based on repository type
        if repo.endswith('_py'):
            success, msg = check_python_imports(repo_path)
            print(msg)
            results.append((repo, success))
        elif repo.endswith('_js') or repo.endswith('_cjs'):
            success, msg = check_node_imports(repo_path)
            print(msg)
            results.append((repo, success))
        else:
            print(f"Unknown repository type for {repo}")
            results.append((repo, False))
    
    print("\nEvaluation Summary:")
    print("-" * 50)
    for repo, success in results:
        status = "✓" if success else "✗"
        print(f"{status} {repo}")

if __name__ == "__main__":
    main() 