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
