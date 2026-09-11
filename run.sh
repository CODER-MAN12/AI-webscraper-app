#!/bin/bash
cd "$(dirname "$0")"

# Automatically add Flutter to PATH if installed in the home directory
if [ -d "$HOME/flutter/bin" ]; then
    export PATH="$PATH:$HOME/flutter/bin"
fi

# Verify flutter command exists
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter is not installed or not in your PATH."
    echo "Download Flutter from https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Locate and enter backend folder
if [ -d "Backend" ]; then
    cd Backend
elif [ -d "backend" ]; then
    cd backend
else
    echo "Error: Backend folder not found!"
    exit 1
fi

echo "Setting up Backend..."
if [ -d ".venv" ]; then
    source .venv/bin/activate
elif [ -d "venv" ]; then
    source venv/bin/activate
fi

if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi

python3 -m fastapi dev main.py &
BACKEND_PID=$!

# Return to root and enter frontend folder
cd ..
if [ -d "Frontend" ]; then
    cd Frontend
elif [ -d "frontend" ]; then
    cd frontend
else
    echo "Error: Frontend folder not found!"
    kill $BACKEND_PID
    exit 1
fi

echo "Installing Flutter dependencies..."
flutter pub get

echo "Starting Flutter App..."
flutter run

kill $BACKEND_PID
