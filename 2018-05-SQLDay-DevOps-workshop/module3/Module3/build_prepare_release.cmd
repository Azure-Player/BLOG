@ECHO OFF

::  This script executes the final build before release and prepares
::  installation package in installation folder.
::  Please set correct version below.

SET INSTALLATIONFOLDER=..\Installation

::  Configuration may be one of Debug, Deploy, Release (same as in Visual Studio)
::  For release build it should always be Release
SET Configuration=Release

SET STARTDATE=%TIME: =0%
SET STARTDATE=%STARTDATE::=-%
SET STARTDATE=%STARTDATE:~0,8%
SET STARTDATE=%DATE%_%STARTDATE%
SET BUILDLOGFILE=WWI_%STARTDATE%_Build.log

SET PATH=%PATH%;%WINDIR%\Microsoft.NET\Framework\v4.0.30319

SET VisualStudioVersion=15.0

SET TF=%ProgramFiles(x86)%\Microsoft Visual Studio 14.0\Common7\IDE\TF.exe

:: Build the solution

MSBuild.exe Module3.sln /t:Build ^
    /fl /flp:LogFile="%BUILDLOGFILE%";Verbosity=Normal /v:q ^
    /p:Configuration=%Configuration% /p:Platform="Any CPU"

IF NOT ERRORLEVEL 0 GOTO ERROR

:: Copy binaries to installation folder

copy /y  .\DeploymentFiles\*  "%INSTALLATIONFOLDER%\dacpacks"
del  "%INSTALLATIONFOLDER%\dacpacks\*create*.sql"

PAUSE
GOTO :EOF

:ERROR
ECHO.
ECHO ERROR ENCOUNTERED. INSTALLATION PACKAGE HAS NOT BEEN PREPARED.
ECHO.
