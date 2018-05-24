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
-- maintain settings
PRINT N'Executing Maintain_DB_settings.sql...';
GO
:r .\Maintain_DB_settings.sql
GO

PRINT 'Executing DropCDC.sql...';
GO
:r .\DropCDC.sql
GO

