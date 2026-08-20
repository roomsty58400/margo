@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set PORT=8000

:CHECK_PORT
netstat -ano | findstr ":%PORT% " >nul
if %errorlevel%==0 (
    set /a PORT+=1
    if !PORT! GTR 8020 (
        echo.
        echo [ERREUR] Aucun port libre trouve entre 8000 et 8020.
        echo Fermez une application qui utilise deja ces ports, ou modifiez PORT dans ce fichier.
        echo.
        pause
        exit /b 1
    )
    goto CHECK_PORT
)

where python >nul 2>nul
if %errorlevel% neq 0 (
    where python3 >nul 2>nul
    if !errorlevel! neq 0 (
        echo.
        echo [ERREUR] Python n'est pas installe ou n'est pas dans le PATH.
        echo Installez Python depuis https://www.python.org/downloads/ puis reessayez
        echo ^(cochez "Add Python to PATH" pendant l'installation^).
        echo.
        pause
        exit /b 1
    )
    set PYTHON_CMD=python3
) else (
    set PYTHON_CMD=python
)

echo Demarrage du serveur local sur le port %PORT%...
start "Margo - serveur local (ne pas fermer, fermez cette fenetre pour arreter le serveur)" /min %PYTHON_CMD% -m http.server %PORT%

timeout /t 1 /nobreak >nul

start "" "http://localhost:%PORT%/margo.html"

echo.
echo Margo est lance : http://localhost:%PORT%/margo.html
echo Une fenetre "serveur local" reste ouverte en arriere-plan (reduite) : fermez-la pour arreter le serveur.
echo.
