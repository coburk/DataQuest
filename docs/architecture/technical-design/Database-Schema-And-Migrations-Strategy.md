# 📋 DATABASE SCHEMA & MIGRATIONS STRATEGY - TRADITIONAL APPROACH

**Status:** ✅ UPDATED FOR TRADITIONAL APPROACH (CHG-001 - 12/5/2025)  
**Version:** 2.0 - Traditional Separate Tables  
**Classification:** Critical - Required Before Phase 1 Launch

---

## 🎯 CRITICAL UPDATE - TRADITIONAL APPROACH CONFIRMED

**This document reflects the approved Traditional Approach design decision.**

### Key Changes:
- ✅ **Separate tables per event type** (no polymorphic JSON)
- ✅ **Educational clarity** added as CORE design principle
- ✅ **Tier 1 tables** fully documented (BadgeAccess, ParkingLotAccess)
- ✅ **Student-visible schema** contains ZERO JSON
- ✅ **Educational design** prioritized over architectural elegance

---

## 📋 DOCUMENT PURPOSE

This specification defines the complete database schema for DataQuest, including all tables, relationships, constraints, and the strategy for managing schema changes through migrations.

**This document enables:**
- ✅ Developers understand the complete data model
- ✅ Database initialization for new environments
- ✅ Schema evolution through migrations
- ✅ Performance through proper indexing
- ✅ Data integrity through constraints
- ✅ Query optimization through design

---

## 🎯 SCOPE

### What This Document Covers:
```
✅ Complete database schema (all tables, columns, types)
✅ Primary/foreign key relationships
✅ Constraints and validation rules
✅ Indexing strategy
✅ Migration strategy and versioning
✅ Seed data strategy
✅ Backup and recovery procedures
✅ Query optimization guidelines
✅ Tier progression and educational design
✅ Phase 1 deliverables and scope
```

### What This Document Does NOT Cover:
```
❌ Specific T-SQL syntax
❌ Advanced replication/sharding
❌ Data warehouse/OLAP
❌ Cloud-specific options
❌ JSON storage (not in student schema)
```

---

## 🗺️ DATABASE ARCHITECTURE

### Design Principles - WITH EDUCATIONAL CLARITY

```
1. Normalization (3NF)
   ├─ Reduces redundancy
   ├─ Maintains integrity
   └─ Supports query flexibility

2. Performance First
   ├─ Strategic denormalization where needed
   ├─ Proper indexing on foreign keys
   └─ Composite indices for common queries

3. Auditability
   ├─ CreatedAt, UpdatedAt timestamps
   ├─ CreatedBy, UpdatedBy tracking
   └─ Hard deletes only (no soft deletes)

4. Extensibility
   ├─ Room for additional fields
   ├─ New tables per tier progression
   └─ Versioning for case content

5. EDUCATIONAL CLARITY ⭐ NEW PRIMARY PRINCIPLE
   ├─ Separate tables for distinct event types
   ├─ NO polymorphic JSON structures
   ├─ Schema communicates investigation domains
   ├─ Each tier introduces new, discoverable tables
   └─ Students learn SQL naturally
```

### Two-Part Schema Design

```
PART 1: Student & Platform Management (Main DB - INTERNAL ONLY)
├─ Students, Student_Sessions, Student_Queries
├─ Query_Feedback, Audit_Log
└─ Note: JSON may exist here ONLY for application use

PART 2: Investigative Case Data (STUDENT-FACING - PURE RELATIONAL)
├─ Tier 1 Tables:
│  ├─ BadgeAccess (Case 1.1 - Badge access logs)
│  └─ ParkingLotAccess (Case 1.2 - Parking lot events)
├─ Tier 2 Tables:
│  ├─ Incidents (Crime reports)
│  └─ CommunicationRecords (Phone/email logs)
├─ Tier 3+ Tables:
│  ├─ WitnessStatements
│  ├─ TransactionLogs
│  └─ [Additional per tier]
└─ Supporting Tables (All Tiers):
   ├─ Cases, Persons, Locations, Evidence
   ├─ StorySteps, AnswerKeys
   └─ [All with EXPLICIT columns - NO JSON]
```

---

## 📊 COMPLETE TABLE ARCHITECTURE

### TIER 1: Foundation (Access Logs)

**BadgeAccess** - Badge swipe records for building access (Case 1.1)
```
Columns: AccessID (PK), CaseID (FK), PersonID (FK), LocationID (FK),
     AccessTime (DATETIME2), AccessType, Status, BadgeID
Indexes: (CaseID, AccessTime), (PersonID, LocationID)
```

**ParkingLotAccess** - Parking lot gate events (Case 1.2)
```
Columns: GateEventID (PK), CaseID (FK), LocationID (FK),
         EventTime (DATETIME2), EventType, VehicleID, VehicleRecorded
Indexes: (LocationID, EventTime), (CaseID, EventTime)
```

### TIER 2: Relationship Exploration

**Incidents** - Crime incident reports
```
Columns: IncidentID (PK), CaseID (FK), IncidentType, IncidentDate,
         LocationID (FK), Description, Severity, ReportedBy (FK)
Indexes: (CaseID, IncidentDate), (IncidentType, LocationID)
```

**CommunicationRecords** - Phone/email/SMS communications
```
Columns: RecordID (PK), CaseID (FK), CallerID (FK), ReceiverID (FK),
   CommunicationType, Timestamp (DATETIME2), Duration, Details
Indexes: (Timestamp, CallerID), (CallerID, ReceiverID)
```

### TIER 3: Data Quality

**WitnessStatements** - Witness testimonies
```
Columns: StatementID (PK), CaseID (FK), WitnessID (FK), LocationID (FK),
       StatementDate (DATETIME2), StatementText, Reliability
Indexes: (CaseID, StatementDate)
```

### TIER 4+: Complex Analysis

**TransactionLogs** - Financial/system access logs
```
Columns: LogID (PK), CaseID (FK), PersonID (FK), LocationID (FK),
         TransactionType, Status, Amount, Timestamp (DATETIME2), Details
Indexes: (CaseID, Timestamp), (PersonID, TransactionType)
```

### SUPPORTING TABLES (All Tiers)

**Cases** - Case definitions and metadata
```
Columns: CaseID (PK), CaseTitle, CaseDescription, DifficultyTier,
         CreatedAt (DATETIME2), IsActive (BIT)
```

**Persons** - Individuals (suspects, witnesses, victims)
```
Columns: PersonID (PK), FirstName, LastName, Role, IsSuspect (BIT),
         Affiliation, CreatedAt (DATETIME2)
Unique: (FirstName, LastName, Role)
```

**Locations** - Physical places of interest
```
Columns: LocationID (PK), Name, Address, Zone, BuildingType,
         Latitude, Longitude, CreatedAt (DATETIME2)
Unique: Name
```

**Evidence** - Physical evidence records
```
Columns: EvidenceID (PK), CaseID (FK), LocationID (FK), Description,
         EvidenceType, Value (DECIMAL), TimestampFound (DATETIME2)
Indexes: (CaseID, TimestampFound)
```

**StorySteps** - Investigation steps (tutoring)
```
Columns: StepID (PK), CaseID (FK), StepNumber, StepPrompt,
         CanonicalQuery, ExpectedValue, CreatedAt (DATETIME2)
Indexes: (CaseID, StepNumber)
```

**AnswerKeys** - Canonical query results (tutoring)
```
Columns: AnswerKeyID (PK), StepID (FK), ExpectedResultHash,
         ExpectedClueValue, CreatedAt (DATETIME2)
```

---

## 🔗 RELATIONSHIPS & CARDINALITY

```
Cases (1:Many) → StorySteps (1:One) → AnswerKeys
Cases (1:Many) → Persons
Cases (1:Many) → Locations
Cases (1:Many) → Evidence (Many:One) → Locations

TIER 1:
Cases (1:Many) → BadgeAccess
  ├─ BadgeAccess (Many:One) → Persons
  └─ BadgeAccess (Many:One) → Locations

Cases (1:Many) → ParkingLotAccess
  └─ ParkingLotAccess (Many:One) → Locations

TIER 2:
Cases (1:Many) → Incidents
  ├─ Incidents (Many:One) → Locations
  └─ Incidents (Many:One) → Persons (Reporter)

Cases (1:Many) → CommunicationRecords
  ├─ CommunicationRecords (Many:One) → Persons (Caller)
  └─ CommunicationRecords (Many:One) → Persons (Receiver)

TIER 3:
Cases (1:Many) → WitnessStatements
  ├─ WitnessStatements (Many:One) → Persons (Witness)
  └─ WitnessStatements (Many:One) → Locations

TIER 4+:
Cases (1:Many) → TransactionLogs
  ├─ TransactionLogs (Many:One) → Persons
  └─ TransactionLogs (Many:One) → Locations
```

---

## 📋 INDEXING STRATEGY

### Primary Indexes (Automatic)
- All primary keys automatically indexed

### Composite Indexes (Performance)
```
Tier 1:
  BadgeAccess: (CaseID, AccessTime), (PersonID, LocationID)
  ParkingLotAccess: (LocationID, EventTime), (CaseID, EventTime)

Tier 2:
  Incidents: (CaseID, IncidentDate), (IncidentType, LocationID)
  CommunicationRecords: (Timestamp, CallerID), (CallerID, ReceiverID)

Tier 3:
  WitnessStatements: (CaseID, StatementDate)

Tier 4+:
  TransactionLogs: (CaseID, Timestamp), (PersonID, TransactionType)

All Tiers:
  Persons: (Role, IsSuspect)
  Evidence: (CaseID, LocationID)
```

---

## 🔄 MIGRATION STRATEGY

### Version Control

```
Format: V[#]_[Description].sql
Examples:
  V001_InitialSchema.sql (Phase 1 - All core + Tier 1)
V002_AddTier2Tables.sql (Phase 1.1 - Incidents, Communications)
  V003_AddWitnessStatements.sql (Phase 1.2 - Tier 3)
  V004_AddTransactionLogs.sql (Phase 1.3 - Tier 4+)
```

### Execution Steps

```
1. Backup current database
2. Run migration scripts in order
3. Verify schema integrity
4. Update seed data if needed
5. Run regression tests
6. Document changes
```

---

## 💾 SEED DATA STRATEGY

### Phase 1 - Tier 1 Cases

**Case 1.1: "Missing Badge Access Record"**
```
├─ 5 Persons (employees, suspects)
├─ 3 Locations (offices, server rooms)
├─ 50+ BadgeAccess records
├─ 2 anomalies (missing/suspicious entries)
└─ Expected: Find the gap in access logs
```

**Case 1.2: "Downtown Parking Lot Theft"**
```
├─ 3 Locations (parking area, surrounding)
├─ 30+ ParkingLotAccess records
├─ 2 suspicious events (unauthorized access)
└─ Expected: Identify suspicious vehicle activity
```

### Seed Data Characteristics
```
✅ Realistic but minimal
✅ Sufficient for investigation
✅ Includes edge cases (NULLs, missing records)
✅ Allows pattern detection
✅ Pre-validated against canonical queries
```

---

## 🔐 NO JSON IN STUDENT SCHEMA - ABSOLUTE REQUIREMENT

### Critical Rule:
```
❌ NO JSON columns in ANY student-visible table
❌ NO JSON_VALUE() in expected student queries
❌ NO polymorphic event designs
❌ NO EventType classifiers
❌ NO hidden data structures
```

### Verification:
```
✅ Every column: explicit, descriptive name
✅ Every table: name communicates purpose
✅ Every relationship: explicit via FK
✅ Data: normalized (3NF)
✅ Queries: straightforward SQL, no parsing
```

---

## ✅ PHASE 1 DELIVERABLES

### Includes:
```
✅ Core tables (Cases, Persons, Locations, Evidence)
✅ Tier 1 tables (BadgeAccess, ParkingLotAccess)
✅ Tier 2 tables (Incidents, CommunicationRecords)
✅ Tutoring tables (StorySteps, AnswerKeys)
✅ All indexes and constraints
✅ Migration scripts (V001_InitialSchema.sql)
✅ Seed data for Tier 1 only
✅ ZERO JSON in student schema
```

### Does NOT Include:
```
❌ Tier 3+ tables (Phase 1.1+)
❌ Advanced indexing
❌ Partitioning/sharding
❌ Replication
❌ Encryption
❌ Soft deletes
```

---

## 📊 CONFIGURATION

### Connection Pooling
```
Min: 5, Max: 100
Timeout: 15 seconds
Lifetime: 300 seconds (recycle every 5 min)
```

### Transaction Isolation
```
Level: READ_COMMITTED (SQL Server default)
Rationale: Prevents dirty reads, maintains performance
```

### Backup Strategy
```
Frequency: Daily
Type: Full + transaction log backups
Retention: 30 days (dev), 90 days (prod)
Recovery: SIMPLE (dev), FULL (prod)
```

---

## 📝 IMPLEMENTATION NOTES

### For Database Architects:
- All tables follow 3NF normalization
- Strategic composite indexes
- No unnecessary denormalization
- Clear semantic naming
- Educational design prioritized

### For SQL Developers:
- Create in dependency order
- Enforce all FK constraints
- Create indexes after data load
- Run seed scripts after schema
- Verify with canonical queries

### For Students:
- Schema is discoverable
- Table names communicate purpose
- NO JSON or hidden complexity
- Relationships are explicit
- Queries are straightforward SQL

---

**Database Schema & Migrations Strategy:** Updated CHG-001 (12/5/2025)  
**Status:** ✅ READY FOR IMPLEMENTATION  
**Approach:** Traditional Separate Tables - Educational Clarity First  
**JSON in Student Schema:** ✅ ZERO  
**Tier 1 Complete:** ✅ BadgeAccess & ParkingLotAccess

