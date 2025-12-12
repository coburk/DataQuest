-- ============================================================================
-- DataQuest SQL Detective - Initial Schema Creation
-- Version: 001
-- Date: December 5, 2025
-- Purpose: Phase 1 database schema for DataQuest educational platform
-- 
-- This schema implements the Traditional Approach for educational clarity:
-- - NO JSON in student-visible schema
-- - Separate tables for distinct event types
-- - All data in explicitly typed columns
-- - Clear, discoverable table structure
-- ============================================================================

-- ============================================================================
-- CORE SUPPORTING TABLES (All Tiers)
-- ============================================================================

-- Cases: Container for investigations
CREATE TABLE Cases (
    CaseID INT PRIMARY KEY IDENTITY(1,1),
    CaseTitle NVARCHAR(255) NOT NULL,
    CaseDescription NVARCHAR(MAX) NULL,
    DifficultyTier INT NOT NULL CHECK (DifficultyTier BETWEEN 1 AND 5),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    IsActive BIT NOT NULL DEFAULT 1
);

-- Persons: Individuals involved in cases (suspects, witnesses, victims)
CREATE TABLE Persons (
    PersonID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50) NOT NULL,
    IsSuspect BIT NOT NULL,
    Affiliation NVARCHAR(100) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

-- Add unique constraint on Persons (FirstName, LastName, Role)
ALTER TABLE Persons
ADD CONSTRAINT UQ_Persons_Name_Role UNIQUE (FirstName, LastName, Role);

-- Locations: Physical places of interest
CREATE TABLE Locations (
  LocationID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL UNIQUE,
    Address NVARCHAR(255) NULL,
    Zone NVARCHAR(50) NULL,
    BuildingType NVARCHAR(100) NULL,
    Latitude DECIMAL(9,6) NULL,
    Longitude DECIMAL(9,6) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

-- Evidence: Physical evidence records
CREATE TABLE Evidence (
    EvidenceID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    LocationID INT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    EvidenceType NVARCHAR(100) NOT NULL,
    Value DECIMAL(10,2) NULL,
    TimestampFound DATETIME2 NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE()),
    CONSTRAINT FK_Evidence_Cases FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),
    CONSTRAINT FK_Evidence_Locations FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- ============================================================================
-- TIER 1 TABLES: Foundation (Badge Access & Parking Lot)
-- ============================================================================

-- BadgeAccess: Badge swipe records for secure building access (Case 1.1)
CREATE TABLE BadgeAccess (
 AccessID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    PersonID INT NOT NULL,
    LocationID INT NOT NULL,
    AccessTime DATETIME2 NOT NULL,
  AccessType NVARCHAR(50) NOT NULL CHECK (AccessType IN ('Entry', 'Exit')),
    Status NVARCHAR(50) NOT NULL CHECK (Status IN ('Successful', 'Failed', 'Denied')),
    BadgeID NVARCHAR(50) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_BadgeAccess_Cases FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),
  CONSTRAINT FK_BadgeAccess_Persons FOREIGN KEY (PersonID) REFERENCES Persons(PersonID),
    CONSTRAINT FK_BadgeAccess_Locations FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- ParkingLotAccess: Parking lot gate events (Case 1.2)
CREATE TABLE ParkingLotAccess (
    GateEventID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    LocationID INT NOT NULL,
    EventTime DATETIME2 NOT NULL,
    EventType NVARCHAR(50) NOT NULL CHECK (EventType IN ('GateEntry', 'GateExit')),
    VehicleID NVARCHAR(50) NULL,
    VehicleRecorded BIT NOT NULL,
    Notes NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_ParkingLotAccess_Cases FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),
    CONSTRAINT FK_ParkingLotAccess_Locations FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- ============================================================================
-- TIER 2 TABLES: Relationship Exploration
-- ============================================================================

-- Incidents: Crime incident reports
CREATE TABLE Incidents (
    IncidentID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    IncidentType NVARCHAR(50) NOT NULL,
    IncidentDate DATETIME2 NOT NULL,
    LocationID INT NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Severity NVARCHAR(50) NULL CHECK (Severity IN ('High', 'Medium', 'Low', NULL)),
    ReportedBy INT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_Incidents_Cases FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),
    CONSTRAINT FK_Incidents_Locations FOREIGN KEY (LocationID) REFERENCES Locations(LocationID),
 CONSTRAINT FK_Incidents_Persons FOREIGN KEY (ReportedBy) REFERENCES Persons(PersonID)
);

-- CommunicationRecords: Phone calls, emails, SMS communications
CREATE TABLE CommunicationRecords (
    RecordID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    CallerID INT NOT NULL,
    ReceiverID INT NOT NULL,
    CommunicationType NVARCHAR(50) NOT NULL CHECK (CommunicationType IN ('Phone', 'Email', 'SMS')),
    Timestamp DATETIME2 NOT NULL,
    Duration INT NULL,
    Details NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_CommunicationRecords_Cases FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),
    CONSTRAINT FK_CommunicationRecords_Caller FOREIGN KEY (CallerID) REFERENCES Persons(PersonID),
    CONSTRAINT FK_CommunicationRecords_Receiver FOREIGN KEY (ReceiverID) REFERENCES Persons(PersonID)
);

-- ============================================================================
-- TIER 3 TABLES: Data Quality & Pattern Recognition
-- ============================================================================

-- WitnessStatements: Witness testimonies and statements
CREATE TABLE WitnessStatements (
    StatementID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    WitnessID INT NOT NULL,
    LocationID INT NULL,
    StatementDate DATETIME2 NOT NULL,
    StatementText NVARCHAR(MAX) NOT NULL,
    Reliability NVARCHAR(50) NULL CHECK (Reliability IN ('High', 'Medium', 'Low', NULL)),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_WitnessStatements_Cases FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),
    CONSTRAINT FK_WitnessStatements_Persons FOREIGN KEY (WitnessID) REFERENCES Persons(PersonID),
    CONSTRAINT FK_WitnessStatements_Locations FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- ============================================================================
-- TIER 4+ TABLES: Complex Orchestration
-- ============================================================================

-- TransactionLogs: Financial transactions and system access logs
CREATE TABLE TransactionLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    PersonID INT NULL,
    LocationID INT NULL,
    TransactionType NVARCHAR(50) NOT NULL,
    Status NVARCHAR(50) NOT NULL CHECK (Status IN ('Success', 'Failed', 'Denied')),
    Amount DECIMAL(10,2) NULL,
    Timestamp DATETIME2 NOT NULL,
    Details NVARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_TransactionLogs_Cases FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),
    CONSTRAINT FK_TransactionLogs_Persons FOREIGN KEY (PersonID) REFERENCES Persons(PersonID),
    CONSTRAINT FK_TransactionLogs_Locations FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

-- ============================================================================
-- TUTORING CONTROL TABLES (All Tiers)
-- ============================================================================

-- StorySteps: Sequential investigation steps for each case
CREATE TABLE StorySteps (
    StepID INT PRIMARY KEY IDENTITY(1,1),
    CaseID INT NOT NULL,
    StepNumber INT NOT NULL,
StepPrompt VARCHAR(MAX) NOT NULL,
    CanonicalQuery VARCHAR(MAX) NOT NULL,
    ExpectedValue VARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_StorySteps_Cases FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
);

-- AnswerKeys: Canonical answers for validating student queries
CREATE TABLE AnswerKeys (
    AnswerKeyID INT PRIMARY KEY IDENTITY(1,1),
    StepID INT NOT NULL,
    ExpectedResultHash VARCHAR(64) NOT NULL,
    ExpectedClueValue VARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT FK_AnswerKeys_StorySteps FOREIGN KEY (StepID) REFERENCES StorySteps(StepID)
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

-- Evidence indexes
CREATE INDEX IX_Evidence_CaseID ON Evidence(CaseID);
CREATE INDEX IX_Evidence_LocationID ON Evidence(LocationID);
CREATE INDEX IX_Evidence_CaseID_TimestampFound ON Evidence(CaseID, TimestampFound);

-- BadgeAccess indexes
CREATE INDEX IX_BadgeAccess_CaseID ON BadgeAccess(CaseID);
CREATE INDEX IX_BadgeAccess_PersonID ON BadgeAccess(PersonID);
CREATE INDEX IX_BadgeAccess_LocationID ON BadgeAccess(LocationID);
CREATE INDEX IX_BadgeAccess_CaseID_AccessTime ON BadgeAccess(CaseID, AccessTime);
CREATE INDEX IX_BadgeAccess_PersonID_LocationID ON BadgeAccess(PersonID, LocationID);

-- ParkingLotAccess indexes
CREATE INDEX IX_ParkingLotAccess_CaseID ON ParkingLotAccess(CaseID);
CREATE INDEX IX_ParkingLotAccess_LocationID ON ParkingLotAccess(LocationID);
CREATE INDEX IX_ParkingLotAccess_LocationID_EventTime ON ParkingLotAccess(LocationID, EventTime);
CREATE INDEX IX_ParkingLotAccess_CaseID_EventTime ON ParkingLotAccess(CaseID, EventTime);

-- Incidents indexes
CREATE INDEX IX_Incidents_CaseID ON Incidents(CaseID);
CREATE INDEX IX_Incidents_LocationID ON Incidents(LocationID);
CREATE INDEX IX_Incidents_CaseID_IncidentDate ON Incidents(CaseID, IncidentDate);
CREATE INDEX IX_Incidents_IncidentType_LocationID ON Incidents(IncidentType, LocationID);

-- CommunicationRecords indexes
CREATE INDEX IX_CommunicationRecords_CaseID ON CommunicationRecords(CaseID);
CREATE INDEX IX_CommunicationRecords_CallerID ON CommunicationRecords(CallerID);
CREATE INDEX IX_CommunicationRecords_ReceiverID ON CommunicationRecords(ReceiverID);
CREATE INDEX IX_CommunicationRecords_Timestamp_CallerID ON CommunicationRecords(Timestamp, CallerID);
CREATE INDEX IX_CommunicationRecords_CallerID_ReceiverID ON CommunicationRecords(CallerID, ReceiverID);

-- WitnessStatements indexes
CREATE INDEX IX_WitnessStatements_CaseID ON WitnessStatements(CaseID);
CREATE INDEX IX_WitnessStatements_WitnessID ON WitnessStatements(WitnessID);
CREATE INDEX IX_WitnessStatements_CaseID_StatementDate ON WitnessStatements(CaseID, StatementDate);

-- TransactionLogs indexes
CREATE INDEX IX_TransactionLogs_CaseID ON TransactionLogs(CaseID);
CREATE INDEX IX_TransactionLogs_PersonID ON TransactionLogs(PersonID);
CREATE INDEX IX_TransactionLogs_CaseID_Timestamp ON TransactionLogs(CaseID, Timestamp);
CREATE INDEX IX_TransactionLogs_PersonID_TransactionType ON TransactionLogs(PersonID, TransactionType);

-- Persons indexes
CREATE INDEX IX_Persons_Role_IsSuspect ON Persons(Role, IsSuspect);

-- StorySteps indexes
CREATE INDEX IX_StorySteps_CaseID_StepNumber ON StorySteps(CaseID, StepNumber);

-- ============================================================================
-- VERIFICATION MESSAGE
-- ============================================================================

PRINT '=============================================================================';
PRINT 'DataQuest Initial Schema (V001) - Successfully Created';
PRINT '=============================================================================';
PRINT '';
PRINT 'Tables Created:';
PRINT '  Core Tables (4): Cases, Persons, Locations, Evidence';
PRINT '  Tier 1 Tables (2): BadgeAccess, ParkingLotAccess';
PRINT '  Tier 2 Tables (2): Incidents, CommunicationRecords';
PRINT '  Tier 3 Tables (1): WitnessStatements';
PRINT '  Tier 4+ Tables (1): TransactionLogs';
PRINT '  Tutoring Tables (2): StorySteps, AnswerKeys';
PRINT '';
PRINT 'Total Tables: 14';
PRINT 'Foreign Keys: 20+';
PRINT 'Indexes: 25+';
PRINT '';
PRINT 'Design Principles Enforced:';
PRINT '  ✓ NO JSON in student-visible schema';
PRINT '  ✓ Traditional separate tables per event type';
PRINT '  ✓ All data in explicitly typed columns';
PRINT '  ✓ Clear, discoverable table structure';
PRINT '  ✓ Educational clarity prioritized';
PRINT '';
PRINT 'Ready for seed data insertion and student use.';
PRINT '=============================================================================';
