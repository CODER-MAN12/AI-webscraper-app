::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSzk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFA9cTRCRAE+1EbsQ5+n//Nami30SQ+ctfYvs37adI/IS+kD2V5cu3V9UnPctJStXaRe5awsDrGxRtXaEJ8KOkQ7iQW2H4ncRMlV7kGbCiS8MZdF7mdECwyWs3kz8lIAe1UTTX7wAFmvk0/0mPdEFnQ==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
cd /d "%~dp0"

echo Starting Frontend App...
start "" "%~dp0Frontend\build\windows\x64\runner\Release\frontend.exe"

echo Starting Backend...
cd /d "%~dp0Backend"

:: Dynamically update pyvenv.cfg with the current absolute path
echo home = %~dp0Backend\python-embed > .venv\pyvenv.cfg
echo implementation = CPython >> .venv\pyvenv.cfg
echo version_info = 3.13.14 >> .venv\pyvenv.cfg
echo include-system-site-packages = false >> .venv\pyvenv.cfg

.venv\Scripts\python.exe -m fastapi dev main.py