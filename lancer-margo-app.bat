@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

rem v4 : page a ouvrir passee en argument (margo.html par defaut) :
rem lancer-margo.bat et lancer-bourgo.bat appellent ce script avec leur page.
set "PAGE=%~1"
if "%PAGE%"=="" set "PAGE=margo.html"
if not exist "%PAGE%" (
    echo.
    echo [ERREUR] Fichier introuvable dans ce dossier : %PAGE%
    echo.
    pause
    exit /b 1
)

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

rem v4 : le port 8000 est-il deja occupe ?
rem  - s'il sert deja CE dossier (ex. lance par lancer-margo.bat puis
rem    lancer-bourgo.bat), on le reutilise et on ouvre simplement la page ;
rem  - s'il sert un AUTRE projet (autre dossier lance avec
rem    "python -m http.server 8000"), Margo/Bourgou y renvoyaient une erreur
rem    404, et un repli sur 8001 casse la cle Google : on propose donc
rem    d'arreter cet autre serveur.
netstat -ano | findstr /R /C:":8000 .*LISTENING" >nul
if %errorlevel%==0 (
    set "HTTP_CODE="
    for /f %%c in ('curl -s -o nul -w "%%{http_code}" "http://localhost:8000/%PAGE%" 2^>nul') do set "HTTP_CODE=%%c"
    if "!HTTP_CODE!"=="200" (
        echo Serveur local deja actif sur le port 8000 pour ce dossier : ouverture de %PAGE%.
        start "" "http://localhost:8000/%PAGE%"
        exit /b 0
    )
    set "OTHER_PID="
    for /f "tokens=5" %%p in ('netstat -ano ^| findstr /R /C:":8000 .*LISTENING"') do set "OTHER_PID=%%p"
    echo.
    echo [ATTENTION] Le port 8000 est utilise par un autre programme ^(PID !OTHER_PID!^),
    echo qui ne sert pas ce dossier. La cle Google ne fonctionne que sur le port 8000.
    set /p STOP_OTHER="Arreter ce programme pour liberer le port 8000 ? (O/N) "
    if /i "!STOP_OTHER!"=="O" (
        taskkill /PID !OTHER_PID! /F >nul 2>nul
        timeout /t 1 /nobreak >nul
    ) else (
        echo Lancement sur un autre port : la carte et les lieux Google ne fonctionneront pas.
    )
)

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

start "" "http://localhost:%PORT%/%PAGE%"

echo.
echo Page lancee : http://localhost:%PORT%/%PAGE%
echo Une fenetre "serveur local" reste ouverte en arriere-plan (reduite) : fermez-la pour arreter le serveur.
echo.
