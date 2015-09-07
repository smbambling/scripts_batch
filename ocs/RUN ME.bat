REM Checking if OCS Agent is installed

if exist "%programfiles%\OCS Inventory Agent\OCSInventory.exe" goto installpsftp

REM Installing OCS Agent

ocspackage-ext.exe

:installpsftp

REM Checking to see if psftp is in OCS directory

if exist "%programfiles%\OCS Inventory Agent\psftp.exe" goto installsshkey

cmd /c xcopy psftp.exe "%programfiles%\OCS Inventory Agent\"

:installsshkey

REM Checking to see if .ppk key is in OCS directory

if exist "%programfiles%\OCS Inventory Agent\ocsoffsite-06182008.ppk" goto installocsbat

cmd /c xcopy ocsoffsite-06182008.ppk "%programfiles%\OCS Inventory Agent\"

:installocsbat

REM Checking to see if ocs-daily-remote.bat is in OCS directory

if exist "%programfiles%\OCS Inventory Agent\ocs-daily-remote.bat" goto installdailytask

cmd /c xcopy ocs-daily-remote.bat "%programfiles%\OCS Inventory Agent\"

:installdailytask

REM Checking to see if Tasked is created

if exist "%systemroot%\Tasks\OCS Agent Local Remote.job" goto runtask

if exist "%systemroot%\Tasks\OCS Inventory Agent.job" del "%systemroot%\Tasks\OCS Inventory Agent.job"

if exist "%systemroot%\Tasks\OCS Agent.job" del "%systemroot%\Tasks\OCS Agent.job"

SCHTASKS /create /TN "OCS Agent Local Remote" /TR "\"C:\Program Files\OCS Inventory Agent\ocs-daily-remote.bat\"" /SC DAILY /ST 11:00:00 /RU "system"

:runtask

REM Run OCS Scheduled Task

schtasks /Run /TN "OCS Agent Local Remote"

RD /S /Q "OCS Script Installer"

