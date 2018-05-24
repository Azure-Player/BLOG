CREATE PROCEDURE [dbo].[GetCityDataFromDW]
AS
BEGIN
	SELECT * FROM [$(WideWorldImportersDW)].dim.City
END