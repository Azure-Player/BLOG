CREATE VIEW [dbo].[CustomerPL]
AS 
SELECT [CustomerId], [RegionCode], [Title], [SSN], [Login], [CountryCode], [FirstName], [Surname], [isActive], [InactiveDate], [CreatedOn], [CreatedBy], [UpdatedOn], [UpdatedBy], [CustomerTypeCode], [Twitter] 
FROM dbo.Customer
WHERE [CountryCode] = 'PL';
