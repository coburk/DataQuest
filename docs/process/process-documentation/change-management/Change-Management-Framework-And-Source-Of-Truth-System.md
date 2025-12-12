# 📋 CHANGE MANAGEMENT FRAMEWORK & SOURCE OF TRUTH SYSTEM

**Date:** December 3, 2025  
**Status:** FRAMEWORK ESTABLISHMENT  
**Version:** 1.0  
**Classification:** CRITICAL - Project Governance

---

## 🎯 PURPOSE

Establish a rigorous change management framework to:
1. ✅ Track ALL deviations from the original proposal
2. ✅ Document rationale for each change
3. ✅ Maintain clear "Source of Truth" version control
4. ✅ Enable progress evaluation against baseline
5. ✅ Support stakeholder accountability

---

## 📍 SOURCE OF TRUTH HIERARCHY

### TIER 1: IMMUTABLE BASELINE (Original Proposal)
**Document:** `docs/proposal/DataQuest-Project-Proposal.md`  
**Status:** READ-ONLY REFERENCE  
**Purpose:** Original capstone requirements and commitments

```
✅ 10-week timeline (Weeks 1-10)
✅ 3 AI Agents required (Database Agent, Case Planner Agent, Query Tutor Agent)
✅ 1 Rule-Based Validator (SQL Enforcer)
✅ At least 1 complete case required
✅ Deliverables defined by Week 10
✅ User stories US-01 through US-10
```

**NO MODIFICATIONS ALLOWED** - This is the binding capstone contract

---

### TIER 2: APPROVED WORKING PLAN (Current Operational Plan)
**Document:** `docs/design-and-planning/DataQuest-Development-Roadmap-Capstone-Focus.md` (TO BE CREATED)  
**Status:** OPERATIONAL BASELINE  
**Purpose:** Current approved execution plan aligned with proposal

```
May reflect clarifications/corrections of original proposal
All deviations must be tracked and approved via Change Management
Status: APPROVED for current execution
```

---

### TIER 3: WORKING DOCUMENTATION (Specifications)
**Documents:** All 9 core specifications + supporting docs  
**Status:** DERIVED FROM TIER 2  
**Purpose:** Implementation details derived from approved plan

```
These must be cross-referenced to TIER 2
Any conflicts must trigger Change Request process
Status: SUPPORTS Tier 2 plan
```

---

## 🔄 CHANGE MANAGEMENT PROCESS

### Step 1: IDENTIFY DEVIATION

When a document contains information that differs from the original proposal:

```
QUESTION:
  Does this document match the original proposal (Tier 1)?
  
IF YES:
  ✅ Mark as "PROPOSAL-COMPLIANT"
  
IF NO:
  ⚠️ Mark as "DEVIATION DETECTED"
  → Continue to Step 2
```

---

### Step 2: DOCUMENT DEVIATION

Create a Change Request entry with:

```
CHANGE REQUEST TEMPLATE:
├─ ID: CRxxxx (sequential)
├─ Date Identified: YYYY-MM-DD
├─ Document: [filename]
├─ Section: [specific section]
├─ Original Requirement: [from proposal]
├─ Current Statement: [from document]
├─ Deviation Type: [Clarification/Correction/Extension/Reduction]
├─ Rationale: [why this change is necessary]
├─ Impact: [what this affects]
├─ Risk Level: [Low/Medium/High]
└─ Status: [Pending/Approved/Rejected]
```

---

### Step 3: EVALUATE IMPACT

Classify the deviation:

```
TYPE 1: CLARIFICATION
├─ Definition: Makes original requirement more specific
├─ Example: "Case Planner Agent" definition expanded
├─ Approval: Can be approved by Project Lead
├─ Risk: Low

TYPE 2: CORRECTION
├─ Definition: Fixes error in original proposal understanding
├─ Example: Timeline was misread, correction documented
├─ Approval: Can be approved by Project Lead
├─ Risk: Low-Medium

TYPE 3: EXTENSION
├─ Definition: Adds scope beyond original proposal
├─ Example: "15 cases" vs. "1 case" required
├─ Approval: REQUIRES Stakeholder/Advisor approval
├─ Risk: High (affects deadline/scope)

TYPE 4: REDUCTION
├─ Definition: Removes scope from original proposal
├─ Example: "6-level hints" changed to "3-level hints"
├─ Approval: REQUIRES Stakeholder/Advisor approval
├─ Risk: High (affects quality/requirements)
```

---

### Step 4: TRACK DECISION

Record approval or rejection:

```
DECISION:
├─ Approved By: [Name/Role]
├─ Approval Date: YYYY-MM-DD
├─ Condition: [if any]
├─ New Source of Truth: [updated doc reference]
└─ Impact on Timeline: [if any]
```

---

## 📊 CHANGE MANAGEMENT LOG

**Location:** `docs/work-effort/Change-Management-Log.md`  
**Updated:** After each change decision  
**Format:** Chronological record of all changes

```
| ID | Date | Document | Type | Rationale | Status | Approved | Notes |
|----|------|----------|------|-----------|--------|----------|-------|
| CR001 | 12/03 | Timeline | Clarification | 10-week vs 12-week clarification | ✅ APPROVED | Project Lead | Source of truth |
| CR002 | 12/03 | ... | ... | ... | ... | ... | ... |
```

---

## 📋 COMPLIANCE VERIFICATION CHECKLIST

For EACH design-and-planning document:

### ✅ COMPLIANCE EVALUATION TEMPLATE

```
DOCUMENT: [filename]
DATE EVALUATED: [date]
EVALUATED BY: [your name]

QUESTION 1: Does this document align with original proposal?
  ☐ YES (mark as PROPOSAL-COMPLIANT)
  ☐ NO (continue to question 2)

QUESTION 2: If deviation, does it have a documented Change Request?
  ☐ YES - CR ID: [___]
  ☐ NO - CREATE CHANGE REQUEST (Step 2 above)

QUESTION 3: Has the change been approved?
  ☐ YES - Approved By: [___]
  ☐ NO - Status: [PENDING]

QUESTION 4: Is document marked with current status?
  ☐ YES - Status marker present: [___]
  ☐ NO - ADD status marker (see below)

OVERALL ASSESSMENT:
  ☐ COMPLIANT - No changes needed
  ☐ COMPLIANT WITH TRACKED CHANGES - Changes documented and approved
  ☐ NON-COMPLIANT - Deviations without approval (needs remediation)
```

---

## 🏷️ DOCUMENT STATUS MARKERS

Add to TOP of every design-and-planning document:

```markdown
---
**STATUS:** [PROPOSAL-COMPLIANT | CHANGE-MANAGED | NON-COMPLIANT]
**SOURCE OF TRUTH:** [Reference to Tier 2 plan or original proposal]
**LAST COMPLIANCE REVIEW:** [YYYY-MM-DD]
**CHANGE REQUESTS:** [CR001, CR002, ...]
---
```

---

## 📍 COMPLIANCE REVIEW SCHEDULE

### Phase 1: COMPREHENSIVE BASELINE (THIS WEEK)

**Evaluate all design-and-planning documents:**

```
WEEK 1 (Dec 3-6):
├─ Query-Tutor-Agent-Implementation-Specification.md
├─ Database-Agent-Implementation-Specification.md
├─ UI-UX-Design-Specification.md
└─ Case-Lifecycle-and-State-Management.md

WEEK 1 CONTINUED (Dec 3-6):
├─ API-and-Service-Layer-Architecture.md
├─ Case-Design-Template-and-Examples.md
├─ Testing-and-QA-Implementation-Guide.md
└─ Agent-Prompt-Engineering-Standards.md

FINAL (Dec 3-6):
└─ MCP-Integration-Design.md

OUTPUT: Compliance verification report for each document
```

### Phase 2: ONGOING MONITORING

During each sprint:
- ✅ Review changes against Source of Truth
- ✅ Update Change Management Log
- ✅ Verify compliance before each milestone

---

## 🗂️ NEW DOCUMENTS TO CREATE

### 1. **Capstone Focus Roadmap** (TIER 2)
**File:** `docs/design-and-planning/DataQuest-Development-Roadmap-Capstone-Focus.md`

```
PURPOSE: Approved execution plan aligned with 10-week capstone
CONTENT:
  ├─ Original proposal requirements
  ├─ Clarifications and corrections
  ├─ Tracked deviations (with Change Requests)
  ├─ 10-week timeline (BINDING)
  ├─ All 8 agents required
  ├─ Stretch goals (post-capstone only)
  └─ Success criteria

STATUS: Replaces confusing "Two-Phase Strategy" document
```

### 2. **Change Management Log**
**File:** `docs/work-effort/Change-Management-Log.md`

```
PURPOSE: Central record of all deviations and approvals
FORMAT: Chronological table of all changes
UPDATED: After each change decision
STATUS: Living document
```

### 3. **Compliance Verification Report**
**File:** `docs/work-effort/Compliance-Verification-Report-Phase-1.md`

```
PURPOSE: Document-by-document compliance assessment
FORMAT: Results of applying compliance template to each design doc
TIMING: Completed by end of Phase 1 (this week)
STATUS: Baseline for ongoing monitoring
```

### 4. **Source of Truth Registry**
**File:** `docs/work-effort/Source-of-Truth-Registry.md`

```
PURPOSE: Master index of all Source of Truth references
FORMAT: Links to all Tier 1, Tier 2, and Tier 3 documents
UPDATED: When new documents created/approved
STATUS: Navigation tool for stakeholders
```

---

## 📊 CHANGE IMPACT ANALYSIS EXAMPLE

To show how this works in practice:

```
IDENTIFIED DEVIATION:
  Document: DataQuest-Development-Roadmap-Two-Phase-Strategy.md
  Section: Timeline
  Original: 10 weeks (proposal)
  Current: 12 weeks (Phase 1 + Phase 2)
  
CHANGE REQUEST:
  ID: CR001
  Type: EXTENSION (added Phase 2 scope)
  Rationale: Team wanted to demonstrate full progression system
  Impact: EXCEEDS capstone deadline
  Risk: HIGH - violates original commitment
  
EVALUATION:
  ✅ APPROVED WITH CONDITIONS:
     - Phase 1 (10 weeks) = capstone deliverable (REQUIRED)
     - Phase 2 (weeks 11+) = stretch goals (OPTIONAL)
     - Capstone deadline NON-NEGOTIABLE
     - Phase 2 only if Phase 1 complete early
  
ACTION:
  → Create new "Capstone Focus" roadmap
  → Mark original as superseded
  → Update all references
  → Track as CR001 in Change Log
```

---

## 📋 EVALUATION WORKFLOW

### FOR EACH DESIGN-AND-PLANNING DOCUMENT:

**Step 1: READ THE DOCUMENT**
- Understand what it specifies
- Note any timeline/scope references

**Step 2: CROSS-REFERENCE PROPOSAL**
- Find related requirement in original proposal
- Compare specification to requirement

**Step 3: IDENTIFY GAPS**
- Does document match proposal?
- Any unexplained deviations?

**Step 4: DOCUMENT FINDINGS**
- Create Change Request if deviation found
- Classify deviation type (Clarification/Correction/Extension/Reduction)

**Step 5: RECORD RESULT**
- Add status marker to document
- Update Compliance Log
- Link to Change Request if applicable

---

## ✅ EXAMPLE COMPLIANCE CHECKLIST

### Document: Query-Tutor-Agent-Implementation-Specification.md

```
COMPLIANCE CHECK:

✅ PROPOSAL REQUIREMENT: "Query Tutor providing guidance"
  DOCUMENT STATEMENT: "Query Tutor Agent provides 6-level Socratic hints"
  ASSESSMENT: ALIGNED ✓
  
✅ PROPOSAL REQUIREMENT: "Multi-level hints"
  DOCUMENT STATEMENT: "Multi-tier hints" with examples
  ASSESSMENT: ALIGNED ✓
  
✅ PROPOSAL REQUIREMENT: "Hints grounded in schema"
  DOCUMENT STATEMENT: "Schema-based hint detection"
  ASSESSMENT: ALIGNED ✓
  
⚠️ TIMELINE: Document specifies "Week 6"
  PROPOSAL: Tutor Agent spec'd for "Week 6"
  ASSESSMENT: ALIGNED ✓

OVERALL: ✅ PROPOSAL-COMPLIANT
NO CHANGE REQUESTS NEEDED
```

---

## 🎯 YOUR IMMEDIATE ACTION ITEMS

### TODAY:
1. ✅ Review this framework
2. ✅ Approve Change Management process
3. ✅ Authorize creation of new Tier 2 documents

### THIS WEEK:
4. ⏳ Systematically evaluate each design-and-planning document
5. ⏳ Complete Compliance Verification Report
6. ⏳ Create Change Management Log (if deviations found)
7. ⏳ Create/update Capstone Focus Roadmap (Tier 2)

### OUTPUT:
- ✅ Clear Source of Truth established
- ✅ All deviations tracked
- ✅ Compliance baseline documented
- ✅ Ready for development phase

---

## 📊 SUCCESS CRITERIA

By end of this week:

```
✅ Source of Truth hierarchy established
✅ Change Management process documented
✅ All design-and-planning documents evaluated
✅ Compliance report completed
✅ Change log created (if applicable)
✅ New Tier 2 roadmap (capstone-focused)
✅ Status markers added to all docs
✅ Stakeholders aligned on Source of Truth
```

---

## 🔗 REFERENCE DOCUMENTS

**TIER 1 (Immutable - Original Proposal):**
- `docs/proposal/DataQuest-Project-Proposal.md`

**TIER 2 (Approved Plan - TO BE CREATED):**
- `docs/design-and-planning/DataQuest-Development-Roadmap-Capstone-Focus.md`

**SUPPORTING (Change Management):**
- `docs/work-effort/Change-Management-Log.md`
- `docs/work-effort/Compliance-Verification-Report-Phase-1.md`
- `docs/work-effort/Source-of-Truth-Registry.md`

---

**FRAMEWORK READY FOR IMPLEMENTATION**

Once approved, proceed to systematic compliance evaluation of all design-and-planning documents.

