# 🎓 DATABASE DESIGN DECISION DOCUMENT

**Date:** December 5, 2025  
**Title:** Database Schema Architecture - Traditional Approach for Educational Clarity  
**Status:** ✅ FINAL DESIGN DECISION - APPROVED  
**Version:** 1.0

---

## 📋 EXECUTIVE SUMMARY

**DataQuest is FIRST AND FOREMOST a SQL teaching tool.**

This document formalizes the critical design decision to use a **Traditional Relational Approach** with **separate tables for distinct event types**, ensuring students learn SQL and relational database design without encountering JSON or other architectural complexities.

---

## 🎯 CORE DESIGN PRINCIPLE

### "JSON is Infrastructure, Not Curriculum"

**Definition:** JSON and other architectural patterns exist in the application layer and internal platform management, but **completely hidden** from the student-facing database schema.

**What Students See:** Clear, separate tables with explicit columns
**What Students Don't See:** JSON, polymorphic designs, event type classifiers, hidden complexity

**Result:** Students learn SQL through natural investigation, not through infrastructure patterns.

---

## ❌ REJECTED APPROACH: POLYMORPHIC DESIGN WITH JSON

### What Was Proposed:

```sql
-- Single Events table (REJECTED)
CREATE TABLE Events (
    EventID INT PRIMARY KEY,
    EventType NVARCHAR(50),        -- 'Access', 'Incident', 'Communication'
    EventData NVARCHAR(MAX),  -- JSON blob containing event-specific data
    ...
)

-- Student would need to write:
SELECT * FROM Events 
WHERE EventType = 'Access' 
  AND JSON_VALUE(EventData, '$.access_type') = 'BadgeSwipe'
```

### Why Rejected:

| Issue | Impact | Severity |
|-------|--------|----------|
| **Requires JSON parsing** | Students must learn JSON_VALUE(), JSON_QUERY() | High |
| **Obscures learning** | Focus shifts from SQL to infrastructure | High |
| **Unintuitive queries** | Not how databases are typically used | High |
| **Hides table structure** | Students can't discover data through schema browser | Medium |
| **Breaks textbook alignment** | Contradicts how SQL courses teach design | Medium |
| **Discourages exploration** | Students don't naturally browse schema | Medium |
| **Adds cognitive load** | Complexity distracts from case investigation | High |

**Decision: REJECTED** ❌ - Not appropriate for educational context

---

## ✅ APPROVED APPROACH: TRADITIONAL SEPARATE TABLES

### What Is Approved:

```sql
-- Tier 1: Separate, clear tables
CREATE TABLE BadgeAccess (
    AccessID INT PRIMARY KEY,
    PersonID INT FOREIGN KEY,
    LocationID INT FOREIGN KEY,
    AccessTime DATETIME2,
    AccessType NVARCHAR(50),      -- 'Entry', 'Exit'
    Status NVARCHAR(50)    -- 'Successful', 'Failed'
)

CREATE TABLE ParkingLotAccess (
 GateEventID INT PRIMARY KEY,
    LocationID INT FOREIGN KEY,
    EventTime DATETIME2,
    EventType NVARCHAR(50),     -- 'GateEntry', 'GateExit'
    VehicleRecorded BIT
)

-- Student writes intuitive SQL:
SELECT * FROM BadgeAccess WHERE AccessTime = '2025-11-14 14:15'
SELECT * FROM ParkingLotAccess WHERE LocationID = 2 AND EventTime BETWEEN '22:00' AND '07:00'
```

### Why Approved:

| Benefit | Impact | Importance |
|---------|--------|------------|
| **Crystal clear intent** | Table name communicates purpose | Critical |
| **Pure SQL learning** | Students focus on SQL, not parsing | Critical |
| **Discoverable schema** | Browse tables, understand data | Important |
| **Textbook alignment** | Matches how SQL is taught | Important |
| **Natural progression** | New tiers introduce new tables | Important |
| **Professional practice** | Real systems often separate concerns | Important |
| **Query performance** | No JSON parsing overhead | Technical |

**Decision: APPROVED** ✅ - Perfect for educational context

---

## 📊 TABLE ARCHITECTURE BY TIER

### Tier 1: Foundation & Safety

**Student Objectives:**
- Learn basic SELECT queries
- Understand WHERE filtering
- Discover table structure
- Build confidence

**Tables:**
```
Core (all tiers):
  ├─ Persons (suspects, witnesses, victims)
  ├─ Locations (places of interest)
  ├─ Cases (case metadata)
  └─ StorySteps + AnswerKeys (tutoring)

Tier 1 Specific:
  ├─ BadgeAccess (server room access - Case 1.1)
  └─ ParkingLotAccess (parking lot gate events - Case 1.2)
```

**Student Queries - Example:**
```sql
-- Case 1.1: Find missing badge access record
SELECT COUNT(*) FROM BadgeAccess 
WHERE CaseID = 1 AND CAST(AccessTime AS DATE) = '2025-11-15'

-- Case 1.2: Analyze parking lot gate activity
SELECT * FROM ParkingLotAccess 
WHERE LocationID = 5 
  AND CAST(EventTime AS TIME) BETWEEN '22:00:00' AND '07:00:00'
ORDER BY EventTime
```

**Why This Works:**
- ✅ Simple, direct table queries
- ✅ No complexity hiding data
- ✅ Natural SQL progression
- ✅ Clear table purposes

---

### Tier 2: Relationships & Patterns

**Student Objectives:**
- Learn JOIN operations
- Understand foreign keys
- Group and aggregate data
- Find patterns

**New Tables:**
```
  ├─ Incidents (crime reports)
  └─ CommunicationRecords (phone/email logs)
```

**Student Queries - Example:**
```sql
-- Find all phone calls involving suspects
SELECT cr.* FROM CommunicationRecords cr
JOIN Persons caller ON cr.CallerID = caller.PersonID
JOIN Persons receiver ON cr.ReceiverID = receiver.PersonID
WHERE (caller.IsSuspect = 1 OR receiver.IsSuspect = 1)
  AND cr.CommunicationType = 'Phone'
ORDER BY cr.Timestamp DESC

-- List all thefts by location
SELECT l.Name, COUNT(i.IncidentID) as TheftCount
FROM Incidents i
JOIN Locations l ON i.LocationID = l.LocationID
WHERE i.IncidentType = 'Theft'
GROUP BY l.LocationID, l.Name
ORDER BY TheftCount DESC
```

**Why This Works:**
- ✅ Natural JOIN patterns on FKs
- ✅ Clear relationships shown through table names
- ✅ Students learn GROUP BY naturally
- ✅ No hidden complexity in data

---

### Tier 3: Data Quality & Consistency

**Student Objectives:**
- Handle NULLs appropriately
- Detect data quality issues
- Validate consistency
- Find anomalies

**New Tables:**
```
  └─ WitnessStatements (witness testimonies)
```

**Student Queries - Example:**
```sql
-- Find locations with missing addresses
SELECT * FROM Locations WHERE Address IS NULL

-- Compare incident times with witness statements
SELECT i.IncidentID, i.IncidentDate, ws.StatementDate
FROM Incidents i
LEFT JOIN WitnessStatements ws ON i.IncidentID = ws.IncidentID
WHERE i.IncidentDate <> CAST(ws.StatementDate AS DATE)

-- Find incidents with unusual timing gaps
SELECT 
  i1.IncidentID as Incident1,
  i2.IncidentID as Incident2,
  DATEDIFF(MINUTE, i1.IncidentDate, i2.IncidentDate) as MinutesBetween
FROM Incidents i1
JOIN Incidents i2 ON i1.CaseID = i2.CaseID
  AND i1.IncidentID < i2.IncidentID
  AND DATEDIFF(MINUTE, i1.IncidentDate, i2.IncidentDate) BETWEEN 1 AND 60
```

**Why This Works:**
- ✅ Pure SQL data quality techniques
- ✅ NULL handling shown explicitly
- ✅ No hidden complexity
- ✅ Students learn common patterns

---

### Tier 4+: Advanced Analysis

**Student Objectives:**
- Complex multi-table orchestration
- Temporal analysis
- Pattern recognition across datasets
- Executive-level reporting

**New Tables:**
```
  └─ TransactionLogs (financial/system access)
  └─ [Additional specialized tables per case]
```

**Why This Works:**
- ✅ Each new table is a new learning opportunity
- ✅ Schema clearly communicates what data exists
- ✅ Students naturally discover relationships
- ✅ No "magic" or hidden complexity

---

## 🔐 JSON USAGE POLICY

### Where JSON Is ALLOWED (Hidden from Students):

```
✅ Application Configuration (Main DB)
  ├─ Case definitions stored as JSON metadata
  └─ Query feedback templates stored as JSON

✅ Platform Management (Main DB)
  ├─ Student session data (internal use only)
  ├─ Query submission history (internal logging)
  └─ Administrative settings

✅ Never Exposed to Student View
```

### Where JSON Is FORBIDDEN (Student-Facing Tables):

```
❌ NO JSON columns in student-visible schema
❌ NO EventData or similar polymorphic columns
❌ NO JSON_VALUE() or JSON_QUERY() in expected student queries
❌ NO JSON parsing required for case investigation
```

### Enforcement:

```
Schema Review:
  ├─ Every table in student-visible DB audited for JSON
  ├─ Every column checked for NVARCHAR(MAX) misuse
  ├─ Every foreign key verified as explicit (not polymorphic)
  └─ Documentation clearly marks "Student-Visible" vs "Internal"
```

---

## 📋 IMPLEMENTATION CHECKLIST

### Schema Design Phase:
- [ ] All student-facing tables use explicit columns (no JSON)
- [ ] Each event type gets its own table (BadgeAccess, ParkingLotAccess, Incidents, etc.)
- [ ] Foreign keys are explicit (no EventType field for polymorphism)
- [ ] Table names clearly communicate purpose
- [ ] Column names match case scenarios

### Documentation Phase:
- [ ] Data dictionary explains each table's purpose in student context
- [ ] ER diagram shows all relationships clearly
- [ ] Migration scripts include only student-visible schema
- [ ] Example queries show pure SQL (no JSON)

### Testing Phase:
- [ ] All Tier 1 case queries work without JSON
- [ ] All Tier 2 case queries use standard JOINs (no polymorphism)
- [ ] Schema browser shows clear, intuitive structure
- [ ] Student can discover tables and understand relationships

### Quality Assurance:
- [ ] Code review: No JSON in student schema
- [ ] Schema audit: All tables serve clear educational purpose
- [ ] Query validation: All canonical queries use pure SQL
- [ ] Documentation review: JSON usage clearly marked as "Internal Only"

---

## 🎓 EDUCATIONAL BENEFITS

### 1. Clarity & Intuition
```
Students see: "This is a BadgeAccess table - it must have badge access data"
Students don't see: Polymorphic complexity or hidden data structures
```

### 2. Discoverability
```
Students browse schema and naturally discover available tables
No guessing about what data is stored where
```

### 3. Learning Progression
```
Tier 1: Single table queries (SELECT, WHERE)
Tier 2: Multi-table JOINs
Tier 3: Complex filtering & aggregation
Tier 4+: Expert-level analysis
```

### 4. Real-World Alignment
```
Students learn how databases are actually designed
Not distracted by architectural patterns
Focus on SQL and investigation
```

---

## ⚖️ TRADE-OFFS

### What We Gain:
- ✅ Educational clarity
- ✅ Student focus on SQL
- ✅ Natural schema discovery
- ✅ Textbook alignment
- ✅ Professional practices

### What We Don't Get:
- ⚠️ Maximum code reuse (small trade-off)
- ⚠️ Extreme architectural flexibility (not needed for Phase 1)
- ⚠️ Minimal table count (good for students!)

**Verdict:** Trade-offs heavily favor educational clarity.

---

## 🚀 NEXT STEPS

1. **Schema Design Document** - Create complete table definitions
2. **SQL Creation Scripts** - Generate all CREATE TABLE statements
3. **Seed Data Scripts** - Create Tier 1 test data
4. **Migration Framework** - Version the schema as V001_InitialSchema.sql
5. **Data Dictionary** - Document every table for students

---

## ✅ APPROVAL & SIGN-OFF

**Design Decision:** Traditional Separate Tables Approach  
**JSON Usage:** Internal/Platform Only (Hidden from Students)  
**Student Focus:** Pure SQL Learning & Investigation  
**Status:** ✅ **APPROVED FOR IMPLEMENTATION**

**Key Principle:** "If students can see it, it must be SQL learning material. If it's infrastructure, hide it."

---

**Document Created:** December 5, 2025  
**Status:** ✅ FINALIZED - READY FOR IMPLEMENTATION  
**Next Phase:** Database Schema Creation

