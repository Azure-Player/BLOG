--Create a master key for the SampleDW database. You only need to create a master key once per database.
CREATE MASTER KEY;
GO


-- Create a database scoped credential with Azure storage account key as the secret.
CREATE DATABASE SCOPED CREDENTIAL KnAzureStorageCredential 
WITH IDENTITY = 'sqlday', 
SECRET = '****************==';
GO

-- Create an external data source with CREDENTIAL option.
--https://blogs.msdn.microsoft.com/cindygross/2015/02/04/understanding-wasb-and-hadoop-storage-in-azure/
--https://docs.microsoft.com/en-us/sql/t-sql/statements/create-external-data-source-transact-sql?view=sql-server-2017
--Blob: wasb://YOURDefaultContainer@YOURStorageAccount.blob.core.windows.net/SomeDirectory/ASubDirectory/AFile.txt
CREATE EXTERNAL DATA SOURCE KnBlobStorage
WITH
(
    TYPE = Hadoop,
--    LOCATION = 'wasbs://wideworldimporters@sqldwholdata.blob.core.windows.net'
    LOCATION = 'wasb://dwh@sqlday.blob.core.windows.net' ,
	CREDENTIAL = KnAzureStorageCredential
);
--DROP EXTERNAL DATA SOURCE KnBlobStorage
GO



CREATE SCHEMA KNext;
GO
CREATE SCHEMA KNdwh;
GO
