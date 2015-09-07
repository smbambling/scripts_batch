REM Check To Verify That RootKit for KB is not installed

REM Modify Date Variable
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set date=%%a-%%b-%%c)

REM Check To See If Script Has Run and Client Has Already Passed Check
if exist %SYSTEMROOT%\MPSysChk-PASSED.log goto end

REM mpsyschk.exe network path
SET mpsyschkpath=\\FS1\C2S2DP\Utilities\

REM Log Location Variable
SET LogLocation=\\FS1\C2S2DP\Utilities\Log

REM PASS: Status is good
REM FAIL: Potentially infected with RootKit

REM Run Tool to Check for RootKit
%mpsyschkpath%\mpsyschk.exe > nul

REM Check ErrorLevel
IF %ErrorLevel% EQU 0 GOTO PASS
IF %ErrorLevel% EQU -1 GOTO FAIL
GOTO ERROR

:PASS
REM Write Output to Logs
Echo %Computername%:	%date% %time%	MPSysChk Status: PASSED >> %SYSTEMROOT%\MPSysChk-PASSED.log
Echo %Computername%,%date%,%time%,Status: PASSED >> %LogLocation%\mpsyschk-%DATE%.csv
goto END

:FAIL
REM Write Output to Logs
Echo %Computername%:	%date% %time%	MPSysChk Status: FAILED >> %SYSTEMROOT%\MPSysChk-FAILED.log
Echo %Computername%,%date%,%time%,Status: FAILED >> %LogLocation%\mpsyschk-%DATE%.csv
goto END

:ERROR
REM Write Output to Logs
Echo %Computername%:	%date% %time%	MPSysChk Status: ERROR - Could Not Run >> %SYSTEMROOT%\MPSysChk-ERROR.log
Echo %Computername%,%date%,%time%,Status: ERROR - Could Not Run >> %LogLocation%\mpsyschk-%DATE%.csv

:END
EXIT