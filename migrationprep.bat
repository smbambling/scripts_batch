set /P _migration=Would you run migation prep (Diable Firewall & Add Migration Groups [Y, (N)]
:run_migrationprep
If "%_migration%"=="" goto :sub_error
If /i "%_migration%"=="Y" goto enable_migration
If /i "%_migration%"=="N" goto:eof
:enable_migration
#disable windows firewall
netsh firewall set opmode disable
#add PROD migration accounts
net localgroup administrators /add CONTOSO\acct_migrators
net localgroup administrators /add "CONTOSO\Domain Admins"
