@echo off
setlocal enabledelayedexpansion

:: Create a directory for all the repositories
set WORKSPACE_DIR=agentic_workspace
if not exist %WORKSPACE_DIR% mkdir %WORKSPACE_DIR%
cd %WORKSPACE_DIR%

echo Setting up development workspace in %CD%

:: Function to clone a repository if it doesn't exist
:clone_repo
if "%~1"=="" goto :eof
set repo_name=%~1
if not exist "%repo_name%" (
    echo Cloning %repo_name%...
    git clone "https://github.com/endomorphosis/%repo_name%.git"
) else (
    echo %repo_name% already exists, updating...
    cd %repo_name%
    git pull
    cd ..
)
goto :eof

:: Clone all repositories
call :clone_repo voice_kit_webgpu_cjs
call :clone_repo ipfs_accelerate_py
call :clone_repo ipfs_transformers_py
call :clone_repo ipfs_parquet_to_car_js
call :clone_repo hallucinate_app

echo Setup complete! All repositories have been cloned to %CD%

:: List the contents of the workspace
echo.
echo Workspace contents:
dir /w

endlocal 