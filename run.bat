@echo off
cd /d "%~dp0"

echo Starting Frontend App...
cd Frontend\build\windows\x64\runner\Release
start "" frontend.exe

echo Starting Backend...
cd /d "%~dp0Backend"

:: Dynamically update pyvenv.cfg with the current absolute path of your bundled python folder
echo home = %~dp0Backend\python-embed > .venv\pyvenv.cfg
echo implementation = CPython >> .venv\pyvenv.cfg
echo version_info = 3.13.14 >> .venv\pyvenv.cfg
echo include-system-site-packages = false >> .venv\pyvenv.cfg

.venv\Scripts\python.exe -m fastapi dev main.py