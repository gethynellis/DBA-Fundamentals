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


## The Value SQL Server Skills can bring





##


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
