-------------------------------------------------------------------------------
-- This script uninstalls tSQLt framework and tries to clean up unit test
-- objects. It is meant to always be executed before deployment.
-------------------------------------------------------------------------------

IF OBJECT_ID('tSQLt.Uninstall', 'P') IS NOT NULL
    EXECUTE tSQLt.Uninstall;

-------------------------------------------------------------------------------
-- Cleanup objects from tSQLt schema and remove tSQLt schema altogether
-- (in case something was left not deleted after tSQLt.Uninstall).
-------------------------------------------------------------------------------

DECLARE @SchemaName nvarchar(128) = 'tSQLt';
DECLARE @stmt NVARCHAR(MAX);

PRINT 'Removing remaining objects from ' + @SchemaName + ' schema...';

-- drop FKs that reference PKs in @SchemaName
SET @stmt = (
SELECT 'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(fk.[schema_id])) + '.' +
    QUOTENAME(OBJECT_NAME(fk.parent_object_id)) + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';' + CHAR(10)
  FROM sys.foreign_keys fk
  INNER JOIN sys.tables t on t.[object_id] = fk.referenced_object_id
    AND fk.[schema_id] <> t.[schema_id]  -- only from other schemas
  WHERE t.[schema_id] = SCHEMA_ID(@SchemaName)
FOR XML PATH('')
);
EXEC(@stmt);

-- drop all CHECK, DEFAULT and FKs
SET @stmt = (
SELECT 'ALTER TABLE '+ QUOTENAME(SCHEMA_NAME(t.[schema_id])) + '.' +
    QUOTENAME(OBJECT_NAME(fk.parent_object_id)), ' DROP CONSTRAINT ', QUOTENAME(fk.name), ';', CHAR(10)
FROM sys.objects fk
INNER JOIN sys.tables t on t.[object_id] = fk.parent_object_id
WHERE t.[schema_id] = SCHEMA_ID(@SchemaName) AND fk.[type] IN ('C', 'D', 'F')
FOR XML PATH('')
);
EXEC(@stmt);
  
 -- drop other objects (order is important)
SET @stmt = (
SELECT CASE 
    WHEN o.[type] ='PK' THEN 'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(o.[schema_id])) + '.' + QUOTENAME(OBJECT_NAME(o.parent_object_id)) + ' DROP CONSTRAINT ' + QUOTENAME(o.name)
    WHEN o.[type] IN ('FN','FS','FT','IF','TF') THEN 'DROP FUNCTION  '+SCHEMA_NAME(o.[schema_id]) + '.' + QUOTENAME(o.name)
    WHEN o.[type] IN ('P', 'PC' ) THEN 'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(o.[schema_id])) + '.' + QUOTENAME(o.name)    
    WHEN o.[type] ='TR' THEN 'DROP TRIGGER ' + QUOTENAME(SCHEMA_NAME(o.[schema_id])) + '.' + QUOTENAME(o.name)
    WHEN o.[type] ='V'  THEN 'DROP VIEW ' + QUOTENAME(SCHEMA_NAME(o.[schema_id])) + '.' + QUOTENAME(o.name)
    WHEN o.[type] ='U'  THEN 'DROP TABLE ' + QUOTENAME(SCHEMA_NAME(o.[schema_id])) + '.' + QUOTENAME(o.name)
END + ';' + CHAR(10)
FROM sys.objects o
WHERE o.[schema_id] = SCHEMA_ID(@SchemaName)
  AND o.[type] IN ('PK', 'FN', 'TF', 'IF', 'TR', 'V', 'U', 'P', 'PC')
ORDER BY CASE WHEN type = 'PK' THEN 1 
              WHEN type in ('FN', 'TF', 'IF', 'FS', 'FT', 'P', 'PC') THEN 2
              WHEN type = 'TR' THEN 3
              WHEN type = 'V' THEN 4
              WHEN type = 'U' THEN 5
            ELSE 6 
          END
FOR XML PATH('')
);
EXEC(@stmt);

-- drop types
SET @stmt = (
SELECT 'DROP TYPE ' + QUOTENAME(SCHEMA_NAME(t.[schema_id])) + '.' + QUOTENAME(t.name) + ';' + CHAR(10)
FROM sys.types t
WHERE t.[schema_id] = SCHEMA_ID(@SchemaName)
FOR XML PATH('')
);
EXEC(@stmt);

IF SCHEMA_ID(@SchemaName) IS NOT NULL
BEGIN;
    EXEC ('DROP SCHEMA ' + @SchemaName);
END;

PRINT 'Cleanup of ' + @SchemaName + ' schema finished.';

