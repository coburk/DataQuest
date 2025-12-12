# 📋 DATABASE MIGRATION FRAMEWORK - DataQuest Phase 1

**Date:** December 5, 2025  
**Version:** 1.0  
**Status:** ✅ READY FOR IMPLEMENTATION  
**Location:** `sql/migrations/`

---

## 🎯 PURPOSE

This document defines the migration strategy, versioning system, and procedures for managing database schema changes throughout the DataQuest project lifecycle.

---

## 📁 MIGRATION FILE STRUCTURE

```
sql/
├── migrations/
│   ├── V001_InitialSchema.sql     # Phase 1 - Core schema + Tier 1 tables
│   ├── V001_SeedData_Tier1.sql      # Phase 1 - Case 1.1 & 1.2 data
│   ├── V002_AddTier2Tables.sql             # Phase 1.1 - Incidents, Communications
│   ├── V002_SeedData_Tier2.sql # Phase 1.1 - Tier 2 test cases
│   ├── V003_AddTier3Tables.sql           # Phase 1.2 - WitnessStatements
│   ├── V003_SeedData_Tier3.sql             # Phase 1.2 - Tier 3 test cases
│   ├── V004_AddTier4Tables.sql    # Phase 2 - TransactionLogs enhanced
│   ├── V004_SeedData_Tier4.sql             # Phase 2 - Tier 4 test cases
│   └── MIGRATION_LOG.txt     # Execution history
├── rollback/
│   ├── R001_DropInitialSchema.sql
│   ├── R002_DropTier2Tables.sql
│   └── [Rollback scripts as needed]
└── README.md          # This file
```

---

## 🔢 VERSIONING CONVENTION

### Format: `V[NUMBER]_[Description].sql`

**Examples:**
- `V001_InitialSchema.sql` - Phase 1 initial schema creation
- `V001_SeedData_Tier1.sql` - Phase 1 initial seed data
- `V002_AddTier2Tables.sql` - Phase 1.1 new tables
- `V002_SeedData_Tier2.sql` - Phase 1.1 seed data

### Numbering Rules:
- **Numbers are SEQUENTIAL:** V001, V002, V003, V004, etc.
- **Schema versions:** Odd numbers (V001, V003, V005...)
- **Data/seed versions:** Matching schema versions
- **Never reuse numbers:** Each migration is permanent record

### Naming Rules:
- Descriptive name after version number
- Use underscore to separate words
- PascalCase-Kebab format
- Example: `V003_AddWitnessStatementsAndIndexes.sql`

---

## 📋 MIGRATION EXECUTION PROCEDURE

### Phase 1 - Initial Deployment

**Step 1: Create Schema**
```sql
-- Execute: V001_InitialSchema.sql
-- Creates: 14 tables, 20+ foreign keys, 25+ indexes
-- Time: ~5 seconds
-- Expected Output: "DataQuest Initial Schema (V001) - Successfully Created"
```

**Step 2: Insert Seed Data**
```sql
-- Execute: V001_SeedData_Tier1.sql
-- Inserts: Case 1.1 (50+ badge records) + Case 1.2 (28+ gate records)
-- Time: ~2 seconds
-- Expected Output: "Seed Data - Phase 1 (Tier 1 Cases) Successfully Inserted"
```

**Step 3: Verify**
```sql
-- Verify Case 1.1 has 50+ records
SELECT COUNT(*) FROM BadgeAccess WHERE CaseID=1;
-- Expected: ~50 rows

-- Verify Case 1.2 has 28+ records
SELECT COUNT(*) FROM ParkingLotAccess WHERE CaseID=2;
-- Expected: ~28 rows

-- Verify Story Steps
SELECT COUNT(*) FROM StorySteps;
-- Expected: 4 rows (2 per case)

-- Verify Answer Keys
SELECT COUNT(*) FROM AnswerKeys;
-- Expected: 4 rows (2 per case)
```

---

## 🔄 MIGRATION ROLLBACK PROCEDURE

### If Migration Fails

**Option 1: Drop and Recreate**
```sql
-- Drop all tables (careful - this deletes data!)
DROP TABLE IF EXISTS AnswerKeys;
DROP TABLE IF EXISTS StorySteps;
DROP TABLE IF EXISTS TransactionLogs;
DROP TABLE IF EXISTS WitnessStatements;
DROP TABLE IF EXISTS CommunicationRecords;
DROP TABLE IF EXISTS Incidents;
DROP TABLE IF EXISTS ParkingLotAccess;
DROP TABLE IF EXISTS BadgeAccess;
DROP TABLE IF EXISTS Evidence;
DROP TABLE IF EXISTS Persons;
DROP TABLE IF EXISTS Locations;
DROP TABLE IF EXISTS Cases;

-- Then re-run: V001_InitialSchema.sql
```

**Option 2: Use Rollback Script**
```sql
-- Execute: R001_DropInitialSchema.sql
-- This safely removes schema without data loss of other objects
```

---

## 📊 CURRENT PHASE 1 MIGRATION STATE

**Status:** ✅ **READY FOR DEPLOYMENT**

### Included Migrations:

| File | Type | Status | Contains |
|------|------|--------|----------|
| V001_InitialSchema.sql | Schema | ✅ Ready | 14 tables, indexes, constraints |
| V001_SeedData_Tier1.sql | Data | ✅ Ready | Case 1.1 & 1.2 (78 records total) |

### Not Yet Created (Phase 1.1+):

| File | Type | Status | Contains |
|------|------|--------|----------|
| V002_AddTier2Tables.sql | Schema | 🔜 Planned | Incidents, CommunicationRecords enhancements |
| V002_SeedData_Tier2.sql | Data | 🔜 Planned | Tier 2 test case data |
| V003_AddTier3Tables.sql | Schema | 🔜 Planned | WitnessStatements enhancements |
| V003_SeedData_Tier3.sql | Data | 🔜 Planned | Tier 3 test case data |
| V004_AddTier4Tables.sql | Schema | 🔜 Planned | TransactionLogs enhancements |
| V004_SeedData_Tier4.sql | Data | 🔜 Planned | Tier 4 test case data |

---

## 📝 MIGRATION LOG FORMAT

Create `sql/migrations/MIGRATION_LOG.txt`:

```
========================================================================
DataQuest Database Migration Log
========================================================================

Migration: V001_InitialSchema.sql
Date: 2025-12-05
Executor: [Your Name]
Status: SUCCESS
Duration: ~5 seconds
Tables Created: 14
Foreign Keys: 20+
Indexes: 25+
Notes: Initial schema with all Phase 1 tables

Migration: V001_SeedData_Tier1.sql
Date: 2025-12-05
Executor: [Your Name]
Status: SUCCESS
Duration: ~2 seconds
Records Inserted: 78 total
  - BadgeAccess: 50+
  - ParkingLotAccess: 28+
  - Persons: 10
  - Locations: 6
  - StorySteps: 4
  - AnswerKeys: 4
Notes: Case 1.1 and 1.2 seed data inserted successfully

------------------------------------------------------------------------
```

---

## 🔐 DEPLOYMENT CHECKLIST

**Before Running V001_InitialSchema.sql:**
- [ ] Backup existing database (if applicable)
- [ ] Verify connection to target database
- [ ] Confirm no existing DataQuest tables
- [ ] Review schema for correctness

**After Running V001_InitialSchema.sql:**
- [ ] Verify all 14 tables created
- [ ] Verify all foreign keys in place
- [ ] Verify all indexes created
- [ ] Run verification query: `SELECT COUNT(*) FROM Cases;` (should return 0)

**Before Running V001_SeedData_Tier1.sql:**
- [ ] Schema successfully created
- [ ] All indexes in place
- [ ] Database connection active

**After Running V001_SeedData_Tier1.sql:**
- [ ] BadgeAccess has 50+ records
- [ ] ParkingLotAccess has 28+ records
- [ ] Persons has 10 records
- [ ] Locations has 6 records
- [ ] StorySteps has 4 records
- [ ] AnswerKeys has 4 records
- [ ] All story steps have associated answer keys

---

## 📚 FUTURE MIGRATIONS

### Phase 1.1 - Tier 2 Tables (Next Step)

**V002_AddTier2Tables.sql will:**
- Add enhancements to Incidents table (if needed)
- Add enhancements to CommunicationRecords (if needed)
- Create new indexes for Tier 2 optimization
- Estimated time: ~2 seconds

**V002_SeedData_Tier2.sql will:**
- Create new test cases for Tier 2
- Insert incident data
- Insert communication records
- Expected data: ~100+ records

### Phase 1.2 - Tier 3 Tables

**V003_AddTier3Tables.sql will:**
- Create WitnessStatements enhancements
- Add supporting indexes
- Estimated time: ~1 second

**V003_SeedData_Tier3.sql will:**
- Insert Tier 3 test case data
- Expected data: ~50+ records

### Phase 2 - Tier 4+ Tables

**V004_AddTier4Tables.sql will:**
- Enhance TransactionLogs table
- Add supporting indexes
- Estimated time: ~1 second

**V004_SeedData_Tier4.sql will:**
- Insert Tier 4+ test case data
- Expected data: ~200+ records

---

## ⚠️ IMPORTANT NOTES

### Database Backup
**CRITICAL:** Always backup database before running migrations:
```sql
-- SQL Server backup
BACKUP DATABASE DataQuest 
TO DISK = 'C:\Backups\DataQuest_Pre_Migration.bak'
WITH INIT, COMPRESSION;
```

### Data Integrity
All foreign key constraints are enforced. Cannot delete parent records without handling children first.

### Index Performance
Indexes are created AFTER tables are populated with seed data. This optimizes index creation.

### Development vs Production
- **Development:** Run all migrations sequentially
- **Production:** Apply migrations during maintenance windows only

---

## 📞 SUPPORT

For migration issues:
1. Check MIGRATION_LOG.txt for previous runs
2. Verify all prerequisites are met
3. Review error messages carefully
4. Rollback to last known good state if needed
5. Document issue and solution in MIGRATION_LOG.txt

---

**Migration Framework:** Version 1.0  
**Status:** ✅ READY  
**Last Updated:** December 5, 2025  
**Next Review:** After Phase 1 deployment

