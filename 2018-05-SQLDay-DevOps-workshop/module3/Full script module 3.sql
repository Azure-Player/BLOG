CREATE PROCEDURE [dbo].[GetCityDataFromDW]
AS
BEGIN
	SELECT * FROM [$(WideWorldImportersDW)].dim.City
END



--prerequisites

CREATE PROCEDURE [dbo].[GetSuppliers_OLTP]
AS
BEGIN
	SELECT * FROM [$(WideWorldImporters)].Purchasing.Suppliers
END


--dbtests
CREATE SCHEMA [testing]


CREATE TABLE [testing].[tExecutionResult]
(
	[Date] [datetime] NOT NULL DEFAULT (getdate()),
	[TestCaseName] [nvarchar](255) NOT NULL,
	[Result] [nvarchar](10) NOT NULL,
	[ExpectedResult] [nvarchar](max) NULL,
	[ActualResult] [nvarchar](max) NULL,
	[CreateBy] [nvarchar](255) NOT NULL DEFAULT (suser_sname())
)


CREATE TABLE [testing].[tStorageTemporaryVariable]
(
	[TestCaseName] [nvarchar](255) NOT NULL,
	[CreateBy] [nvarchar](255) NOT NULL DEFAULT (suser_sname()),
	[VariableName] [nvarchar](50) NULL,
	[Value] [nvarchar](max) NULL
)



CREATE PROCEDURE [testing].[pSetTempVariable]
(
	@TestCaseName nvarchar(255),
	@VariableName nvarchar(50)
	,@Value nvarchar(max)
)
AS
BEGIN

IF EXISTS ( SELECT * FROM testing.[tStorageTemporaryVariable] 
			WHERE [TestCaseName] = @TestCaseName AND [VariableName]  = @VariableName AND [CreateBy] = suser_sname()
		)
	BEGIN
		UPDATE testing.[tStorageTemporaryVariable]
			SET Value = @Value 		
		WHERE [TestCaseName] = @TestCaseName AND [VariableName]  = @VariableName AND [CreateBy] = suser_sname()
	END
	ELSE 
	BEGIN
		INSERT INTO testing.[tStorageTemporaryVariable] ([TestCaseName],[VariableName],[Value])
			VALUES (@TestCaseName, @VariableName, @Value )

	END


	RETURN 0
END



CREATE PROCEDURE [testing].[testing a Integration.GetLineageKey]
AS
BEGIN
 --Assemble: Fake the Lineage table to make sure it is empty 
  --and that constraints will not be a problem

  EXEC tSQLt.FakeTable 'Integration.Lineage';

  --Put 2 test records into the table
	INSERT INTO [Integration].[Lineage]
			   ([Lineage Key]
			   ,[Data Load Started]
			   ,[Table Name]
			   ,[Data Load Completed]
			   ,[Was Successful]
			   ,[Source System Cutoff Time])
     VALUES
           (1,GETDATE()-1,'City',GETDATE(),1,GETDATE()) 
		   ,(2,GETDATE()-1,'Customer',GETDATE(),1,GETDATE())


  --Act: Call the [GetLineageKey] procedure

	EXEC	[Integration].[GetLineageKey]
		@TableName = 'City',
		@NewCutoffTime = '2018-05-14 09:00:00'

	DECLARE @ct int = (SELECT COUNT(*) FROM Integration.Lineage)
  
  --Assert: Make sure the count is correct

  EXEC tSQLt.AssertEquals 3, @ct;
END

--install tsql do pre


--install test class 

EXEC tSQLt.NewTestClass 'testing';
GO

--pre

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
