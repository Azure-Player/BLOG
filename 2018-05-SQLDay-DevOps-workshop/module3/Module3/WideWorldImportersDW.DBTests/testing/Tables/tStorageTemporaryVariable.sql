CREATE TABLE [testing].[tStorageTemporaryVariable]
(
	[TestCaseName] [nvarchar](255) NOT NULL,
	[CreateBy] [nvarchar](255) NOT NULL DEFAULT (suser_sname()),
	[VariableName] [nvarchar](50) NULL,
	[Value] [nvarchar](max) NULL
)
