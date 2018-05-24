CREATE USER [Portal]
	FOR LOGIN Portal
	WITH DEFAULT_SCHEMA = WebPortal;

GO

GRANT CONNECT TO [Portal]
GO
GRANT EXECUTE ON [WebPortal].[ExecuteLoadingIrisDS] TO Portal;
