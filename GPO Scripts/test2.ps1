$addmembers = New-Object system.collections.arraylist

$groupname="dum-it"
$groupname2="eobu-dum-im-it"

#Active Directory path for the group that you will be editing
$groupou="ou=Groups,ou=DUM,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com"

$diff1=Get-QADGroupMember prod\$groupname -Indirect   
$diff2=Get-QADGroupMember prod\$groupname2 -Indirect

Foreach ($member in $diff1)
{
If ($diff2 -contains $member.Name)
	{echo "User $member Already In Group"}
Else
	{$addgroup.add("$member")}
}