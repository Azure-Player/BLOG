--https://docs.microsoft.com/en-us/azure/sql-data-warehouse/load-data-wideworldimportersdw

/*
Connection String:
sqlplayer-dwh.database.windows.net,1433

*/

USE master
GO
CREATE LOGIN LoaderRC60 WITH PASSWORD = 'a123STRONGpassword!';
CREATE USER LoaderRC60 FOR LOGIN LoaderRC60;
GO

USE SampleDW
GO
CREATE USER LoaderRC60 FOR LOGIN LoaderRC60;
GRANT CONTROL ON DATABASE::SampleDW to LoaderRC60;
EXEC sp_addrolemember 'staticrc60', 'LoaderRC60';


GO

