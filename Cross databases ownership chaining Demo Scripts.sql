/********How to check if cross-db ownership chaining is enabled at the server level*******/
SELECT Name, value_in_use 
from sys.configurations
where name like '%cross db ownership chaining%'


--Enable and disbale server level cross-db ownership chaining
--Enable

EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'cross db ownership chaining', 1;
GO
RECONFIGURE;
GO

--Disbale
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'cross db ownership chaining', 0;
GO
RECONFIGURE;
GO

--How to check if cross-db ownership chaining is enabled for an invidiual database

select name , is_db_chaining_on
from sys.databases 

--You can enable and disabled cross db ownership chaining at the database level by 
ALTER DATABASE dbname SET DB_CHAINING OFF;
ALTER DATABASE dbname SET DB_CHAINING ON;

/****Cross db ownership chaining - a worked example****/
--Create some databases
CREATE DATABASE SourceDB;
CREATE DATABASE TargetDB;

-- Set the db owner to SA
USE master;

-- Set the owner of SourceDB to sa
ALTER AUTHORIZATION ON DATABASE::SourceDB TO sa;
-- Set the owner of TargetDB to sa
ALTER AUTHORIZATION ON DATABASE::TargetDB TO sa;
-- Set the owner of TargetDB to sa
ALTER AUTHORIZATION ON DATABASE::Targets TO sa

 
-- Set trustworthy to on

ALTER DATABASE SourceDB SET TRUSTWORTHY ON;
ALTER DATABASE TargetDB SET TRUSTWORTHY ON;
ALTER DATABASE TARGETS SET TRUSTWORTHY ON;

--Create some objects and data in the target database

USE TargetDB;

-- Create a table
CREATE TABLE dbo.Employees (
    ID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Position NVARCHAR(50)
);

-- Insert sample data
INSERT INTO dbo.Employees (ID, Name, Position)
VALUES
    (1, 'Alice Johnson', 'Manager'),
    (2, 'Bob Smith', 'Developer');



--Create a Stored Procedure in SourceDB

USE SourceDB;
GO
CREATE PROCEDURE dbo.GetEmployees
AS
BEGIN
    SELECT * FROM TargetDB.dbo.Employees;
END;


--Create and Configure the DemoUser
-- Create a SQL login
CREATE LOGIN DemoUser WITH PASSWORD = 'StrongPassword123!';

-- Create a user in SourceDB
USE SourceDB;
CREATE USER DemoUser FOR LOGIN DemoUser;
EXEC sp_addrolemember 'db_owner', 'DemoUser';

--Create a login targetdb

-- Create a user in TargetDB
USE TargetDB;
CREATE USER DemoUser FOR LOGIN DemoUser;

-- Create a user in TargetDB
USE Targets;
CREATE USER DemoUser FOR LOGIN DemoUser;

/*If you are running this as a demo in SSMS then you now need to connect as the demo user
using SQL Server Authentication. I would do this by connecting in object explorer in SSMS. I will state which user needs to execute the script in the comments*/

--Ensure you logged in as DemoUser
USE SourceDB;
EXEC dbo.GetEmployees;

--You need to be using a login with Sys Admin permssions to run the following

--Enable and disbale server level cross-db ownership chaining
--Enable

EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'cross db ownership chaining', 1;
GO
RECONFIGURE;
GO


--Ensure you logged in as DemoUser. This should now work
USE SourceDB;
EXEC dbo.GetEmployees;


--Inadvert access to the targets database

--Ensure you logged in as DemoUser
USE SourceDB;
EXEC dbo.GetEmployees;
EXEC ReturnBusinessShowLeads

/**Recommendation: Disable at the server level**/

--Lets turn the cross db ownership option off  at the server level

EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
EXEC sp_configure 'cross db ownership chaining', 0;
GO
RECONFIGURE;
GO


-----Try the queries Ensure you logged in as DemoUser. These should fail
USE SourceDB;
EXEC dbo.GetEmployees;

EXEC ReturnBusinessShowLeads

--Enable Cross DB ownership chaining at the database level
ALTER DATABASE targetdb SET DB_CHAINING ON;
ALTER DATABASE sourcedb SET DB_CHAINING ON;

---Try the queries Ensure you logged in as DemoUser. These should return data  from taregtdb but from targets database
USE SourceDB;
EXEC dbo.GetEmployees;
EXEC ReturnBusinessShowLead

-- Turn off DB Chaining
ALTER DATABASE targetdb SET DB_CHAINING OFF;
ALTER DATABASE sourcedb SET DB_CHAINING OFF;

USE [TargetDB]
GO
ALTER ROLE [db_datareader] ADD MEMBER [DemoUser]
GO

--Ensure you logged in as DemoUser
USE SourceDB;
EXEC dbo.GetEmployees;
EXEC ReturnBusinessShowLeads

