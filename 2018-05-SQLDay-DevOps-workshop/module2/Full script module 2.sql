CREATE TABLE [dbo].[Users]
(
	[UserId] INT IDENTITY NOT NULL,
	[UserName] sysname NOT NULL,
	[Email] NVARCHAR(200) NOT NULL,
	CONSTRAINT pkUsers PRIMARY KEY (UserId)
)

GO


CREATE TABLE [dbo].[UsersAudit]
(
	[UsersAuditId] INT IDENTITY NOT NULL,
	[UserId] INT NOT NULL,
	[UserName] sysname NOT NULL,
	[Email] NVARCHAR(200) NOT NULL,
	[CreatedOn] DATETIME2(7) CONSTRAINT[dfUsersAudit_CreatedOn] DEFAULT (GETDATE()) NOT NULL,
	CONSTRAINT pkUsersAudit PRIMARY KEY (UsersAuditId)
)


CREATE PROCEDURE [dbo].[Users_Insert]
(	
	@UserName sysname,
	@Email NVARCHAR(100)
)AS
BEGIN
	INSERT INTO dbo.[Users] (UserName, Email)
	SELECT @UserName,@Email
END



using System; // contains types (String / Int64 / Guid), Exception, and ArgumentException
using System.Data; // contains the CommandType, ConnectionState, SqlDbType, and ParameterDirection enums
using System.Data.SqlClient; // contains SqlConnection, SqlCommand, SqlParameter, and SqlDataReader
using System.Data.SqlTypes; // contains the Sql* types for input / output params
using System.Text; // contains StringBuilder
using Microsoft.SqlServer.Server; // contains SqlFacet(Attribute), SqlContext, (System)DataAccessKind


namespace CLRLibrary
{
    public class StoredProc
    {
        [SqlProcedure(Name ="UserAudit")]
        public static void UserAudit
            (
             SqlInt32 UserId,
             SqlString UserName,
             SqlString Email            
            )
        {
            using(SqlConnection con = new SqlConnection("context connection = true"))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "INSERT INTO dbo.UsersAudit (UserId,UserName,Email) "+
                    " SELECT @UserId,@UserName, @Email";
                cmd.Parameters.AddWithValue("@UserId", UserId);
                cmd.Parameters.AddWithValue("@UserName", UserName);
                cmd.Parameters.AddWithValue("@Email", Email);
                cmd.ExecuteNonQuery();
            }
        }
    }
}



CREATE TRIGGER [dbo].[Trigger_Users]
    ON [dbo].[Users]
    FOR INSERT
    AS
    BEGIN
        SET NoCount ON
		
		DECLARE @userName sysname, @Email NVARCHAR(200), @UserId INT
		SELECT @UserId= Inserted.UserId,
				@userName= Inserted.UserName,
				@Email=Inserted.Email 
		FROM Inserted

		EXEC [dbo].[UserAudit] @UserId, @userName, @Email

    END
	
	
--post



--pre
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








--R
CREATE TABLE [dbo].[Iris]
(
	[Sepal.Length] decimal(10,2),
	[Sepal.Width] decimal(10,2),
	[Petal.Length] decimal(10,2),
	[Petal.Width] decimal(10,2),
	[Species] nvarchar(50)
)



CREATE PROCEDURE [dbo].[get_iris_dataset]
AS
BEGIN  
 EXEC   sp_execute_external_script  
       @language = N'R'  
     , @script = N'iris_data <- iris;'
     , @input_data_1 = N''  
     , @output_data_1_name = N'iris_data'
     WITH RESULT SETS (("Sepal.Length" float not null,   
           "Sepal.Width" float not null,  
        "Petal.Length" float not null,   
        "Petal.Width" float not null, "Species" varchar(100)));  
END;
GO


CREATE PROCEDURE [dbo].[generate_iris_model]
AS
BEGIN
 EXEC sp_execute_external_script  
      @language = N'R'  
     , @script = N'  
          library(e1071);  
          irismodel <-naiveBayes(iris[,1:4], iris[,5]);  
          trained_model <- data.frame(payload = as.raw(serialize(irismodel, connection=NULL)));  
'  
     , @input_data_1 = N'select "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species" from iris'  
     , @input_data_1_name = N'iris'  
     , @output_data_1_name = N'trained_model'  
    WITH RESULT SETS ((model varbinary(max)));  
END;
GO




CREATE PROCEDURE [dbo].[load_iris_ds]
AS
BEGIN


INSERT INTO dbo.iris
EXEC get_iris_dataset
END 


--job  -> do post deploy
USE [msdb]
GO

DECLARE @JobName sysname = N'LoadInitialIrisDS'
DECLARE @JobId UNIQUEIDENTIFIER = (
SELECT job_id FROM dbo.sysjobs
WHERE name = @JobName)


/****** Object:  Job [LoadInitialIrisDS]    Script Date: 11.05.2018 22:35:01 ******/
EXEC msdb.dbo.sp_delete_job @job_id=@JobId, @delete_unused_schedule=1
GO

/****** Object:  Job [LoadInitialIrisDS]    Script Date: 11.05.2018 22:35:01 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 11.05.2018 22:35:01 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'LoadInitialIrisDS', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'LGBSPL\dwidera', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [delete iris data]    Script Date: 11.05.2018 22:35:01 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'delete iris data', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'delete from dbo.Iris', 
		@database_name=N'Module2', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Load]    Script Date: 11.05.2018 22:35:01 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Load', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC  [dbo].[load_iris_ds] ', 
		@database_name=N'Module2', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily_3AM', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180511, 
		@active_end_date=99991231, 
		@active_start_time=30000, 
		@active_end_time=235959, 
		@schedule_uid=N'a9434f44-155a-44e1-8529-b598ddd43c19'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


--post deploy
PRINT 'Loading jobs'
GO
:r .\Jobs\LoadIrisData.sql


--security

CREATE SCHEMA [WebPortal] AUTHORIZATION dbo;


CREATE PROCEDURE [WebPortal].[ExecuteLoadingIrisDS]
AS
BEGIN

EXECUTE dbo.Load_Iris_DS
END


CREATE LOGIN [Portal] WITH PASSWORD = '@l@MAK0TTa'

CREATE USER [Portal]
	FOR LOGIN Portal
	WITH DEFAULT_SCHEMA = WebPortal;

GO

GRANT CONNECT TO [Portal]
GO
GRANT EXECUTE ON [WebPortal].[ExecuteLoadingIrisDS] TO Portal;




--AUDIT
CREATE SERVER AUDIT [LocalServerAudit]
/*	TO APPLICATION_LOG
	WITH ( QUEUE_DELAY = 1000, ON_FAILURE = SHUTDOWN )
*/
    TO FILE ( 
        FILEPATH = '$(AuditDirectory)',
        MAXSIZE = 10 MB, MAX_ROLLOVER_FILES = 1000, RESERVE_DISK_SPACE = OFF
    )
    WITH ( 
        QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE,

        -- audit object will have known GUID in order to work with HA solutions
        AUDIT_GUID = 'CD5D429D-20E6-4695-9C0C-8720691217E1'
    );

	
	
CREATE SERVER AUDIT SPECIFICATION [LocalServerAuditSpecification]
FOR SERVER AUDIT [LocalServerAudit]
ADD (APPLICATION_ROLE_CHANGE_PASSWORD_GROUP),
    ADD (AUDIT_CHANGE_GROUP),
    ADD (BACKUP_RESTORE_GROUP),
    ADD (DATABASE_CHANGE_GROUP),
    ADD (DATABASE_OBJECT_CHANGE_GROUP),
    ADD (DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP),
    ADD (DATABASE_OBJECT_PERMISSION_CHANGE_GROUP),
    ADD (DATABASE_OWNERSHIP_CHANGE_GROUP),
    ADD (DATABASE_PERMISSION_CHANGE_GROUP),
    ADD (DATABASE_PRINCIPAL_CHANGE_GROUP),
    ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP),
    ADD (DBCC_GROUP),
    ADD (LOGIN_CHANGE_PASSWORD_GROUP),
    ADD (SCHEMA_OBJECT_CHANGE_GROUP),
    ADD (SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP),
    ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP),
    ADD (SERVER_OBJECT_CHANGE_GROUP),
    ADD (SERVER_OBJECT_OWNERSHIP_CHANGE_GROUP),
    ADD (SERVER_OBJECT_PERMISSION_CHANGE_GROUP),
    ADD (SERVER_PERMISSION_CHANGE_GROUP),
    ADD (SERVER_PRINCIPAL_CHANGE_GROUP),
    ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP),
    ADD (SERVER_STATE_CHANGE_GROUP),
    ADD (TRACE_CHANGE_GROUP),
    ADD (USER_CHANGE_PASSWORD_GROUP),
    ADD (USER_DEFINED_AUDIT_GROUP)

    WITH (STATE = ON);

/* 
 Note: SSDT supports so-called management-scoped object, but only for initial
 creation. SERVER AUDIT, SERVER AUDIT SPECIFICATION and DATABASE AUDIT
 SPECIFICATION belong to this group of objects. During subsequent deployments
 SSDT will not attempt to alter them if their definition changes in the project.
 It will emit warning 72038 and will not generate code for the change.

 Please change the definition here as needed, so deployment on non-existing
 database succeeds, but if you want to change existing audit object, do it in
 pre- or post-deploy script, or by dropping it before deployment, or using
 another workaround.
*/


CREATE DATABASE AUDIT SPECIFICATION [DatabaseAuditSpecification]
    FOR SERVER AUDIT [LocalServerAudit]
    ADD (INSERT, UPDATE, DELETE ON SCHEMA::dbo BY public)
WITH (State = ON);



--LINKED SERVER
EXECUTE sp_addlinkedserver @server = N'D-WIDERA2\SQLEXPRESS14', @srvproduct=N'SQL Server' ;
GO

EXECUTE dbo.sp_addlinkedsrvlogin @rmtsrvname = N'D-WIDERA2\SQLEXPRESS14', @locallogin = NULL , @useself = N'False', @rmtuser = N'sa', @rmtpassword = N'TdH49Kat'
GO


--CDC - do post deploy
-- enable CDC on the database, if not already enabled

IF 0 = (SELECT is_cdc_enabled FROM sys.databases WHERE name='$(DatabaseName)')
BEGIN;
    PRINT N'Enabling CDC for database.';
    EXEC sys.sp_cdc_enable_db;
END;

-- enable CDC on all tables in schemas codes, dbo, if not already enabled

DECLARE @SchemaName SYSNAME, @TableName SYSNAME;
DECLARE @Statement VARCHAR(1000);

DECLARE c CURSOR FAST_FORWARD FOR

    SELECT s.name SchemaName, t.name TableName
    FROM sys.tables t
        JOIN sys.schemas s ON t.[schema_id] = s.[schema_id]
    WHERE t.is_ms_shipped = 0
        AND s.name ='dbo'
        AND t.name NOT IN ('__RefactorLog', 'sysdiagrams')
        AND t.is_tracked_by_cdc = 0
    ORDER BY SchemaName, TableName

OPEN c;

FETCH NEXT FROM c INTO @SchemaName, @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN;
    PRINT N'Enabling CDC for table ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + '...';
    EXEC sys.sp_cdc_enable_table @source_schema = @SchemaName, @source_name = @TableName, @role_name = 'EDWauditTrailReader';
    FETCH NEXT FROM c INTO @SchemaName, @TableName;
END;

CLOSE c;

DEALLOCATE c;

-- add capture job if not exists
EXECUTE sys.sp_cdc_add_job @job_type='capture';


-- add or change cleanup job to match security requirements

IF EXISTS(SELECT * from msdb.dbo.cdc_jobs
WHERE job_type = 'cleanup' AND database_id = DB_ID('$(DatabaseName)'))
BEGIN;
    EXECUTE sys.sp_cdc_change_job 
        @job_type = N'cleanup',
        @retention = 43200;
END;
ELSE
BEGIN;
    EXECUTE sys.sp_cdc_add_job
        @job_type = N'cleanup',
        @retention = 43200;
END;


--wyłaczenie CDC
EXEC sys.sp_cdc_disable_db;


--pre
PRINT 'Executing DropCDC.sql...';
GO
:r .\DropCDC.sql
GO



