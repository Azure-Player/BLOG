CREATE PROCEDURE [dbo].[GetSuppliers_OLTP]
AS
BEGIN
	SELECT * FROM [$(WideWorldImporters)].Purchasing.Suppliers
END