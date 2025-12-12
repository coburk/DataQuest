# 🔍 DATABASE GUIDELINES COMPREHENSIVE REVIEW - DESIGN DECISIONS FINALIZED

**Date:** December 5, 2025 - Morning  
**Status:** ✅ DESIGN APPROACH FINALIZED - TRADITIONAL APPROACH CONFIRMED  
**Objective:** Verify all database design guidelines before proceeding

---

## 🎯 CRITICAL DESIGN DECISION: TRADITIONAL APPROACH FOR EDUCATIONAL CLARITY

### Educational Philosophy

**This is FIRST AND FOREMOST a SQL teaching tool.**

- ✅ Students learn SQL through investigation
- ✅ Students learn relational database design through exploration
- ✅ Students learn query writing through solving cases
- ✅ **JSON is infrastructure, not curriculum**

**Core Principle:** Students should NEVER see, know about, or interact with JSON artifacts. All application complexity is hidden from the student-facing database.

---

## 📋 GUIDELINES REVIEW COMPLETED

I have systematically reviewed ALL database-related guidelines and documentation. Below is a comprehensive summary of what must be complied with.

---

## 🎯 CRITICAL GUIDELINES TO FOLLOW

### 1. CORE DOMAIN MODELS (From Core Domain Models.md)

**Primary Entity Classes:**

```
Case-Related Entities:
├─ Case (root container)
├─ Person (represents individuals - suspects, witnesses, victims)
├─ Location (physical settings/places of interest)
├─ EvidenceRecord (pieces of evidence or log entries)
└─ CommunicationRecord (logs of communication)

Control & Workflow Entities:
├─ CasePlan (root container for investigation)
├─ StoryStep (sequential tasks for students)
└─ AnswerKey (canonical answers for comparison)
```

**Key Properties Required:**

| Entity | MUST Include | Purpose |
|--------|--------------|---------|
| **Person** | `PersonID (PK)`, `FirstName`, `LastName`, `Role`, `IsSuspect (bool)` | Identify individuals in case |
| **Location** | `LocationID (PK)`, `Name`, `Address` | Track places of interest |
| **EvidenceRecord** | `EvidenceID (PK)`, `CaseID (FK)`, `LocationID (FK)`, `TimestampFound (DateTime)` | Link evidence to locations |
| **CommunicationRecord** | `RecordID (PK)`, `CallerID (FK)`, `ReceiverID (FK)`, `Timestamp (DateTime)` | Track communications |
| **StoryStep** | `StepID (PK)`, `CaseID (FK)`, `StepPrompt`, `CanonicalQuery`, `ExpectedValue` | Sequential case progression |
| **AnswerKey** | `AnswerKeyID (PK)`, `StepID (FK)`, `ExpectedResultHash`, `ExpectedClueValue` | Validate student answers |

---

### 2. TRADITIONAL EVENT TABLE APPROACH (Educational Priority)

#### Design Principle: Separate Tables by Event Type

**Instead of polymorphic design with JSON, use semantically clear, separate tables:**

```sql
-- BADGE ACCESS RECORDS (Tier 1, Case 1.1)
-- Students query: "Find all badge access records from yesterday"
-- No JSON, no EventType filtering, just simple SQL
BadgeAccess Table

-- PARKING LOT ACCESS (Tier 1, Case 1.2)
-- Students query: "When did the gate open during the break-in?"
-- Clear table name, straightforward columns
ParkingLotAccess Table

-- INCIDENTS (Tier 2+)
-- Students query: "List all thefts in downtown"
-- Traditional incident reporting structure
Incidents Table

-- COMMUNICATION RECORDS (Tier 2+)
-- Students query: "Find all calls between these two people"
-- Clear caller/receiver relationships
CommunicationRecords Table

-- WITNESS STATEMENTS (Tier 3+)
-- Students query: "What did the witness say about location X?"
-- Explicit structure, not hidden in JSON
WitnessStatements Table

-- TRANSACTION LOGS (Tier 4+)
-- Students query: "Find unauthorized access attempts"
-- Dedicated table for financial/access logs
TransactionLogs Table
```

**Why This Approach:**

✅ **Students see exactly what they're querying** - Table names match case scenarios  
✅ **No JSON parsing required** - Pure SQL learning  
✅ **Discoverable schema** - Browse available tables, understand data structure  
✅ **Textbook-aligned** - Follows relational database design principles  
✅ **Clear investigations** - Each table type maps to a case theme  
✅ **Natural progression** - Tiers introduce new tables (new concepts)  
✅ **No hidden complexity** - What students see is what they work with  

**Important:** JSON may exist in application layer, but NEVER in student-visible schema.

---

### 3. DATA DICTIONARY SPECIFICATIONS (From Data Dictionary - DataQuest.md)

**Required Table Structure:**

#### Crime Investigation Core Tables

```sql
Persons Table:
├─ PersonID (INT, PK, Not Null)
├─ FirstName (NVARCHAR(100), Not Null)
├─ LastName (NVARCHAR(100), Not Null)
├─ Role (NVARCHAR(50), Not Null) -- e.g., 'Suspect', 'Witness', 'Victim'
├─ IsSuspect (BIT, Not Null)
└─ CONSTRAINT: No duplicates on (FirstName, LastName, Role)

Locations Table:
├─ LocationID (INT, PK, Not Null)
├─ Name (NVARCHAR(255), Not Null)
├─ Address (NVARCHAR(255), Nullable)
├─ Zone (NVARCHAR(50), Nullable) -- e.g., 'Downtown', 'Parking Lot A'
├─ BuildingType (NVARCHAR(100), Nullable)
└─ CONSTRAINT: Name must be unique

Evidence Table:
├─ EvidenceID (INT, PK, Not Null)
├─ CaseID (INT, FK, Not Null)
├─ LocationID (INT, FK, Nullable)
├─ Description (NVARCHAR(MAX), Not Null)
├─ EvidenceType (NVARCHAR(100), Not Null)
├─ Value (DECIMAL(10,2), Nullable)
└─ TimestampFound (DATETIME2, Not Null)

CommunicationRecords Table:
├─ RecordID (INT, PK, Not Null)
├─ CallerID (INT, FK, Not Null → Persons)
├─ ReceiverID (INT, FK, Not Null → Persons)
├─ Timestamp (DATETIME2, Not Null)
├─ CommunicationType (NVARCHAR(50)) -- e.g., 'Phone', 'Email'
└─ Details (NVARCHAR(MAX), Nullable)
```

#### Tutoring Control Tables

```sql
StorySteps Table:
├─ StepID (INT, PK, Not Null)
├─ CaseID (INT, FK, Not Null)
├─ StepPrompt (VARCHAR(MAX), Not Null)
├─ CanonicalQuery (VARCHAR(MAX), Not Null) -- The correct SQL query
└─ ExpectedValue (VARCHAR(MAX), Not Null)

AnswerKeys Table:
├─ AnswerKeyID (INT, PK, Not Null)
├─ StepID (INT, FK, Not Null → StorySteps)
├─ ExpectedResultHash (VARCHAR(64), Not Null)
└─ ExpectedClueValue (VARCHAR(MAX), Not Null)
```

---

### 4. DATABASE SCHEMA & MIGRATIONS STRATEGY (From Database-Schema-And-Migrations-Strategy.md)

**Required Design Principles:**

```
✅ Normalization (3NF)
   └─ Reduces redundancy, maintains integrity, supports query flexibility

✅ Performance First
   └─ Strategic denormalization where needed
   └─ Proper indexing on foreign keys
   └─ Composite indices for common queries

✅ Auditability
   ├─ CreatedAt, UpdatedAt timestamps (on appropriate tables)
   ├─ CreatedBy, UpdatedBy tracking
   └─ Hard deletes only (no soft deletes - users cannot delete records)

✅ Extensibility
   ├─ Room for additional fields
   ├─ Room for new event-type tables as tiers progress
   └─ Versioning for case content

✅ EDUCATIONAL CLARITY (NEW PRINCIPLE)
   ├─ Separate tables for distinct event types
   ├─ NO polymorphic JSON structures visible to students
   ├─ Schema clearly communicates investigation domains
   └─ Each tier introduces new, discoverable tables
```

**Two-Part Schema Architecture:**

```
PART 1: Student & Platform Management (Main DB - INTERNAL ONLY)
├─ Students - Student profiles and progress
├─ Student_Sessions - Case session tracking
├─ Student_Queries - Query submissions and results
├─ Query_Feedback - AI tutor feedback
├─ Audit_Log - Security and compliance logging
└─ Note: JSON may exist here for application use, NOT visible to students

PART 2: Investigative Case Data (STUDENT-FACING - PURE RELATIONAL DESIGN)
├─ Tier 1 Tables:
│  ├─ BadgeAccess - Badge swipe records for server/building access
│  └─ ParkingLotAccess - Parking lot gate events
├─ Tier 2 Tables:
│  ├─ Incidents - Crime incident reports
│  └─ CommunicationRecords - Phone/email logs
├─ Tier 3+ Tables:
│  ├─ WitnessStatements - Witness testimonies
│  ├─ TransactionLogs - Financial/system access logs
│  └─ [New tables as tiers expand]
└─ Supporting Tables:
   ├─ Cases - Case metadata
   ├─ Persons - Individuals involved
   ├─ Locations - Physical locations
   ├─ Evidence - Physical evidence records
   ├─ StorySteps - Sequential investigation steps
   └─ AnswerKeys - Canonical query results
```

---

### 5. NAMING CONVENTIONS (From Naming Conventions Guide - DataQuest.md)

**SQL Server Database Naming Rules:**

```
Table Names: PascalCase (e.g., Persons, Locations, BadgeAccess, ParkingLotAccess)
Column Names:       PascalCase (e.g., PersonID, FirstName, AccessTime)
Foreign Keys:  ForeignKeyFormat = (FK_SourceTable_ReferencedTable)
Indexes:  IX_TableName_Columns (e.g., IX_BadgeAccess_AccessTime)
Constraints:        CK_TableName_ConstraintName
Primary Keys:  PK_TableName (implicit in SQL Server)
Stored Procedures:  sp_ActionNameEntityName (e.g., sp_GetPersonsByRole)
Views:   vw_DescriptiveViewName
Triggers:        trgAfterActionTable (e.g., trgAfterInsertPersons)

✗ NEVER USE IN STUDENT-FACING SCHEMA:
  └─ JSON columns or JSON_VALUE() functions
  └─ Polymorphic event designs
  └─ EventType classifiers requiring filtering
  └─ Anything that requires application-layer parsing

✗ SQL NAMING NEVER USE:
  └─ Hyphens in SQL names
  └─ Underscores to separate words (use PascalCase instead)
  └─ Reserved SQL keywords
  └─ Spaces or special characters
```

---

### 6. CARDINALITY & RELATIONSHIPS

**Required Relationships (From Data Dictionary):**

| Relationship | Cardinality | Interpretation |
|---|---|---|
| Cases → StorySteps | 1:Many | One case has one or more steps |
| StorySteps → AnswerKeys | 1:One | One step has exactly one answer key |
| Cases → Persons | 1:Many | One case involves zero or more persons |
| Cases → BadgeAccess | 1:Many | One case has many access records |
| Cases → ParkingLotAccess | 1:Many | One case has many parking lot events |
| Cases → Incidents | 1:Many | One case has many incidents |
| Persons → CommunicationRecords (Caller) | 1:Many | One person may be caller in many records |
| Persons → CommunicationRecords (Receiver) | 1:Many | One person may be receiver in many records |
| Evidence → Locations | Many:One | Many evidence items per location |
| Evidence → Cases | Many:One | Many evidence items per case |

---

### 7. DATA TYPES & CONSTRAINTS

**Standard Data Type Mappings:**

```
Identifiers:        INT (auto-increment) or GUID for StudentID
Text (Short):  NVARCHAR(max length needed) -- e.g., NVARCHAR(100)
Text (Long):        NVARCHAR(MAX) or VARCHAR(MAX)
Descriptions:       NVARCHAR(MAX) (supports Unicode)
Currency:           DECIMAL(10,2)
Timestamps:         DATETIME2 (precision to 100 nanoseconds)
Boolean:        BIT (1 = True, 0 = False)
Hash Values:   VARCHAR(64) for SHA-256, etc.

NULL Handling:
├─ Not Null: Required fields (IDs, names, foreign keys)
├─ Nullable: Optional fields (addresses, descriptions, nullable relationships)
└─ Defaults: Use where appropriate (e.g., GETUTCDATE() for timestamps)

IMPORTANT - NO JSON IN STUDENT SCHEMA:
├─ ✗ NO NVARCHAR(MAX) used for JSON storage in student tables
├─ ✗ NO JSON columns in student-visible schema
├─ ✓ ALL data in explicitly typed columns for clarity
```

---

### 8. INDEXING STRATEGY

**Required Indexes:**

```
PRIMARY KEY Indexes:
├─ All primary keys automatically indexed (SQL Server default)

FOREIGN KEY Indexes:
├─ All foreign keys MUST be indexed for JOIN performance
├─ Example: CREATE INDEX IX_BadgeAccess_CaseID ON BadgeAccess(CaseID)

COMMONLY QUERIED COLUMNS:
├─ Persons: LastName, FirstName, Role
├─ Locations: Name, Zone
├─ BadgeAccess: AccessTime, PersonID, LocationID
├─ ParkingLotAccess: EventTime, LocationID
├─ CommunicationRecords: CallerID, ReceiverID, Timestamp

COMPOSITE INDEXES (for common query patterns):
├─ BadgeAccess: (CaseID, AccessTime) for time-based queries
├─ ParkingLotAccess: (LocationID, EventTime) for gate activity
├─ Persons: (Role, IsSuspect) for role-based filtering
└─ CommunicationRecords: (Timestamp, CallerID) for temporal queries
```

---

### 9. PHASE 1 SCOPE LIMITATIONS

**What Phase 1 MUST Include:**

```
✅ Core tables: Persons, Locations, Evidence, CommunicationRecords, Cases
✅ Tier 1 tables: BadgeAccess, ParkingLotAccess
✅ Tutoring tables: StorySteps, AnswerKeys
✅ Basic relationships and foreign keys
✅ Primary indexes on all PKs and FKs
✅ Composite indexes for common query patterns
✅ Seed data for Tier 1 cases (Cases 1.1 & 1.2)
✅ Migration scripts for schema creation
✅ NO JSON in student-visible schema
```

**What Phase 1 Does NOT Include (Defer to Phase 2+):**

```
❌ Advanced partitioning strategies
❌ Replication or sharding
❌ Data warehouse/OLAP tables
❌ Historical/temporal tables (SYSTEM_TIME)
❌ Full-text search indexes
❌ Advanced security (encryption at rest, etc.)
❌ Soft deletes (hard deletes only)
❌ JSON columns in student-facing schema
```

---

## ✅ INDUSTRY BEST PRACTICES TO FOLLOW

### A. Normalization Level
```
Target: 3NF (Third Normal Form)
├─ No transitive dependencies
├─ Reduce data redundancy
└─ Maintain data integrity while supporting query flexibility
```

### B. Transaction Isolation Level
```
Recommended: READ_COMMITTED (SQL Server default)
├─ Prevents dirty reads
├─ Balances performance and safety
└─ Appropriate for educational application
```

### C. Connection Pooling
```
Min Pool Size: 5
Max Pool Size: 100
Connection Timeout: 15 seconds
Lifetime: 300 seconds (recycle every 5 minutes)
```

### D. Backup Strategy
```
Frequency: Daily (minimum)
Type: Full backup + transaction log backups
Retention: 30 days for development, 90 days for production
Recovery Model: FULL for production, SIMPLE for development
```

---

## ✅ EDUCATIONAL DESIGN PRINCIPLES (CRITICAL)

### JSON Usage - Application Layer Only

**JSON Storage Rules:**

```
❌ NEVER in student-visible schema
❌ NEVER in student queries
❌ NEVER in case data tables
✅ Only in application configuration (if needed)
✅ Only for internal platform management (Main DB)
✅ Completely hidden from student view
```

**Student Experience:**

```
Students see:    SELECT * FROM BadgeAccess WHERE PersonID = 5
Students do NOT see: SELECT * FROM Events WHERE JSON_VALUE(EventData, '$.person_id') = 5

Students query:      JOINs on CommunicationRecords (Caller, Receiver)
Students do NOT see: JSON parsing with JSON_QUERY()

Students explore:    DISTINCT values in CommunicationRecords.CommunicationType
Students do NOT see: Polymorphic event type filtering
```

---

## 🎯 TIER PROGRESSION - CLEAR TABLE INTRODUCTION

### Tier 1: Foundation
```
Available Tables: Persons, Locations, Cases
New Tables: BadgeAccess, ParkingLotAccess
Skills: Simple SELECT, WHERE, basic JOINs
```

### Tier 2: Relationship Exploration
```
Available Tables: [Tier 1] + Evidence
New Tables: Incidents, CommunicationRecords
Skills: Complex JOINs, GROUP BY, aggregation
```

### Tier 3: Data Quality & Pattern Recognition
```
Available Tables: [Tier 2]
New Tables: WitnessStatements
Skills: NULL handling, data validation, inconsistency detection
```

### Tier 4: Complex Orchestration
```
Available Tables: [Tier 3] + Relationships
New Tables: TransactionLogs
Skills: Multi-table orchestration, temporal analysis, CTEs
```

### Tier 5: Professional Analysis
```
Available Tables: [Tier 4]
New Tables: (Optional) SupplementalData
Skills: Executive analysis, ambiguity handling, statistical thinking
```

---

## 🚀 READINESS CHECKLIST FOR DATABASE SCHEMA DESIGN

### Design Principles ✅
- [x] 3NF normalization approach
- [x] Auditability with timestamps (CreatedAt, UpdatedAt)
- [x] Hard deletes only (no soft deletes)
- [x] Performance-first design philosophy
- [x] **EDUCATIONAL CLARITY AS PRIMARY PRINCIPLE**

### Core Entities ✅
- [x] Person entity with required fields
- [x] Location entity with required fields
- [x] Evidence entity with relationships
- [x] BadgeAccess entity (Tier 1, Case 1.1)
- [x] ParkingLotAccess entity (Tier 1, Case 1.2)
- [x] StorySteps and AnswerKeys for tutoring

### Relationships ✅
- [x] Cases 1:Many to StorySteps
- [x] StorySteps 1:One to AnswerKeys
- [x] Evidence Many:One to Cases
- [x] Evidence Many:One to Locations
- [x] BadgeAccess Many:One to Cases
- [x] ParkingLotAccess Many:One to Cases

### Naming & Conventions ✅
- [x] PascalCase for all table and column names
- [x] FK constraint naming: FK_SourceTable_ReferencedTable
- [x] Index naming: IX_TableName_Columns
- [x] NO JSON in student-visible schema

### Data Types ✅
- [x] INT for numeric IDs (auto-increment)
- [x] NVARCHAR for text fields (Unicode support)
- [x] DATETIME2 for all timestamps
- [x] DECIMAL(10,2) for currency
- [x] BIT for boolean flags
- [x] NO JSON columns in student schema

### Indexing ✅
- [x] All primary keys indexed (automatic)
- [x] All foreign keys indexed (manual, required)
- [x] Composite indexes on common query patterns
- [x] Indexes documented in design

### Scope ✅
- [x] Phase 1 includes core tables
- [x] Phase 1 includes Tier 1 specific tables
- [x] Phase 1 includes basic relationships
- [x] Advanced features deferred to Phase 2+
- [x] Seed data for Tier 1 cases only
- [x] NO JSON in student-visible schema

---

## 📊 COMPLIANCE SUMMARY

**All documentation reviewed:**
- ✅ Core Domain Models (entity requirements)
- ✅ Data Dictionary (table specifications)
- ✅ Database Schema & Migrations Strategy (design principles)
- ✅ Naming Conventions (naming rules)
- ✅ Case Design Examples (data requirements)
- ✅ **Educational Priority (NEW - JSON hidden from students)**

**Standards verified:**
- ✅ 3NF normalization
- ✅ Industry-standard data types
- ✅ Proper relationship cardinality
- ✅ Professional naming conventions
- ✅ Performance optimization guidelines
- ✅ **Traditional table approach for educational clarity**

**Status:** ✅ **READY TO PROCEED - TRADITIONAL APPROACH FINALIZED**

---

## 🎯 FINAL DESIGN DECISION SUMMARY

### ✅ APPROVED APPROACH: TRADITIONAL SEPARATE TABLES

- **Polymorphic Design:** ❌ REJECTED
- **JSON in Student Schema:** ❌ REJECTED  
- **EventType Classification:** ❌ NOT IN STUDENT VIEW
- **Traditional Separate Tables:** ✅ APPROVED

### Why:

1. **SQL is the curriculum** - Students learn SQL, not JSON parsing
2. **Clear and intuitive** - Table names tell the story
3. **Discoverable schema** - Browse tables, understand data structure
4. **Professional practice** - Real systems often separate event types
5. **Educational alignment** - Matches textbook examples
6. **Natural tier progression** - New tables introduce new concepts

### Application Layer:
- Can use JSON internally for platform management
- Students NEVER see, touch, or interact with JSON
- All complexity is behind the scenes

---

**Guidelines Review Complete:** December 5, 2025 - 11:30 AM  
**Design Approach Finalized:** December 5, 2025 - 12:00 PM  
**Compliance Level:** 100% (All guidelines identified, documented, and finalized)  
**Ready for Implementation:** ✅ **YES - PROCEED WITH SCHEMA CREATION**

