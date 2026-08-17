@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ============================================
echo   Publication de Margo sur GitHub
echo   Depot : https://github.com/roomsty58400/margo.git
echo ============================================
echo.

REM --- Verifie que Git est installe ---
where git >nul 2>nul
if not %errorlevel%==0 (
    echo [ERREUR] Git n'est pas installe ou n'est pas dans le PATH.
    echo Telecharge-le ici : https://git-scm.com/download/win
    echo puis relance ce script.
    pause
    exit /b 1
)

set REPO_URL=https://github.com/roomsty58400/margo.git

REM --- Initialise le depot local si besoin, et pointe vers le bon remote ---
if not exist ".git" (
    echo Initialisation du depot Git local...
    git init
    git remote add origin %REPO_URL%
) else (
    git remote get-url origin >nul 2>nul
    if %errorlevel%==0 (
        git remote set-url origin %REPO_URL%
    ) else (
        git remote add origin %REPO_URL%
    )
)

REM --- Identite Git (necessaire pour committer) : demandee une seule fois ---
git config user.name >nul 2>nul
if not %errorlevel%==0 (
    set /p GIT_NAME=Ton nom pour les commits Git :
    git config user.name "!GIT_NAME!"
)
git config user.email >nul 2>nul
if not %errorlevel%==0 (
    set /p GIT_EMAIL=Ton email pour les commits Git :
    git config user.email "!GIT_EMAIL!"
)

REM --- Fichiers a NE JAMAIS publier (cle API, sauvegardes locales...) ---
REM Regenere a chaque lancement pour rester a jour.
(
    echo # Genere automatiquement par publier-github.bat - ne pas publier ces fichiers
    echo apiki.env
    echo *.env
    echo archives/
    echo Thumbs.db
    echo .DS_Store
    echo _to_delete/
    echo desktop.ini
) > .gitignore

git add -A

REM --- Rien a publier ? ---
git diff --cached --quiet
if %errorlevel%==0 (
    echo.
    echo Rien a publier : aucun fichier modifie depuis le dernier envoi.
    pause
    exit /b 0
)

echo.
echo Fichiers qui vont etre publies :
git diff --cached --name-status
echo.

set /p COMMIT_MSG=Message de commit (Entree = message par defaut) :
if "%COMMIT_MSG%"=="" set COMMIT_MSG=Mise a jour Margo

git commit -m "%COMMIT_MSG%"
if not %errorlevel%==0 (
    echo.
    echo [ERREUR] Le commit a echoue : rien ne sera envoye sur GitHub.
    pause
    exit /b 1
)
echo.
echo [OK] Commit cree : "%COMMIT_MSG%"

git branch -M main

echo.
echo Recuperation des eventuels changements distants (si le depot n'est pas vide)...
git pull origin main --rebase --allow-unrelated-histories

echo.
echo Envoi vers GitHub...
git push -u origin main

if %errorlevel%==0 (
    echo.
    echo [OK] Publie avec succes sur %REPO_URL%
) else (
    echo.
    echo [ERREUR] L'envoi a echoue.
    echo - Verifie ta connexion internet.
    echo - Git peut ouvrir une fenetre de connexion GitHub : connecte-toi si demande.
    echo - Si le depot distant a diverge, resous le conflit puis relance ce script.
)
echo.
pause
