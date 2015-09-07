@echo off

set key=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\ /v Type
FOR /F "tokens=3" %%G IN ('REG QUERY %key%') DO set key_value=%%G
IF [%key_value%]==[0x1] (%windir%\system32\REG.EXE ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters /v DisabledComponents /t REG_DWORD /d 0xff /f) ELSE ( ECHO "IPv6 Not Installed")