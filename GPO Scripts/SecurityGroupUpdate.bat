@echo off

REM Variable for IM group name
	SET groupname="eobu-dum-im-aclcl"

REM Variable for Group OU Location - OU where the IM group you are editing 
	SET groupou="ou=Groups,ou=DUM,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com"

REM Variable for Security Group Location - Group you want to query to add users from
	SET orggroup="CN=dum-aclcl,ou=groups,ou=dum,ou=eobu,ou=org,dc=prod,dc=c2s2,dc=l-3com,dc=com"

REM Check to see if Group supplied in groupname variable exist
	FOR /f "tokens=*" %%A in ( '"dsquery group dc=prod,dc=c2s2,dc=l-3com,dc=com -name %groupname%"' ) do set GroupTest=%%A 
	FOR /F "tokens=1 delims=," %%G IN (%GroupTest%) DO set GroupTest=%%G
	if ("%GroupTest%")==("") (goto :end)

REM Remove All Members From Group (Needs to be done before Seaching OU and re-adding members)
dsget group "CN="%groupname%,%groupou%"" -members | dsmod group "CN="%groupname%,%groupou%"" -rmmbr 

:add
REM Scan Share Group and Add Members to IM Group
dsget group "%orggroup%" -members | dsmod group "CN=%groupname%,%groupou%" -addmbr

REM Remove DUM IT
echo CN=dum-it,%groupou% | dsmod group "CN="%groupname%,%groupou%"" -rmmbr

:end