USe AdventureWorksLT2019;

CREATE TABLE CustomersTemporal (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    EmailAddress NVARCHAR(50),
    PhoneNumber NVARCHAR(25),
    Address NVARCHAR(100),
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
) 
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.CustomersHistory));


INSERT INTO CustomersTemporal (CustomerID, FirstName, LastName, EmailAddress, PhoneNumber, Address)
VALUES (1, 'John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Main St'),
       (2, 'Jane', 'Smith', 'jane.smith@example.com', '098-765-4321', '456 Oak St');

UPDATE CustomersTemporal
SET EmailAddress = 'john.newemail@example.com'
WHERE CustomerID = 1;


SELECT * FROM CustomersTemporal WHERE CustomerID = 1;
SELECT * FROM CustomersHistory WHERE CustomerID = 1;

SELECT * 
FROM CustomersTemporal 
FOR SYSTEM_TIME AS OF '2024-09-12 12:00:00'
WHERE CustomerID = 1

