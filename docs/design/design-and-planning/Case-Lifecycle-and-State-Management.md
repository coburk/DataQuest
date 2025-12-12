# Case Lifecycle and State Management Specification

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - CRITICAL PATH  
**Version:** 1.0  
**Classification:** Binding Implementation Standard

---

**SOURCE OF TRUTH TRACKING**

**COMPLIANCE STATUS:** ✅ PROPOSAL-COMPLIANT  
**SOURCE OF TRUTH:** 
- Tier 1: `docs/proposal/DataQuest-Project-Proposal.md`
- Tier 3: This document

**CHANGE REQUESTS:** NONE  
**CAPSTONE IMPACT:** ZERO  
**LAST COMPLIANCE REVIEW:** December 3, 2025  
**REVIEWED BY:** Systematic Compliance Review

---

## 📋 Document Purpose

This specification defines the complete lifecycle of cases in DataQuest, including all states, transitions, and state management requirements. It operationalizes the student journey through investigation cases from start to completion and tier advancement.

**This document enables:**
- ✅ Developers to implement case flow without ambiguity
- ✅ QA to validate state transitions without clarification
- ✅ Maintainers to understand progression logic
- ✅ Integration between UI, agents, and backend systems

---

## 🎯 Scope

### What This Document Covers

```
✅ Complete case state machine
✅ Case states and valid transitions
✅ Query submission workflow
✅ Validation and feedback loops
✅ Evidence and timeline interactions
✅ Session management (Phase 1 stateless)
✅ Progress persistence requirements (Phase 2)
✅ State data structures
✅ Error states and recovery
✅ Case completion and advancement
✅ Tier progression triggers
✅ State persistence and storage
```

### What This Document Does NOT Cover

```
❌ Database schema details (see Technical Design)
❌ UI rendering (see UI/UX Specification)
❌ Agent implementation (see Agent Specifications)
❌ Case content design (see Case Design Template)
```

---

## 🏗️ Architecture Overview

### Case Lifecycle Vision

```
CASE FLOW:

START
  │
  ├─ [User selects case]
  │    ↓
  ├─ [Case initialized - NOT_STARTED state]
  │    ↓
  ├─ [User enters case - IN_PROGRESS state]
  │    ├─ Query attempt loop:
  │    │  ├─ User views question
  │    │  ├─ User writes query
  │    │  ├─ User submits query
  │    │  ├─ System validates query
  │    │  ├─ Query Tutor provides feedback
  ││  └─ [Loop until correct or hints exhausted]
  │    │
  │    ├─ [Multiple questions, same pattern]
  │    │
  │    └─ [Final correct query submitted]
  │   ↓
  ├─ [Case solved - COMPLETED state]
  │    ↓
  ├─ [Case completion screen shown]
  │    ├─ Summary displayed
  │    ├─ Achievement recorded
  │    └─ Tier progress updated
  │      ↓
  ├─ [Check tier advancement]
  │    ├─ If tier complete → Show tier promotion
  │    └─ If tier incomplete → Recommend next case
  │         ↓
END (Student advances or continues tier)
```

### State Machine Diagram

```
┌─────────────┐
│ NOT_STARTED │ ← Initial state
└──────┬──────┘
       │ [User enters case]
       ↓
┌─────────────────────┐
│   IN_PROGRESS       │ ← Question 1
├─────────────────────┤
│ question_index: 0   │
│ query_attempts: []  │
│ hint_level: 1│
│ elapsed_time: 0s    │
└──────┬──────┬───────┘
    │      │
   [ERROR] [SUCCESS]
       │      │
  ┌────▼─┐    └──────┬──────────────────────┐
  │ERROR │      ↓          │
  └────┬─┘    [Next Question?]    │
       │     ↓        │
       │      ┌────────┬────────┐     │
       │      │    │        ││
       │  [YES][NO]    │ [NO]   │            │
       │      │        │   ││
       │      │     ↓        ↓          │
│   │   ┌──────────────────┐      │
       │      │   │ IN_PROGRESS      │      │
       │      │   │ (Next Question)  │      │
       │      │   │ question_index:1 │      │
       │      │   └─────┬────────────┘      │
       │      │         │  │
       │      └─────────┘          │
 ││
       └────────────┬─────────────────────┬─┘
        │    │
           [TIMEOUT/ABANDON]      [ALL CORRECT]
        │          │
          ↓            ↓
            ┌──────────────┐      ┌─────────────┐
      │ ABANDONED    │      │  COMPLETED  │
            │ (Optional)   │      │             │
     └──────────────┘      └─────┬───────┘
   │
     ↓
               [Tier check]
      │
             ┌───────────────┼───────────────┐
           │       │       │
       [PROMOTED][CONTINUE]    [LOCKED]
          │   │     │
  ↓   ↓    ↓
      [Show new tier]  [Case selection] [Next unlock]
```

---

## 📊 Case States (Comprehensive)

### State 1: NOT_STARTED

```
PURPOSE: Case selected but not yet entered
CHARACTERISTICS:
├─ User has viewed case in selection screen
├─ No progress made
├─ No time elapsed
└─ Can start or return to selection

DATA STRUCTURE:
{
  caseId: "case_001",
  status: "NOT_STARTED",
  startedAt: null,
  completedAt: null,
  questionIndex: null,
  queryAttempts: [],
  hintLevel: 0,
  elapsedSeconds: 0,
  currentQuestion: null
}

TRANSITIONS:
├─ → IN_PROGRESS [When user clicks START]
└─ → NOT_STARTED [When user returns to selection]

VALID OPERATIONS:
├─ View case details
├─ Start case
└─ Return to case selection
```

### State 2: IN_PROGRESS

```
PURPOSE: User actively solving case
CHARACTERISTICS:
├─ User viewing current question
├─ User may be writing query
├─ Time is elapsing
├─ Hints may be requested
├─ Multiple attempts possible
└─ Can be paused/abandoned (optional Phase 2)

DATA STRUCTURE:
{
  caseId: "case_001",
  status: "IN_PROGRESS",
  startedAt: "2025-12-03T10:30:00Z",
  completedAt: null,
  questionIndex: 0,
  totalQuestions: 3,
  queryAttempts: [
    {
      attemptNumber: 1,
      query: "SELECT * FROM Transactions",
      submittedAt: "2025-12-03T10:32:00Z",
 isCorrect: false,
      errorType: "logic_error",
      errorMessage: "Returned 1,247 rows. Expected 23.",
      hintLevelAtSubmission: 1
    }
  ],
  hintLevel: 1,
  elapsedSeconds: 120,
  currentQuestion: {
    questionId: "q_001",
    text: "Which transactions are missing?",
    promptStep: 1
  },
  studentTier: "Junior Data Analyst",
  sessionId: "session_abc123"
}

TRANSITIONS:
├─ → IN_PROGRESS [Query submitted, incorrect - loop continues]
├─ → IN_PROGRESS [Next question answered correctly]
├─ → COMPLETED [All questions answered correctly]
├─ → ABANDONED [If timeout reached - Phase 2 optional]
└─ → IN_PROGRESS [Paused and resumed - Phase 2+]

VALID OPERATIONS:
├─ View case narrative
├─ View current question
├─ Write query
├─ Submit query
├─ Request hint
├─ Access database schema
├─ View prior attempts (optional)
├─ Pause case (Phase 2+)
└─ Abandon case (Phase 2+ optional)
```

### State 3: COMPLETED

```
PURPOSE: User answered all questions correctly
CHARACTERISTICS:
├─ All questions answered with correct queries
├─ Case summary generated
├─ Time tracked for records
├─ Achievement recorded
├─ Tier progress updated
└─ Ready for advancement decision

DATA STRUCTURE:
{
  caseId: "case_001",
  status: "COMPLETED",
  startedAt: "2025-12-03T10:30:00Z",
  completedAt: "2025-12-03T10:38:45Z",
  totalElapsedSeconds: 515,
  estimatedMinutes: 15,
  questionIndex: 2,
  totalQuestions: 3,
  queryAttempts: [
    {...}, // All attempts recorded
  {...}
  ],
  finalHintLevel: 2,
  totalQueryAttempts: 5,
  caseResult: {
    allQuestionsCorrect: true,
    timeWithinEstimate: true,
  averageAttemptsPerQuestion: 1.67
  },
  tierBefore: "Junior Data Analyst",
  tierAfter: "Junior Data Analyst",
  tierProgressCount: {
    completed: 2,
    total: 3,
    percentComplete: 66
  }
}

TRANSITIONS:
├─ [Case completion screen shown]
├─ [Achievement recorded]
├─ [Tier progress updated]
├─ → COMPLETED (visible in history)
└─ [Next action: Continue tier or unlock promotion]

VALID OPERATIONS:
├─ View completion summary
├─ View case results
├─ Review queries submitted
├─ Return to case selection
├─ Start next case (if available)
└─ Continue to next tier (if tier complete)
```

### State 4: ABANDONED (Optional - Phase 2+)

```
PURPOSE: Case not completed (optional feature)
CHARACTERISTICS:
├─ User gave up or time expired
├─ Partial progress recorded
├─ Can be resumed later (Phase 2+)
└─ Doesn't count as tier progress

DATA STRUCTURE:
{
  caseId: "case_001",
  status: "ABANDONED",
  startedAt: "2025-12-03T10:30:00Z",
  completedAt: null,
  abandonedAt: "2025-12-03T10:50:00Z",
  abandonReason: "time_expired" | "user_gave_up" | "session_lost",
  questionIndex: 1,
  totalQuestions: 3,
  percentComplete: 33,
  elapsedSeconds: 1200,
  canResume: true,
  lastQueryAttempts: [...],
  lastHintLevel: 3
}

TRANSITIONS (Phase 2+):
├─ → ABANDONED [On timeout or user request]
├─ → IN_PROGRESS [If user resumes case]
├─ → NOT_STARTED [If user restarts from beginning]
└─ → ARCHIVED [If not resumed for extended period]

VALID OPERATIONS (Phase 2+):
├─ View abandon reason
├─ Resume case (return to question where abandoned)
├─ Restart case from beginning
└─ Return to case selection
```

### State 5: ERROR (Transient)

```
PURPOSE: Query submission resulted in error
CHARACTERISTICS:
├─ Database connection failed
├─ Query has syntax error
├─ Timeout occurred
├─ System error encountered
└─ Transient error (can retry)

DATA STRUCTURE:
{
  caseId: "case_001",
  status: "ERROR",
  errorType: "syntax_error",
  errorCode: "SQL_SYNTAX_001",
  errorMessage: "Unexpected token 'SLECT' on line 1",
submittedQuery: "SLECT * FROM Transactions",
  errorLine: 1,
  errorColumn: 1,
  recoveryAction: "correct_and_resubmit",
  fallbackState: "IN_PROGRESS"
}

TRANSITIONS:
├─ → IN_PROGRESS [After error displayed and user corrects]
├─ → IN_PROGRESS [User requests new attempt]
└─ → ABANDONED [If repeated errors prevent progress]

VALID OPERATIONS:
├─ View error message
├─ View error location (if applicable)
├─ Get SQL help (optional)
├─ Return to query editor
└─ Clear and try again
```

---

## 🔄 Query Submission Workflow

### Complete Query Submission Flow

```
1. USER SUBMITS QUERY
   │
   ├─ Query captured from editor
   ├─ Trim whitespace
   └─ Validate non-empty
        │
        ├─ [EMPTY] → Error, stay in editor
└─ [NOT EMPTY] → Continue
             │
2. SYNTAX VALIDATION
   │
 ├─ Parse SQL syntax
   ├─ Check keywords
   └─ Validate structure
        │
        ├─ [ERROR] → Display SQL error, return to editor
        │          attempt_count += 1
        └─ [VALID] → Continue
│
3. CONTEXT VALIDATION
   │
   ├─ Check tables used are in case schema
   ├─ Check columns are valid
   └─ Validate joins make sense
        │
  ├─ [ERROR] → Display context error ("Table X not in schema")
        │          Return to editor, increment attempt
        └─ [VALID] → Continue
       │
4. EXECUTE QUERY
   │
   ├─ Run against case database
   ├─ Capture results
   └─ Record execution details
│
        ├─ [DB_ERROR] → Display database error, return to editor
  │    increment attempt_count
        │
   ├─ [TIMEOUT] → Display timeout message
        │            suggest optimizing query or try again
        │        increment attempt_count
        │
        └─ [SUCCESS] → Continue
        │
5. EVALUATE RESULTS
   │
   ├─ Compare against canonical query results
   ├─ Check row count matches
   ├─ Check column values match
   └─ Validate completeness
        │
        ├─ [INCORRECT] → 
        │     ├─ Display "Not quite" feedback
   │     ├─ Call Query Tutor for hints
     │     ├─ Check escalation triggers
        │     ├─ increment attempt_count
        │     └─ Return to editor
     │
        └─ [CORRECT] →
  │
6. HANDLE CORRECT ANSWER
   │
 ├─ Record correct query
   ├─ Record attempt count
   ├─ Record hint level at success
   ├─ Record elapsed time
   ├─ Display celebration message
   ├─ Call Query Tutor for validation message
   └─ Check: Are there more questions?
        │
   ├─ [YES] → Advance questionIndex, load next question
        │      Display next question
        │    Status: Still IN_PROGRESS
        │
        └─ [NO] → All questions answered correctly
      Set status: COMPLETED
Show completion screen
```

### Data Captured Per Query Attempt

```
QUERY_ATTEMPT Record:
{
  attemptNumber: 1,
  caseId: "case_001",
  questionId: "q_001",
  submittedAt: "2025-12-03T10:32:45Z",
  submittedQuery: "SELECT * FROM Transactions WHERE Status = 'Missing'",
  executionDuration: 234,  // milliseconds
  resultRowCount: 23,
  expectedRowCount: 23,
  isCorrect: true,
  errorType: null,
  errorMessage: null,
  hintLevelAtSubmission: 1,
  studentTier: "Junior Data Analyst",
  canonicalQuery: "SELECT CustomerID, Code FROM CodeLog WHERE Status = 'Missing'",
  resultMatchesExpected: true,
  feedback: "Excellent! You found all 23 missing codes!"
}
```

---

## 💾 Session Management

### Phase 1: Stateless (MVP)

```
PHASE 1 APPROACH:
├─ No persistent user sessions (stateless)
├─ Each case access is independent
├─ No resumption between sessions
├─ Case state exists only during active session
├─ After browser close or timeout:
│  └─ Case returns to NOT_STARTED
│     (User selects case again to restart)

ADVANTAGES:
├─ Simpler implementation
├─ No database session tracking
├─ Reduced server state management
├─ Stateless scalability
└─ Clear MVP scope

LIMITATIONS:
├─ User loses mid-case progress on refresh
├─ No ability to resume later
├─ No cross-session history (yet)
└─ User experience: Restart entire case

SESSION IDENTIFIER (Phase 1):
{
  sessionId: "session_xyz123",
  caseId: "case_001",
  userId: null,  // No user tracking Phase 1
  startedAt: "2025-12-03T10:30:00Z",
  expiresAt: "2025-12-03T11:30:00Z",  // 1 hour
  lastActivityAt: "2025-12-03T10:35:00Z",
  isValid: true
}
```

### Phase 2: Persistent User Tracking

```
PHASE 2 APPROACH:
├─ User authentication enabled
├─ Case state persisted to database
├─ Sessions maintained across logins
├─ Ability to pause and resume
├─ Cross-device continuity (optional)

USER_SESSION (Phase 2):
{
  sessionId: "session_abc123",
  userId: "user_123",
  caseId: "case_001",
  startedAt: "2025-12-03T10:30:00Z",
  lastActivityAt: "2025-12-03T10:35:00Z",
  caseState: {
    status: "IN_PROGRESS",
    questionIndex: 1,
    queryAttempts: [...],
    hintLevel: 2,
    elapsedSeconds: 300
  },
  deviceInfo: {
    userAgent: "Mozilla/5.0...",
    ipAddress: "192.168.1.1"
  }
}

CASE_PROGRESS (Phase 2 - Persisted):
{
  caseProgressId: "progress_001",
  userId: "user_123",
  caseId: "case_001",
  tierAtAttempt: "Junior Data Analyst",
  status: "COMPLETED",
  startedAt: "2025-12-03T10:30:00Z",
  completedAt: "2025-12-03T10:38:45Z",
  totalElapsedSeconds: 515,
  queryAttempts: [...],
  finalHintLevel: 2,
  createdAt: "2025-12-03T10:30:00Z",
  updatedAt: "2025-12-03T10:38:45Z"
}
```

---

## 🧠 State Management Architecture

### Component Architecture

```
┌──────────────────────────────────────────────────────┐
│     Case State Manager       │
├──────────────────────────────────────────────────────┤
│        │
│  ┌─────────────────────────────────────────────┐   │
│  │  State Storage (In-Memory, Phase 1)     │   │
│  │  ├─ currentCaseState: CaseState         │   │
│  │  ├─ queryAttempts: QueryAttempt[]     │   │
│  │  ├─ sessionId: string           │   │
│  │  └─ startTime: DateTime         │   │
│  └─────────────────────────────────────────────┘   │
│         ↑           ↑     │
│   │      │   │
│  ┌─────────────────┐  ┌────────────────────┐       │
│  │ State Observer  │  │ State Persister    │       │
│  │ (UI notified)   │  │ (DB - Phase 2)     │       │
│  └─────────────────┘  └────────────────────┘       │
│         ↑         ↑        │
│         │      │      │
│  ┌──────────────────────────────────────────┐       │
│  │    State Transition Controller         │       │
│  │    ├─ ValidateTransition()    │       │
│  │    ├─ ExecuteTransition()            │       │
│  │    └─ NotifyStateChange()      │       │
│  └──────────────────────────────────────────┘       │
│         ↑           │
│         │  │
│  ┌──────────────────────────────────────────┐       │
│  │    External Event Handlers          │     │
│  │    ├─ OnQuerySubmitted()    │       │
│  │    ├─ OnHintRequested()          │ │
│  │    ├─ OnQuestionAnswered()     │       │
│  │    └─ OnCaseCompleted()        │       │
│  └──────────────────────────────────────────┘       │
│  │
└──────────────────────────────────────────────────────┘
```

### State Mutation Rules

```
IMMUTABILITY PRINCIPLE:
├─ State changes only via explicit transitions
├─ No direct state mutation from UI
├─ All changes logged for audit trail
└─ Previous states retained for recovery

TRANSITION VALIDATION:
├─ Check current state allows transition
├─ Validate all required data present
├─ Verify preconditions met
├─ Check permissions/tier level
└─ Execute transition atomically

EXAMPLE - Correct Query Transition:
CurrentState: IN_PROGRESS (question 0)
Transition: ON_QUERY_CORRECT
Preconditions:
├─ Status == "IN_PROGRESS"
├─ Query results match canonical
├─ Current question is answerable
└─ Student tier is valid

NewState: IN_PROGRESS (question 1) or COMPLETED
Changes:
├─ questionIndex += 1 (or mark complete)
├─ Add query_attempt to attempts array
├─ Update elapsedSeconds
├─ Clear currentQueryText (for UI)
└─ Log state transition
```

---

## 📊 Tier Progression Logic

### Tier Advancement Trigger

```
TIER ADVANCEMENT DECISION LOGIC:

WHEN case status changes to COMPLETED:
  1. Get current tier
  2. Get tier case requirements (e.g., "3 cases")
  3. Count completed cases in tier
  4. Compare count to requirement
  
  IF count >= requirement:
    ├─ Tier is complete
    ├─ Record tier completion
    ├─ Unlock next tier
    ├─ Trigger promotion ceremony
    ├─ Update studentTier
    ├─ Show tier advancement screen
    └─ Award achievement badge
  ELSE:
    ├─ Tier not yet complete
    ├─ Update progress percentage
    ├─ Calculate remaining cases
    ├─ Show progress toward next tier
    ├─ Recommend next case
  └─ Continue with current tier

TIER_PROGRESSION Record (Phase 2):
{
  progressionId: "prog_123",
  userId: "user_123",
  fromTier: "Junior Data Analyst",
  toTier: "Senior Data Analyst",
  transitionedAt: "2025-12-03T11:00:00Z",
  completedCaseCount: 3,
  requiredCaseCount: 3,
  achievementUnlocked: "promotion_to_tier_2"
}
```

### Promotion Ceremony (UI Flow)

```
WHEN tier advancement triggers:

1. Show PROMOTION SCREEN:
   ├─ 🎉 Celebration emoji
   ├─ "PROMOTION! You've advanced!"
   ├─ From tier: "Junior Data Analyst" (Bronze)
   └─ To tier: "Senior Data Analyst" (Silver)

2. SHOW TIER CHARACTERISTICS:
   ├─ New tier name
   ├─ New tier mission
   ├─ New tier responsibilities
   ├─ New case preview
   └─ Expected difficulty increase

3. UNLOCK NEXT TIER:
   ├─ Show next tier cases become available
   ├─ Update case selection screen
 ├─ Award achievement badge
   └─ Update tier display

4. GUIDE NEXT STEP:
   ├─ "Ready for your next challenge?"
   ├─ [START FIRST SENIOR ANALYST CASE]
   └─ [OR VIEW ALL CASES]

Example Message:
"CONGRATULATIONS! You're now a Senior Data Analyst.

You've completed all Junior Data Analyst cases and 
demonstrated the foundational SQL skills needed for 
independent analysis.

Your next challenge: Learn to combine multiple data 
sources with JOINs and handle complex data relationships.

Ready to begin?"
```

---

## 🎯 Error States and Recovery

### Error Scenarios

**Scenario 1: SQL Syntax Error**

```
TRIGGER: User submits query with syntax error

ERROR_RESPONSE:
{
  status: "ERROR",
  errorType: "syntax_error",
  errorCode: "SQL_SYNTAX_001",
  message: "Unexpected token 'SLECT' on line 1",
  submittedQuery: "SLECT * FROM Transactions",
  errorLine: 1,
  errorColumn: 1,
  suggestion: "Did you mean: SELECT?"
}

DISPLAY TO STUDENT:
"❌ SQL Error at line 1
There's a syntax error in your query.

Error: Unexpected token 'SLECT' on line 1

Suggestion: Did you mean 'SELECT'?

Correct your query and try again."

RECOVERY:
├─ Query attempt recorded (with error flag)
├─ Attempt count incremented
├─ Student returned to editor
├─ Query text still visible (for editing)
├─ Error highlighted in editor (optional)
└─ Focus moved to query editor
```

**Scenario 2: Database Connection Error**

```
TRIGGER: Database connection lost during query execution

ERROR_RESPONSE:
{
  status: "ERROR",
  errorType: "database_connection_error",
  errorCode: "DB_CONNECTION_001",
  message: "Unable to connect to database",
  retriable: true,
  retryAfterSeconds: 5
}

DISPLAY TO STUDENT:
"⚠️ Temporary Issue

We're having trouble connecting to the database.
This is usually temporary.

Your query was not executed.

Options:
[TRY AGAIN IN 5 SECONDS] [GO BACK TO EDITOR]"

RECOVERY:
├─ Attempt NOT counted (transient error)
├─ Student can retry immediately
├─ Query text preserved in editor
├─ System retries connection
└─ On success: Execute query normally
```

**Scenario 3: Query Timeout**

```
TRIGGER: Query takes too long to execute

ERROR_RESPONSE:
{
  status: "ERROR",
  errorType: "query_timeout",
  errorCode: "DB_TIMEOUT_001",
  message: "Query execution exceeded 30 second timeout",
  executionTime: 30123,  // milliseconds
  suggestion: "Try filtering with WHERE or limiting results"
}

DISPLAY TO STUDENT:
"⏱️ Query Timeout

Your query took too long to execute (over 30 seconds).
This usually means the query is inefficient or 
returning too many rows.

Tips:
• Use WHERE clause to filter records
• Avoid SELECT * if you don't need all columns
• Consider LIMIT to reduce result set

[BACK TO EDITOR] [VIEW HINTS]"

RECOVERY:
├─ Attempt counted (it's a real attempt)
├─ Hint level may escalate
├─ Query text preserved
├─ Student encouraged to optimize
└─ No penalty (learning moment)
```

---

## 🧪 Testing Scenarios

### Test Case 1: Simple Case Completion Flow

```
SCENARIO: Student completes simple case correctly
TIER: Junior Data Analyst

STEPS:
1. User on case selection screen
2. Click START on "The Missing Code" case
   → Status: NOT_STARTED → IN_PROGRESS
   → UI shows case narrative
   → UI shows first question

3. User writes query: SELECT * FROM CodeLog WHERE Status = 'Missing'
4. User clicks SUBMIT
   → Query validated (syntax OK, tables OK)
   → Query executed
   → Results: 23 rows (matches expected)
 → Status: IN_PROGRESS (no change, continue)

5. Display: "Excellent! You found all 23 missing codes!"
6. Show next question or completion

EXPECTED OUTCOMES:
✓ Status changed to IN_PROGRESS
✓ Query attempt recorded
✓ Result evaluated correctly
✓ Feedback displayed
✓ Progression logic triggered
✓ Student moves to next step
```

### Test Case 2: Tier Advancement

```
SCENARIO: Student completes last case in tier
TIER: Junior Data Analyst (3/3 cases)

STEPS:
1. User completes "Account Mystery" case (3rd case)
   → Status: COMPLETED
   → Tier progression logic triggered

2. Check: completed_cases (3) >= required_cases (3)
→ Tier advancement decision: YES

3. Trigger promotion:
   → Award achievement badge
   → Record tier transition
   → Unlock Senior Data Analyst
   → Show promotion ceremony screen

4. Display promotion message with next tier preview

EXPECTED OUTCOMES:
✓ Case recorded as COMPLETED
✓ Tier advancement triggered
✓ Achievement recorded
✓ New tier unlocked
✓ Promotion screen shown
✓ Student tier updated
✓ Next tier cases become available
```

### Test Case 3: Error Handling and Recovery

```
SCENARIO: Student encounters SQL error, recovers
TIER: Senior Data Analyst

STEPS:
1. User submits query with typo: "SLECT * FROM..."
   → Syntax validation fails
   → Error status: ERROR
   → Error message displayed

2. Student sees error message
3. Student corrects query: "SELECT * FROM..."
4. Student resubmits
   → Validation succeeds
   → Query executes
   → Results evaluated
   → Status: COMPLETED or continues

EXPECTED OUTCOMES:
✓ Error detected and reported
✓ Error message helpful
✓ Query text preserved for editing
✓ Student can retry
✓ Correction handled properly
✓ No penalty for syntax error
```

---

## 📚 Related Documents

**Core Standards:**
- `DataQuest-Tier-System-Official-Design-Guideline.md`
- `Query-Tutor-Agent-Implementation-Specification.md`
- `Database-Agent-Implementation-Specification.md`

**Integration Points:**
- `UI-UX-Design-Specification.md`
- `API-and-Service-Layer-Architecture.md`
- `Case-Design-Template-and-Examples.md`

**Testing:**
- `Testing-and-QA-Implementation-Guide.md`

---

## ✅ Implementation Checklist

### Design Phase

```
[ ] Review state machine diagram
[ ] Validate all state transitions
[ ] Review data structures for each state
[ ] Plan error handling approach
[ ] Design query submission workflow
[ ] Plan session management strategy
```

### Development Phase

```
[ ] Implement case state enum/constants
[ ] Implement state machine transitions
[ ] Implement query submission workflow
[ ] Implement validation logic
[ ] Implement error handling
[ ] Implement session management (Phase 1)
[ ] Implement state persistence (Phase 2)
[ ] Implement tier progression logic
[ ] Implement state recovery procedures
```

### Testing Phase

```
[ ] Unit test state transitions
[ ] Unit test query submission workflow
[ ] Unit test error handling
[ ] Unit test tier progression logic
[ ] Integration test case flow
[ ] Integration test with UI
[ ] Integration test with agents
[ ] End-to-end test complete case flow
```

### QA Validation

```
[ ] Verify all state transitions valid
[ ] Verify error messages helpful
[ ] Verify recovery procedures work
[ ] Verify tier advancement works
[ ] Verify state persistence (Phase 2)
[ ] Verify performance under load
[ ] Verify error edge cases handled
```

---

## 🎓 Conclusion

The Case Lifecycle and State Management is the **operational heart of DataQuest**. This specification ensures that every student interaction flows smoothly, states are managed correctly, and students progress appropriately through the tier system.

**Key Success Factors:**

1. **Clear state machine** - Understand all possible states
2. **Valid transitions** - Only allow appropriate state changes
3. **Error handling** - Graceful recovery from all errors
4. **Data capture** - Record all relevant interaction data
5. **Tier progression** - Automatic advancement when ready
6. **Performance** - Quick state transitions and updates
7. **Resilience** - Handle edge cases and failures

---

**IMPLEMENTATION SPECIFICATION COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR DEVELOPMENT**

