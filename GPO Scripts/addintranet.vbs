On Error Resume Next

Const HKEY_CURRENT_USER = &H80000001

strComputer = "."

'Connect to the Standard Registry Provider
Set objReg=GetObject("winmgmts:\\" & strComputer & "\root\default:StdRegProv")

'Specify registry path
strKeyPath = "Software\Microsoft\Windows\CurrentVersion\Internet Settings\" _
    & "ZoneMap\Domains\l-3com.com"

'Create registry key for l-3com.com
objReg.CreateKey HKEY_CURRENT_USER, strKeyPath


'create and configure a single registry value
strValueName = "*"
'1= Intranet Sites zone 2= Trusted Sites 3=Internet Sites
dwValue = 2

'use the SetDWORDValue method to create our new registry value
objReg.SetDWORDValue HKEY_CURRENT_USER, strKeyPath, strValueName, dwValue


'Specify registry (sub)path
strKeyPath = "Software\Microsoft\Windows\CurrentVersion\Internet Settings\" _
    & "ZoneMap\Domains\l-3com.com\*.c2s2"

'Create registry key for *.c2s2
objReg.CreateKey HKEY_CURRENT_USER, strKeyPath

'create and configure a single registry value
strValueName = "*"
'1= Intranet Sites zone 2= Trusted Sites 3=Internet Sites
dwValue = 1

'use the SetDWORDValue method to create our new registry value
objReg.SetDWORDValue HKEY_CURRENT_USER, strKeyPath, strValueName, dwValue