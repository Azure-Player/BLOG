CREATE TABLE [dbo].[Users]
(
	[UserId] INT IDENTITY NOT NULL,
	[UserName] sysname NOT NULL,
	[Email] NVARCHAR(200) NOT NULL,
	CONSTRAINT pkUsers PRIMARY KEY (UserId)
)

GO

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