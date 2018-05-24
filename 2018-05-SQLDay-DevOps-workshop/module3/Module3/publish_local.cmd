@ECHO OFF

rem  This script builds and publishes the solution to local instance
rem  of SQL Server, according to publish profiles in local.publish.xml
rem  in each project.

rem  Set path to MSBuild.exe
SET PATH=%PATH%;%WINDIR%\Microsoft.NET\Framework\v4.0.30319
SET VisualStudioVersion=15.0

set start=%time%
SET STARTDATE=%TIME: =0%
SET STARTDATE=%DATE%_%STARTDATE::=-%

ECHO.
ECHO Building the solution...
ECHO.

MSBuild.exe /t:Build Module3.sln /p:Module3=Debug /p:Platform="Any CPU"  ^
	/v:detailed /fl /flp:LogFile=CDS_%STARTDATE%_Build.log;Verbosity=Normal;Encoding=UTF-8
IF %ERRORLEVEL% NEQ 0 GOTO WaitForKey

ECHO.
ECHO Publishing the solution...
ECHO.

rem  Publish all projects in solution.
MSBuild.exe /t:Publish Module3.sln /p:Configuration=Debug /p:Platform="Any CPU"  ^
	/p:SqlPublishProfilePath=local.publish.xml  ^
    /fl /flp:LogFile=CDS_%STARTDATE%_Publish.log;Verbosity=Normal;Encoding=UTF-8


set end=%time%
set options="tokens=1-4 delims=:,."
for /f %options% %%a in ("%start%") do set start_h=%%a&set /a start_m=100%%b %% 100&set /a start_s=100%%c %% 100&set /a start_ms=100%%d %% 100
for /f %options% %%a in ("%end%") do set end_h=%%a&set /a end_m=100%%b %% 100&set /a end_s=100%%c %% 100&set /a end_ms=100%%d %% 100

set /a hours=%end_h%-%start_h%
set /a mins=%end_m%-%start_m%
set /a secs=%end_s%-%start_s%
set /a ms=%end_ms%-%start_ms%
if %hours% lss 0 set /a hours = 24%hours%
if %mins% lss 0 set /a hours = %hours% - 1 & set /a mins = 60%mins%
if %secs% lss 0 set /a mins = %mins% - 1 & set /a secs = 60%secs%
if %ms% lss 0 set /a secs = %secs% - 1 & set /a ms = 100%ms%
if 1%ms% lss 100 set ms=0%ms%


set /a totalsecs = %hours%*3600 + %mins%*60 + %secs% 
echo Build and Publish took %hours%:%mins%:%secs%.%ms% (%totalsecs%.%ms%s total)

:WaitForKey
PAUSE
