@echo off 
call .venv\Scripts\activate.bat 
python -m fastapi dev main.py 
