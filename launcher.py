import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

# Base project paths
ROOT_DIR = Path(__file__).resolve().parent
BACKEND_DIR = ROOT_DIR / "Backend"
FRONTEND_DIR = ROOT_DIR / "Frontend"

MAIN_PY = BACKEND_DIR / "app" / "main.py"
DART_FILE = FRONTEND_DIR / "lib" / "main.dart"

def check_uv_installed() -> str:
    """Checks if 'uv' package manager is installed on system PATH."""
    uv_path = shutil.which("uv")
    if not uv_path:
        print("❌ Error: 'uv' package manager is not installed on system PATH.")
        print("Please install uv (e.g., pip install uv) and try again.")
        sys.exit(1)
    return uv_path

def sync_dependencies(uv_path: str):
    """Syncs Python dependencies using uv inside the Backend folder."""
    print("⚡ Syncing Python dependencies via 'uv'...")
    try:
        subprocess.run([uv_path, "sync"], cwd=BACKEND_DIR, check=True)
        print("✅ Backend virtual environment and dependencies are ready.\n")
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to sync dependencies: {e}")
        sys.exit(1)

def run_fastapi(uv_path: str):
    """Starts the FastAPI server via 'uv run fastapi dev app/main.py' inside Backend."""
    print("🚀 Starting FastAPI backend server...")
    cmd = [uv_path, "run", "fastapi", "dev", str(MAIN_PY)]
    process = subprocess.Popen(cmd, cwd=BACKEND_DIR)
    return process

def run_flutter_ui():
    """Runs the Flutter/Dart application inside Frontend."""
    # Flutter projects require 'flutter run' to handle lib/main.dart properly
    flutter_cmd = shutil.which("flutter") or shutil.which("dart")
    
    if not flutter_cmd:
        print("❌ Error: Neither 'flutter' nor 'dart' SDK was found on system PATH.")
        sys.exit(1)

    print("🎨 Launching Frontend UI (Frontend/lib/main.dart)...")
    
    # Use 'flutter run -d windows' if on Windows, or standard run
    if "flutter" in flutter_cmd:
        cmd = [flutter_cmd, "run", "-t", str(DART_FILE)]
    else:
        cmd = [flutter_cmd, "run", str(DART_FILE)]

    process = subprocess.Popen(cmd, cwd=FRONTEND_DIR)
    return process

def main():
    # 1. Sync dependencies in Backend/
    uv_path = check_uv_installed()
    sync_dependencies(uv_path)

    fastapi_proc = None
    ui_proc = None

    try:
        # 2. Boot up FastAPI Server in background
        fastapi_proc = run_fastapi(uv_path)
        time.sleep(2)  # Give server 2 seconds to bind port

        # 3. Boot up Flutter/Dart UI
        ui_proc = run_flutter_ui()

        # Wait until user closes the UI app
        ui_proc.wait()

    except KeyboardInterrupt:
        print("\n🛑 Shutting down processes...")

    finally:
        # Cleanup background processes when app closes
        if ui_proc and ui_proc.poll() is None:
            ui_proc.terminate()
        if fastapi_proc and fastapi_proc.poll() is None:
            fastapi_proc.terminate()

        print("👋 Application shut down successfully.")

if __name__ == "__main__":
    main()