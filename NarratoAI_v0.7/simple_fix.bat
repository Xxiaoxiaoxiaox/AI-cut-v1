@echo off
setlocal

echo ===============================================
echo    NarratoAI Fix Tool
echo ===============================================
echo.

set SCRIPT_DIR=%~dp0
set LOG_FILE=%SCRIPT_DIR%fix_report.txt

echo Fix Report > "%LOG_FILE%"
echo Fix Time: %date% %time% >> "%LOG_FILE%"
echo ============================================== >> "%LOG_FILE%"

echo Fixing common issues...
echo.

:: 1. Fix config file
echo [1/5] Checking config file...
echo [1/5] Checking config file... >> "%LOG_FILE%"

if not exist "%SCRIPT_DIR%NarratoAI\config.toml" (
    if exist "%SCRIPT_DIR%NarratoAI\config.example.toml" (
        echo Copying config file...
        copy "%SCRIPT_DIR%NarratoAI\config.example.toml" "%SCRIPT_DIR%NarratoAI\config.toml" >nul 2>&1
        if %errorlevel% equ 0 (
            echo [OK] Config file created
            echo [OK] Config file created >> "%LOG_FILE%"
        ) else (
            echo [ERROR] Cannot create config file
            echo [ERROR] Cannot create config file >> "%LOG_FILE%"
        )
    ) else (
        echo [WARNING] Example config file not found
        echo [WARNING] Example config file not found >> "%LOG_FILE%"
    )
) else (
    echo [OK] Config file exists
    echo [OK] Config file exists >> "%LOG_FILE%"
)

:: 2. Fix Streamlit directory
echo.
echo [2/5] Fixing Streamlit config...
echo [2/5] Fixing Streamlit config... >> "%LOG_FILE%"

set STREAMLIT_DIR=%USERPROFILE%\.streamlit
if not exist "%STREAMLIT_DIR%" (
    mkdir "%STREAMLIT_DIR%" 2>nul
    if %errorlevel% equ 0 (
        echo [OK] Streamlit directory created
        echo [OK] Streamlit directory created >> "%LOG_FILE%"
    ) else (
        echo [ERROR] Cannot create Streamlit directory
        echo [ERROR] Cannot create Streamlit directory >> "%LOG_FILE%"
    )
) else (
    echo [OK] Streamlit directory exists
    echo [OK] Streamlit directory exists >> "%LOG_FILE%"
)

:: Create credentials file
set CREDENTIAL_FILE=%STREAMLIT_DIR%\credentials.toml
if not exist "%CREDENTIAL_FILE%" (
    (
        echo [general]
        echo email = ""
    ) > "%CREDENTIAL_FILE%" 2>nul
    if %errorlevel% equ 0 (
        echo [OK] Streamlit credentials file created
        echo [OK] Streamlit credentials file created >> "%LOG_FILE%"
    )
)

:: 3. Check Python modules
echo.
echo [3/5] Checking Python modules...
echo [3/5] Checking Python modules... >> "%LOG_FILE%"

if exist "%SCRIPT_DIR%lib\python\python.exe" (
    "%SCRIPT_DIR%lib\python\python.exe" -c "import streamlit" >nul 2>&1
    if %errorlevel% neq 0 (
        echo Installing Streamlit...
        echo Installing Streamlit... >> "%LOG_FILE%"
        "%SCRIPT_DIR%lib\python\python.exe" -m pip install streamlit --quiet 2>>"%LOG_FILE%"
        if %errorlevel% equ 0 (
            echo [OK] Streamlit installed successfully
            echo [OK] Streamlit installed successfully >> "%LOG_FILE%"
        ) else (
            echo [ERROR] Streamlit installation failed
            echo [ERROR] Streamlit installation failed >> "%LOG_FILE%"
        )
    ) else (
        echo [OK] Streamlit module available
        echo [OK] Streamlit module available >> "%LOG_FILE%"
    )
) else (
    echo [ERROR] Python interpreter not found
    echo [ERROR] Python interpreter not found >> "%LOG_FILE%"
)

:: 4. Clean temporary files
echo.
echo [4/5] Cleaning temporary files...
echo [4/5] Cleaning temporary files... >> "%LOG_FILE%"

if exist "%SCRIPT_DIR%NarratoAI\__pycache__" (
    rmdir /s /q "%SCRIPT_DIR%NarratoAI\__pycache__" 2>nul
    echo [OK] Cleaned Python cache
    echo [OK] Cleaned Python cache >> "%LOG_FILE%"
)

for %%f in ("%SCRIPT_DIR%*.tmp" "%SCRIPT_DIR%*.temp") do (
    if exist "%%f" (
        del "%%f" 2>nul
        echo [OK] Deleted temp file: %%~nxf
        echo [OK] Deleted temp file: %%~nxf >> "%LOG_FILE%"
    )
)

:: 5. Check port usage
echo.
echo [5/5] Checking port usage...
echo [5/5] Checking port usage... >> "%LOG_FILE%"

netstat -an 2>nul | findstr ":8501" >nul
if %errorlevel% equ 0 (
    echo [WARNING] Port 8501 is in use
    echo [WARNING] Port 8501 is in use >> "%LOG_FILE%"
) else (
    echo [OK] Port 8501 is available
    echo [OK] Port 8501 is available >> "%LOG_FILE%"
)

echo.
echo ==============================================
echo Fix completed!
echo ==============================================
echo.

echo Fix completed! >> "%LOG_FILE%"
echo Fix report saved to: %LOG_FILE%
echo.
echo Press any key to exit...
pause >nul
