@ECHO OFF

IF EXIST %WINDIR%\depcheck.txt goto end

wmic OS Get DataExecutionPrevention_SupportPolicy >> %WINDIR%\TEMP\dep.txt

setlocal enabledelayedexpansion
set i=1
for /f "tokens=*" %%a in ('type %WINDIR%\TEMP\dep.txt') do (
  set Line!i!=%%a
  set /a i+=1
)

If %Line2% == 3 (echo "Set To OPTOUT" >> %WINDIR%\depcheck.txt) ELSE (

bcdedit.exe /set {current} nx OptOut

)

del %WINDIR%\TEMP\dep.txt

:end