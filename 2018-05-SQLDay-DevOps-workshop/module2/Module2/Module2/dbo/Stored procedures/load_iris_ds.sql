CREATE PROCEDURE [dbo].[load_iris_ds]
AS
BEGIN


INSERT INTO dbo.iris
EXEC get_iris_dataset
END 