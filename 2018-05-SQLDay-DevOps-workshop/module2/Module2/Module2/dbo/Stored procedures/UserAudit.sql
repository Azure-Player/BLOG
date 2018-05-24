CREATE PROCEDURE [dbo].[UserAudit]
@UserId INT, @UserName NVARCHAR (MAX) NULL, @Email NVARCHAR (MAX) NULL
AS EXTERNAL NAME [CLRLibrary].[CLRLibrary.StoredProc].[UserAudit]