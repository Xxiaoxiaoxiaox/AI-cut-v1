@echo off
setlocal

:main_menu
cls
echo.
echo ===============================================
echo    NarratoAI Simple Menu
echo ===============================================
echo.
echo Please select an option:
echo.
echo [1] Start NarratoAI
echo [2] Check System
echo [3] Fix Issues
echo [4] Update NarratoAI
echo [5] View Help
echo [6] Exit
echo.
set /p choice=Enter option (1-6):

if "%choice%"=="1" goto start_app
if "%choice%"=="2" goto check_system
if "%choice%"=="3" goto fix_issues
if "%choice%"=="4" goto update_app
if "%choice%"=="5" goto show_help
if "%choice%"=="6" goto exit_menu
echo Invalid option, please try again
timeout /t 2 >nul
goto main_menu

:start_app
cls
echo ===============================================
echo    Start NarratoAI
echo ===============================================
echo.
if exist "%~dp0simple_start.bat" (
    call "%~dp0simple_start.bat"
) else (
    echo [ERROR] Cannot find simple_start.bat
    pause
)
goto main_menu

:check_system
cls
echo ===============================================
echo    System Check
echo ===============================================
echo.
if exist "%~dp0simple_check.bat" (
    call "%~dp0simple_check.bat"
) else (
    echo [ERROR] Cannot find simple_check.bat
    pause
)
goto main_menu

:fix_issues
cls
echo ===============================================
echo    Fix Issues
echo ===============================================
echo.
if exist "%~dp0simple_fix.bat" (
    call "%~dp0simple_fix.bat"
) else (
    echo [ERROR] Cannot find simple_fix.bat
    pause
)
goto main_menu

:update_app
cls
echo ===============================================
echo    Update NarratoAI
echo ===============================================
echo.
if exist "%~dp0update.bat" (
    call "%~dp0update.bat"
) else (
    echo [ERROR] Cannot find update.bat
    pause
)
goto main_menu

:show_help
cls
echo ===============================================
echo    Help Information
echo ===============================================
echo.
echo Script descriptions:
echo.
echo 1. Start NarratoAI
echo    - Use safe startup script
echo    - Auto check dependencies
echo    - Detailed error logging
echo.
echo 2. System Check
echo    - Check all dependencies
echo    - Generate check report
echo    - Identify potential issues
echo.
echo 3. Fix Issues
echo    - Auto fix common problems
echo    - Clean cache files
echo    - Install missing modules
echo.
echo 4. Update NarratoAI
echo    - Update code from repository
echo    - Update pip and dependencies
echo    - Handle network proxy issues
echo.
echo Common problems:
echo.
echo Q: Script flashes and closes?
echo A: Run "System Check" first, then "Fix Issues"
echo.
echo Q: Permission denied?
echo A: Right-click and "Run as administrator"
echo.
echo Q: Port occupied?
echo A: Run "Fix Issues" to handle automatically
echo.
echo Q: Missing modules?
echo A: Run "Fix Issues" to install automatically
echo.
echo Technical support:
echo - Check generated log files
echo - Ensure antivirus doesn't block execution
echo - Install Visual C++ Redistributable
echo.
echo Press any key to return to main menu...
pause >nul
goto main_menu

:exit_menu
echo.
echo Thank you for using NarratoAI!
echo.
timeout /t 2 >nul
exit /b 0
