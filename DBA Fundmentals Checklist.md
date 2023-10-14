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

#### 3. Database Health Check
A simple health check to understand the status and any issues with your SQL Server.

##### Using SP_Blitz:
```SQL
EXEC sp_Blitz @CheckUserDatabaseObjects = 0;
```
SP_Blitz is a part of FirstResponder Kit and provides a quick overview of the system health and various issues prioritized by criticality.

#### 4. Managing Backups
Backups can be managed in several ways, including Maintenance Plans via GUI, or scripts.

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

##### Using SP_Blitz to Show SysAdmins:
SP_BLITZ reveals sysadmin users amongst other security-related information.

```SQL
-- Code to add user to a database, e.g., AdventureWorks, and subsequent check would go here.
```

#### 6. Recoverability: Testing Database Backups
Ensure backups are reliable by using PowerShell commands.

```PowerShell
Test-DbaLastBackup -SqlInstance "lab000001\SQLSERVER2017","lab000001"
```

#### 7. Database Maintenance
- **CheckDB**: Vital for identifying and dealing with database corruption.
- **Index Maintenance**: Handle fragmentation and ensure index optimization.

##### Utilizing Ola Hallengren's IndexOptimize Job:
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
```SQL
--Your SQL for generating a block would go here.
```
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
