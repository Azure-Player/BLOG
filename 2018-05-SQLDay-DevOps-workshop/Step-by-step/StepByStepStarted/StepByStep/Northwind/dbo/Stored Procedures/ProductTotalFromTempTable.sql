CREATE PROCEDURE ProductTotalFromTempTable
AS
BEGIN
	SELECT ProductName, Total=SUM(Quantity)
	FROM Products P, [Order Details] OD, Orders O, #Customers C
	WHERE  C.CustomerID = O.CustomerID AND O.OrderID = OD.OrderID AND OD.ProductID = P.ProductID
	GROUP BY ProductName

END
