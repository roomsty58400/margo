@echo off
cd /d "%~dp0"

where python >nul 2>nul
if %errorlevel%==0 (
    start "Serveur local - Itineraire (laisse cette fenetre ouverte)" cmd /k "python -m http.server 8000"
    goto :ouvrir
)

where py >nul 2>nul
if %errorlevel%==0 (
    start "Serveur local - Itineraire (laisse cette fenetre ouverte)" cmd /k "py -m http.server 8000"
    goto :ouvrir
)

echo Python est introuvable (ni "python" ni "py" ne fonctionnent).
echo Ouvre le menu Demarrer, cherche "IDLE" ou "Python", et note son emplacement,
echo ou reinstalle Python en cochant "Add python.exe to PATH".
pause
exit /b 1

:ouvrir
timeout /t 2 /nobreak >nul
start "" "http://localhost:8000/margo.html"
