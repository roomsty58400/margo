@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set PORT=8000

rem v2 : ferme un serveur Margo deja lance (fenetre "Margo - serveur local")
rem avant de verifier le port, pour que le port 8000 se libere et soit
rem systematiquement reutilise d'un lancement a l'autre. Auparavant, une
rem fenetre serveur oubliee en arriere-plan (minimisee) faisait sauter au
rem port libre suivant (8001, 8002...) a chaque nouveau lancement, ce qui
rem cassait la restriction "referent HTTP" de la cle API Google Maps (qui
rem n'autorisait qu'un seul port fixe).
taskkill /FI "WINDOWTITLE eq Margo - serveur local*" /F >nul 2>nul
timeout /t 1 /nobreak >nul

:CHECK_PORT
rem v3 : seul un serveur en ECOUTE (LISTENING) occupe vraiment le port.
rem Auparavant, les simples traces de connexions recentes (TIME_WAIT, qui
rem restent ~2 min apres avoir utilise l'appli dans le navigateur) faisaient
rem croire le port 8000 occupe : le script passait alors sur 8001, ou la cle
rem Google (restreinte au port 8000) ne fonctionne pas -> ni carte ni lieux.
netstat -ano | findstr /R /C:":%PORT% .*LISTENING" >nul
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
