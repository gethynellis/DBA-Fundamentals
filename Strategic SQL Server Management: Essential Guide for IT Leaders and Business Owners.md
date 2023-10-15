# Strategic SQL Server Management: Essential Guide for IT Leaders and Business Owners

## Navigating SQL Server without a Dedicated DBA: Practical Approaches for Optimal Performance and Security

## Introduction
In the modern era, data has often been likened to the gold rushes of yesteryears, representing untapped wealth waiting to be mined. However, a more apt comparison might be to oil. Just as crude oil requires intricate refining processes and a robust infrastructure to transform it into valuable products, data, too, necessitates sophisticated tools and strategies to be harnessed effectively.

Reflect for a moment: How many among us work for a truly data-driven organisation? And how many are striving towards building such a business landscape, navigating the complexities of data management daily? The role of a Database Administrator (DBA) has never been more crucial. Yet, there are countless professionals without the title of a DBA, who find themselves tasked with managing the intricate world of SQL Server.

Consider the ramifications of improper SQL Server management. The stakes are high, both for individual professionals and the businesses they represent. Let's revisit the oil analogy: Would an oil refinery ever be overseen solely by its gatekeeper? Would the CEO of a major oil company directly manage the day-to-day operations of the refinery? And can we imagine entrusting machinery operators with the responsibility to both operate and maintain complex refining equipment without specialized training?

The answer is a resounding no.

In the same vein, the management of SQL Server, the "refinery" of your data-driven business, demands expertise, precision, and strategic foresight. This White Paper delves deep into the intricacies of managing SQL Server effectively, offering insights and guidance tailored for IT leaders and business owners who are at the frontline of the data revolution.

## Where to start
If you have SQL Server manage, but you don't have dedicated in-house expertise it can feel a little daunting as you wonder where to start. Let me start by giving a checklist of things you will need to ensure are in place to keep your SQL Server humming along nicely while you focus on your other job

- [ ] The best tools to use
- [ ] Understand What problems you have
- [ ] Recoverability
- [ ] Reliability
- [ ] Security
- [ ] Performance
- [ ] Monitoring and Maintenance

## The best tools to use Free Tools that can really help you 
If you are looking after SQL Server you want to keep things as simple as possible. There are some great free tools out that can save you time, which is no doubt a precious commodity for you and also allow you to keep your database management activities as simple as possible.

I'm going to assume that you are familiar or at least have used SQL Server Management Studio previously as that is SQL Servers main client utility for DBAs and Developers alike, but that too is a free download.

The tools I'd recommend you install include the following. Most of these have their own websites and GitHub repositories so if you want to find out more go to your favourite browser and search for them

- **DBATools:** - a set of PowerShell commands that make working with SQL Server a breeze 
- **DbaChecks:** - Dba Checks is part of DBA tools. There are some additional steps to install all the components. This tool can be used to check your SQL Servers every day to see if there is anything you need to worry about. You can come in the morning to check a PowerBI and see if you need to fix anything before getting on with your day
- **FirstResponder Kit:** Contains a suite of scripts for DBAs to aid in health checks, diagnostics, and data collection.
- **Ola Hallengren's Maintenance Solution:** A popular SQL Server backup, integrity check, and index and statistics maintenance solution.
- **SP_Whoisactive** - A useful stroed procedure that can help you identify what might be causing your SQL Server block up
- **SQLWatch:** A monitoring solution that utilizes Power BI for visualization.

We can install these using PowerShell with a few lines of code. These tools will be ready for your use. You specify multiple SQL instances if you want to install these on more than one SQL Server installation.

```PowerShell
Install-Module -Name dbatools
Install-Module Pester -SkipPublisherCheck -Force -RequiredVersion 4.10.0
Import-Module Pester -Force -RequiredVersion 4.10.0
Install-DbaFirstResponderKit -SqlInstance "DESKTOP-VKJJ599" -Database master
Install-DbaMaintenanceSolution -SqlInstance "DESKTOP-VKJJ599" -InstallJobs -CleanupTime 72
Install-DbaSqlWatch -SqlInstance "DESKTOP-VKJJ599"
Install-DbaWhoisactive -SqlInstance "DESKTOP-VKJJ599"
```

We are ready to check a task as done on our list

- [X] The best tools to use
- [ ] Understand What problems you have
- [ ] Recoverability
- [ ] Reliability
- [ ] Security
- [ ] Performance
- [ ] Monitoring and Maintenance

## Understand what problems, if any, you need fix

Brent Ozar has developed a first responder kit which he has made open source and freely available. You can use his tools for many things but the one I like is the quick SQL Server health check it will let you run on any SQL Server instance

So we'll switch over to SQL Server Management Studio or Azure Data Tools, whichever is your preference. And we'll use the sp_blitz stored procedure that is part of the first respnder kit to run a quick health check. This will give us a prioritised list of all the things things we will need to look at. This is a simple health check to understand the status and any issues with your SQL Server and more importanly it tells you where to start.

Execute the sp_blitz stored procedure in SSMS

##### Using SP_Blitz:
```SQL
EXEC sp_Blitz @CheckUserDatabaseObjects = 0;
```
SP_Blitz is a part of the FirstResponder Kit and provides a quick overview of the system's health and various issues prioritized by criticality.

The output of this script will generally dictate what you need to do next. But we'll cover the main areas here

![image](https://github.com/gethynellis/DBA-Fundamentals/assets/30595485/76650202-5d16-4912-bfb4-2e43a92c22b7)

So we know what we need to do, that;s another check off the list


- [X] The best tools to use
- [X] Understand What problems you have
- [ ] Recoverability
- [ ] Reliability
- [ ] Security
- [ ] Performance
- [ ] Monitoring and Maintenance

## Recoverability
What we are talking about here is the ability to recover your database should something bad happen. If you think nothing bad can happen to your databases let me share some real life examples iwth with that will hopefully make you think differently

- A developer accidentally runs an update statement without a  ```WHERE``` clause so all your prices get updated to be £1.99
- A developer accidentally runs a delete statement without  a ```WHERE```  clause so all your prices get deleted
- Three disks in the same raid array fail in the space of 30 minutes

The list could go on here, things happen, you business data i critical to your business. You need to be ensure it is firstly backed up, then secondly, you can restore it.

So we'll do that first

### Managing Backups
Backups can be managed in several ways, including Maintenance Plans via GUI, or scripts.

It's worth noting a little about each database's recovery model, SQL Server recovery models are designed to control transaction log maintenance and to help manage different approaches to recovery from failures. They determine how transactions are logged, whether the transaction log requires (and allows) backing up, and what kinds of restore operations are available. There are three main recovery models in SQL Server: 

1. **Full Recovery Model**:
    - **Logging**: All transactions are fully logged.
    - **Backup**: Both full and transaction log backups can be made.
    - **Recovery**: Can recover to an exact point in time (assuming all needed log backups are available).
    - **Usage**: This model is essential when you require the ability to restore to a specific point in time, such as in systems where data accuracy and completeness are critical.

2. **Bulk-Logged Recovery Model**:
    - **Logging**: Most transactions are fully logged, but certain bulk operations are minimally logged.
    - **Backup**: Both full and transaction log backups can be made.
    - **Recovery**: Can recover to the end of any backup, but point-in-time recovery is not available for bulk operations. 
    - **Usage**: This model is useful when performing bulk operations for performance reasons, and when it's acceptable to not have point-in-time recovery for those operations.

3. **Simple Recovery Model**:
    - **Logging**: All transactions are fully logged.
    - **Backup**: Only full and differential backups are possible (transaction log backups are not available).
    - **Recovery**: Can recover only up to the end of a backup. No point-in-time recovery.
    - **Usage**: This model is suitable for development, test environments, or systems where data changes are not critical and data can be recreated or re-imported without significant effort.

Choosing the appropriate recovery model depends on your specific data recovery requirements, including your tolerance for data loss and how much downtime is acceptable in the event of a failure. Whatever recovery model you go with please take the time to understand what you need to manage the log

The code below is taken from the step of an Ola Hellengren full backup job we deployed in a previous step. You don't need to run this below, let the agent job run this for you this is just showing you what the syntax looks like. **You just need to setup the schedule and timing using the SQL Server Agent**

We have deployed the solution and the jobs already. We just need to ensure they run and back up to an appropriate place. This might be off the server, it might be on the server. If you back up to the server, hopefully, ideally, the reality is you want something, whether its another backup tool or something you implement yourself to 

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
These are how the jobs look on the SQL Server Agent

![image](https://github.com/gethynellis/DBA-Fundamentals/assets/30595485/255ca1a8-9ce9-4a2e-a1b4-d792b4bb6a72)

### Recoverability: Testing Database Backups
So we have to our backups running. How can we tell if we tell if they are good and we can retore from them? The short answer is we need to restore them. How can we do that nice easily, well we have dbatools to help us. The command below will retore all the database on an instance. One at a time, Also runing DBCC CHECKDB on the  backups. We will know our backups are good

```PowerShell
Test-DbaLastBackup -SqlInstance "lab000001\SQLSERVER2017","lab000001"
```

You simply need enough free space for your largest database to run the  restore test. This  powershell command will restore the database using a different name, run a CHECKDB  against the restore and tear down your restored database. 

Test your backups, they could save your business if you ever need them.

We have are making progress now down our list

- [X] The best tools to use
- [X] Understand What problems you have
- [X] Recoverability
- [ ] Reliability
- [ ] Security
- [ ] Performance
- [ ] Monitoring and Maintenance

## Reliability

`CHECKDB` in SQL Server is a command that helps in ensuring the integrity and consistency of database structures. When we talk about `CHECKDB`, we typically mean the command `DBCC CHECKDB`, where `DBCC` stands for Database Console Commands, which are a series of statements in SQL Server for database maintenance and management.

### What does `CHECKDB` do?

1. **Integrity Checks**: 
   - It verifies the physical and logical integrity of all the objects in the specified database.
   
2. **Allocations Checks**:
   - It checks all the allocation structures for consistency and ensures there's no allocation error.

3. **System Table Checks**:
   - It checks system tables for corruption and ensures system tables are functioning correctly.

4. **Index Checks**:
   - It checks the indexes in the database for consistency to ensure that data retrieval can occur optimally.
   
5. **Row and Page Checks**:
   - It ensures that every row and page in the database is correctly linked and there's no corruption in the data.
   
### Why should people run `CHECKDB`?

1. **Data Integrity**:
   - To ensure that the data stored in the database remains reliable and consistent, and no corruption has occurred that could undermine data quality.
   
2. **Prevent Data Loss**:
   - Detecting corruption early can help prevent data loss by giving you a chance to repair issues before they become critical, or to restore from a backup while minimal data is lost.
   
3. **Performance Maintenance**:
   - Though logical inconsistencies might not always be evident to users, they can impact performance. Running `CHECKDB` helps ensure optimal performance by identifying and allowing you to resolve any inconsistencies.
   
4. **Disaster Recovery Planning**:
   - Ensuring that backups are free from corruption is vital in a disaster recovery plan. Running `CHECKDB` against a restored backup ensures that the backup is sound and restorable.

5. **Avoiding Downtime**:
   - Identifying and resolving issues before they lead to significant problems can help you avoid unexpected downtime.

### Usage Example:

```SQL
DBCC CHECKDB ('YourDatabaseName')
```

You replace `'YourDatabaseName'` with the name of the database you want to check. Running `CHECKDB` can be resource-intensive, so it's often recommended to run it during periods of low database usage if possible.

In simple terms, think of `DBCC CHECKDB` like a doctor's check-up but for your database. It checks all the vital aspects to ensure everything is in order and functioning properly, helping to maintain healthy data and a reliable system. You should run it regularly.

Luckily the Ola Hellengren maintenance solution can take care of this for you too. You just need to schedule the jobs to run at off peak period for your database workload. Think out of hours during the night. The jobs will look like this

![image](https://github.com/gethynellis/DBA-Fundamentals/assets/30595485/d7b7f843-0fe2-4b6f-b54a-7ecd1eb43d41)


We are making good progress through out checklist

- [X] The best tools to use
- [X] Understand What problems you have
- [X] Recoverability
- [X] Reliability
- [ ] Security
- [ ] Performance
- [ ] Monitoring and Maintenance



## Security
From a security perspectiuve you will want to undersand who has sysadmin access to your databases server. If you have sysadmin access you can do anything you like to the server. It's a role that only a few will have access too. As a DBA you will want to monitor who has access 

SP_BLITZ reveals sysadmin users, amongst other security-related information. Review the peridocally to make sure that only the right people have sysadmin access

![image](https://github.com/gethynellis/DBA-Fundamentals/assets/30595485/97020a94-a010-413a-8c6a-d3a5792be453)


I demo a great security in the demo which shows and scripts out all the user permission in a database. It's not my script and I don't have permission to punlish here so I will send you toe sqlservercentral where the script is publish

https://www.sqlservercentral.com/scripts/script-db-level-permissions-v3 

![image](https://github.com/gethynellis/DBA-Fundamentals/assets/30595485/84964285-9f25-443f-9e80-f1b6d8ed019f)

So we now have a handle on security

- [X] The best tools to use
- [X] Understand What problems you have
- [X] Recoverability
- [X] Reliability
- [X] Security
- [ ] Performance
- [ ] Monitoring and Maintenance


## Performance - Blocking

Blocking in SQL Server (and databases in general) is a typical performance issue because it's essentially about competition for resources. When multiple processes try to access the same resource, especially in high-transaction environments, they can't all get what they want at the same time. This situation results in waits, queues, and reduced performance. Let’s dig a bit deeper.

### Why Blocking Occurs:

1. **Resource Competition**:
   - Multiple transactions try to access the same resource simultaneously. One transaction locks a resource, and others must wait, resulting in blocking.

2. **Locking**:
   - SQL Server uses various locks (like row locks, page locks, and table locks) to ensure data consistency and integrity during transactions. While a resource is locked by one transaction, others that want to access it must wait, causing blocks.

### Why Blocking is a Common Performance Issue:

1. **Concurrent Access**:
   - In busy systems, many users or processes often try to access the same data simultaneously, increasing the probability of blocking issues.

2. **Long-Running Transactions**:
   - Transactions that take a long time to complete hold locks for longer, increasing the likelihood that other transactions will be blocked.

3. **Lack of Optimization**:
   - Poorly optimized queries or indexes may lead to unnecessary or prolonged locks, contributing to blocking.

4. **Inadequate Isolation Levels**:
   - Lower isolation levels reduce locking and blocking but might compromise data consistency. Higher isolation levels safeguard consistency but increase locking and therefore blocking.

5. **High Transaction Volumes**:
   - Systems with high transaction volumes inherently have more contention for resources, leading to more potential blocking.

6. **Schema Design Issues**:
   - Design issues like improper indexing, normalization issues, or other schema-related problems might force queries to obtain more locks than necessary, escalating blocking scenarios.

### Impact on Performance:

- **Delayed Transactions**: Other transactions have to wait their turn to access resources, causing delays.
  
- **Reduced Throughput**: The transaction rate can be throttled by blocking, reducing the system’s throughput.

- **Increased Latency**: The time to complete individual transactions can increase, harming the user experience.

- **Potential Deadlocks**: In some cases, blocking can evolve into deadlocks, where transactions mutually block each other.

### Mitigation:

1. **Query Optimization**:
   - Ensuring that queries are as efficient as possible can reduce lock times and minimize blocking.

2. **Index Optimization**:
   - Proper indexing ensures data can be accessed with minimal locking, reducing the chances of blocking.

3. **Monitoring and Alerting**:
   - Implementing monitoring to alert for blocking issues allows for pro-active issue resolution.

By understanding and addressing the causes and impacts of blocking, you can fine-tune database performance and ensure smoother, more consistent interactions for end-users.

You use the following to simulate a blocking scenario and see how you can use sp_whoisactive to view get infromation on the blocking scenario

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

So we now have a handle on a common performance issue. We'll leave indexing which will also have a positive  impact on performance for another 

- [X] The best tools to use
- [X] Understand What problems you have
- [X] Recoverability
- [X] Reliability
- [X] Security
- [X] Performance
- [ ] Monitoring and Maintenance

## Monitoring and Maintenance

You will need to maintain your indexes as these can get fragmented when database inserts, updates and deletes are running. More importantly though Statsitics, which the optimizer uses to come up with the best plan for executing a query need to be updated. SQL Server will update these automatically, however sometime the algorithm doesn't quite kick in time and you might want to update these yourselfs. Fortunately Ola Hellengren's script can take car eof that for us too. You might need to tweak of change the job settings to get it to to update the indexes for you

![image](https://github.com/gethynellis/DBA-Fundamentals/assets/30595485/90086e03-a424-49b5-a940-a9d3fb6cce53)

### DBATools DBACHECKS and Visualizing Daily Checks on your SQL Server Estate
So if you are in a situation where you are not a full-time DBA, you will want to keep an eye on your environment. Maybe have some checks run and let you know if you run into any issues. Again dbatools and dbachecks will be your friend

This will install what you need to run dbachecks

```PowerShell
Install-Module Pester -Force -SkipPublisherCheck -RequiredVersion '4.10.1’
Install-Module dbachecks
```

This will run subset of the checks. You can change these depending on what you want to check 

 
```PowerShell
$SQLInsts = ("DESKTOP-VKJJ599")
$CompList = ("DESKTOP-VKJJ599")
Invoke-DbcCheck -ComputerName $CompList  -SqlInstance $SQLInsts -Checks  ErrorLog, FailedJob, Storage, LastFullBackup -ExcludeDatabase SQLWatch -PassThru -Show Fails | Update-DbcPowerBiDataSource -Path C:\Course
Start-DbcPowerBi
```


- **DailyChecks Power BI**: Ensure to explore your Power BI dashboard for vital signs and stats from your Daily Checks.

### SQLWatch for ongoing monitoring
Lastly, if you need historical data to analyse what has been ongoing on your server, there are lot of good monitoring tools out that you can buy off the shelf. The chances are though, if you don't have a DBA you won't have a monitoring tool either

Marcin has some great documentation on sqlwatch.io so you can check that and best of all, it's free


- [X] The best tools to use
- [X] Understand What problems you have
- [X] Recoverability
- [X] Reliability
- [X] Security
- [X] Performance
- [X] Monitoring and Maintenance



## **Unlock Premier SQL Server Expertise Tailored For Your Business**

Step into a world where two decades of unparalleled data experience meets innovation. From my early days as a report writer and web developer to a seasoned Database Administrator (DBA), I've consistently evolved, and so has my venture, gethynellis.com. Our collaboration with the esteemed Wyeden team amplifies our dedication to offering transformative, wallet-friendly solutions tailored to today's dynamic business environment. Dive into our bouquet of offerings:

**Exclusive SQL Server DBA Workshop**
Dive deep for a day with our top-tier consultants. Together, we'll navigate our comprehensive checklist, ensuring not only that everything is perfectly configured for you but also that you grasp the reasons behind each setting. Depart from our session with the confidence that your SQL Server is in prime condition. And while we arm you with the knowledge to manage your SQL Server moving forward, remember we're just a call away should you ever need further assistance. Empower yourself and ensure your SQL Server's robust health with our workshop.

**SQL Server Virtual DBA (Managed Service)**
Imagine having an adept DBA at your fingertips without the overhead of hiring one full-time. Integrate our seasoned professionals into your team, ensuring your SQL Server receives impeccable care. Experience our excellence for a month, and if you aren't elated, the month is on us – no strings attached.

**Call-off Contract**
Seeking flexibility without a long-term commitment? Our call-off contract is your answer. Pre-purchase a set number of days, starting as low as five, to test the waters. It's the ideal choice for SQL Server maestros needing occasional external support without the weight of a hefty contract.

**SQL Server Migrations and Upgrades**
Consider every upgrade or migration a breeze. Whether you're transitioning to a cloud platform or updating your SQL Server, we guarantee a seamless shift, keeping your data's sanctity intact.

**SQL Server Health Checks & Performance Tweaks**
Trust our meticulous checks and tuning to keep your SQL

Server at its optimal performance. Data is the lifeblood of your business, and we ensure it flows without a hitch.

**Data Platform Architecture & Design**
Crafting robust data platform architectures is our forte. From high availability to disaster recovery solutions, we also guide you on licensing intricacies to balance compliance with cost-effectiveness.

**Data Architecture & Strategy Consulting**
Illuminate your business's data trajectory. We're your partners in sculpting potent data architectures and actionable data strategies.

**Training on SQL Server & Microsoft Data Platform**
Propel your team's prowess with our in-depth training modules, inclusive of the Microsoft Official Curriculum.

**Critical Friend Advisory**
Every journey has its bumps. As your 'Critical Friend,' lean on us for unbiased, expert advice, ensuring smooth sailing through both technical and non-technical terrains.

At its core, overseeing SQL Server shouldn't be overwhelming for you. Shed the weight of recruiting a full-time member or committing to a hefty service contract. Trust Gethyn Ellis to offer tailored assistance that aligns with your needs. Connect with us, and together we'll shape an ideal solution tailored just for you.
