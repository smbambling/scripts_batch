::generate .ocs file with computer inventory data


:: SET ALL VARIABLES ::

set test=0
::OCS Server IP Address
set host=192.168.40.41

::SFTP Server IP Address
set host2=209.9.4.59

::SFTP Server Port
set port=53322

::SFTP User Name
set username=ocs

::SFTP User Password
set keyfile=ocsoffsite-06182008.ppk


:: If you can't ping %host% then set test to 1
PING -n 3 -w 1000 %host% |find "TTL=" || set test=1

:: Change to OCS Inventory Directory
cd "%PROGRAMFILES%\OCS Inventory Agent"

:: Delete OLD .ocs file if exist to save room
IF EXIST "%PROGRAMFILES%\OCS Inventory Agent\*.ocs" del *.ocs

:: Delete OLD .xml file if exist to save room
IF EXIST "%PROGRAMFILES%\OCS Inventory Agent\*.xml" del *.xml

:: If can't ping %host% run ocs agent in local mode, other wise run it to connect to server
IF %test% == 1 (
	start "" "%PROGRAMFILES%\OCS Inventory Agent\OCSInventory.exe" /local /xml
) ELSE (
	"%PROGRAMFILES%\OCS Inventory Agent\OCSInventory.exe"
	GOTO END
)

::wait 14 seconds for .ocs file to be generated
ping 127.0.0.1 -n 15 > nul

:: If you can't ping %host2% then set test to 2
PING -n 3 -w 1000 %host2% |find "TTL=" && set test=2

::check to make sure
IF %test% == 2 (IF exist *.ocs set test=3)


::FTP .ocs file
IF %test% == 3 (
	echo cd ocs-offsite>sftpcmd.bat
	echo cd ocs>>sftpcmd.bat
	echo mput *.ocs>>sftpcmd.bat
	echo cd ..>>sftpcmd.bat
	echo cd xml>>sftpcmd.bat
	echo mput *.xml>>sftpcmd.bat
	echo quit>>sftpcmd.bat
	echo Windows Registry Editor Version 5.00>key.reg
	echo [HKEY_CURRENT_USER\Software\SimonTatham]>>key.reg
	echo [HKEY_CURRENT_USER\Software\SimonTatham\PuTTY]>>key.reg
	echo [HKEY_CURRENT_USER\Software\SimonTatham\PuTTY\SshHostKeys]>>key.reg
	echo "rsa2@53322:209.9.4.59"="0x23,0xbbd9d58c74fe1214d6e5a283e525c0147ae244cfc6f4e4942882b6a12bf30cce19fa8d3052c87511fc89d9697d114e70459db682df607712a22641a7dadc735486cca5ff1f16f20ad333fadaefc58585da75accc49751ea1396b8f5cdd4d81bc7823711ecebe5ace1f78c2868b7096e279929c5b663e1b23e833eba06f8dd77453bb2f29c5dadc5a95f3ed5ef2fff8bcae0252e61a95e96d9ad1037408bb7ddd5dc156e25838046d2c16023304628db365932a3d69e4f89c0cd05b00bc20fca674ef8846b1cfc91f1c33c0c43a0d22588ef4448f22141db3f3e31b7aa7ae60fffa72bad7feda4cdfa39a65e97644932b86bca850ebec6d81581f28e95d4f0361">>key.reg
	regedit /s key.reg
	psftp.exe -P %port% %username%@%host2% -i %keyfile% -b sftpcmd.bat -batch		
	del sftpcmd.bat
	del key.reg
)

