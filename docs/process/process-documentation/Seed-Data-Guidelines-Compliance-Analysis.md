# Seed Data Analysis - Project Guidelines Compliance Review

**Date:** December 2, 2025  
**Reviewer:** Copilot Assistant  
**File Analyzed:** sql/seed_data.sql  
**Status:** ⚠️ ISSUES FOUND - Non-Compliant with Project Guidelines

---

## Executive Summary

The `seed_data.sql` file contains **SQL scripts that don't align with the project's Data Dictionary and naming conventions** as defined in:
- `docs/design-and-planning/Data Dictionary - DataQuest.md`
- `docs/design-and-planning/Naming Conventions Guide - DataQuest.md`

**Key Issues:**
1. ⚠️ Table names don't match Data Dictionary definitions
2. ⚠️ Column naming inconsistency (camelCase vs UPPER_CASE)
3. ⚠️ Missing required tables from Data Dictionary
4. ⚠️ Incorrect table structure and relationships

---

## Issue #1: Table Name Mismatch

### Current Implementation (seed_data.sql)
```sql
Person        -- Wrong: Singular
Location              -- Wrong: Singular
Evidence          -- Correct per dictionary
Communication  -- Wrong: Not in dictionary
Case    -- Wrong: Singular form
CaseStep      -- Wrong: Not matching dictionary
StudentQuery    -- Wrong: Not in dictionary
```

### Data Dictionary Definition
```
Cases      -- Correct: Plural, matches dictionary
Persons         -- Correct: Plural, matches dictionary
Locations           -- Correct: Plural, matches dictionary
Relationships       -- Missing from seed data
Evidence            -- Correct
WitnessStatements   -- Missing from seed data
TransactionLogs   -- Missing from seed data
StorySteps          -- Missing from seed data
AnswerKeys        -- Missing from seed data
```

**Guideline Reference:**
- Per Data Dictionary: All core tables use plural forms
- Current implementation uses mixed singular/plural naming

---

## Issue #2: Column Naming Inconsistency

### SQL Naming Convention in Data Dictionary

The Data Dictionary specifies these column naming patterns:

**Primary Keys:**
```sql
CaseID              -- Format: [TableName]ID (with caps ID)
PersonID
LocationID
EvidenceID
```

**Standard Columns:**
```sql
Name-- Format: PascalCase
Address             -- Format: PascalCase
Role        -- Format: PascalCase
Type       -- Format: PascalCase
Timestamp       -- Format: PascalCase
TimestampFound    -- Format: PascalCase with No underscores
StatementText       -- Format: PascalCase
```

### Current Implementation Issues

**In create_dataquest_db.sql:**
```sql
[PersonId]          -- Wrong: camelCase 'Id' instead of 'ID'
[LocationId]        -- Wrong: camelCase 'Id' instead of 'ID'
[CaseId]            -- Wrong: camelCase 'Id' instead of 'ID'
[CaseStepId]     -- Wrong: camelCase 'Id' instead of 'ID'
[FromPersonId]      -- Wrong: camelCase 'Id' instead of 'ID'
[ToPersonId]   -- Wrong: camelCase 'Id' instead of 'ID'
```

**Correct Format per Dictionary:**
```sql
[PersonID]          -- Correct: PascalCase with 'ID'
[LocationID]        -- Correct: PascalCase with 'ID'
[CaseID]   -- Correct: PascalCase with 'ID'
[CaseStepID]        -- Correct: PascalCase with 'ID'
[PersonID_A]        -- Per dictionary for relationships
[PersonID_B]        -- Per dictionary for relationships
```

---

## Issue #3: Missing Required Tables from Data Dictionary

### Tables in seed_data.sql
- ✅ Person (should be Persons)
- ✅ Location (should be Locations)
- ✅ Evidence (correct)
- ✅ Communication (not in dictionary)
- ✅ Case (should be Cases)
- ✅ CaseStep (should be StorySteps)
- ❌ StudentQuery (should be removed - not in dictionary)

### Tables in Data Dictionary NOT in seed_data.sql
- ❌ **Relationships** - Not seeded (required for Person-to-Person connections)
- ❌ **WitnessStatements** - Not seeded (required for case narrative)
- ❌ **TransactionLogs** - Not seeded (required for timelines)
- ❌ **AnswerKeys** - Not seeded (required for case solutions)

---

## Issue #4: Column Structure Mismatch

### Cases Table

**Current Implementation:**
```sql
CREATE TABLE [dbo].[Case] (
    [CaseId] INT,
    [CaseName] NVARCHAR(200),
    [CaseDescription] NVARCHAR(MAX),
 [CaseStatus] NVARCHAR(50),
    [Difficulty] NVARCHAR(50),
    ...
)
```

**Data Dictionary Specification:**
```sql
Cases:
  CaseID   - PK, Not Null, INT
  CaseTitle   - Not Null, VARCHAR(100)  [NOT CaseName]
  InitialPrompt    - Not Null, VARCHAR(MAX)  [NOT CaseDescription]
  Conclusion       - Nullable, VARCHAR(MAX)  [NOT CaseStatus/Difficulty]
```

**Issues:**
- ❌ Column name: `CaseName` should be `CaseTitle`
- ❌ Column name: `CaseDescription` should be `InitialPrompt`
- ❌ Column name: `CaseStatus` not in dictionary
- ❌ Column name: `Difficulty` not in dictionary
- ❌ Missing: `Conclusion` column

---

### Persons Table

**Current Implementation:**
```sql
CREATE TABLE [dbo].[Person] (
    [PersonId] INT,
    [FirstName] NVARCHAR(100),
 [LastName] NVARCHAR(100),
    [Gender] CHAR(1),
    [DateOfBirth] DATE,
    [Occupation] NVARCHAR(100),
    [PhoneNumber] NVARCHAR(20),
    [EmailAddress] NVARCHAR(100),
    ...
)
```

**Data Dictionary Specification:**
```sql
Persons:
  PersonID         - PK, Not Null, INT
  Name       - Not Null, VARCHAR(50)    [NOT FirstName/LastName]
  Role      - Not Null, VARCHAR(50)    [NOT Occupation]
  IsSuspect        - Not Null, BIT           [NEW FIELD]
```

**Issues:**
- ❌ Column name: `PersonId` should be `PersonID`
- ❌ Column structure: `FirstName`/`LastName` should be combined into `Name`
- ❌ Column removed: `Gender`, `DateOfBirth`, `Occupation` not in dictionary
- ❌ Column name: `PhoneNumber`/`EmailAddress` not in dictionary
- ❌ Missing: `Role` column (defining Suspect, Witness, Victim)
- ❌ Missing: `IsSuspect` column (BIT flag)

---

### Evidence Table

**Current Implementation:**
```sql
CREATE TABLE [dbo].[Evidence] (
[EvidenceId] INT,
    [EvidenceDescription] NVARCHAR(MAX),
    [EvidenceType] NVARCHAR(100),
    [FoundLocation] INT,
    [FoundDate] DATETIME2,
    [Chain] NVARCHAR(500),
    ...
)
```

**Data Dictionary Specification:**
```sql
Evidence:
  EvidenceID       - PK, Not Null, INT
  CaseID           - FK to Cases, Not Null, INT  [MISSING]
  LocationID       - FK to Locations, INT    [Different name in current]
  Type        - Not Null, VARCHAR(50)       [Different name/type]
  TimestampFound   - Not Null, DATETIME2     [Different name]
```

**Issues:**
- ❌ Column: `EvidenceId` should be `EvidenceID`
- ❌ Column name: `EvidenceDescription` not in dictionary
- ❌ Column name: `FoundLocation` should be `LocationID`
- ❌ Column name: `FoundDate` should be `TimestampFound`
- ❌ Column: `Chain` not in dictionary
- ❌ Missing: **CaseID** - Critical foreign key
- ❌ Type size too large (VARCHAR(100) vs VARCHAR(50))

---

## Issue #5: Incorrect Relationships

### Communication Table

**Current Implementation:**
```sql
CREATE TABLE [dbo].[Communication] (
    [CommunicationId] INT PRIMARY KEY,
    [FromPersonId] INT,
    [ToPersonId] INT,
    [CommunicationType] NVARCHAR(50),
    [CommunicationDateTime] DATETIME2,
    [MessageContent] NVARCHAR(MAX),
    ...
)
```

**Issue:** This table is NOT in the Data Dictionary. 

**What should exist instead:**
- **Relationships** table (for Person-to-Person connections)
- **TransactionLogs** table (for temporal evidence like calls/emails/access logs)

**Data Dictionary Relationships Table:**
```sql
Relationships:
  RelationshipID   - PK, Not Null, INT
  PersonID_A       - FK to Persons, Not Null, INT
  PersonID_B       - FK to Persons, Not Null, INT
  Type - Not Null, VARCHAR(50)
  [Comment: e.g., 'Coworker', 'Sibling', 'Acquaintance']
```

---

## SQL Naming Convention Violations

### Bracket Usage
**Current:** `[dbo].[TableName]` with brackets
**Correct:** Continue with brackets for SQL Server compatibility ✅

### Capitalization Pattern

| Element | Current | Dictionary | Correct? |
|---------|---------|------------|----------|
| Table Names | `Person`, `Location`, `Case` | `Persons`, `Locations`, `Cases` | ❌ Wrong |
| Column IDs | `PersonId`, `LocationId` | `PersonID`, `LocationID` | ❌ Wrong |
| Column Names | `CaseName`, `FirstName` | `CaseTitle`, `Name` | ❌ Wrong |
| Timestamps | `FoundDate`, `CreatedDate` | `TimestampFound`, `Timestamp` | ⚠️ Inconsistent |

---

## Recommendations

### Priority 1: CRITICAL - Fix Schema
1. ✅ Rename tables to match Data Dictionary (Person → Persons, etc.)
2. ✅ Rename columns to match Data Dictionary (CaseId → CaseID, etc.)
3. ✅ Remove non-dictionary tables (Communication, StudentQuery)
4. ✅ Add missing tables (Relationships, WitnessStatements, TransactionLogs, StorySteps, AnswerKeys)
5. ✅ Update column structures to match dictionary specifications

### Priority 2: HIGH - Update Seed Data
1. Update INSERT statements to use correct table names
2. Update column names in INSERT statements
3. Add seed data for missing tables
4. Ensure referential integrity (CaseID in Evidence, etc.)

### Priority 3: MEDIUM - Documentation
1. Update .md files in docs/design-and-planning/ to reflect final schema
2. Add schema migration notes
3. Document table-to-dictionary mapping

### Priority 4: LOW - Testing
1. Verify all FKs resolve correctly
2. Test all sample queries with new schema
3. Update agent prompts (Database Agent) to reflect new schema

---

## Files to Modify

1. **MUST UPDATE:**
   - `sql/create_dataquest_db.sql` - Fix all table/column names
   - `sql/seed_data.sql` - Update INSERT statements

2. **SHOULD UPDATE:**
   - `docs/design-and-planning/Data Dictionary - DataQuest.md` - Add create scripts
   - Documentation files - Reflect final schema decisions

3. **MAY UPDATE:**
 - `.editorconfig` - Add SQL naming conventions
   - Project analysis documents

---

## Validation Checklist

- [ ] All table names match Data Dictionary (plural forms)
- [ ] All column IDs use format `[TableName]ID` (not `Id`)
- [ ] All table names and columns conform to PascalCase
- [ ] No columns exist outside Data Dictionary scope
- [ ] All foreign keys are properly defined
- [ ] Seed data aligns with schema
- [ ] Referential integrity is maintained
- [ ] Sample data is realistic and suitable for cases

---

**Analysis Completed:** December 2, 2025  
**Status:** ⚠️ NON-COMPLIANT - Requires corrections before merge
**Next Steps:** Implement Priority 1 recommendations

