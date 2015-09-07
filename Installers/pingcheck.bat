if exist pingresults.txt del pingresults.txt 
for /f %%a in (hosts.txt) DO @ping -n 1 -w 100 %%a > pingresults.txt
:for /f "tokens=7" %%G IN (pingresults.txt) Do @echo %%G > failed.txt
:del pingresults.txt