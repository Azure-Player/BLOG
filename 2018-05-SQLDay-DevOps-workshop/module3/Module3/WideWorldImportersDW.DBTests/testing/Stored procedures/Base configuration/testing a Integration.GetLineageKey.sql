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