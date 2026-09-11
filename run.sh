#!/bin/bash
cd "$(dirname "$0")"

# Locate and enter backend folder safely
if [ -d "Backend" ]; then
    cd Backend
elif [ -d "backend" ]; then
    cd backend
else
    echo "Error: Backend folder not found!"
    exit 1
fi

echo "Starting Backend Server..."
if [ -d ".venv" ]; then
    source .venv/bin/activate
elif [ -d "venv" ]; then
    source venv/bin/activate
fi

python3 -m fastapi dev main.py &
BACKEND_PID=$!

# Return to root and locate frontend folder safely
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

echo "Starting Flutter App..."
flutter run

kill $BACKEND_PID
