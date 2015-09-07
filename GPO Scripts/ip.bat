@echo off
IPCONFIG |FIND "IP" > %TEMP%.\TEMP.DAT
FOR /F "tokens=2 delims=:" %%a in (%TEMP%.\TEMP.DAT) do set IP=%%a
del %TEMP%.\TEMP.DAT
set IP=%IP:~1%

FOR /F "tokens=3 delims=." %%a IN ("%IP%") DO (SET OCT3=%%a)

echo %OCT3%

