@echo off
setlocal enabledelayedexpansion

echo Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo Python is not installed or not in PATH
    echo Please install Python 3.x and add it to your PATH
    exit /b 1
)

echo Checking Node.js installation...
node --version >nul 2>&1
if errorlevel 1 (
    echo Node.js is not installed or not in PATH
    echo Please install Node.js and add it to your PATH
    exit /b 1
)

echo Checking npm installation...
npm --version >nul 2>&1
if errorlevel 1 (
    echo npm is not installed or not in PATH
    echo Please install npm and add it to your PATH
    exit /b 1
)

echo.
echo Running repository evaluation...
python evaluate.py

if errorlevel 1 (
    echo Evaluation failed
    exit /b 1
)

echo.
echo Evaluation completed successfully
pause 