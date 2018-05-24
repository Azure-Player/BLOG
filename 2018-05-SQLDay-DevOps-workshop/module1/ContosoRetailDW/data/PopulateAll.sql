CREATE PROCEDURE [dbo].[PopulateAll]
AS

	exec [data].[Populate_dbo_DimChannel];



RETURN 0
