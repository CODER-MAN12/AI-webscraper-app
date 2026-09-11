@echo off
cd /d "%~dp0"

echo Starting Backend Server...
cd Backend
start cmd /k "python -m fastapi dev main.py"

echo Starting Flutter App...
cd ../Frontend
flutter run

pause