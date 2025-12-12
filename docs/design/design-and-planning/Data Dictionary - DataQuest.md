Documenting the database structure is crucial for the **Database Agent (US-04)** and the  **Case Planner Agent (US-07)** . Below is the **Data Dictionary** and a conceptual representation of the **Logical Data Model** using  **Crow's Foot Notation** , which will serve as the blueprint for the DataQuest database.

---

## 💾 Data Dictionary (Logical Model)

The Data Dictionary defines the purpose, constraints, and data types for all core entities (tables) in the DataQuest system.

### Core Investigative Entities

| **Table**         | **Column Name** | **Data Type** | **Key/Constraint** | **Definition / Business Rule**                     |
| ----------------------- | --------------------- | ------------------- | ------------------------ | -------------------------------------------------------- |
| **Cases**         | `CaseID`            | `INT`             | PK, Not Null             | Unique identifier for the investigation.                 |
|                         | `CaseTitle`         | `VARCHAR(100)`    | Not Null                 | Narrative title of the case.                             |
|                         | `InitialPrompt`     | `VARCHAR(MAX)`    | Not Null                 | The starting story prompt for the student.               |
|                         | `Conclusion`        | `VARCHAR(MAX)`    | Nullable                 | The resolved narrative upon solving the case.            |
| **Persons**       | `PersonID`          | `INT`        | PK, Not Null  | Unique ID for any individual (suspect, witness, victim). |
|         | `FirstName`         | `VARCHAR(50)`     | Not Null     | First name of the person.         |
| | `LastName` | `VARCHAR(50)`     | Not Null    | Last name of the person.  |
|       | `Role`              | `VARCHAR(50)`     | Not Null         | E.g., 'Suspect', 'Witness', 'Victim'.   |
|   | `IsSuspect`         | `BIT`       | Not Null                 | Boolean flag (0=No, 1=Yes).      |
| **Locations**     | `LocationID`        | `INT`             | PK, Not Null             | Unique ID for a physical place.                          |
|                         | `Name`              | `VARCHAR(100)`    | Not Null                 | E.g., 'Warehouse A', 'Cafe Corner'.                      |
|                         | `Address`           | `VARCHAR(255)`    | Not Null                 | Physical location for mapping.                           |
| **Relationships** | `RelationshipID`    | `INT`             | PK, Not Null             | Unique ID for the relationship link.                     |
|                         | `PersonID_A`        | `INT`             | FK to Persons            | The first person in the relationship.                    |
|                         | `PersonID_B`        | `INT`             | FK to Persons            | The second person in the relationship.                   |
|                         | `Type`              | `VARCHAR(50)`     | Not Null                 | E.g., 'Coworker', 'Sibling', 'Acquaintance'.             |

### Evidence and Log Data

| **Table**             | **Column Name** | **Data Type** | **Key/Constraint** | **Definition / Business Rule**                       |
| --------------------------- | --------------------- | ------------------- | ------------------------ | ---------------------------------------------------------- |
| **Evidence**          | `EvidenceID`        | `INT`             | PK, Not Null             | Unique ID for a piece of evidence.                         |
|                             | `CaseID`            | `INT`             | FK to Cases, Not Null    | Links evidence to a specific case.                         |
|                             | `LocationID`        | `INT`             | FK to Locations          | Where the evidence was found.                              |
|                             | `Type`              | `VARCHAR(50)`     | Not Null                 | E.g., 'CCTV_Log', 'Financial_Record'.                      |
|                             | `TimestampFound`    | `DATETIME2`       | Not Null                 | Date and time the evidence was collected.                  |
| **WitnessStatements** | `StatementID`       | `INT`             | PK, Not Null             | Unique ID for a statement.                                 |
|                             | `CaseID`            | `INT`             | FK to Cases, Not Null    | Links statement to a case.                                 |
|                             | `PersonID`          | `INT`             | FK to Persons, Not Null  | The person who provided the statement.                     |
|                             | `StatementText`     | `VARCHAR(MAX)`    | Not Null                 | The full text of the witness account.                      |
| **TransactionLogs**   | `LogID`             | `INT`             | PK, Not Null             | Unique ID for a transaction or access event.               |
|                             | `PersonID`          | `INT`             | FK to Persons, Nullable  | The person who executed the transaction/access (if known). |
|                             | `Timestamp`         | `DATETIME2`       | Not Null                 | The exact time of the logged event (critical for joins).   |
|                             | `Amount`            | `DECIMAL(10, 2)`  | Nullable                 | Financial amount, if applicable.                           |

### AI and Tutoring Control

| **Table**      | **Column Name**  | **Data Type** | **Key/Constraint**   | **Definition / Business Rule**                            |
| -------------------- | ---------------------- | ------------------- | -------------------------- | --------------------------------------------------------------- |
| **StorySteps** | `StepID`             | `INT`             | PK, Not Null               | Sequential order of the steps within a case.                    |
|                      | `CaseID`             | `INT`             | FK to Cases, Not Null      | The case this step belongs to.                                  |
|                      | `StepPrompt`         | `VARCHAR(MAX)`    | Not Null                   | The investigative question presented to the student.            |
|                      | `CanonicalQuery`     | `VARCHAR(MAX)`    | Not Null                   | The correct SQL query for the Tutor Agent (US-05).              |
| **AnswerKeys** | `AnswerKeyID`        | `INT`             | PK, Not Null               | Unique ID for the canonical answer.                             |
|                      | `StepID`             | `INT`             | FK to StorySteps, Not Null | The step this answer corresponds to.                            |
|                      | `ExpectedResultHash` | `VARCHAR(64)`     | Not Null                   | Hash of the canonical result set for comparison.                |
|                      | `ExpectedClueValue`  | `VARCHAR(MAX)`    | Not Null                   | The specific text/number clue the student must find to proceed. |

---

## 🗺️ Logical Data Model (Crow's Foot Notation)

The Logical Data Model below visually represents the tables and their required cardinality. This structure is essential for the **Database Agent** to explain joins and for the **Case Planner Agent** to build complex, multi-table queries.

### Key Relationships and Cardinality

| **Relationship**                            | **Cardinality (Minimum**                                | **Maximum)**                                                                                                                                                  | **Interpretation** |
| ------------------------------------------------- | ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| **Cases**$\to$**StorySteps**        | (1**$\mid$**Many)**$\to$**(1**$\mid$**Many) | A**Case** *must*have**one or more** `StorySteps`. A `StoryStep` *must*belong to**exactly one** `Case`.                                  |                          |
| **StorySteps**$\to$**AnswerKeys**   | (1**$\mid$**Many)**$\to$**(1**$\mid$**One)  | A**StoryStep** *must*have**exactly one** `AnswerKey`. An `AnswerKey` *must*map to**exactly one** `StoryStep`.                           |                          |
| **Cases**$\to$**Persons**           | (1**$\mid$**Many)**$\to$**(0**$\mid$**Many) | A**Case**involves**zero or more** `Persons`. A `Person` *may*be involved in**zero or more** `Cases`. (Implicit join via logs/statements). |                          |
| **Persons**$\to$**TransactionLogs** | (1**$\mid$**Many)**$\to$**(0**$\mid$**Many) | A**Person** *may*be responsible for**zero or more** `TransactionLogs`. A `TransactionLog` *may*be linked to**zero or one** `Person`.    |                          |

# 📋 Data Dictionary - DataQuest: SQL Detective

**Version:** 2.0 (Updated for Traditional Approach - 12/5/2025)  
**Last Updated:** December 5, 2025  
**Status:** UPDATED FOR TRADITIONAL TABLE APPROACH  
**Scope:** DataQuest student-facing database schema

---

## 🎯 DESIGN PHILOSOPHY UPDATE

**CRITICAL CHANGE:** This data dictionary now reflects the **Traditional Separate Tables Approach**.

### What Changed:
- ✅ **NO JSON** in student-visible schema
- ✅ **Separate tables** for each event type (BadgeAccess, ParkingLotAccess, Incidents, etc.)
- ✅ **Clear table names** that communicate purpose
- ✅ **Educational clarity** is the primary design principle
- ✅ **Tier-specific tables** for natural skill progression

### What Students See:
```
Students query: SELECT * FROM BadgeAccess WHERE AccessTime = '2025-11-14'
Students don't see: JSON_VALUE(), polymorphic designs, or hidden complexity
```

---

## 📊 CORE TABLES (All Tiers - Foundation)

### Cases Table
```sql
| Column Name    | Data Type     | Constraints      | Definition / Business Rule      |
|----------------|---------------|--------------------|------------------------------------------------------|
| CaseID         | INT           | PK, Not Null   | Unique identifier for the investigation  |
| CaseTitle      | NVARCHAR(255) | Not Null           | Name of the case (e.g., "Missing Badge Access")     |
| CaseDescription| NVARCHAR(MAX) | Nullable      | Detailed description of the case scenario            |
| DifficultyTier | INT     | Not Null, 1-5      | Tier level (1=Foundation, 5=Director)         |
| CreatedAt      | DATETIME2     | Not Null, Default  | When case was created (for auditability)    |
| IsActive       | BIT        | Not Null           | Whether case is available for students              |
```

### Persons Table
```sql
| Column Name | Data Type     | Constraints  | Definition / Business Rule         |
|-------------|---------------|--------------|---------------------------------------------------------------|
| PersonID | INT        | PK, Not Null | Unique ID for any individual (suspect, witness, victim)      |
| FirstName   | NVARCHAR(100) | Not Null     | Person's first name        |
| LastName    | NVARCHAR(100) | Not Null     | Person's last name     |
| Role      | NVARCHAR(50)  | Not Null     | Role in investigation (Suspect, Witness, Victim, Employee)  |
| IsSuspect   | BIT     | Not Null| Boolean - is this person a suspect? (1=Yes, 0=No)      |
| Affiliation | NVARCHAR(100) | Nullable     | Organization/company (if applicable)            |
| CreatedAt   | DATETIME2 | Not Null | When record created (for auditability)            |

UNIQUE CONSTRAINT: No duplicates on (FirstName, LastName, Role)
```

### Locations Table
```sql
| Column Name  | Data Type      | Constraints  | Definition / Business Rule          |
|--------------|----------------|--------------|------------------------------------------------------|
| LocationID   | INT  | PK, Not Null | Unique ID for a physical place         |
| Name         | NVARCHAR(255)  | Not Null     | Location name (e.g., "Server Room 4th Floor") |
| Address   | NVARCHAR(255)  | Nullable     | Street address   |
| Zone| NVARCHAR(50)   | Nullable | Geographic/building zone (e.g., "Downtown", "Parking Lot A") |
| BuildingType | NVARCHAR(100)  | Nullable     | Type of building (Office, Parking, Warehouse, etc.) |
| Latitude     | DECIMAL(9,6)   | Nullable   | Geographic latitude (future use)     |
| Longitude    | DECIMAL(9,6)   | Nullable   | Geographic longitude (future use)     |
| CreatedAt    | DATETIME2      | Not Null     | When record created       |

UNIQUE CONSTRAINT: Location names must be unique
```

### Evidence Table
```sql
| Column Name    | Data Type      | Constraints      | Definition / Business Rule  |
|----------------|----------------|------------------|---------------------------------------------------------|
| EvidenceID   | INT      | PK, Not Null     | Unique ID for a piece of evidence  |
| CaseID         | INT | FK, Not Null     | Case this evidence belongs to     |
| LocationID     | INT       | FK, Nullable     | Where evidence was found              |
| Description    | NVARCHAR(MAX)  | Not Null    | Detailed description of the evidence  |
| EvidenceType   | NVARCHAR(100)  | Not Null         | Type (Document, Physical, Digital, etc.)            |
| Value          | DECIMAL(10,2)  | Nullable         | Monetary or importance value          |
| TimestampFound | DATETIME2      | Not Null         | When evidence was discovered (critical for joins)    |
| CreatedAt      | DATETIME2      | Not Null         | When record created          |

FOREIGN KEY: CaseID → Cases(CaseID)
FOREIGN KEY: LocationID → Locations(LocationID)
INDEX: (CaseID, TimestampFound) for time-based queries
```

---

## 📊 TIER 1 TABLES (Foundation - Cases 1.1 & 1.2)

### BadgeAccess Table
**Purpose:** Track badge swipe access records (server rooms, secure areas)  
**Student Query Examples:**
```sql
-- Find all badge access records from a specific date
SELECT * FROM BadgeAccess WHERE CaseID = 1 AND CAST(AccessTime AS DATE) = '2025-11-14'

-- Find who accessed a specific location
SELECT ba.*, p.FirstName, p.LastName FROM BadgeAccess ba
JOIN Persons p ON ba.PersonID = p.PersonID
WHERE ba.LocationID = 3 ORDER BY ba.AccessTime
```

```sql
| Column Name    | Data Type     | Constraints      | Definition / Business Rule       |
|----------------|---------------|-----------=--------|-----------------------------------------------------|
| AccessID       | INT     | PK, Not Null | Unique ID for this access event           |
| CaseID         | INT           | FK, Not Null     | Case this access record belongs to    |
| PersonID       | INT           | FK, Not Null     | Person who accessed    |
| LocationID     | INT      | FK, Not Null     | Secure location accessed|
| AccessTime     | DATETIME2     | Not Null         | Exact time of badge swipe   |
| AccessType     | NVARCHAR(50)  | Not Null| Entry or Exit (values: 'Entry', 'Exit')         |
| Status         | NVARCHAR(50)  | Not Null  | Successful or Failed (values: 'Successful', 'Failed', 'Denied') |
| BadgeID        | NVARCHAR(50)  | Nullable         | Badge number (if tracked separately)      |
| CreatedAt      | DATETIME2     | Not Null         | When record created   |

FOREIGN KEY: CaseID → Cases(CaseID)
FOREIGN KEY: PersonID → Persons(PersonID)
FOREIGN KEY: LocationID → Locations(LocationID)
INDEX: (CaseID, AccessTime) for badge activity analysis
INDEX: (PersonID, LocationID) for person-location correlation
```

### ParkingLotAccess Table
**Purpose:** Track parking lot gate events (entry/exit records)  
**Student Query Examples:**
```sql
-- Find all gate activity during specific time window
SELECT * FROM ParkingLotAccess 
WHERE LocationID = 5 AND EventTime BETWEEN '22:00:00' AND '07:00:00'
ORDER BY EventTime

-- Identify gate events during incident time
SELECT * FROM ParkingLotAccess 
WHERE LocationID = 5 AND EventTime BETWEEN '2025-11-14 02:00' AND '2025-11-14 06:00'
```

```sql
| Column Name    | Data Type     | Constraints      | Definition / Business Rule     |
|----------------|---------------|--------------------|-----------------------------------------------------|
| GateEventID    | INT           | PK, Not Null     | Unique ID for this gate event           |
| CaseID         | INT      | FK, Not Null     | Case this event belongs to             |
| LocationID     | INT           | FK, Not Null     | Parking lot location   |
| EventTime      | DATETIME2     | Not Null   | Exact time of gate activation  |
| EventType   | NVARCHAR(50)  | Not Null     | Gate entry or exit (values: 'GateEntry', 'GateExit')|
| VehicleID  | NVARCHAR(50)  | Nullable         | Vehicle plate or ID if recorded             |
| VehicleRecorded| BIT       | Not Null         | Whether vehicle was recorded by gate system        |
| Notes | NVARCHAR(MAX) | Nullable| Additional notes about gate event     |
| CreatedAt      | DATETIME2     | Not Null   | When record created           |

FOREIGN KEY: CaseID → Cases(CaseID)
FOREIGN KEY: LocationID → Locations(LocationID)
INDEX: (LocationID, EventTime) for gate activity analysis
INDEX: (CaseID, EventTime) for case timeline reconstruction
```

---

## 📊 TIER 2 TABLES (Relationship Exploration)

### Incidents Table
**Purpose:** Track crime incident reports  
**Student Query Examples:**
```sql
-- Find all theft incidents in downtown
SELECT * FROM Incidents 
WHERE IncidentType = 'Theft' AND LocationID IN (
  SELECT LocationID FROM Locations WHERE Zone = 'Downtown'
)

-- Analyze incidents by type and location
SELECT i.IncidentType, l.Name, COUNT(*) as IncidentCount
FROM Incidents i
JOIN Locations l ON i.LocationID = l.LocationID
GROUP BY i.IncidentType, l.LocationID, l.Name
ORDER BY IncidentCount DESC
```

```sql
| Column Name   | Data Type      | Constraints      | Definition / Business Rule |
|---------------|----------------|--------------------|-----------------------------------------------------|
| IncidentID    | INT            | PK, Not Null     | Unique ID for this incident      |
| CaseID   | INT        | FK, Not Null     | Case this incident belongs to       |
| IncidentType  | NVARCHAR(50)   | Not Null   | Type of incident (Theft, Vandalism, Assault, etc.) |
| IncidentDate  | DATETIME2      | Not Null| When incident occurred               |
| LocationID    | INT    | FK, Not Null     | Where incident occurred         |
| Description   | NVARCHAR(MAX)  | Not Null         | Detailed description of incident         |
| Severity | NVARCHAR(50)   | Nullable         | Severity level (High, Medium, Low)        |
| ReportedBy | INT      | FK, Nullable     | Person who reported incident          |
| CreatedAt     | DATETIME2   | Not Null         | When report was filed              |

FOREIGN KEY: CaseID → Cases(CaseID)
FOREIGN KEY: LocationID → Locations(LocationID)
FOREIGN KEY: ReportedBy → Persons(PersonID)
INDEX: (CaseID, IncidentDate) for timeline analysis
INDEX: (IncidentType, LocationID) for pattern analysis
```

### CommunicationRecords Table
**Purpose:** Track communications (phone calls, emails) between individuals  
**Student Query Examples:**
```sql
-- Find all phone calls involving suspects
SELECT cr.* FROM CommunicationRecords cr
JOIN Persons caller ON cr.CallerID = caller.PersonID
JOIN Persons receiver ON cr.ReceiverID = receiver.PersonID
WHERE (caller.IsSuspect = 1 OR receiver.IsSuspect = 1)
  AND cr.CommunicationType = 'Phone'
ORDER BY cr.Timestamp DESC

-- Analyze call patterns between two people
SELECT COUNT(*) as CallCount, 
       SUM(DATEDIFF(MINUTE, cr.Timestamp, cr.EndTime)) as TotalMinutes
FROM CommunicationRecords cr
WHERE cr.CallerID = 5 AND cr.ReceiverID = 8
  AND cr.CommunicationType = 'Phone'
```

```sql
| Column Name      | Data Type      | Constraints      | Definition / Business Rule           |
|------------------|----------------|--------------------|-----------------------------------------------------|
| RecordID         | INT| PK, Not Null     | Unique ID for this communication            |
| CaseID  | INT            | FK, Not Null     | Case this communication belongs to       |
| CallerID         | INT       | FK, Not Null     | Person who initiated communication     |
| ReceiverID       | INT    | FK, Not Null     | Person who received communication      |
| CommunicationType| NVARCHAR(50)   | Not Null   | Type (Phone, Email, SMS, etc.)        |
| Timestamp        | DATETIME2      | Not Null         | When communication occurred   |
| Duration         | INT            | Nullable  | Duration in seconds (for calls)       |
| Details     | NVARCHAR(MAX)  | Nullable      | Communication details or summary       |
| CreatedAt        | DATETIME2      | Not Null         | When record created       |

FOREIGN KEY: CaseID → Cases(CaseID)
FOREIGN KEY: CallerID → Persons(PersonID)
FOREIGN KEY: ReceiverID → Persons(PersonID)
INDEX: (Timestamp, CallerID) for temporal queries
INDEX: (CallerID, ReceiverID) for relationship queries
```

---

## 📊 TIER 3 TABLES (Data Quality & Pattern Recognition)

### WitnessStatements Table
**Purpose:** Track witness testimonies  
**Student Query Examples:**
```sql
-- Find all witness statements about a location
SELECT ws.* FROM WitnessStatements ws
WHERE ws.LocationID = 5 ORDER BY ws.StatementDate

-- Compare incident times with witness statements
SELECT i.IncidentID, i.IncidentDate, ws.StatementDate,
  DATEDIFF(HOUR, i.IncidentDate, ws.StatementDate) as HoursDifference
FROM Incidents i
LEFT JOIN WitnessStatements ws ON i.IncidentID = ws.IncidentID
WHERE i.CaseID = 2
```

```sql
| Column Name   | Data Type      | Constraints      | Definition / Business Rule       |
|---------------|----------------|--------------------|-----------------------------------------------------|
| StatementID   | INT          | PK, Not Null     | Unique ID for this statement       |
| CaseID        | INT  | FK, Not Null     | Case this statement belongs to          |
| WitnessID     | INT | FK, Not Null | Person giving statement        |
| LocationID    | INT  | FK, Nullable     | Location witness was reporting about       |
| StatementDate | DATETIME2      | Not Null         | When statement was given      |
| StatementText | NVARCHAR(MAX)  | Not Null   | Full text of witness statement  |
| Reliability   | NVARCHAR(50)   | Nullable       | Assessment of reliability (High, Medium, Low)      |
| CreatedAt     | DATETIME2      | Not Null     | When record created     |

FOREIGN KEY: CaseID → Cases(CaseID)
FOREIGN KEY: WitnessID → Persons(PersonID)
FOREIGN KEY: LocationID → Locations(LocationID)
INDEX: (CaseID, StatementDate) for timeline analysis
```

---

## 📊 TIER 4+ TABLES (Complex Orchestration)

### TransactionLogs Table
**Purpose:** Track financial transactions and system access logs  
**Student Query Examples:**
```sql
-- Find unauthorized access attempts
SELECT * FROM TransactionLogs 
WHERE TransactionType = 'UnauthorizedAccess' AND CaseID = 4
ORDER BY Timestamp DESC

-- Analyze transaction patterns
SELECT PersonID, COUNT(*) as TransactionCount,
  SUM(CASE WHEN Status = 'Failed' THEN 1 ELSE 0 END) as FailureCount
FROM TransactionLogs
WHERE CaseID = 4 AND Timestamp >= '2025-11-10'
GROUP BY PersonID
ORDER BY FailureCount DESC
```

```sql
| Column Name      | Data Type      | Constraints| Definition / Business Rule|
|------------------|----------------|--------------------|-----------------------------------------------------|
| LogID      | INT     | PK, Not Null     | Unique ID for this transaction/log       |
| CaseID           | INT            | FK, Not Null     | Case this log belongs to |
| PersonID         | INT      | FK, Nullable     | Person involved in transaction (if known)  |
| LocationID       | INT            | FK, Nullable     | Location where transaction occurred  |
| TransactionType  | NVARCHAR(50)   | Not Null         | Type of transaction or access attempt           |
| Status     | NVARCHAR(50)   | Not Null    | Success/Failure/Denied    |
| Amount           | DECIMAL(10,2)  | Nullable       | Financial amount, if applicable|
| Timestamp        | DATETIME2      | Not Null     | Exact time of transaction (critical for joins)    |
| Details          | NVARCHAR(MAX)  | Nullable     | Additional transaction details                |
| CreatedAt        | DATETIME2      | Not Null         | When record created         |

FOREIGN KEY: CaseID → Cases(CaseID)
FOREIGN KEY: PersonID → Persons(PersonID)
FOREIGN KEY: LocationID → Locations(LocationID)
INDEX: (CaseID, Timestamp) for time-based analysis
INDEX: (PersonID, TransactionType) for behavior analysis
```

---

## 📊 TUTORING CONTROL TABLES (All Tiers)

### StorySteps Table
**Purpose:** Sequential investigation steps for each case  

```sql
| Column Name  | Data Type      | Constraints      | Definition / Business Rule        |
|--------------|----------------|--------------------|-----------------------------------------------------|
| StepID       | INT     | PK, Not Null     | Unique ID for this investigation step             |
| CaseID       | INT  | FK, Not Null     | Case this step belongs to |
| StepNumber   | INT     | Not Null   | Sequence order within case (1, 2, 3...)|
| StepPrompt   | VARCHAR(MAX)   | Not Null    | Investigation question presented to student       |
| CanonicalQuery| VARCHAR(MAX)   | Not Null    | The correct SQL query solution           |
| ExpectedValue| VARCHAR(MAX)   | Not Null         | Expected result or clue value  |
| CreatedAt    | DATETIME2      | Not Null| When step was created       |

FOREIGN KEY: CaseID → Cases(CaseID)
INDEX: (CaseID, StepNumber) for step progression
```

### AnswerKeys Table
**Purpose:** Canonical answers for validating student queries  

```sql
| Column Name      | Data Type      | Constraints      | Definition / Business Rule                 |
|------------------|----------------|--------------------|-----------------------------------------------------|
| AnswerKeyID      | INT | PK, Not Null   | Unique ID for this answer key         |
| StepID           | INT     | FK, Not Null     | Step this answer key belongs to |
| ExpectedResultHash| VARCHAR(64)    | Not Null    | SHA-256 hash of canonical result set    |
| ExpectedClueValue| VARCHAR(MAX)  | Not Null         | Specific clue student must find        |
| CreatedAt        | DATETIME2      | Not Null      | When answer key was created         |

FOREIGN KEY: StepID → StorySteps(StepID)
```

---

## 🔗 RELATIONSHIP CARDINALITY DIAGRAM

```
TIER 1 & FOUNDATION:
┌─────────────────────────────────────────────────────┐
│ Cases (1:Many) StorySteps (1:One) AnswerKeys   │
│ Cases (1:Many) Persons                │
│ Cases (1:Many) Locations  │
│ Cases (1:Many) Evidence (Many:One) Locations    │
└─────────────────────────────────────────────────────┘

TIER 1 SPECIFIC:
┌─────────────────────────────────────────────────────┐
│ Cases (1:Many) BadgeAccess             │
│   BadgeAccess (Many:One) Persons          │
│   BadgeAccess (Many:One) Locations                 │
│         │
│ Cases (1:Many) ParkingLotAccess        │
│   ParkingLotAccess (Many:One) Locations            │
└─────────────────────────────────────────────────────┘

TIER 2:
┌─────────────────────────────────────────────────────┐
│ Cases (1:Many) Incidents     │
│   Incidents (Many:One) Locations     │
│   Incidents (Many:One) Persons (Reporter)          │
│          │
│ Cases (1:Many) CommunicationRecords   │
│   CommunicationRecords (Many:One) Persons (Caller) │
│   CommunicationRecords (Many:One) Persons (Receiver)│
└─────────────────────────────────────────────────────┘

TIER 3:
┌─────────────────────────────────────────────────────┐
│ Cases (1:Many) WitnessStatements          │
│   WitnessStatements (Many:One) Persons (Witness)   │
│   WitnessStatements (Many:One) Locations           │
└─────────────────────────────────────────────────────┘

TIER 4+:
┌─────────────────────────────────────────────────────┐
│ Cases (1:Many) TransactionLogs  │
│   TransactionLogs (Many:One) Persons               │
│   TransactionLogs (Many:One) Locations        │
└─────────────────────────────────────────────────────┘
```

---

## 📝 IMPORTANT NOTES FOR STUDENTS

### ✅ What You'll See in This Database:
- Clear, separate tables for different types of information
- Table names that describe what data they contain
- Straightforward column names that are easy to understand
- Natural relationships between tables using IDs

### ❌ What You Won't See:
- JSON data structures
- Polymorphic designs or event type classifiers
- Hidden or "magical" complexity
- Application-level architecture in your queries

### 🎓 Learning Progression:

**Tier 1:** Work with BadgeAccess and ParkingLotAccess - learn basic SQL  
**Tier 2:** Add Incidents and Communications - learn JOINs and aggregation  
**Tier 3:** Add WitnessStatements - handle data quality and NULL values  
**Tier 4+:** Add TransactionLogs - complex multi-table analysis  

---

## 📋 INDEX STRATEGY FOR PERFORMANCE

### Automatically Indexed (Primary Keys):
- All primary keys have automatic indexes

### Manually Indexed (Foreign Keys & Common Queries):
- BadgeAccess(CaseID, AccessTime)
- BadgeAccess(PersonID, LocationID)
- ParkingLotAccess(LocationID, EventTime)
- CommunicationRecords(Timestamp, CallerID)
- Persons(Role, IsSuspect)
- Incidents(CaseID, IncidentDate)
- TransactionLogs(PersonID, TransactionType)

---

**Data Dictionary Version:** 2.0 (Updated 12/5/2025)  
**Traditional Approach:** ✅ IMPLEMENTED  
**JSON in Student Schema:** ✅ NONE  
**Status:** ✅ READY FOR USE
