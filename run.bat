@echo off
cd /d "%~dp0"

echo Starting Backend Server...
cd Backend
if exist .venv (
    call .venv\Scripts\activate.bat
) else if exist venv (
    call venv\Scripts\activate.bat
)
start cmd /k "python -m fastapi dev main.py"

REM Wait 4 seconds for the server to spin up
timeout /t 4 /nobreak > nul

echo Starting Frontend App...
cd /d "%~dp0Frontend\build\windows\x64\runner\Release"
if exist frontend.exe (
    start frontend.exe
) else (
    echo Error: frontend.exe not found in Frontend build directory!
    pause
)