CREATE VIEW dbo.OpenQueryVIEW
AS
SELECT        P.ProductID, P.ProductName, P.SupplierID, P.CategoryID, P.QuantityPerUnit, P.UnitPrice, P.UnitsInStock, P.UnitsOnOrder, P.ReorderLevel, P.Discontinued, PS.ProductSourceCode
FROM            dbo.Products AS P LEFT OUTER JOIN
                             (SELECT        ProductName, ProductSourceCode
                               FROM OPENQUERY([$(LinkedServer)], 'select * from [$(nwd_Source)].dbo.ProductsSource') 
							) AS PS 
							ON P.ProductName = PS.ProductName

GO
