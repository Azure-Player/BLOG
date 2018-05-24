@ECHO OFF
::  commented entries may be useful for other types of deployments
SET SQLINSTANCE=localhost\SQL2017EXPRESS
SET WideWorldImporters_DB=WideWorldImporters
SET WideWorldImportersDW_DB=WideWorldImportersDW
SET DACPACS_PATH=..\dacpacks

:: *************************************************************************************
:: * Below this point there are no configurable variables. Change anything here
:: * only if there are problems with script (doesn't work, works improperly etc.)
:: *************************************************************************************

SET COMMONPARAMS=/tsn:%SQLINSTANCE% ^
    /p:BlockOnPossibleDataLoss=true /p:BlockWhenDriftDetected=false /p:AllowDropBlockingAssemblies=true ^
    /p:IncludeTransactionalScripts=true /p:DoNotAlterChangeDataCaptureObjects=false ^
	/p:RegisterDataTierApplication=true


CALL get_date.cmd
SET SQLPACKAGE=DAC\130\sqlpackage.exe

SET STARTDATE=%TIME: =0%
SET STARTDATE=%STARTDATE::=-%
SET STARTDATE=%STARTDATE:~0,8%
SET STARTDATE=%FDATE%_%STARTDATE%
SET PUBLISHLOGFILE=WWI_%STARTDATE%__Deploy.log
SET SCRIPTFILEPREFIX=WWI_%STARTDATE%
SET VisualStudioVersion=15.0
SET ERROR=



CALL :LogMessage WWI deployment script %0.
CALL :LogMessage Current date and time: %DATE% %TIME%
CALL :LogMessageToLogFile Computer name: %COMPUTERNAME%, user name: %USERDOMAIN%\%USERNAME%
CALL :LogMessageToLogFile
CALL :LogMessageToLogFile SQLINSTANCE=%SQLINSTANCE%
CALL :LogMessage

::  Check if required tools are available

::  Check if SQLCMD is available
WHERE /Q SqlCmd.exe
IF %ERRORLEVEL% NEQ 0 (
	SET ERROR=SQLCMD.exe was not found.
	GOTO ReportErrorAndExit
)

::  Check if SqlPackage is available
IF NOT EXIST "%SQLPACKAGE%" (
	SET ERROR=SqlPackage.exe was not found.
	GOTO ReportErrorAndExit
)

::  Check if SQL Server was specified
IF "x%SQLINSTANCE%" == "x" (
	SET ERROR=SQL Server instance name was not specified.
	GOTO ReportErrorAndExit
)

::  Check if SQL Server is available
CALL :LogMessage Connecting to SQL Server %SQLINSTANCE%...
SQLCMD -S %SQLINSTANCE% -d master -Q "SELECT 1" >NUL 2>NUL
IF %ERRORLEVEL% EQU 0 GOTO SQLServerOK
SET ERROR=Cannot connect to SQL Server %SQLINSTANCE%.
GOTO ReportErrorAndExit

:SQLServerOK


::  Check that all required dacpacs are available

DIR "%DACPACS_PATH%\WideWorldImporters.dacpac" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 GOTO ReportMissingDacpac
DIR "%DACPACS_PATH%\WideWorldImportersDW.dacpac" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 GOTO ReportMissingDacpac
DIR "%DACPACS_PATH%\WideWorldImportersDW.DBTests.dacpac" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 GOTO ReportMissingDacpac
DIR "%DACPACS_PATH%\WideWorldImportersDW.Prerequisites.dacpac" >NUL 2>NUL
IF %ERRORLEVEL% NEQ 0 GOTO ReportMissingDacpac

GOTO AllDacpacFilesExist

:ReportMissingDacpac
SET ERROR=At least one dacpac file is missing. Check the %DACPACS_PATH% directory.
GOTO ReportErrorAndExit

:AllDacpacFilesExist
CALL :LogMessage %SCRIPTFILEPREFIX%_WideWorldImportersDW.sql
CALL :LogMessage Generating script for WideWorldImportersDW project...
"%SQLPACKAGE%" /a:Script /sf:"%DACPACS_PATH%\WideWorldImportersDW.dacpac" %COMMONPARAMS% ^
	/tdn:%WideWorldImportersDW_DB% /op:%SCRIPTFILEPREFIX%_WideWorldImportersDW.sql ^
	>>"%PUBLISHLOGFILE%" 2>>&1
	
IF %ERRORLEVEL% NEQ 0 GOTO ReportErrorAndExit

CALL :LogMessage Publishing WideWorldImportersDW project...
"%SQLPACKAGE%" /a:Publish /sf:"%DACPACS_PATH%\WideWorldImportersDW.dacpac" %COMMONPARAMS% ^
	/tdn:%WideWorldImportersDW_DB% ^
	>>"%PUBLISHLOGFILE%" 2>>&1


CALL :LogMessage Generating script for WideWorldImporters project...
"%SQLPACKAGE%" /a:Script /sf:"%DACPACS_PATH%\WideWorldImporters.dacpac" %COMMONPARAMS% ^
	/tdn:%WideWorldImporters_DB% /op:%SCRIPTFILEPREFIX%.sql ^
	/v:WideWorldImportersDW=%WideWorldImportersDW_DB% ^
	>>"%PUBLISHLOGFILE%" 2>>&1

IF %ERRORLEVEL% NEQ 0 GOTO ReportErrorAndExit

CALL :LogMessage Publishing WideWorldImporters project...
"%SQLPACKAGE%" /a:Publish /sf:"%DACPACS_PATH%\WideWorldImporters.dacpac" %COMMONPARAMS% ^
	/tdn:%WideWorldImporters_DB% ^
	/v:WideWorldImportersDW=%WideWorldImportersDW_DB% ^
	>>"%PUBLISHLOGFILE%" 2>>&1



CALL :LogMessage Generating script for WideWorldImportersDW.Prerequisites project...
"%SQLPACKAGE%" /a:Script /sf:"%DACPACS_PATH%\WideWorldImportersDW.Prerequisites.dacpac" %COMMONPARAMS% ^
	/tdn:%WideWorldImportersDW_DB% /op:%SCRIPTFILEPREFIX%.sql ^
	/v:WideWorldImportersDW=%WideWorldImportersDW_DB% ^
	/v:WideWorldImporters=%WideWorldImporters_DB% ^
	>>"%PUBLISHLOGFILE%" 2>>&1

IF %ERRORLEVEL% NEQ 0 GOTO ReportErrorAndExit

CALL :LogMessage Publishing WideWorldImporters project...
"%SQLPACKAGE%" /a:Publish /sf:"%DACPACS_PATH%\WideWorldImporters.dacpac" %COMMONPARAMS% ^
	/tdn:%WideWorldImportersDW_DB% ^
	/v:WideWorldImportersDW=%WideWorldImportersDW_DB% ^
	/v:WideWorldImporters=%WideWorldImporters_DB% ^
	>>"%PUBLISHLOGFILE%" 2>>&1

CALL :LogMessage %SCRIPTFILEPREFIX%_WideWorldImportersDW.DBTests.sql
CALL :LogMessage Generating script for WideWorldImportersDW.DBTests project...
"%SQLPACKAGE%" /a:Script /sf:"%DACPACS_PATH%\WideWorldImportersDW.DBTests.dacpac" %COMMONPARAMS% ^
	/tdn:%WideWorldImportersDW_DB% /op:%SCRIPTFILEPREFIX%_WideWorldImportersDW.DBTests.sql ^
	>>"%PUBLISHLOGFILE%" 2>>&1
	
IF %ERRORLEVEL% NEQ 0 GOTO ReportErrorAndExit

CALL :LogMessage Publishing WideWorldImportersDW.DBTests project...
"%SQLPACKAGE%" /a:Publish /sf:"%DACPACS_PATH%\WideWorldImportersDW.DBTests.dacpac" %COMMONPARAMS% ^
	/tdn:%WideWorldImportersDW_DB% ^
	>>"%PUBLISHLOGFILE%" 2>>&1


IF %ERRORLEVEL% NEQ 0 GOTO ReportErrorAndExit

CALL :LogMessage
CALL :LogMessage All projects have been deployed successfully.
CALL :LogMessage Check the log file %PUBLISHLOGFILE% for more details.
CALL :LogMessageToLogFile
CALL :LogMessageToLogFile Current date and time: %DATE% %TIME%
CALL :LogMessageToLogFile End of log.

GOTO:EOF

:::::::::  Subroutines

:: LogMessage arg arg ...
:: Write message to screen and log file
:LogMessage
IF "x%*" == "x" GOTO LogEmptyLine
ECHO %*
ECHO %* >>"%PUBLISHLOGFILE%"
GOTO:EOF
:LogEmptyLine
ECHO.
ECHO. >>"%PUBLISHLOGFILE%"
GOTO:EOF

:: LogMessageToLogFile arg arg ...
:: Write message to log file only
:LogMessageToLogFile
IF "x%*" == "x" GOTO LogEmptyLineToLogFile
ECHO %* >>"%PUBLISHLOGFILE%"
GOTO:EOF
:LogEmptyLineToLogFile
ECHO. >>"%PUBLISHLOGFILE%"
GOTO:EOF

:::::::::: GOTO targets (not subroutines)

:: optionally set ERROR to message that will be logged
:ReportErrorAndExit
IF NOT "x%ERROR%" == "x" CALL :LogMessage & CALL :LogMessage %ERROR%
CALL :LogMessage
CALL :LogMessage Deployment aborted due to errors.
CALL :LogMessage Check the log file %PUBLISHLOGFILE% for more details.
CALL :LogMessage Check the script %0 for possible problems.
CALL :LogMessageToLogFile
CALL :LogMessageToLogFile Current date and time: %DATE% %TIME%
CALL :LogMessageToLogFile End of log.
EXIT /B 1
