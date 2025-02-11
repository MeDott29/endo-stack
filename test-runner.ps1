# Test Runner for Endo-Stack
Write-Host "Endo-Stack Test Runner" -ForegroundColor Green

# Load configuration
$config = Get-Content -Raw -Path "endo-stack.config.json" | ConvertFrom-Json

# Function to run Node.js tests
function Run-NodeTests {
    param (
        [string]$component
    )
    Write-Host "`nRunning tests for $component..." -ForegroundColor Yellow
    Set-Location "agentic_workspace\$component"
    
    # Install dependencies if needed
    if (-not (Test-Path "node_modules")) {
        Write-Host "Installing dependencies..." -ForegroundColor Cyan
        npm install
    }
    
    # Run tests
    npm test
    
    # Return to root
    Set-Location ..\..
}

# Function to run Python tests
function Run-PythonTests {
    param (
        [string]$component
    )
    Write-Host "`nRunning tests for $component..." -ForegroundColor Yellow
    Set-Location "agentic_workspace\$component"
    
    # Create virtual environment if needed
    if (-not (Test-Path "venv")) {
        Write-Host "Creating virtual environment..." -ForegroundColor Cyan
        python -m venv venv
        .\venv\Scripts\Activate.ps1
        pip install -r requirements.txt
    } else {
        .\venv\Scripts\Activate.ps1
    }
    
    # Run tests
    python -m pytest tests/
    
    # Deactivate virtual environment
    deactivate
    
    # Return to root
    Set-Location ..\..
}

# Function to run hybrid tests
function Run-HybridTests {
    param (
        [string]$component
    )
    Write-Host "`nRunning tests for $component..." -ForegroundColor Yellow
    Set-Location "agentic_workspace\$component"
    
    # Frontend tests
    Write-Host "Running frontend tests..." -ForegroundColor Cyan
    if (-not (Test-Path "frontend\node_modules")) {
        Set-Location frontend
        npm install
        npm test
        Set-Location ..
    }
    
    # Backend tests
    Write-Host "Running backend tests..." -ForegroundColor Cyan
    if (-not (Test-Path "backend\venv")) {
        Set-Location backend
        python -m venv venv
        .\venv\Scripts\Activate.ps1
        pip install -r requirements.txt
        python -m pytest tests/
        deactivate
        Set-Location ..
    }
    
    # Return to root
    Set-Location ..\..
}

# Run tests for each component
foreach ($component in $config.components.PSObject.Properties) {
    $name = $component.Name
    $type = $component.Value.type
    
    switch ($type) {
        "node" {
            Run-NodeTests -component $name
        }
        "python" {
            Run-PythonTests -component $name
        }
        "hybrid" {
            Run-HybridTests -component $name
        }
    }
}

Write-Host "`nAll tests completed!" -ForegroundColor Green 