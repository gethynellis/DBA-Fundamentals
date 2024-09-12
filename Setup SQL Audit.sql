USE Master;

-- Create a server audit that writes to a file
CREATE SERVER AUDIT Audit_CustomerTable
TO FILE (FILEPATH = 'C:\SQLAudit\', MAXSIZE = 10 MB)
WITH (ON_FAILURE = CONTINUE);  -- Specify what happens if auditing fails
GO

-- Enable the server audit
ALTER SERVER AUDIT Audit_CustomerTable
WITH (STATE = ON);
GO


USE AdventureWorksLT2019;
GO

-- Create a database audit specification for the Customer table
CREATE DATABASE AUDIT SPECIFICATION Audit_CustomerTable_Spec
FOR SERVER AUDIT Audit_CustomerTable
ADD (SELECT ON SalesLT.Customer BY [public]),  -- Capture SELECT operations
ADD (INSERT ON SalesLT.Customer BY [public]),  -- Capture INSERT operations
ADD (UPDATE ON SalesLT.Customer BY [public]),  -- Capture UPDATE operations
ADD (DELETE ON SalesLT.Customer BY [public])   -- Capture DELETE operations
WITH (STATE = ON);
GO


-- Verify that the auditing setup is active
SELECT * 
FROM sys.database_audit_specifications;
GO


-- Perform a SELECT operation
SELECT * 
FROM SalesLT.Customer;
GO

-- Perform an INSERT operation
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
           'Mrs.',  -- Title
           'Jane',  -- FirstName
           'A',  -- MiddleName
           'Doe',  -- LastName
           NULL,  -- Suffix, assuming no suffix
           'AdventureWorks',  -- CompanyName
           'adventureworks\jsmith',  -- SalesPerson
           'john.doe@example.com',  -- EmailAddress
           '555-999-9990',  -- Phone
           'AQAAAAEAACcQAAAAELnA5AB3QiJixrfw+P+98Jl0JHkMN6J1Z',  -- PasswordHash (dummy hash)
           'X1Y2Z3W4',  -- PasswordSalt (dummy salt)
           NEWID(),  -- rowguid, generates a new uniqueidentifier
           GETDATE())  -- ModifiedDate, sets the current timestamp
GO


-- Perform an UPDATE operation
UPDATE SalesLT.Customer
SET Phone = '555-999-9999'
WHERE FirstName = 'Jane' AND LastName = 'Doe';
GO

-- Perform a DELETE operation
DELETE FROM SalesLT.Customer
WHERE FirstName = 'Jane' AND LastName = 'Doe';
GO

-- View the audit logs
SELECT *
FROM sys.fn_get_audit_file('C:\SQLAudit\*.*', DEFAULT, DEFAULT);
GO

-- Disable the database audit specification
ALTER DATABASE AUDIT SPECIFICATION Audit_CustomerTable_Spec
WITH (STATE = OFF);
GO

-- Drop the database audit specification
DROP DATABASE AUDIT SPECIFICATION Audit_CustomerTable_Spec;
GO


-- Disable the server audit
ALTER SERVER AUDIT Audit_CustomerTable
WITH (STATE = OFF);
GO

-- Drop the server audit
DROP SERVER AUDIT Audit_CustomerTable;
GO









