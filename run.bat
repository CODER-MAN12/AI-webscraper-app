@echo off
cd /d "%~dp0"

:: Locate and enter Backend folder
if exist Backend (
    cd Backend
) else if exist backend (
    cd backend
) else (
    echo Error: Backend folder not found!
    pause
    exit /b 1
)

echo Setting up Backend...
if exist .venv (
    call .venv\Scripts\activate.bat
) else if exist venv (
    call venv\Scripts\activate.bat
)

if exist requirements.txt (
    pip install -r requirements.txt
)

echo Starting Backend Server with fastapi dev...
start cmd /k "python -m fastapi dev main.py"

:: Return to root and enter Frontend folder
cd ..
if exist Frontend (
    cd Frontend
) else if exist frontend (
    cd frontend
) else (
    echo Error: Frontend folder not found!
    pause
    exit /b 1
)

echo Installing Flutter dependencies...
flutter pub get

echo Starting Flutter App...
flutter run

pause
