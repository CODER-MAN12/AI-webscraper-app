@echo off
cd /d "%~dp0"

<<<<<<< HEAD
echo Starting Backend Server...
cd Backend
=======
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
>>>>>>> 7ce7d28ee47cd5e4eac9f85db167b8ad817ee222
if exist .venv (
    call .venv\Scripts\activate.bat
) else if exist venv (
    call venv\Scripts\activate.bat
)
<<<<<<< HEAD
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
=======

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
>>>>>>> 7ce7d28ee47cd5e4eac9f85db167b8ad817ee222
