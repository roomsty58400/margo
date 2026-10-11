@echo off
rem Lance Margo (margo.html) sur le serveur local du port 8000 (le seul ou la
rem cle Google de apiki.env fonctionne). Toute la logique (serveur Python,
rem reutilisation du serveur deja lance, port occupe) est dans lancer-app.bat.
call "%~dp0lancer-app.bat" margo.html
