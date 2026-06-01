@echo off
setlocal

echo ===============================================
echo    NarratoAI Simple Launcher
echo ===============================================
echo.

set CURRENT_DIR=%~dp0
set LOG_FILE=%CURRENT_DIR%startup.log

echo NarratoAI Startup Log > "%LOG_FILE%"
echo Start Time: %date% %time% >> "%LOG_FILE%"
echo ============================================== >> "%LOG_FILE%"

echo Current directory: %CURRENT_DIR%
echo Current directory: %CURRENT_DIR% >> "%LOG_FILE%"

:: Check basic structure
echo.
echo Checking system...
echo Checking system... >> "%LOG_FILE%"

if not exist "%CURRENT_DIR%NarratoAI" (
    echo [ERROR] NarratoAI directory not found
    echo [ERROR] NarratoAI directory not found >> "%LOG_FILE%"
    goto error_exit
)

if not exist "%CURRENT_DIR%lib" (
    echo [ERROR] lib directory not found
    echo [ERROR] lib directory not found >> "%LOG_FILE%"
    goto error_exit
)

:: Set environment variables
echo.
echo Setting environment...
echo Setting environment... >> "%LOG_FILE%"

set FFMPEG_BINARY=%CURRENT_DIR%lib\ffmpeg\ffmpeg-7.0-essentials_build\ffmpeg.exe
set FFMPEG_PATH=%CURRENT_DIR%lib\ffmpeg\ffmpeg-7.0-essentials_build
set IMAGEMAGICK_BINARY=%CURRENT_DIR%lib\imagemagic\ImageMagick-7.1.1-29-portable-Q16-x64\magick.exe
set IMAGEMAGICK_PATH=%CURRENT_DIR%lib\imagemagic\ImageMagick-7.1.1-29-portable-Q16-x64
set PYTHON_BINARY=%CURRENT_DIR%lib\python\python.exe
set PYTHONPATH=%CURRENT_DIR%NarratoAI;%PYTHONPATH%

:: Add to PATH safely (without checking duplicates to avoid PATH parsing issues)
set "PATH=%FFMPEG_PATH%;%IMAGEMAGICK_PATH%;%PATH%"
echo Added FFmpeg and ImageMagick to PATH >> "%LOG_FILE%"

:: Set project variables
set NARRATO_ROOT=%CURRENT_DIR%NarratoAI
set NARRATO_FFMPEG=%FFMPEG_BINARY%
set NARRATO_IMAGEMAGICK=%IMAGEMAGICK_BINARY%

:: Check dependencies
echo.
echo Checking dependencies...
echo Checking dependencies... >> "%LOG_FILE%"

if not exist "%PYTHON_BINARY%" (
    echo [ERROR] Python interpreter not found: %PYTHON_BINARY%
    echo [ERROR] Python interpreter not found: %PYTHON_BINARY% >> "%LOG_FILE%"
    goto error_exit
)

if not exist "%FFMPEG_BINARY%" (
    echo [ERROR] FFmpeg not found: %FFMPEG_BINARY%
    echo [ERROR] FFmpeg not found: %FFMPEG_BINARY% >> "%LOG_FILE%"
    goto error_exit
)

if not exist "%IMAGEMAGICK_BINARY%" (
    echo [ERROR] ImageMagick not found: %IMAGEMAGICK_BINARY%
    echo [ERROR] ImageMagick not found: %IMAGEMAGICK_BINARY% >> "%LOG_FILE%"
    goto error_exit
)

if not exist "%CURRENT_DIR%NarratoAI\webui.py" (
    echo [ERROR] Main program webui.py not found
    echo [ERROR] Main program webui.py not found >> "%LOG_FILE%"
    goto error_exit
)

echo [OK] All dependencies found
echo [OK] All dependencies found >> "%LOG_FILE%"

:: Test Python
echo.
echo Testing Python...
echo Testing Python... >> "%LOG_FILE%"

"%PYTHON_BINARY%" --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python cannot run properly
    echo [ERROR] Python cannot run properly >> "%LOG_FILE%"
    echo Suggest installing Microsoft Visual C++ Redistributable
    goto error_exit
)

echo [OK] Python works normally
echo [OK] Python works normally >> "%LOG_FILE%"

:: Configure Streamlit
echo.
echo Configuring Streamlit...
echo Configuring Streamlit... >> "%LOG_FILE%"

set STREAMLIT_DIR=%USERPROFILE%\.streamlit
set CREDENTIAL_FILE=%STREAMLIT_DIR%\credentials.toml

if not exist "%STREAMLIT_DIR%" (
    mkdir "%STREAMLIT_DIR%" 2>nul
    if %errorlevel% equ 0 (
        echo [OK] Created Streamlit config directory
        echo [OK] Created Streamlit config directory >> "%LOG_FILE%"
    )
)

if not exist "%CREDENTIAL_FILE%" (
    if exist "%STREAMLIT_DIR%" (
        (
            echo [general]
            echo email=""
        ) > "%CREDENTIAL_FILE%" 2>nul
        if %errorlevel% equ 0 (
            echo [OK] Created Streamlit credentials file
            echo [OK] Created Streamlit credentials file >> "%LOG_FILE%"
        )
    )
)

:: Check Streamlit module
"%PYTHON_BINARY%" -c "import streamlit" >nul 2>&1
if %errorlevel% neq 0 (
    echo Streamlit module not available, trying to install...
    echo Streamlit module not available, trying to install... >> "%LOG_FILE%"
    "%PYTHON_BINARY%" -m pip install streamlit --quiet 2>>"%LOG_FILE%"
    if %errorlevel% neq 0 (
        echo [ERROR] Cannot install Streamlit
        echo [ERROR] Cannot install Streamlit >> "%LOG_FILE%"
        goto error_exit
    )
    echo [OK] Streamlit installed successfully
    echo [OK] Streamlit installed successfully >> "%LOG_FILE%"
) else (
    echo [OK] Streamlit module available
    echo [OK] Streamlit module available >> "%LOG_FILE%"
)

:: Start application
echo.
echo Preparing to start application...
echo Preparing to start application... >> "%LOG_FILE%"

cd /d "%CURRENT_DIR%NarratoAI" 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Cannot change to project directory
    echo [ERROR] Cannot change to project directory >> "%LOG_FILE%"
    goto error_exit
)

echo.
echo Starting NarratoAI application...
echo Browser window will open automatically
echo If browser doesn't open, manually visit: http://127.0.0.1:8501
echo.

echo Starting Streamlit application... >> "%LOG_FILE%"
"%PYTHON_BINARY%" -m streamlit run webui.py --browser.serverAddress="127.0.0.1" --server.enableCORS=True --server.maxUploadSize=2048 --browser.gatherUsageStats=False 2>&1

set EXIT_CODE=%errorlevel%
echo Application exited with code: %EXIT_CODE% >> "%LOG_FILE%"

if %EXIT_CODE% neq 0 (
    echo.
    echo Application exited abnormally with code: %EXIT_CODE%
    echo Check log file for details: %LOG_FILE%
)

echo.
echo Press any key to exit...
pause >nul
goto :eof

:error_exit
echo.
echo Startup failed!
echo Check log file for details: %LOG_FILE%
echo.
echo Suggested actions:
echo 1. Run simple_check.bat to check system
echo 2. Run simple_fix.bat to fix issues
echo 3. Run as administrator
echo.
echo Press any key to exit...
pause >nul
exit /b 1
