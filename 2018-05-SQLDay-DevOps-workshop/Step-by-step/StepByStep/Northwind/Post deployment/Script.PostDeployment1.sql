/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
CREATE OR ALTER VIEW dbo.OpenQueryVIEW
AS
SELECT        P.ProductID, P.ProductName, P.SupplierID, P.CategoryID, P.QuantityPerUnit, P.UnitPrice, P.UnitsInStock, P.UnitsOnOrder, P.ReorderLevel, P.Discontinued, PS.ProductSourceCode
FROM            dbo.Products AS P LEFT OUTER JOIN
                             (SELECT        ProductName, ProductSourceCode
                               FROM OPENQUERY([$(LinkedServer)], 'select * from [$(nwd_Source)].dbo.ProductsSource') 
							) AS PS 
							ON P.ProductName = PS.ProductName

GO