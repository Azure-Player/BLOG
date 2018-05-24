CREATE TABLE [testing].[tExecutionResult]
(
	[Date] [datetime] NOT NULL DEFAULT (getdate()),
	[TestCaseName] [nvarchar](255) NOT NULL,
	[Result] [nvarchar](10) NOT NULL,
	[ExpectedResult] [nvarchar](max) NULL,
	[ActualResult] [nvarchar](max) NULL,
	[CreateBy] [nvarchar](255) NOT NULL DEFAULT (suser_sname())
)
