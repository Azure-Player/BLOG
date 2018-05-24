CREATE PROCEDURE [testing].[pSetTempVariable]
(
	@TestCaseName nvarchar(255),
	@VariableName nvarchar(50)
	,@Value nvarchar(max)
)
AS
BEGIN

IF EXISTS ( SELECT * FROM testing.[tStorageTemporaryVariable] 
			WHERE [TestCaseName] = @TestCaseName AND [VariableName]  = @VariableName AND [CreateBy] = suser_sname()
		)
	BEGIN
		UPDATE testing.[tStorageTemporaryVariable]
			SET Value = @Value 		
		WHERE [TestCaseName] = @TestCaseName AND [VariableName]  = @VariableName AND [CreateBy] = suser_sname()
	END
	ELSE 
	BEGIN
		INSERT INTO testing.[tStorageTemporaryVariable] ([TestCaseName],[VariableName],[Value])
			VALUES (@TestCaseName, @VariableName, @Value )

	END


	RETURN 0
END

