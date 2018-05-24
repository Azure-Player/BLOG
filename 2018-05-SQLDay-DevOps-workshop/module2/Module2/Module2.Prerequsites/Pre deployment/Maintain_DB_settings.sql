IF EXISTS (SELECT 1
           FROM   [dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
		-- Disable service broker manually because dacpack parameter ScriptDatabaseOptions=False 
		--is specified in the installation script.
		ALTER DATABASE [$(DatabaseName)] SET DISABLE_BROKER WITH ROLLBACK IMMEDIATE;
    END
GO