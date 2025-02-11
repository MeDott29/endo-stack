# Health Check for Endo-Stack
Write-Host "Endo-Stack Health Check" -ForegroundColor Green

# Load configuration
$config = Get-Content -Raw -Path "endo-stack.config.json" | ConvertFrom-Json

# Function to check if a port is in use
function Test-Port {
    param (
        [int]$port
    )
    $result = Test-NetConnection -ComputerName localhost -Port $port -WarningAction SilentlyContinue
    return $result.TcpTestSucceeded
}

# Function to check Node.js component
function Test-NodeComponent {
    param (
        [string]$name,
        [int]$port
    )
    Write-Host "`nChecking $name..." -ForegroundColor Yellow
    
    # Check if Node.js is installed
    try {
        $nodeVersion = node --version
        Write-Host "Node.js version: $nodeVersion" -ForegroundColor Green
    } catch {
        Write-Host "Node.js not found!" -ForegroundColor Red
        return $false
    }
    
    # Check if port is available
    if (Test-Port -port $port) {
        Write-Host "Port $port is in use (service might be running)" -ForegroundColor Green
    } else {
        Write-Host "Port $port is available" -ForegroundColor Yellow
    }
    
    # Check dependencies
    Set-Location "agentic_workspace\$name"
    if (Test-Path "node_modules") {
        Write-Host "Dependencies are installed" -ForegroundColor Green
    } else {
        Write-Host "Dependencies not found!" -ForegroundColor Red
    }
    Set-Location ..\..
    
    return $true
}

# Function to check Python component
function Test-PythonComponent {
    param (
        [string]$name,
        [int]$port
    )
    Write-Host "`nChecking $name..." -ForegroundColor Yellow
    
    # Check if Python is installed
    try {
        $pythonVersion = python --version
        Write-Host "Python version: $pythonVersion" -ForegroundColor Green
    } catch {
        Write-Host "Python not found!" -ForegroundColor Red
        return $false
    }
    
    # Check if port is available
    if (Test-Port -port $port) {
        Write-Host "Port $port is in use (service might be running)" -ForegroundColor Green
    } else {
        Write-Host "Port $port is available" -ForegroundColor Yellow
    }
    
    # Check virtual environment
    Set-Location "agentic_workspace\$name"
    if (Test-Path "venv") {
        Write-Host "Virtual environment exists" -ForegroundColor Green
    } else {
        Write-Host "Virtual environment not found!" -ForegroundColor Red
    }
    Set-Location ..\..
    
    return $true
}

# Function to check IPFS
function Test-IPFS {
    Write-Host "`nChecking IPFS..." -ForegroundColor Yellow
    
    # Check IPFS API
    try {
        $response = Invoke-WebRequest -Uri $config.ipfs.node/api/v0/version -Method GET
        if ($response.StatusCode -eq 200) {
            Write-Host "IPFS node is running" -ForegroundColor Green
        }
    } catch {
        Write-Host "IPFS node is not running!" -ForegroundColor Red
        return $false
    }
    
    # Check IPFS Gateway
    try {
        $response = Invoke-WebRequest -Uri $config.ipfs.gateway/ipfs/QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG -Method GET
        if ($response.StatusCode -eq 200) {
            Write-Host "IPFS gateway is accessible" -ForegroundColor Green
        }
    } catch {
        Write-Host "IPFS gateway is not accessible!" -ForegroundColor Red
    }
    
    return $true
}

# Function to check GPU
function Test-GPU {
    Write-Host "`nChecking GPU..." -ForegroundColor Yellow
    
    # Check if running on Windows
    if ($IsWindows -or $env:OS -match "Windows") {
        try {
            $gpu = Get-WmiObject Win32_VideoController
            Write-Host "GPU: $($gpu.Name)" -ForegroundColor Green
            Write-Host "Driver Version: $($gpu.DriverVersion)" -ForegroundColor Green
        } catch {
            Write-Host "Could not get GPU information!" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "GPU check not implemented for this OS" -ForegroundColor Yellow
    }
    
    return $true
}

# Main health check
$allHealthy = $true

# Check IPFS
$allHealthy = $allHealthy -and (Test-IPFS)

# Check GPU
$allHealthy = $allHealthy -and (Test-GPU)

# Check each component
foreach ($component in $config.components.PSObject.Properties) {
    $name = $component.Name
    $type = $component.Value.type
    $port = $component.Value.port
    
    switch ($type) {
        "node" {
            $allHealthy = $allHealthy -and (Test-NodeComponent -name $name -port $port)
        }
        "python" {
            $allHealthy = $allHealthy -and (Test-PythonComponent -name $name -port $port)
        }
        "hybrid" {
            # Check frontend
            $allHealthy = $allHealthy -and (Test-NodeComponent -name "$name/frontend" -port $component.Value.frontend.port)
            # Check backend
            $allHealthy = $allHealthy -and (Test-PythonComponent -name "$name/backend" -port $component.Value.backend.port)
        }
    }
}

# Final status
Write-Host "`nHealth Check Summary:" -ForegroundColor Cyan
if ($allHealthy) {
    Write-Host "All systems are healthy!" -ForegroundColor Green
} else {
    Write-Host "Some systems need attention!" -ForegroundColor Red
} 