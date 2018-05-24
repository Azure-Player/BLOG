USE [master]
RESTORE DATABASE [WideWorldImportersDW] FROM  DISK = N'D:\SQLDay 2018 Local Repo\WideWorldImportersDW-Full.bak' WITH  FILE = 1,  MOVE N'WWI_Primary' TO N'D:\SQL16\WideWorldImportersDW.mdf',  MOVE N'WWI_UserData' TO N'D:\SQL16\WideWorldImportersDW_UserData.ndf',  MOVE N'WWI_Log' TO N'D:\SQL16\WideWorldImportersDW.ldf',  MOVE N'WWIDW_InMemory_Data_1' TO N'D:\SQL16\WideWorldImportersDW_InMemory_Data_1',  NOUNLOAD,  STATS = 5

GO

USE [master]
RESTORE DATABASE [WideWorldImporters] FROM  DISK = N'D:\SQLDay 2018 Local Repo\WideWorldImporters-Standard.bak' WITH  FILE = 1,  MOVE N'WWI_Primary' TO N'D:\SQL16\WideWorldImporters.mdf',  MOVE N'WWI_UserData' TO N'D:\SQL16\WideWorldImporters_UserData.ndf',  MOVE N'WWI_Log' TO N'D:\SQL16\WideWorldImporters.ldf',  NOUNLOAD,  STATS = 5

GO



