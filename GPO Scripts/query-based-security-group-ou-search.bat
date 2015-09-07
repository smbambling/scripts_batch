@echo off

REM Variable for group name
SET groupname="dum-set"

REM Variable for Group OU Location - OU where the group you are editing 
SET groupou="ou=Groups,ou=DUM,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com"

REM Variable for User OU Location - OU you want to search users to add to the security group
SET adduserou="ou=Remote,ou=Users,ou=DUM,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com"

for /f "tokens=*" %%A in ( '"dsquery group dc=prod,dc=c2s2,dc=l-3com,dc=com -name %groupname%"' ) do set GroupTest=%%A 

FOR /F "tokens=1 delims=," %%G IN (%GroupTest%) DO set GroupTest=%%G

if ("%GroupTest%")==("") (goto :end)

REM Remove All Members From Group (Needs to be done before Seaching OU and re-adding members) you might get an error if group is already empty
dsget group "CN="%groupname%","%groupou%"" -members | dsmod group "cn="%groupname%","%groupou%"" -rmmbr 

REM Scan OU and Add Members to Group
dsquery user "%adduserou%" | dsmod group "cn=%groupname%,%groupou%" -addmbr
