@echo off
setlocal enabledelayedexpansion

echo Starting setup script...

:: Create a directory for all the repositories
set WORKSPACE_DIR=agentic_workspace
echo Creating/checking workspace directory: %WORKSPACE_DIR%
if not exist %WORKSPACE_DIR% (
    mkdir %WORKSPACE_DIR%
    echo Created directory: %WORKSPACE_DIR%
) else (
    echo Directory already exists: %WORKSPACE_DIR%
)
cd %WORKSPACE_DIR%

echo Current directory: %CD%

echo.
echo Cloning repositories...

:: Clone all repositories
call :clone_repo voice_kit_webgpu_cjs
call :clone_repo ipfs_accelerate_py
call :clone_repo ipfs_transformers_py
call :clone_repo ipfs_parquet_to_car_js
call :clone_repo hallucinate_app

echo.
echo Setup complete! All repositories have been processed.
echo Current location: %CD%

:: List the contents of the workspace
echo.
echo Workspace contents:
dir /w

goto :end

:: Function to clone a repository if it doesn't exist
:clone_repo
if "%~1"=="" (
    echo No repository name provided
    goto :eof
)
set repo_name=%~1
echo Processing repository: %repo_name%
if not exist "%repo_name%" (
    echo Attempting to clone %repo_name%...
    git clone "https://github.com/endomorphosis/%repo_name%.git"
    if errorlevel 1 (
        echo ERROR: Failed to clone %repo_name%
        echo Git clone command returned error code: %errorlevel%
    ) else (
        echo Successfully cloned %repo_name%
    )
) else (
    echo Repository %repo_name% already exists, updating...
    cd %repo_name%
    git pull
    if errorlevel 1 (
        echo ERROR: Failed to update %repo_name%
    ) else (
        echo Successfully updated %repo_name%
    )
    cd ..
)
exit /b

:end
endlocal 