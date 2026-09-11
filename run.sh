#!/bin/bash
cd "$(dirname "$0")"

echo "Starting Backend Server with python3 -m fastapi dev..."
cd Backend
python3 -m fastapi dev main.py &
BACKEND_PID=$!

echo "Starting Flutter App..."
cd ../Frontend
flutter run

kill $BACKEND_PID