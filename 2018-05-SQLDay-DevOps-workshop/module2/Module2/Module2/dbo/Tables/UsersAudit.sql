CREATE TABLE [dbo].[UsersAudit]
(
	[UsersAuditId] INT IDENTITY NOT NULL,
	[UserId] INT NOT NULL,
	[UserName] sysname NOT NULL,
	[Email] NVARCHAR(200) NOT NULL,
	[CreatedOn] DATETIME2(7) CONSTRAINT[dfUsersAudit_CreatedOn] DEFAULT (GETDATE()) NOT NULL,
	CONSTRAINT pkUsersAudit PRIMARY KEY (UsersAuditId)
)
