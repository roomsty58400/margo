@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ===================================================
echo   Publication des changements Margo vers GitHub
echo ===================================================
echo.

where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERREUR] Git n'est pas installe ou n'est pas dans le PATH.
    echo Installez Git depuis https://git-scm.com/download/win puis reessayez.
    echo.
    pause
    exit /b 1
)

git rev-parse --is-inside-work-tree >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERREUR] Ce dossier n'est pas un depot git ^(ou git n'y voit rien^).
    echo.
    pause
    exit /b 1
)

echo Etat actuel du depot :
echo.
git status
echo.

set /p CONFIRM="Ajouter et committer les changements ci-dessus si besoin, puis publier sur GitHub ? (O/N) "
if /i not "%CONFIRM%"=="O" (
    echo.
    echo Annule, rien n'a ete publie.
    echo.
    pause
    exit /b 0
)

git diff --quiet --exit-code
set HAS_UNSTAGED=%errorlevel%
git diff --cached --quiet --exit-code
set HAS_STAGED=%errorlevel%
set HAS_UNTRACKED=0
for /f %%i in ('git ls-files --others --exclude-standard') do set HAS_UNTRACKED=1

if not "%HAS_UNSTAGED%%HAS_STAGED%%HAS_UNTRACKED%"=="000" (
    set /p MESSAGE="Message du commit (laisser vide pour un message automatique) : "
    if "!MESSAGE!"=="" set "MESSAGE=Mise a jour Margo"
    git add -A
    git commit -m "!MESSAGE!"
    if !errorlevel! neq 0 (
        echo.
        echo [ERREUR] Le commit a echoue - voir le message ci-dessus.
        echo.
        pause
        exit /b 1
    )
    echo.
) else (
    echo Rien a committer ^(deja a jour localement^) - passage direct au push.
    echo.
)

echo Envoi vers GitHub ^(git push^)...
git push

if %errorlevel% neq 0 (
    echo.
    echo [ERREUR] Le push a echoue - verifiez votre connexion internet et vos identifiants GitHub
    echo ^(un identifiant/mot de passe Git peut etre redemande, ou un jeton d'acces si l'authentification
    echo par mot de passe est desactivee sur GitHub^).
    echo.
    pause
    exit /b 1
)

echo.
echo Publication terminee avec succes.
echo Le site sera a jour sous 1 a 2 minutes sur https://roomsty58400.github.io/margo/
echo.
pause
