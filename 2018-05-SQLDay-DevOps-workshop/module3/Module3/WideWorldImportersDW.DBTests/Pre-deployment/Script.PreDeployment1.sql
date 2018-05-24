/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

PRINT 'tSQLt requires CLR to be enabled'
GO
EXEC sp_configure 'clr enabled', 1;
GO
RECONFIGURE;
GO

PRINT 'Install TSQLT'
GO
:r ./InstalTSQLT.sql


PRINT 'Create new testing classes '
GO
:r ./CreateTestClasses.sql
