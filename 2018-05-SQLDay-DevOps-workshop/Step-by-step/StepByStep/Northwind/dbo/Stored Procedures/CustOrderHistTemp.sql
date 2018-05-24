
CREATE PROCEDURE [dbo].[CustOrderHistTemp] @CustomerID nchar(5)
AS

SELECT * INTO #Customers
FROM dbo.Customers
WHERE CustomerId = @CustomerID


SELECT ProductName, Total=SUM(Quantity)
FROM Products P, [Order Details] OD, Orders O, #Customers C
WHERE  C.CustomerID = O.CustomerID AND O.OrderID = OD.OrderID AND OD.ProductID = P.ProductID
GROUP BY ProductName


DROP TABLE #Customers