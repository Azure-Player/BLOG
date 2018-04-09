USE [AdventureWorks2012]
GO

--Init
sp_configure 
GO
sp_configure 'Database Mail XPs', 1
GO
RECONFIGURE
GO

DROP PROCEDURE dbo.SendAlert
GO

CREATE PROCEDURE dbo.SendAlert
AS
	
	BEGIN TRY 
		PRINT '*** Preparing to send email number 1... ***'

		DECLARE @Title VARCHAR(100);
		SET @Title = 'TEST Alert 1 @ ' + CONVERT(VARCHAR(10), GETDATE(), 120);
		DECLARE @message VARCHAR(5000)

		EXEC msdb.dbo.sp_send_dbmail @profile_name = NULL,
			@recipients = 'recipient@sqlplayer.net', 
			@subject = @Title,
			@body = 'Some email body here...'
		
		--Step 2
		PRINT '*** Preparing to send email number 2... ***'
								
		SET @Title = 'TEST Alert 2 @ ' + CONVERT(VARCHAR(10), GETDATE(), 120);
		SELECT @message =  '
SELECT TOP 10 
		[BusinessEntityID], [PersonType], [Title], [FirstName], [LastName]
FROM [Person].[Person]
WHERE [EmailPromotion] = 2;
                            '
		EXEC msdb.dbo.sp_send_dbmail
			 @recipients = 'recipient@sqlplayer.net'  
			,@subject = @Title
			,@body_format = 'HTML' 
			,@body = 'You can find the details in the attachement.'
			,@attach_query_result_as_file = 1
			,@query = @message;


		--Solution #1
		PRINT '*** Solution #1: Preparing to send email number 3... ***'
								
		SET @Title = 'Solution #1 Alert 3 @ ' + CONVERT(VARCHAR(10), GETDATE(), 120);
		SELECT @message =  '
SELECT TOP 10 
		[BusinessEntityID], [PersonType], [Title], [FirstName], [LastName]
FROM [AdventureWorks2012].[Person].[Person]
WHERE [EmailPromotion] = 2;
                            '
		EXEC msdb.dbo.sp_send_dbmail
			 @recipients = 'recipient@sqlplayer.net'  
			,@subject = @Title
			,@body_format = 'HTML' 
			,@body = 'You can find the details in the attachement.'
			,@attach_query_result_as_file = 1
			,@query = @message;



		--Solution #2
		PRINT '*** Solution #2: Preparing to send email number 4... ***'
								
		SET @Title = 'Solution #2 Alert 4 @ ' + CONVERT(VARCHAR(10), GETDATE(), 120);
		SELECT @message =  '
SELECT TOP 10 
		[BusinessEntityID], [PersonType], [Title], [FirstName], [LastName]
FROM [Person].[Person]
WHERE [EmailPromotion] = 2;
                            '
		EXEC msdb.dbo.sp_send_dbmail
			 @execute_query_database = 'AdventureWorks2012'
			,@recipients = 'recipient@sqlplayer.net'  
			,@subject = @Title
			,@body_format = 'HTML' 
			,@body = 'You can find the details in the attachement.'
			,@attach_query_result_as_file = 1
			,@query = @message;

	END TRY

	BEGIN CATCH
		SELECT  
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage;  
		RETURN 1;
	END CATCH

	RETURN 0;

GO



--Execute

DECLARE @Result INT;
EXEC @Result = dbo.SendAlert;
PRINT @Result;
GO


/*
*** Preparing to send email number 1... ***
Mail (Id: 2) queued.
*** Preparing to send email number 2... ***
Msg 22050, Level 16, State 1, Line 58
Failed to initialize sqlcmd library with error number -2147467259.
0
*/
