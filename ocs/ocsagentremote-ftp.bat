::generate .ocs file with computer inventory data

set test=0
::OCS Server IP Address
set host=192.168.40.99

::FTP Server IP Address
set host2=63.220.29.152

:: If you can't ping %host% then set test to 1
PING -n 3 -w 1000 %host% |find "TTL=" || set test=1

:: Change to OCS Inventory Directory
cd "%PROGRAMFILES%\OCS Inventory Agent"

:: Delete OLD .ocs file if exist to save room
IF EXIST "%PROGRAMFILES%\OCS Inventory Agent\*.ocs" del *.ocs

:: If can't ping %host% run ocs agent in local mode, other wise run it to connect to server
IF %test% == 1 (
	start "" "%PROGRAMFILES%\OCS Inventory Agent\OCSInventory.exe" /local
) ELSE (
	"%PROGRAMFILES%\OCS Inventory Agent\OCSInventory.exe"
)

::wait 10 seconds for .ocs file to be generated
ping 127.0.0.1 -n 11 > nul

:: If you can't ping %host2% then set test to 2
PING -n 3 -w 1000 %host2% |find "TTL=" && set test=2

::check to make sure
IF %test% == 2 (IF exist *.ocs set test=3)

::Open port 21 in Windows Firewall
netsh firewall add allowedprogram C:\WINDOWS\system32\ftp.exe FTP ENABLE

::FTP .ocs file
IF %test% == 3 (
	echo user ocsuser>ftpcmd.dat
	echo qwerty>>ftpcmd.dat
	echo bin>>ftpcmd.dat
	echo put *.ocs>>ftpcmd.dat
	echo quit>>ftpcmd.dat
	ftp -n -s:ftpcmd.dat servers.mkisystems.com
	del ftpcmd.dat
)

:: Close port 21 in Windows Firewall
netsh firewall delete allowedprogram C:\WINDOWS\system32\ftp.exe
