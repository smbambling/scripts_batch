@echo off
if exist "%PROGRAMFILES%\Webroot\Client\spysweeper.exe" goto check
if not exist "%PROGRAMFILES%\Webroot\Client\spysweeper.exe" goto install
:check
if exist "%PROGRAMFILES%\Webroot\Client\SpySweeperUI.exe" goto loaded
if not exist "%PROGRAMFILES%\Webroot\Client\SpySweeperUI.exe" goto install
:install
mkdir C:\tempinstall 
xcopy "\\prod-etn-spy01\webrootdistropoint\WebrootClientSetup.*" C:\tempinstall
msiexec /i C:\tempinstall\WebrootClientSetup.msi /quiet
RD /Q /S C:\tempinstall\
goto end
:loaded
echo Webroot Enterprise Clients are already Installed
:end