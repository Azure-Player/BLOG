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
EXEC sp_configure 'show advanced options',1
go
RECONFIGURE
GO
EXEC  sp_configure  'clr strict security',0
GO
RECONFIGURE
GO
EXEC  sp_configure  'external scripts enabled',1
GO
RECONFIGURE
GO
EXEC sp_configure 'show advanced options',0
go
RECONFIGURE
GO
EXEC  sp_configure  'clr enabled',1
GO
RECONFIGURE
GO
