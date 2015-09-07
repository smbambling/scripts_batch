@echo off
SET /P var_username=Please Enter User Name: 
SET /P var_password=Please Enter Password: 
SET /P var_distributionpoint= Please Enter Distribution Point: 
psexec.exe -u %var_username% -p %var_password% @hosts.txt "%var_distributionpoint%\webrootinstall.bat"