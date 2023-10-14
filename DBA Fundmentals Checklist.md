### SQL Server Management and Monitoring with PowerShell and SQL Scripts

This resource provides a guide to various tools and scripts that facilitate effective SQL Server management and monitoring, ensuring the optimization of your databases. This is ineffect the demo script I run through during the talk

#### 1. Introduction to DBATools
[DBATools](https://dbatools.io/) is a powerful module offering a collection of PowerShell commands that aid in managing SQL Servers. 

- **Installation**: You can install them using PowerShell  with the following command:
```PowerShell
Install-Module -Name dbatools
```
    
#### 2. Other useful community tools
I then install the useful community that we demo during the session

- **DbaChecks**: Ensures your SQL Server instances are adhering to best practices.
- **FirstResponder Kit**: Contains a suite of scripts for DBAs to aid in health checks, diagnostics, and data collection.
- **Ola Hallengren's Maintenance Solution**: A popular solution for SQL Server backup, integrity check, and index and statistics maintenance.
- **SQLWatch**: A monitoring solution that utilizes Power BI for visualization.

```PowerShell
Install-DbaFirstResponderKit -SqlInstance "DESKTOP-VKJJ599" -Database master
Install-DbaMaintenanceSolution -SqlInstance "DESKTOP-VKJJ599" -InstallJobs -CleanupTime 72
Install-DbaSqlWatch -SqlInstance "DESKTOP-VKJJ599"
Install-DbaWhoisactive -SqlInstance "DESKTOP-VKJJ599"
 ```

#### 3. Database Health Check
So we'll switch over to SQL Server Management Studio or Azure Data Tools. And we'll use the Spblitz stored procedure to run a quick health check. This will give us a prioritised list of all the things things we will need to look at. This is a simple health check to understand the status and any issues with your SQL Server.

Execute the sp_blitz stored procedure in SSMS

##### Using SP_Blitz:
```SQL
EXEC sp_Blitz @CheckUserDatabaseObjects = 0;
```
SP_Blitz is a part of the FirstResponder Kit and provides a quick overview of the system's health and various issues prioritized by criticality.

The output of this script will generally dictate what you need to next. For the purposes of my demo, we need backups and fact

#### 4. Managing Backups
Backups can be managed in several ways, including Maintenance Plans via GUI, or scripts.

The code below is taken from the step of a Ola Hellengren full backup job. You don't need to run this, let the agent job run this for you this is just showing you what the syntax looks like

We have deployed the solution and the jobs already, we just need to make sure that they run and 

##### Using Ola Hallengren's Maintenance Solution:
```SQL
EXECUTE [dbo].[DatabaseBackup]
@Databases = 'USER_DATABASES',
@Directory = N'C:\Path\To\Your\Backup\Directory',
@BackupType = 'FULL',
@Verify = 'Y',
@CleanupTime = 72,
@CheckSum = 'Y',
@LogToTable = 'N'
```

#### 5. Security
Ensure that your SQL Server is securely configured and manage user access effectively.

SP_BLitz will let you know a

##### Using SP_Blitz to Show SysAdmins:
SP_BLITZ reveals sysadmin users, amongst other security-related information. Review the peridocally to make sure that only the right people have sysadmin access

I demo a great security in the demo which shows and scripts out all the user permission in a database. It's not my script and I don't have permission to punlish here so I will send you toe sqlservercentral where the script is publish

https://www.sqlservercentral.com/scripts/script-db-level-permissions-v3 

#### 6. Recoverability: Testing Database Backups
So we have to our backups running. How can we tell if we tell if they are good and we can retore from them? The short answer is we need to restore them. How can we do that nice easily, well we have dbatools to help us. The command below will retore all the database on an instance. One at a time, Also runing DBCC CHECKDB on the  backups. We will know our backups are good

```PowerShell
Test-DbaLastBackup -SqlInstance "lab000001\SQLSERVER2017","lab000001"
```

#### 7. Database Maintenance
- **CheckDB**: Vital for identifying and dealing with database corruption.
- **Index Maintenance**: Handle fragmentation and ensure index optimization.

##### Utilizing Ola Hallengren's IndexOptimize Job:
The following is taken from the job step an will reorganise of rebuild your indexes depending the level 
```SQL
EXECUTE dbo.IndexOptimize 
@Databases = 'USER_DATABASES',
@FragmentationLow = NULL,
@FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationLevel1 = 5,
@FragmentationLevel2 = 30,
@UpdateStatistics = 'ALL',
@OnlyModifiedStatistics = 'Y'
```

#### 8. Monitoring and Blocking Scenarios
Using SQLWatch for monitoring and identifying blocking scenarios using `sp_WhoIsActive`.

##### Creating a Blocking Scenario:
Open a a New Query windoed and run the following. The updates a table and leaves the transaction open so we should get locls
```SQL
USE AdventureWorks2014
GO

SELECT * FROM [Person].[Person]
WHERE BusinessEntityID = 1

begin transaction

update Person.Person
set FirstName = 'Gethyn'
WHERE BusinessEntityID = 1
```

Then we'll try and access from another window, simulating a blocking situations

```SQL
SELECT * FROM [Person].[Person]
WHERE BusinessEntityID = 1
```

In a third window we can find the locks
##### Identifying a Blocking Scenario with SP_WhoIsActive:
```SQL
EXEC sp_WhoIsActive
@find_block_leaders = 1,
@sort_order = '[blocked_session_count] DESC'
```

#### 9. Visualizing Checks with Power BI
- **DailyChecks Power BI**: Ensure to explore your Power BI dashboard for vital signs and stats from your Daily Checks.

---

**Note**: This guide serves as a basic resource. Always ensure to thoroughly test scripts and commands in a safe and recoverable environment before applying them to production. Ensure that you understand what each script and command does, and how it affects your environment.

---

This structured guide will provide users, especially those on GitHub, a clear and concise view of how to utilize various tools and scripts for managing, monitoring, and optimizing SQL Server instances. Feel free to modify according to specific use cases or environments.
