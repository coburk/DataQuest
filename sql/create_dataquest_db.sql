-- Create DataQuest database
-- This script creates the initial database schema for DataQuest: SQL Detective
-- Schema follows the Data Dictionary defined in docs/design-and-planning/

-- Use master database to create the new database
USE master;
GO

-- Drop existing database if it exists (for development)
-- Comment out or remove in production
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DataQuest')
BEGIN
    ALTER DATABASE DataQuest SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataQuest;
END
GO

-- Create the DataQuest database
CREATE DATABASE DataQuest;
GO

-- Use the DataQuest database for schema creation
USE DataQuest;
GO

-- ============================================================
-- CORE INVESTIGATIVE ENTITIES
-- ============================================================

-- Create Cases table
-- Represents investigation narratives that students solve
CREATE TABLE [dbo].[Cases] (
    [CaseID] INT PRIMARY KEY IDENTITY(1,1),
    [CaseTitle] VARCHAR(100) NOT NULL,
    [InitialPrompt] VARCHAR(MAX) NOT NULL,
    [Conclusion] VARCHAR(MAX) NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
GO

-- Create Persons table
-- Represents individuals involved in cases (suspects, witnesses, victims)
CREATE TABLE [dbo].[Persons] (
    [PersonID] INT PRIMARY KEY IDENTITY(1,1),
    [FirstName] VARCHAR(50) NOT NULL,
    [LastName] VARCHAR(50) NOT NULL,
    [Role] VARCHAR(50) NOT NULL, -- 'Suspect', 'Witness', 'Victim', 'Investigator'
    [IsSuspect] BIT NOT NULL DEFAULT 0,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
GO

-- Create Locations table
-- Represents physical places relevant to investigations
CREATE TABLE [dbo].[Locations] (
    [LocationID] INT PRIMARY KEY IDENTITY(1,1),
    [Name] VARCHAR(100) NOT NULL,
    [Address] VARCHAR(255) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);
GO

-- Create Relationships table
-- Represents connections between persons (coworker, sibling, etc.)
CREATE TABLE [dbo].[Relationships] (
    [RelationshipID] INT PRIMARY KEY IDENTITY(1,1),
    [PersonID_A] INT NOT NULL,
[PersonID_B] INT NOT NULL,
    [Type] VARCHAR(50) NOT NULL, -- 'Coworker', 'Sibling', 'Acquaintance', 'Friend', 'Employer'
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([PersonID_A]) REFERENCES [dbo].[Persons]([PersonID]),
    FOREIGN KEY ([PersonID_B]) REFERENCES [dbo].[Persons]([PersonID]),
    CONSTRAINT CHK_Different_Persons CHECK ([PersonID_A] <> [PersonID_B])
);
GO

-- ============================================================
-- EVIDENCE AND LOG DATA
-- ============================================================

-- Create Evidence table
-- Represents physical or digital evidence in a case
CREATE TABLE [dbo].[Evidence] (
    [EvidenceID] INT PRIMARY KEY IDENTITY(1,1),
    [CaseID] INT NOT NULL,
    [LocationID] INT NULL,
    [Type] VARCHAR(50) NOT NULL, -- 'CCTV_Log', 'Financial_Record', 'Email', 'Physical'
    [TimestampFound] DATETIME2 NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([CaseID]) REFERENCES [dbo].[Cases]([CaseID]),
    FOREIGN KEY ([LocationID]) REFERENCES [dbo].[Locations]([LocationID])
);
GO

-- Create WitnessStatements table
-- Represents narrative accounts from people involved in cases
CREATE TABLE [dbo].[WitnessStatements] (
    [StatementID] INT PRIMARY KEY IDENTITY(1,1),
    [CaseID] INT NOT NULL,
    [PersonID] INT NOT NULL,
    [StatementText] VARCHAR(MAX) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([CaseID]) REFERENCES [dbo].[Cases]([CaseID]),
    FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons]([PersonID])
);
GO

-- Create TransactionLogs table
-- Represents events, access logs, financial transactions, etc. for timeline building
CREATE TABLE [dbo].[TransactionLogs] (
    [LogID] INT PRIMARY KEY IDENTITY(1,1),
    [PersonID] INT NULL,
    [Timestamp] DATETIME2 NOT NULL,
    [Amount] DECIMAL(10, 2) NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Persons]([PersonID])
);
GO

-- ============================================================
-- AI AND TUTORING CONTROL
-- ============================================================

-- Create StorySteps table
-- Represents sequential investigation steps within a case
CREATE TABLE [dbo].[StorySteps] (
    [StepID] INT PRIMARY KEY IDENTITY(1,1),
    [CaseID] INT NOT NULL,
    [StepNumber] INT NOT NULL,
    [StepPrompt] VARCHAR(MAX) NOT NULL,
    [CanonicalQuery] VARCHAR(MAX) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([CaseID]) REFERENCES [dbo].[Cases]([CaseID]),
    UNIQUE ([CaseID], [StepNumber])
);
GO

-- Create AnswerKeys table
-- Represents the canonical solutions and expected results for each step
CREATE TABLE [dbo].[AnswerKeys] (
    [AnswerKeyID] INT PRIMARY KEY IDENTITY(1,1),
    [StepID] INT NOT NULL,
    [ExpectedResultHash] VARCHAR(64) NOT NULL,
    [ExpectedClueValue] VARCHAR(MAX) NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    FOREIGN KEY ([StepID]) REFERENCES [dbo].[StorySteps]([StepID]),
    UNIQUE ([StepID])
);
GO

-- ============================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================

-- Person/Relationship lookups
CREATE INDEX IDX_Persons_FirstName ON [dbo].[Persons]([FirstName]);
CREATE INDEX IDX_Persons_LastName ON [dbo].[Persons]([LastName]);
CREATE INDEX IDX_Relationships_PersonA ON [dbo].[Relationships]([PersonID_A]);
CREATE INDEX IDX_Relationships_PersonB ON [dbo].[Relationships]([PersonID_B]);

-- Location lookups
CREATE INDEX IDX_Locations_Name ON [dbo].[Locations]([Name]);
CREATE INDEX IDX_Locations_Address ON [dbo].[Locations]([Address]);

-- Evidence and logs
CREATE INDEX IDX_Evidence_CaseID ON [dbo].[Evidence]([CaseID]);
CREATE INDEX IDX_Evidence_Type ON [dbo].[Evidence]([Type]);
CREATE INDEX IDX_Evidence_Timestamp ON [dbo].[Evidence]([TimestampFound]);

-- Witness and statement lookups
CREATE INDEX IDX_WitnessStatements_CaseID ON [dbo].[WitnessStatements]([CaseID]);
CREATE INDEX IDX_WitnessStatements_PersonID ON [dbo].[WitnessStatements]([PersonID]);

-- Transaction logs and timelines
CREATE INDEX IDX_TransactionLogs_PersonID ON [dbo].[TransactionLogs]([PersonID]);
CREATE INDEX IDX_TransactionLogs_Timestamp ON [dbo].[TransactionLogs]([Timestamp]);

-- Story steps and answers
CREATE INDEX IDX_StorySteps_CaseID ON [dbo].[StorySteps]([CaseID]);
CREATE INDEX IDX_AnswerKeys_StepID ON [dbo].[AnswerKeys]([StepID]);

GO

-- ============================================================
-- Schema created successfully - Data Dictionary compliant
-- ============================================================
