# Case Design Template and Examples Specification

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - CRITICAL PATH  
**Version:** 1.0  
**Classification:** Binding Implementation Standard

---

## 📋 Document Purpose

This specification provides the definitive template for designing DataQuest cases and includes five complete example cases (one per tier). It operationalizes case design principles into concrete, reusable patterns that enable consistent, high-quality case creation.

**This document enables:**
- ✅ Content creators to design cases without ambiguity
- ✅ QA to validate cases against clear criteria
- ✅ Developers to understand case structure
- ✅ Phase 2 expansion with confidence

---

## 🎯 Scope

### What This Document Covers

```
✅ Case design philosophy and principles
✅ Case structure template (JSON/data model)
✅ Tier-specific case characteristics
✅ Contradiction design patterns
✅ Red herring design patterns
✅ Evidence and timeline patterns
✅ Story progression guidelines
✅ Prompt writing guidelines
✅ Question design patterns
✅ 5 complete example cases (Tier 1-5)
✅ Case validation checklist
✅ Performance guidelines
```

### What This Document Does NOT Cover

```
❌ UI/UX implementation (see UI/UX Specification)
❌ State management (see Case Lifecycle)
❌ Agent implementation (see Agent Specifications)
❌ Service layer (see API Architecture)
```

---

## 🏗️ Case Design Philosophy

### Core Principle: Support Investigation, Not Just Teach

```
NOT: "Here's how to use WHERE clauses. Write a query to..."
BUT: "A customer reports a code wasn't recorded. 
     Find all missing codes in the system."

PRINCIPLE: Cases are investigations, not lessons
Students learn by solving meaningful problems
```

### Case Anatomy

```
EVERY CASE HAS:

1. INVESTIGATION GOAL
   └─ What is the student trying to discover?
   
2. CONTEXT/NARRATIVE
   └─ Why does this investigation matter?
   
3. INVESTIGATION STEPS (Questions)
   ├─ Step 1: Foundation
   ├─ Step 2: Deeper
   └─ Step 3: Resolution or Pattern
   
4. EVIDENCE LAYER
├─ Data in tables
   ├─ Data quality issues (intentional)
   └─ Contradictions or patterns
   
5. LEARNING OBJECTIVE
   ├─ SQL concepts practiced
   ├─ Data thinking concepts
   └─ Investigation skills
```

---

## 📊 Case Design Template

### Case Structure (JSON Schema)

```json
{
  "caseId": "case_001",
  "caseName": "The Missing Code",
  "tier": "Junior Data Analyst",
  "estimatedMinutes": 15,
  "difficulty": "simple",
  
  "narrative": {
    "title": "Investigation Title",
    "context": "Why this matters...",
    "summary": "One-line summary for case selection",
    "background": "Longer context for the student"
  },
  
  "learningObjectives": [
    "SQL Concept 1: SELECT specific columns",
    "SQL Concept 2: WHERE clause filtering",
  "Data Concept 1: Understanding data completeness",
    "Investigation Skill 1: Finding missing data"
  ],
  
  "investigationGoal": "Find all missing codes...",
  
  "schema": {
    "tables": [
      {
  "name": "CodeLog",
        "description": "Records of codes entered",
        "columns": [
          {
     "name": "CodeID",
            "type": "INT",
 "description": "Unique code identifier",
     "nullable": false,
   "isPrimaryKey": true,
            "exampleValues": [1, 2, 3]
          },
          {
          "name": "Code",
            "type": "VARCHAR(10)",
       "description": "The code value",
        "nullable": false,
"exampleValues": ["ABC123", "DEF456"]
          },
    {
        "name": "Status",
            "type": "VARCHAR(20)",
            "description": "Current status (Active, Missing, Closed)",
          "nullable": false,
            "constraints": "Values: Active, Missing, Closed",
  "exampleValues": ["Active", "Missing"]
        },
          {
            "name": "CreatedDate",
  "type": "DATETIME",
            "description": "When code was entered",
            "nullable": false,
            "exampleValues": ["2025-01-01", "2025-01-02"]
  }
        ]
      },
 {
  "name": "Customers",
        "description": "Customer information",
        "columns": [
   {
            "name": "CustomerID",
        "type": "INT",
     "description": "Unique customer identifier",
            "nullable": false,
            "isPrimaryKey": true
          },
          {
   "name": "CustomerName",
            "type": "VARCHAR(100)",
            "description": "Customer name",
          "nullable": false
          }
 ]
    }
    ],
    "relationships": [
      {
"fromTable": "CodeLog",
  "fromColumn": "CustomerID",
        "toTable": "Customers",
        "toColumn": "CustomerID",
        "type": "ManyToOne"
      }
    ]
  },
  
  "questions": [
    {
      "questionIndex": 0,
   "questionId": "q_001",
"text": "Which customer codes have Status = 'Missing'?",
  "promptStep": 1,
      "hint1": "What tables contain the information we need?",
  "hint2": "The CodeLog table has Status and Code columns.",
      "hint3": "You might use SELECT... FROM... WHERE...",
      "canonicalQuery": "SELECT CustomerID, Code FROM CodeLog WHERE Status = 'Missing'",
    "expectedRowCount": 23,
      "learningFocus": "SELECT specific columns, WHERE clause",
      "investigationPurpose": "Identify all missing codes"
    },
    {
      "questionIndex": 1,
      "questionId": "q_002",
      "text": "How many missing codes belong to each customer?",
      "promptStep": 2,
      "hint1": "How would you count results by customer?",
      "hint2": "GROUP BY can organize results by a column.",
      "hint3": "Consider SELECT CustomerID, COUNT(*) FROM CodeLog WHERE Status = 'Missing' GROUP BY CustomerID",
      "canonicalQuery": "SELECT CustomerID, COUNT(*) as MissingCount FROM CodeLog WHERE Status = 'Missing' GROUP BY CustomerID",
      "expectedRowCount": 8,
      "learningFocus": "GROUP BY, COUNT aggregation",
      "investigationPurpose": "Understand distribution of missing codes"
    },
  {
      "questionIndex": 2,
      "questionId": "q_003",
      "text": "Which customer has the most missing codes?",
      "promptStep": 3,
      "hint1": "You have a count by customer. How to find the highest?",
      "hint2": "You could sort by count descending and limit results.",
  "hint3": "SELECT CustomerID, COUNT(*) FROM CodeLog WHERE Status = 'Missing' GROUP BY CustomerID ORDER BY COUNT(*) DESC LIMIT 1",
      "canonicalQuery": "SELECT TOP 1 CustomerID, COUNT(*) as MissingCount FROM CodeLog WHERE Status = 'Missing' GROUP BY CustomerID ORDER BY COUNT(*) DESC",
      "expectedRowCount": 1,
      "learningFocus": "ORDER BY, LIMIT/TOP, aggregation",
   "investigationPurpose": "Identify root cause"
    }
  ],
  
  "dataQualityIssues": [
    {
      "tableName": "CodeLog",
      "issueType": "intentional_missing_data",
      "description": "Some codes have Status = 'Missing'",
      "pattern": "23 codes out of 1,247 have status Missing",
      "investigationRelevance": "This is what student is investigating",
   "studentTier": "Affects how this is revealed"
    },
    {
      "tableName": "CodeLog",
      "issueType": "potential_red_herring",
      "description": "Some codes with Status = 'Active' have NULL CreatedDate",
   "pattern": "42 active codes have no CreatedDate",
      "investigationRelevance": "Student might notice but not needed for solution",
      "redHerringPurpose": "Teaches students to focus on relevant data"
    }
  ],
  
  "contradictions": [],
  
  "testDataGeneration": {
    "tablePopulation": "CodeLog: 1,247 rows, Customers: 47 rows",
    "seedStrategies": [
  "23 codes with Status='Missing' (investigation focus)",
      "42 codes with NULL CreatedDate (red herring)",
      "Remaining codes with Status='Active' or 'Closed'"
    ]
  }
}
```

---

## 🎯 Tier-Specific Case Characteristics

### TIER 1: Junior Data Analyst

**Case Characteristics:**
```
Complexity: Simple (straightforward data)
Questions: 2-3 questions, building in difficulty
SQL Concepts: 1-2 foundational concepts per case
Time: 5-15 minutes
Data Quality Issues: 1 intentional (the investigation focus)
Red Herrings: 0-1 (light)
Contradictions: 0 (none)

Example Structure:
├─ Question 1: Find basic data (SELECT WHERE)
├─ Question 2: Understand pattern (simple COUNT or similar)
└─ Question 3: (Optional) Find what to fix
```

**Investigation Pattern:**
```
NOT: "Complex investigation with multiple angles"
BUT: "Find this specific thing in the data"

Example: "Find all missing codes" 
(Simple, clear, straightforward)
```

---

### TIER 2: Senior Data Analyst

**Case Characteristics:**
```
Complexity: Moderate (multiple tables, relationships)
Questions: 3 questions, building sophistication
SQL Concepts: 3-4 concepts (JOINs, GROUP BY, ORDER BY)
Time: 15-25 minutes
Data Quality Issues: 2-3 intentional issues
Red Herrings: 1-2 (moderate)
Contradictions: 0-1 (light)

Example Structure:
├─ Question 1: Single table SELECT with WHERE
├─ Question 2: JOIN two tables, aggregate
└─ Question 3: Analyze pattern or find anomaly
```

**Investigation Pattern:**
```
NOT: "Simple lookup"
BUT: "Investigate relationship between data sets"

Example: "Data Quality Check: Find transactions 
 that don't match account records"
(Requires JOINs and understanding relationships)
```

---

### TIER 3: Data Inspector

**Case Characteristics:**
```
Complexity: Complex (multiple tables, quality issues)
Questions: 3-4 questions, sophisticated analysis
SQL Concepts: 5-6 concepts (subqueries, CTEs, complex aggregation)
Time: 20-40 minutes
Data Quality Issues: 3-5 intentional issues
Red Herrings: 2-3 (substantial)
Contradictions: 1-2 (mild)

Example Structure:
├─ Question 1: Identify quality issue
├─ Question 2: Understand scope of issue
├─ Question 3: Analyze root cause
└─ Question 4: Recommend verification
```

**Investigation Pattern:**
```
NOT: "Find one specific thing"
BUT: "Systematic quality verification across data"

Example: "Quality Assurance Investigation: Verify 
 transaction data consistency across 5 tables"
(Requires multi-table analysis and quality thinking)
```

---

### TIER 4: Data Detective

**Case Characteristics:**
```
Complexity: Very Complex (sophisticated analysis needed)
Questions: 4-5 questions, strategic investigation
SQL Concepts: Advanced (window functions, complex CTEs)
Time: 30-50 minutes
Data Quality Issues: 4-6 intentional issues
Red Herrings: 3-4 (sophisticated)
Contradictions: 2-3 (meaningful)

Example Structure:
├─ Question 1: Identify anomaly
├─ Question 2: Understand scope
├─ Question 3: Investigate contradiction
├─ Question 4: Analyze pattern
└─ Question 5: Recommend strategy
```

**Investigation Pattern:**
```
NOT: "Simple problem with clear solution"
BUT: "Complex situation with multiple valid interpretations"

Example: "Data Investigation: Resolve conflicting 
 time stamps and amounts across transaction history"
(Multiple valid approaches, ambiguity acknowledged)
```

---

### TIER 5: Director of Data Integrity

**Case Characteristics:**
```
Complexity: Highly Complex (strategic analysis)
Questions: 4-6 questions, executive-level investigation
SQL Concepts: Expert-level (all advanced concepts)
Time: 40-60+ minutes
Data Quality Issues: 5-8 intentional issues
Red Herrings: 4-5 (sophisticated, challenging)
Contradictions: 3-5 (significant)

Example Structure:
├─ Question 1: Assess overall integrity
├─ Question 2: Identify strategic issue
├─ Question 3: Analyze first contradiction
├─ Question 4: Analyze second contradiction
├─ Question 5: Synthesize findings
└─ Question 6: Recommend strategy
```

**Investigation Pattern:**
```
NOT: "Clear problem needing technical solution"
BUT: "Strategic ambiguity requiring organizational perspective"

Example: "Data Integrity Strategy: The data tells 
 multiple valid stories. Which interpretation 
 serves business goals best?"
(Explicit acknowledgment of ambiguity and trade-offs)
```

---

## 🎨 Design Patterns

### Pattern 1: Contradiction Design

**What is a Contradiction?**
```
A contradiction exists when:
├─ Data appears to conflict when viewed one way
├─ But has valid explanation when viewed another way
├─ Or has no single "right" interpretation

Example: Time Contradiction
├─ Transaction says 2:30 PM on Tuesday
├─ But account update shows 1:45 PM
├─ Question: Which is the true time?
└─ Answer: Depends on interpretation (business logic)
```

**How to Design:**
```
STEP 1: Identify Investigation Goal
└─ What data quality question are we exploring?

STEP 2: Create Data State
├─ Data Interpretation A: "This means X..."
└─ Data Interpretation B: "This could mean Y..."

STEP 3: Plant Evidence
├─ Include data supporting both interpretations
├─ Make both seem equally valid
└─ Require student analysis to understand

STEP 4: Design Questions
├─ Q1: Identify the contradiction
├─ Q2: Understand scope
├─ Q3: Analyze interpretations
└─ Q4: Recommend resolution strategy

EXAMPLE CONTRADICTION:
Tier 4 Case: "Transaction History Discrepancy"
├─ Some transactions recorded twice
├─ Once with Amount=100, once with Amount=50
├─ Question: Data entry error? Partial posting? Payment plan?
└─ Investigation reveals: System processed partial payments as separate records
```

**Tier Guidance:**
```
Tier 1-2: NO contradictions
Tier 3: 1 mild contradiction (obvious resolution)
Tier 4: 2-3 meaningful contradictions (ambiguity acknowledged)
Tier 5: 3-5 complex contradictions (strategic implications)
```

---

### Pattern 2: Red Herring Design

**What is a Red Herring?**
```
A red herring is:
├─ Data that looks relevant but isn't
├─ Data that distresses the problem but doesn't solve it
├─ Intentional misdirection teaching focus

Example: Red Herring
├─ Student sees NULL values in Date column
├─ Initially thinks: "Missing dates are the problem!"
├─ Investigation shows: "Dates are N/A for certain record type"
└─ Focus should be: "Other quality issue entirely"

WHY USE RED HERRINGS?
├─ Teaches students to think critically
├─ Forces verification before assuming
├─ Builds investigation discipline
└─ Reflects real-world data complexity
```

**How to Design:**
```
STEP 1: Identify Main Investigation
└─ What should student find?

STEP 2: Create Distraction
├─ Add data pattern that looks suspicious
├─ Make it seem relevant initially
├─ But ultimately not the answer

STEP 3: Add Evidence
├─ Include data supporting the red herring
├─ Include data showing it's not the answer
└─ Require analysis to sort through

STEP 4: Design Questions
├─ Q1-2: Lead toward main investigation
├─ Q3: Student might notice red herring
├─ Q4: Focus back on main finding
└─ Optional Q5: "What about that NULL issue?"

EXAMPLE RED HERRINGS:
Tier 1 Case:
├─ Red Herring: Some codes have Status='Active' with NULL Date
└─ Reality: Those are test records, not relevant

Tier 3 Case:
├─ Red Herring: One table has duplicate rows
└─ Reality: Duplicates are for historical tracking, expected

Tier 5 Case:
├─ Red Herring: Conflicting time stamps seem to indicate fraud
└─ Reality: Different systems use different time zones
```

**Tier Guidance:**
```
Tier 1: 0-1 obvious red herrings (if any)
Tier 2: 1-2 moderate red herrings
Tier 3: 2-3 subtle red herrings
Tier 4: 3-4 sophisticated red herrings
Tier 5: 4-5 complex red herrings
```

---

### Pattern 3: Evidence Layering

**What is Evidence Layering?**
```
Evidence layering means:
├─ Information revealed progressively
├─ First questions show basic facts
├─ Later questions reveal complexity
├─ Full picture emerges through investigation

Example: Layered Evidence
├─ Q1: "How many codes are missing?" → 23
├─ Q2: "Which customers have missing codes?" → 8 customers
├─ Q3: "Which customer has the most?" → Customer 101 (18/23)
├─ Q4: "When were these entered?" → All in January
└─ Emerging Pattern: One customer entered incomplete data
```

**How to Design:**
```
STEP 1: Identify Full Story
└─ What's the complete picture?

STEP 2: Break Into Evidence Layers
├─ Layer 1: Basic facts (easy to find)
├─ Layer 2: Deeper analysis (moderate)
├─ Layer 3: Pattern recognition (advanced)
└─ Layer 4: Strategic implications (expert)

STEP 3: Design Questions to Reveal
├─ Q1: Reveal Layer 1
├─ Q2: Reveal Layer 2
├─ Q3: Reveal Layer 3
└─ Q4: Reveal Layer 4

EXAMPLE LAYERING:
Tier 3 Case: "Data Quality Audit"
├─ Layer 1: "How many transactions total?" → 5,247
├─ Layer 2: "How many have missing amounts?" → 847
├─ Layer 3: "When were these entered?" → Mix of dates
├─ Layer 4: "Which employees entered them?" → Pattern emerges
└─ Insight: Certain data entry process has systematic quality issue
```

**Tier Guidance:**
```
Tier 1: 2 layers (basic → pattern)
Tier 2: 3 layers (basic → intermediate → pattern)
Tier 3: 3-4 layers (basic → intermediate → complex → implications)
Tier 4: 4-5 layers (+ strategic ambiguity)
Tier 5: 5-6 layers (+ multiple valid interpretations)
```

---

## 📝 Question Design Guidelines

### Question Characteristics by Tier

**TIER 1 Questions:**
```
Question Text:
├─ Simple, direct language
├─ 1 concept per question
├─ Clear data focus
└─ Example: "Which codes have Status = 'Missing'?"

Canonical Query:
├─ Basic SELECT WHERE
├─ 1-2 clauses max
└─ Example: SELECT * FROM CodeLog WHERE Status = 'Missing'

Success Criteria:
├─ Correct results returned
├─ No specific column requirements
└─ Row count matches expected

Hints Progress:
├─ Level 1: "What table has this data?"
├─ Level 2: "Use WHERE for filtering"
└─ Level 3: Full query template
```

**TIER 3 Questions:**
```
Question Text:
├─ More sophisticated language
├─ 2-3 concepts involved
├─ Quality/verification focus
└─ Example: "Verify data consistency: 
   Identify transactions without matching account records"

Canonical Query:
├─ JOIN, GROUP BY, HAVING likely needed
├─ Subquery may be used
└─ 3-5 clauses typical

Success Criteria:
├─ Specific columns required
├─ Row count matches expected
├─ Data quality interpretation correct

Hints Progress:
├─ Level 1: "What tables would you check?"
├─ Level 2: "How would you find non-matching?"
├─ Level 3: "Use LEFT JOIN to find unmatched"
├─ Level 4: Subquery suggestion
└─ Level 5: Partial query
```

**TIER 5 Questions:**
```
Question Text:
├─ Strategic, nuanced language
├─ 4-6 concepts involved
├─ Ambiguity acknowledged
└─ Example: "Analyze timestamp discrepancies: 
   Multiple time zones exist. Reconcile using 
 business logic. Which interpretation is correct?"

Canonical Query:
├─ Window functions likely needed
├─ CTEs for clarity
├─ Complex logic (8+ clauses)
└─ May have multiple "correct" approaches

Success Criteria:
├─ Specific columns required
├─ Row count expected (or range if ambiguous)
├─ Analysis approach valued over single answer
├─ Justification for interpretation required

Hints Progress:
├─ Level 1: "What are the interpretations?"
├─ Level 2: "What business logic applies?"
├─ Level 3: "How would you compare?"
├─ Level 4: "Consider window functions"
└─ Level 5: Detailed approach (not full answer)
```

---

## 🧩 Five Complete Example Cases

### Example Case 1: Tier 1 - The Missing Code

**Case Metadata:**
```
caseId: case_tier1_001
caseName: The Missing Code
tier: Junior Data Analyst
estimatedMinutes: 12
difficulty: Simple
```

**Narrative:**
```
"A customer complained that a code they entered 
isn't showing up in the system. You're a Junior Data 
Analyst tasked with finding all codes that are 
marked as missing in our system.

Find all codes with Status = 'Missing' so they 
can be investigated."
```

**Learning Objectives:**
```
1. SELECT specific columns from a table
2. Use WHERE clause to filter data
3. Understand data completeness
4. Find and report missing records
```

**Schema (2 tables):**
```
CodeLog:
├─ CodeID (INT, PK)
├─ Code (VARCHAR)
├─ Status (VARCHAR: Active, Missing, Closed)
├─ CreatedDate (DATETIME)
└─ CustomerID (INT, FK)

Customers:
├─ CustomerID (INT, PK)
└─ CustomerName (VARCHAR)
```

**Data:**
```
CodeLog: 1,247 total rows
├─ 1,224 with Status='Active'
├─ 23 with Status='Missing'
└─ 0 with Status='Closed'

Customers: 47 rows
└─ Mix of real and test customers
```

**Questions:**

```
Q1: "Which customer codes have Status = 'Missing'?"
│
├─ Canonical Query: 
│SELECT CustomerID, Code FROM CodeLog WHERE Status = 'Missing'
│
├─ Expected Results: 23 rows
│
├─ Hint Level 1: "What tables contain the information we need?"
├─ Hint Level 2: "The CodeLog table has Status and Code columns"
├─ Hint Level 3: "Try: SELECT ... FROM CodeLog WHERE Status = 'Missing'"
│
└─ Learning: SELECT WHERE, column selection

Q2: "How many missing codes are there?"
│
├─ Canonical Query:
│  SELECT COUNT(*) as MissingCodeCount FROM CodeLog WHERE Status = 'Missing'
│
├─ Expected Results: 23 (one row)
│
├─ Hint Level 1: "How would you count the number of rows?"
├─ Hint Level 2: "Use the COUNT function"
├─ Hint Level 3: "Try: SELECT COUNT(*) FROM CodeLog WHERE Status = 'Missing'"
│
└─ Learning: COUNT aggregation

Q3: "Get a list of missing codes, sorted by date entered"
│
├─ Canonical Query:
│SELECT Code, CreatedDate FROM CodeLog WHERE Status = 'Missing' ORDER BY CreatedDate
│
├─ Expected Results: 23 rows, sorted by date
│
├─ Hint Level 1: "How would you sort results?"
├─ Hint Level 2: "Use ORDER BY to sort"
├─ Hint Level 3: "Try: ... ORDER BY CreatedDate"
│
└─ Learning: ORDER BY, result organization
```

**Red Herrings:**
```
Red Herring 1: Some codes with Status='Active' have NULL CustomerID
└─ Not relevant to investigation
└─ Teaches: Not all anomalies are the problem
```

**Contradictions:**
```
None (Tier 1 doesn't have contradictions)
```

**Validation Checklist:**
```
✓ SQL concepts: Basic (SELECT, WHERE, COUNT, ORDER BY)
✓ Time estimate: Met (12 minutes typical)
✓ Difficulty: Simple (straightforward data queries)
✓ Questions: 3 (appropriate for tier)
✓ Learning progression: Clear (basic → aggregate → sort)
✓ Red herrings: 1 (appropriate for tier)
✓ Contradictions: 0 (correct for tier)
```

---

### Example Case 2: Tier 2 - Data Quality Check

**Case Metadata:**
```
caseId: case_tier2_001
caseName: Data Quality Check: Transaction Matching
tier: Senior Data Analyst
estimatedMinutes: 20
difficulty: Moderate
```

**Narrative:**
```
"As a Senior Data Analyst, you're responsible for 
quarterly data quality audits. This time, you're 
checking if all transactions have matching account records.

Your investigation: Find transactions that don't 
have a corresponding account in the system."
```

**Learning Objectives:**
```
1. JOIN multiple tables to verify relationships
2. Use LEFT JOIN to find non-matching records
3. Understand referential integrity
4. Verify data relationships are valid
5. Use WHERE with NULL checking
```

**Schema (3 tables):**
```
Transactions:
├─ TransactionID (INT, PK)
├─ AccountID (INT, FK → Accounts)
├─ Amount (DECIMAL)
├─ TransactionDate (DATETIME)
└─ Status (VARCHAR)

Accounts:
├─ AccountID (INT, PK)
├─ AccountName (VARCHAR)
├─ AccountType (VARCHAR)
└─ OpenDate (DATETIME)

AccountTypes:
├─ TypeID (INT, PK)
├─ TypeName (VARCHAR)
└─ Description (VARCHAR)
```

**Data:**
```
Transactions: 2,847 total rows
├─ 2,805 with valid AccountID (exists in Accounts)
├─ 42 with invalid AccountID (not in Accounts)
└─ Known issue: Test transactions with Account=999

Accounts: 134 rows
└─ 124 active, 10 closed

Red Herring: Some transactions have Status='Pending'
└─ Not related to referential integrity issue
```

**Questions:**

```
Q1: "How many transactions have matching accounts?"
│
├─ Canonical Query:
│  SELECT COUNT(t.TransactionID) as MatchingTransactions
│  FROM Transactions t
│  JOIN Accounts a ON t.AccountID = a.AccountID
│
├─ Expected Results: 2,805
│
├─ Hint Level 1: "How would you verify relationships between tables?"
├─ Hint Level 2: "Use JOIN to match transactions with accounts"
├─ Hint Level 3: "Try: ... FROM Transactions t JOIN Accounts a 
│    ON t.AccountID = a.AccountID"
│
└─ Learning: JOINs, relationships

Q2: "Find all transactions WITHOUT matching accounts"
│
├─ Canonical Query:
│  SELECT t.TransactionID, t.AccountID, t.Amount, t.TransactionDate
│  FROM Transactions t
│  LEFT JOIN Accounts a ON t.AccountID = a.AccountID
│  WHERE a.AccountID IS NULL
│
├─ Expected Results: 42 rows
│
├─ Hint Level 1: "What JOIN type finds non-matching?"
├─ Hint Level 2: "LEFT JOIN returns unmatched rows as NULL"
├─ Hint Level 3: "Use WHERE ... IS NULL to find them"
│
└─ Learning: LEFT JOIN, NULL checking

Q3: "Group unmatched transactions by AccountID 
   to understand the scope"
│
├─ Canonical Query:
│  SELECT t.AccountID, COUNT(*) as UnmatchedCount,
│       SUM(t.Amount) as TotalAmount
│  FROM Transactions t
│  LEFT JOIN Accounts a ON t.AccountID = a.AccountID
│  WHERE a.AccountID IS NULL
│  GROUP BY t.AccountID
│  ORDER BY UnmatchedCount DESC
│
├─ Expected Results: 2-3 rows (mostly AccountID=999)
│
├─ Hint Level 1: "How would you group by problem account?"
├─ Hint Level 2: "GROUP BY the AccountID"
├─ Hint Level 3: "Include COUNT and SUM for analysis"
│
└─ Learning: GROUP BY aggregation, sorting

Q4: "Verify: These mismatched transactions are 
     for AccountID = 999. That's our test account. 
     Are there ANY other mismatched accounts?"
│
├─ Canonical Query:
│  SELECT DISTINCT t.AccountID
│  FROM Transactions t
│  LEFT JOIN Accounts a ON t.AccountID = a.AccountID
│  WHERE a.AccountID IS NULL
│  AND t.AccountID != 999
│
├─ Expected Results: 0 rows (only 999)
│
├─ Hint Level 1: "What other accounts are unmatched?"
├─ Hint Level 2: "Filter out test account (999)"
├─ Hint Level 3: "Use DISTINCT and WHERE AccountID != 999"
│
└─ Learning: Data quality verification, filtering test data
```

**Red Herrings:**
```
Red Herring 1: Status='Pending' transactions
└─ Some students might think these are problematic
└─ They're not - Pending status is valid
└─ Teaches: Not all unusual data is a problem

Red Herring 2: Closed accounts with recent transactions
└─ Seems like problem but is actually valid
└─ Teaches: Understanding business logic
```

**Contradictions:**
```
None (Tier 2 doesn't have contradictions)
```

**Validation Checklist:**
```
✓ SQL concepts: Intermediate (JOINs, GROUP BY, aggregates)
✓ Time estimate: Met (20 minutes typical)
✓ Difficulty: Moderate (requires relationship understanding)
✓ Questions: 4 (appropriate for tier)
✓ Learning progression: Clear (join → find issues → analyze → verify)
✓ Red herrings: 2 (appropriate for tier)
✓ Contradictions: 0 (correct for tier)
```

---

### Example Case 3: Tier 3 - Data Quality Audit

**Case Metadata:**
```
caseId: case_tier3_001
caseName: Data Quality Audit: Transaction Completeness
tier: Data Inspector
estimatedMinutes: 35
difficulty: Complex
```

**Narrative:**
```
"As a Data Inspector, you're conducting a 
comprehensive data quality audit. Your team 
flagged potential data quality issues in the 
transaction system.

Your task: Systematically verify data 
completeness, consistency, and integrity 
across the transaction system."
```

**Learning Objectives:**
```
1. Conduct systematic data quality verification
2. Identify multiple types of quality issues
3. Understand data completeness (NULLs, missing values)
4. Use subqueries for complex analysis
5. Create verification queries
6. Quantify quality issues
```

**Schema (4 tables):**
```
Transactions (2,847 rows):
├─ TransactionID (PK)
├─ AccountID (FK)
├─ Amount (DECIMAL)
├─ TransactionDate (DATETIME)
├─ Status (VARCHAR)
└─ PostedDate (DATETIME, nullable)

Accounts (134 rows):
├─ AccountID (PK)
├─ AccountName (VARCHAR)
├─ AccountType (FK)
└─ Balance (DECIMAL)

TransactionTypes (5 rows):
├─ TypeID (PK)
└─ TypeName (VARCHAR)

AuditLog (history):
├─ TransactionID (FK)
├─ ChangeType (VARCHAR)
└─ ChangeDate (DATETIME)
```

**Data Quality Issues (Intentional):**
```
Issue 1: 42 transactions with invalid AccountID (test data)
Issue 2: 156 transactions with NULL PostedDate
Issue 3: 89 transactions with Amount = 0
Issue 4: 23 transactions with TransactionDate > PostedDate (time anomaly)
Issue 5: 12 transactions missing from AuditLog
```

**Red Herrings:**
```
Red Herring 1: Status='Pending' on 234 transactions
└─ Looks like problem but is valid state

Red Herring 2: Some accounts have negative balance
└─ Looks problematic but is valid for certain account types

Red Herring 3: One transaction amount is 999,999
└─ Looks like data entry error but is legitimate large transaction
```

**Contradictions:**
```
Contradiction 1: Mild - PostedDate Ordering
├─ Some transactions posted before TransactionDate
├─ Q3 will investigate and resolve
└─ Resolution: Business logic explains it
```

**Questions:**

```
Q1: "Identify data completeness issues:
    Count transactions with NULL in key fields"
│
├─ Expected Analysis:
│  SELECT 'NULL PostedDate' as Issue, 
│     COUNT(*) as Count
│  FROM Transactions WHERE PostedDate IS NULL
│  UNION ALL
│  SELECT 'NULL Amount', COUNT(*)
│  FROM Transactions WHERE Amount IS NULL
│... etc
│
├─ Expected Result: Issues: 156 NULL PostedDate, etc.
│
├─ Hint Level 1: "What are 'key fields' in transactions?"
├─ Hint Level 2: "Check PostedDate, Amount, Status..."
├─ Hint Level 3: "Use UNION to combine multiple checks"
│
└─ Learning: UNION, NULL checking, completeness

Q2: "Identify referential integrity issues:
    Find transactions without accounts AND 
    accounts without transactions"
│
├─ Expected Analysis:
│  ... (complex LEFT JOINs)
│
├─ Expected Result: 42 orphan transactions, 5 unused accounts
│
├─ Hint Level 1: "What relationships should exist?"
├─ Hint Level 2: "Use LEFT JOIN both directions"
├─ Hint Level 3: "Check for NULL on both sides"
│
└─ Learning: Bidirectional relationships, complex JOINs

Q3: "Analyze timestamp consistency:
    Find cases where PostedDate < TransactionDate
  (Transactions posted before they occurred)"
│
├─ Expected Analysis:
│  SELECT COUNT(*) as BackdatedTransactions
│  FROM Transactions
│  WHERE PostedDate < TransactionDate
│
├─ Expected Result: 23 backdated
│
├─ Hint Level 1: "Logically, what should be true?"
├─ Hint Level 2: "Posted date should be after transaction date"
├─ Hint Level 3: "Find WHERE PostedDate < TransactionDate"
│
├─ Investigation Insight: Possible timing conflict
│  (Note: This is a mild contradiction - reasons could be 
│   time zones, system lag, or error)
│
└─ Learning: Logical verification, contradiction analysis

Q4: "Create comprehensive quality scorecard:
Calculate % of transactions that are 'healthy'"
│
├─ Expected Analysis:
│  Healthy = NOT orphan AND NOT NULL required AND 
│      NOT zero amount AND NOT backdated
│
├─ Expected Result: ~95% healthy
│
├─ Hint Level 1: "What makes a transaction 'healthy'?"
├─ Hint Level 2: "Define criteria, count against total"
├─ Hint Level 3: "Use CASE/WHEN for conditional counting"
│
└─ Learning: Aggregating multiple conditions
```

**Validation Checklist:**
```
✓ SQL concepts: Advanced (UNION, complex JOINs, CTEs)
✓ Time estimate: Met (35 minutes typical)
✓ Difficulty: Complex (multiple quality dimensions)
✓ Questions: 4 (appropriate for tier)
✓ Learning progression: Issues → relationships → contradictions → synthesis
✓ Red herrings: 3 (appropriate for tier)
✓ Contradictions: 1 (appropriate for tier)
```

---

### Example Case 4: Tier 4 - Data Detective Investigation

**Case Metadata:**
```
caseId: case_tier4_001
caseName: Transaction Discrepancy Investigation
tier: Data Detective
estimatedMinutes: 45
difficulty: Very Complex
```

**Narrative:**
```
"As a Data Detective, you've been brought in to 
investigate a critical discrepancy: Our accounting 
team reports that monthly totals don't match between 
two data sources.

Your investigation should resolve: Why are the 
totals different? What's the data telling us?"
```

**Learning Objectives:**
```
1. Investigate complex data anomalies
2. Handle ambiguous situations requiring strategic thinking
3. Use advanced SQL (window functions, CTEs)
4. Analyze data quality issues with business context
5. Develop and test hypotheses
6. Recommend resolution strategies
```

**Data Quality Issues (Intentional):**
```
Issue 1: Duplicate transactions (same data entered twice)
Issue 2: Partial transactions (Amount split across records)
Issue 3: Timezone mismatches in dates
Issue 4: Account consolidations mid-period (data inconsistency)
Issue 5: Deleted records (soft deletes not properly handled)
```

**Contradictions (Meaningful):**
```
Contradiction 1: Two "correct" interpretations exist
├─ If we count: A, B, C as separate = Total X
├─ If we deduplicate: A=B duplicate, C separate = Total Y
├─ Both are "correct" depending on business logic

Contradiction 2: PostedDate vs TransactionDate discrepancies
├─ Which date should we use for accounting?
├─ Different departments use different dates
└─ Valid argument for either approach
```

**Questions:**

```
Q1: "Establish baseline: Calculate monthly totals 
    using transaction date"
│
├─ Expected Result: Sum by month using TransactionDate
│
└─ Learning: Baseline establishment

Q2: "Calculate alternate totals using posted date"
│
├─ Expected Result: Different totals per month
│
├─ Insight: Two interpretations of "monthly total" exist
│
└─ Learning: Multiple valid perspectives

Q3: "Identify duplicate/split transactions causing discrepancy"
│
├─ Expected Analysis: 
│  ├─ Some amounts split across records: 50 + 50 instead of 100
│  ├─ Some amounts duplicated: Same transaction entered twice
│  └─ Some linked via transaction grouping
│
├─ Hint: "How would you detect identical/similar amounts?"
│
└─ Learning: Pattern detection

Q4: "For the duplicates and splits identified, 
    calculate corrected monthly totals"
│
├─ Expected Result: Corrected totals align with accounting
│
└─ Learning: Data reconciliation

Q5: "Recommend which interpretation (TransactionDate vs 
    PostedDate) should be used going forward and why"
│
├─ Context: This acknowledges ambiguity
│
├─ Acceptable Answers:
│  - "Use TransactionDate because [business reason]"
│  - "Use PostedDate because [business reason]"
│  - "Use both with clear documentation"
│  - "Standardize to resolve ambiguity"
│
└─ Learning: Strategic recommendation despite ambiguity
```

**Validation Checklist:**
```
✓ SQL concepts: Expert-level (CTEs, window functions)
✓ Time estimate: Met (45 minutes typical)
✓ Difficulty: Very Complex (strategic analysis)
✓ Questions: 5 (appropriate for tier)
✓ Learning progression: Establish → compare → identify → correct → decide
✓ Red herrings: 3-4 (sophisticated misdirection)
✓ Contradictions: 2 (meaningful, strategic)
```

---

### Example Case 5: Tier 5 - Executive Data Integrity Assessment

**Case Metadata:**
```
caseId: case_tier5_001
caseName: Strategic Data Integrity Assessment
tier: Director of Data Integrity
estimatedMinutes: 60
difficulty: Highly Complex
```

**Narrative:**
```
"As Director of Data Integrity, you're presenting 
to executive leadership about enterprise data quality.

The situation is ambiguous: Data can be interpreted 
multiple ways. Your job: Analyze all perspectives, 
acknowledge trade-offs, and recommend strategy."
```

**Learning Objectives:**
```
1. Conduct strategic-level data assessment
2. Handle significant data ambiguity
3. Develop multiple valid hypotheses
4. Acknowledge limitations and uncertainties
5. Make informed recommendations
6. Consider organizational impact
7. Present findings with appropriate caveats
```

**Data Quality Issues & Contradictions (Complex):**
```
Issue 1: Account consolidations with conflicting histories
Issue 2: Three "truth sources" with different amounts
Issue 3: Timezone and calendar boundary misinterpretations
Issue 4: Legitimate vs fraud transactions indistinguishable
Issue 5: Test data not properly segregated
Issue 6: Multiple valid business logic interpretations
Issue 7: Historical data reconciliation impossible
Issue 8: No clear "canonical truth"
```

**Questions:**

```
Q1: "Assess overall data quality on multiple dimensions"
│
├─ Analysis needed:
│  ├─ Completeness
│  ├─ Accuracy (multiple definitions)
│  ├─ Consistency (across sources)
│  ├─ Validity
│  └─ Timeliness
│
├─ Expected Result: Quality scorecard with caveats
│
└─ Learning: Comprehensive assessment

Q2: "Identify where multiple 'correct' interpretations exist"
│
├─ Expected Analysis: 
│  ├─ Interpretation A would give result X
│  ├─ Interpretation B would give result Y
│  ├─ Both are defensible based on business logic
│  └─ No way to know which is "truth"
│
└─ Learning: Acknowledging ambiguity

Q3: "For each ambiguous area, develop two hypotheses 
    about what the data is actually saying"
│
├─ Expected:
│  ├─ Hypothesis 1: [Assumption set A → Result X]
│  ├─ Hypothesis 2: [Assumption set B → Result Y]
│  └─ Evidence supporting each
│
└─ Learning: Competing narratives

Q4: "Assess organizational risk if we're wrong about 
    each interpretation"
│
├─ Expected:
│  ├─ Consequence of Assumption A: [business impact]
│  ├─ Consequence of Assumption B: [different impact]
│  └─ Risk profile for each
│
└─ Learning: Strategic decision-making

Q5: "Recommend organizational data strategy: 
    - Accept ambiguity and document?
    - Choose interpretation and standardize?
    - Invest in resolution?
    - Other approach?"
│
├─ Acceptable Answer Types:
│  ├─ "Accept ambiguity: Document both interpretations"
│  ├─ "Choose B: Standardize to this approach"
│  ├─ "Invest: Implement validation to resolve"
│  ├─ "Accept limitations: Acknowledge uncertainty"
│  └─ "Hybrid: Combination approach with trade-offs"
│
├─ Key: Must acknowledge trade-offs and limitations
│
└─ Learning: Strategic decision with constraints

Q6: "What decisions would change based on which 
    interpretation is correct? Who needs to know?"
│
├─ Expected: Analysis of stakeholder impact
│
├─ Acceptable Answer: Acknowledges who cares and how
│
└─ Learning: Organizational context
```

**Validation Checklist:**
```
✓ SQL concepts: Expert-level (all advanced concepts)
✓ Time estimate: Met (60 minutes typical)
✓ Difficulty: Highly Complex (strategic ambiguity)
✓ Questions: 6 (appropriate for tier)
✓ Learning progression: Assess → identify ambiguity → develop hypotheses →
│           assess risk → decide → socialize
✓ Red herrings: 4-5 (sophisticated, challenging)
✓ Contradictions: 3-5 (significant, strategic)
✓ Explicit ambiguity: YES (core of case)
```

---

## ✅ Case Validation Checklist

**Every case should pass these checks:**

```
TIER APPROPRIATENESS:
[ ] Case matches tier difficulty
[ ] SQL concepts appropriate for tier
[ ] Time estimate realistic
[ ] Questions build appropriately
[ ] Learning objectives match tier level

STRUCTURE:
[ ] Clear narrative/context
[ ] Investigation goal obvious
[ ] Schema clearly documented
[ ] Questions follow evidence layering
[ ] Progression from simple to complex

SQL QUALITY:
[ ] Canonical queries are correct
[ ] Queries can be executed against schema
[ ] Results deterministic and correct
[ ] Multiple valid approaches acknowledged

DATA QUALITY:
[ ] Intentional issues clear to designer
[ ] Red herrings obvious to expert
[ ] Contradictions meaningful (Tier 3+)
[ ] Test data generation documented
[ ] Data realistic and proportional

LEARNING:
[ ] Learning objectives clear
[ ] Questions support objectives
[ ] Progression teaches tier skills
[ ] Evidence layering works
[ ] Depth appropriate for tier

TONE:
[ ] Professional and respectful
[ ] Career-focused (not game-like)
[ ] Tier-appropriate language
[ ] Encouraging and supportive
[ ] No judgment or sarcasm
```

---

## 🎓 Prompt Writing Guidelines

### System Prompts for Hint Generation

```
TIER 1 HINT SYSTEM PROMPT:
"You are a supportive SQL tutor for beginners. 
Keep language very simple and concrete. Use 
spreadsheet analogies. Explain step-by-step 
without overwhelming. Celebrate small wins."

TIER 3 HINT SYSTEM PROMPT:
"You are a professional data quality mentor. 
Provide structured guidance. Acknowledge multiple 
approaches. Focus on verification and confidence. 
Build expertise progressively."

TIER 5 HINT SYSTEM PROMPT:
"You are a strategic data advisor. Acknowledge 
ambiguity and trade-offs explicitly. Support 
informed decision-making. Respect organizational 
context. Facilitate executive-level thinking."
```

### Schema Explanation Prompts

```
TIER 1 SCHEMA PROMPT:
"Explain this column for a complete beginner. 
Use simple business language. Give concrete examples. 
Make it obvious what the data represents."

TIER 5 SCHEMA PROMPT:
"Explain this column with full technical context. 
Acknowledge ambiguities in how it's used. Note 
any data quality concerns. Support strategic decision-making."
```

---

## 📚 Related Documents

**Core Standards:**
- `DataQuest-Tier-System-Official-Design-Guideline.md`
- `Query-Tutor-Agent-Implementation-Specification.md`
- `Database-Agent-Implementation-Specification.md`

**Integration Points:**
- `Case-Lifecycle-and-State-Management.md`
- `API-and-Service-Layer-Architecture.md`
- `UI-UX-Design-Specification.md`

---

## ✅ Implementation Checklist

### Case Creation

```
[ ] Define investigation goal
[ ] Design schema
[ ] Create test data
[ ] Write questions
[ ] Generate expected results
[ ] Design red herrings
[ ] Plan contradictions (if tier > 2)
[ ] Write narrative
[ ] Document learning objectives
[ ] Create hint hierarchy (1-6 levels)
```

### Validation

```
[ ] All questions answerable
[ ] Canonical queries correct
[ ] Expected results deterministic
[ ] Schema complete and documented
[ ] Red herrings effective
[ ] Contradictions meaningful
[ ] Time estimate accurate
[ ] Tier appropriateness verified
```

### Documentation

```
[ ] Case JSON complete
[ ] Data generation strategy documented
[ ] Learning objectives clear
[ ] Investigation goal obvious
[ ] Hint strategy documented
[ ] Validation checklist passed
```

---

## 🎓 Conclusion

The Case Design Template and Examples specification provides **definitive guidance for creating high-quality DataQuest cases**. With this template and five complete examples, content creators can design cases with confidence that match tier requirements and support meaningful learning.

**Key Success Factors:**

1. **Clear investigation focus** - Students know what they're investigating
2. **Progressive complexity** - Evidence layering reveals story
3. **Appropriate tier matching** - SQL concepts match tier level
4. **Meaningful contradictions** - Acknowledge ambiguity when appropriate
5. **Subtle red herrings** - Teach critical thinking
6. **Professional tone** - Career-focused, not game-like
7. **Testable quality** - Cases work consistently

---

**IMPLEMENTATION SPECIFICATION COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR CASE CREATION**

