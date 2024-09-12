USE AdventureWorksLT2019;
GO

-- Enable CDC on the database
EXEC sys.sp_cdc_enable_db;
GO

USE AdventureWorksLT2019;
GO

-- Enable CDC on the Customer table
EXEC sys.sp_cdc_enable_table 
    @source_schema = N'SalesLT', 
    @source_name = N'Customer', 
    @role_name = NULL;  -- Optional role that can query CDC tables, NULL means all users
GO


USE AdventureWorksLT2019;
GO

-- Check which tables have CDC enabled
SELECT is_tracked_by_cdc,* 
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN cdc.change_tables cdc ON t.object_id = cdc.source_object_id
WHERE s.name = N'SalesLT' AND t.name = N'Customer';


---- Insert a new customer
USE [AdventureWorksLT2019]
GO

INSERT INTO [SalesLT].[Customer]
           ([NameStyle]
           ,[Title]
           ,[FirstName]
           ,[MiddleName]
           ,[LastName]
           ,[Suffix]
           ,[CompanyName]
           ,[SalesPerson]
           ,[EmailAddress]
           ,[Phone]
           ,[PasswordHash]
           ,[PasswordSalt]
           ,[rowguid]
           ,[ModifiedDate])
     VALUES
           (0,  -- NameStyle: 0 for default
           'Mr.',  -- Title
           'John',  -- FirstName
           'A',  -- MiddleName
           'Doe',  -- LastName
           NULL,  -- Suffix, assuming no suffix
           'AdventureWorks',  -- CompanyName
           'adventureworks\jsmith',  -- SalesPerson
           'john.doe@example.com',  -- EmailAddress
           '555-123-4567',  -- Phone
           'AQAAAAEAACcQAAAAELnA5AB3QiJixrfw+P+98Jl0JHkMN6J1Z',  -- PasswordHash (dummy hash)
           'X1Y2Z3W4',  -- PasswordSalt (dummy salt)
           NEWID(),  -- rowguid, generates a new uniqueidentifier
           GETDATE())  -- ModifiedDate, sets the current timestamp
GO


-- Update a customer record
UPDATE SalesLT.Customer
SET Phone = '999-999-9999'
WHERE FirstName = 'John' AND LastName = 'Doe';

-- Delete the customer record
DELETE FROM SalesLT.Customer
WHERE FirstName = 'John' AND LastName = 'Doe';


-- Query the CDC change table for the Customer table
SELECT *
FROM cdc.SalesLT_Customer_CT;



