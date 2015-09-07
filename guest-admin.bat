::Optional: Create guest Admin account for offsite users.

set user=Laptop
set password=Ghost*Pepper3
set group=administrators

@echo off
net user /add %user% %password%
net localgroup %group% %user% /add

 