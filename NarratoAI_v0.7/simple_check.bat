@echo off
setlocal

echo ===============================================
echo    NarratoAI System Check
echo ===============================================
echo.

set SCRIPT_DIR=%~dp0
set LOG_FILE=%SCRIPT_DIR%check_report.txt
set ERROR_COUNT=0

echo System Check Report > "%LOG_FILE%"
echo Check Time: %date% %time% >> "%LOG_FILE%"
echo ============================================== >> "%LOG_FILE%"

echo Checking system environment...
echo.

:: 1. Check directories
echo [1/6] Checking directories...
echo [1/6] Checking directories... >> "%LOG_FILE%"

if exist "%SCRIPT_DIR%NarratoAI" (
    echo [OK] NarratoAI directory exists
    echo [OK] NarratoAI directory exists >> "%LOG_FILE%"
) else (
    echo [ERROR] NarratoAI directory missing
    echo [ERROR] NarratoAI directory missing >> "%LOG_FILE%"
    set /a ERROR_COUNT+=1
)

if exist "%SCRIPT_DIR%lib" (
    echo [OK] lib directory exists
    echo [OK] lib directory exists >> "%LOG_FILE%"
) else (
    echo [ERROR] lib directory missing
    echo [ERROR] lib directory missing >> "%LOG_FILE%"
    set /a ERROR_COUNT+=1
)

:: 2. Check Python
echo.
echo [2/6] Checking Python...
echo [2/6] Checking Python... >> "%LOG_FILE%"

if exist "%SCRIPT_DIR%lib\python\python.exe" (
    echo [OK] Python interpreter exists
    echo [OK] Python interpreter exists >> "%LOG_FILE%"
    
    "%SCRIPT_DIR%lib\python\python.exe" --version >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Python can run
        echo [OK] Python can run >> "%LOG_FILE%"
    ) else (
        echo [ERROR] Python cannot run
        echo [ERROR] Python cannot run >> "%LOG_FILE%"
        set /a ERROR_COUNT+=1
    )
) else (
    echo [ERROR] Python interpreter missing
    echo [ERROR] Python interpreter missing >> "%LOG_FILE%"
    set /a ERROR_COUNT+=1
)

:: 3. Check FFmpeg
echo.
echo [3/6] Checking FFmpeg...
echo [3/6] Checking FFmpeg... >> "%LOG_FILE%"

if exist "%SCRIPT_DIR%lib\ffmpeg\ffmpeg-7.0-essentials_build\ffmpeg.exe" (
    echo [OK] FFmpeg exists
    echo [OK] FFmpeg exists >> "%LOG_FILE%"
) else (
    echo [ERROR] FFmpeg missing
    echo [ERROR] FFmpeg missing >> "%LOG_FILE%"
    set /a ERROR_COUNT+=1
)

:: 4. Check ImageMagick
echo.
echo [4/6] Checking ImageMagick...
echo [4/6] Checking ImageMagick... >> "%LOG_FILE%"

if exist "%SCRIPT_DIR%lib\imagemagic\ImageMagick-7.1.1-29-portable-Q16-x64\magick.exe" (
    echo [OK] ImageMagick exists
    echo [OK] ImageMagick exists >> "%LOG_FILE%"
) else (
    echo [ERROR] ImageMagick missing
    echo [ERROR] ImageMagick missing >> "%LOG_FILE%"
    set /a ERROR_COUNT+=1
)

:: 5. Check main program
echo.
echo [5/6] Checking main program...
echo [5/6] Checking main program... >> "%LOG_FILE%"

if exist "%SCRIPT_DIR%NarratoAI\webui.py" (
    echo [OK] webui.py exists
    echo [OK] webui.py exists >> "%LOG_FILE%"
) else (
    echo [ERROR] webui.py missing
    echo [ERROR] webui.py missing >> "%LOG_FILE%"
    set /a ERROR_COUNT+=1
)

:: 6. Check permissions
echo.
echo [6/6] Checking permissions...
echo [6/6] Checking permissions... >> "%LOG_FILE%"

echo test > "%SCRIPT_DIR%temp_test.txt" 2>nul
if exist "%SCRIPT_DIR%temp_test.txt" (
    echo [OK] Write permission available
    echo [OK] Write permission available >> "%LOG_FILE%"
    del "%SCRIPT_DIR%temp_test.txt" 2>nul
) else (
    echo [ERROR] No write permission
    echo [ERROR] No write permission >> "%LOG_FILE%"
    set /a ERROR_COUNT+=1
)

:: Show results
echo.
echo ==============================================
echo Check completed!
echo ==============================================
echo.

echo Check completed! >> "%LOG_FILE%"
echo Error count: %ERROR_COUNT% >> "%LOG_FILE%"

if %ERROR_COUNT% equ 0 (
    echo [OK] No errors found, system should work normally
    echo [OK] No errors found, system should work normally >> "%LOG_FILE%"
    echo.
    echo If you still have problems:
    echo 1. Run as administrator
    echo 2. Check antivirus settings
    echo 3. Ensure network connection
) else (
    echo [ERROR] Found %ERROR_COUNT% errors
    echo [ERROR] Found %ERROR_COUNT% errors >> "%LOG_FILE%"
    echo.
    echo Please fix the above errors and try again
    echo Recommend running simple_fix.bat to auto-fix
)

echo.
echo Detailed report saved to: %LOG_FILE%
echo.
echo Press any key to exit...
pause >nul
