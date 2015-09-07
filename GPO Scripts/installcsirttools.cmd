@ECHO OFF
REM
REM installcsirttools.cmd - Used to install the CSIRT tools onto a machine
REM

REM
REM Version History
REM
REM    1.5.0 - 12/14/2009 - modified to use DNS alias rather than server name
REM    1.1.0 - 10/23/2009 - updated to remove old CSIRT package and install new
REM    1.0.1 - 08/11/2009 - toolset updated to version 1.0.1, added logging
REM    1.0.0 - 07/31/2009 - initial release
REM

REM
REM Set the source folder for the install files
REM 
SET srcpath=\\prod-etn-spy01.prod.c2s2.l-3com.com\CSIRT-tools

REM
REM if old CSIRT tool folder exists, delete it.
REM
IF EXIST "%ProgramFiles%\CSIRT" ECHO. Deleting old CSIRT tool in "%ProgramFiles%\CSIRT"
IF EXIST "%ProgramFiles%\CSIRT" DEL "%ProgramFiles%\CSIRT" /S/F/Q >NUL
IF EXIST "%ProgramFiles%\CSIRT" RMDIR "%ProgramFiles%\CSIRT" /S/Q >NUL

REM
REM Check for current version file, if exists exit... nothing to do
REM
IF EXIST "C:\CSIRT\version-1.5.0.txt" GOTO END

REM
REM Check if CSIRT folder doesn't exists, if so skip to installing the files
REM
IF NOT EXIST "C:\CSIRT" GOTO SKIP

REM
REM If folder exists and wrong version then empty and delete the CSIRT folder on target
REM
IF EXIST "C:\CSIRT" ECHO. Deleting existing files in "C:\CSIRT"
IF EXIST "C:\CSIRT" DEL "C:\CSIRT" /S/F/Q >NUL
IF EXIST "C:\CSIRT" RMDIR "C:\CSIRT" /S/Q >NUL

:SKIP
REM
REM Create the CSIRT folder
REM
@ECHO. Creating folder "C:\CSIRT"
MKDIR "C:\CSIRT"

REM
REM Copy tools to the target
REM
ECHO. Copying collection script to "C:\CSIRT"
XCOPY "%srcpath%\remotepayload\*" "C:\CSIRT" /E >NUL

REM
REM set permissions on collection folder
REM
ECHO. Setting permissions on folder "C:\CSIRT"
"%srcpath%\localtools\xcacls.exe" "C:\CSIRT" /E /P "Authenticated Users":R /Y >NUL

REM
REM update log file
REM
ECHO.%DATE:~10,4%/%DATE:~4,2%/%DATE:~7,2%	%TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%	%COMPUTERNAME%	1.5.0	%USERDOMAIN%	%USERNAME% >> %WINDIR%\Temp\%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%-temp.log
type %WINDIR%\Temp\%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%-temp.log >> %srcpath%\logs\%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%.log
DEL %WINDIR%\Temp\%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%-temp.log

ECHO. Install complete

:END


