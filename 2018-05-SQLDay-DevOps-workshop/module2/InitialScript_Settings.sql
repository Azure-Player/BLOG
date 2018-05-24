EXEC sp_configure 'show advanced options',1
go
RECONFIGURE
GO
EXEC  sp_configure  'clr strict security',1
GO
RECONFIGURE
GO
EXEC  sp_configure  'external scripts enabled',0
GO
RECONFIGURE
GO
EXEC sp_configure 'show advanced options',0
go
RECONFIGURE
GO
EXEC  sp_configure  'clr enabled',0
GO
RECONFIGURE
GO
