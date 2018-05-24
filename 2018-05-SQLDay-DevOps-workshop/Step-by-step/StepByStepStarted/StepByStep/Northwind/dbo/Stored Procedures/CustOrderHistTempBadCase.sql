
CREATE PROCEDURE [dbo].[CustOrderHistTempBadCase] @CustomerID nchar(5)
AS

SELECT * INTO #Customers
FROM dbo.Customers
WHERE CustomerId = @CustomerID


EXEC dbo.ProductTotalFromTempTable
