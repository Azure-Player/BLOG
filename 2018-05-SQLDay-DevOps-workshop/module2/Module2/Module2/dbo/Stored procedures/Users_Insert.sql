CREATE PROCEDURE [dbo].[Users_Insert]
(	
	@UserName sysname,
	@Email NVARCHAR(100)
)AS
BEGIN
	INSERT INTO dbo.[Users] (UserName, Email)
	SELECT @UserName,@Email
END