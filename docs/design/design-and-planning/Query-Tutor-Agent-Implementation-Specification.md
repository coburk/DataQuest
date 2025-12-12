# Query Tutor Agent Implementation Specification

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - CRITICAL PATH  
**Version:** 1.0  
**Classification:** Binding Implementation Standard

---

**SOURCE OF TRUTH TRACKING**

**COMPLIANCE STATUS:** ✅ PROPOSAL-COMPLIANT  
**SOURCE OF TRUTH:** 
- Tier 1: `docs/proposal/DataQuest-Project-Proposal.md` (Week 6: US-06)
- Tier 3: This document

**CHANGE REQUESTS:** NONE  
**LAST COMPLIANCE REVIEW:** December 3, 2025  
**REVIEWED BY:** Systematic Compliance Review

---

## 📋 Document Purpose

This specification defines how the Query Tutor Agent operationalizes the Socratic method for SQL query development. It transforms the pedagogical principles in the Official Design Guideline into concrete, implementable behavior patterns.

**This document enables:**
- ✅ Developers to implement Query Tutor without ambiguity
- ✅ QA to validate agent responses without clarification
- ✅ Maintainers to understand design decisions
- ✅ Stakeholders to verify alignment with learning goals

---

## 🎯 Scope

### What This Document Covers

```
✅ Socratic questioning patterns by tier
✅ Hint escalation algorithm and triggers
✅ Question and hint templates for each tier
✅ Natural language generation guidelines
✅ Integration with case context and student progress
✅ Response evaluation and success criteria
✅ Error handling and recovery patterns
✅ Conversation state management
✅ Context awareness requirements
✅ Performance and safety constraints
```

### What This Document Does NOT Cover

```
❌ Specific LLM or AI framework choice
❌ UI/conversation interface design (see UI/UX specification)
❌ Case content design (see Case Design Template)
❌ Database schema (see Technical Design)
❌ Authentication or session management (see Case Lifecycle)
```

---

## 🏗️ Architecture Overview

### Query Tutor Agent Role

```
STUDENT INTERACTION FLOW:

Student Question/Attempt
        ↓
Query Tutor Agent Receives Context
        ├─ Student's current tier
        ├─ Case context and expectations
        ├─ Query history in this case
        ├─ Hint escalation level
        └─ Student's interaction patterns
        ↓
Socratic Method Applied
        ├─ Evaluate current state
        ├─ Select appropriate tier
        ├─ Generate Socratic question/hint
        ├─ Assess student's progress
        └─ Determine escalation need
        ↓
Response Generated
        ├─ Question or hint
        ├─ Explanation if appropriate
        ├─ Encouragement or guidance
└─ Next step suggestions
     ↓
Response Delivered to Student
        ↓
Student Responds
        ↓
[LOOP] Evaluate Progress
```

### Component Architecture

```
┌─────────────────────────────────────────────┐
│       Query Tutor Agent System│
├─────────────────────────────────────────────┤
│       │
│  ┌─────────────────────────────────────┐   │
│  │  Context Analyzer          │   │
│  │  ├─ Student tier determination      │   │
│  │  ├─ Query analysis     │   │
│  │  ├─ Error identification│   │
│  │  └─ Progress assessment        │   │
│  └─────────────────────────────────────┘   │
│       ↓      │
│  ┌─────────────────────────────────────┐   │
│  │  Socratic Engine    │   │
│  │  ├─ Question template selection     │   │
│  │  ├─ Scaffolding level application   │   │
│  │  ├─ Follow-up pattern matching      │   │
│  │  └─ Hint escalation logic           │   │
│  └─────────────────────────────────────┘   │
│           ↓  │
│┌─────────────────────────────────────┐   │
│  │  Response Generator   │   │
│  │  ├─ Question composition     │   │
│  │  ├─ Hint generation               │   │
│  │  ├─ Explanation synthesis  │   │
│  │  └─ Tone and style application      │   │
│  └─────────────────────────────────────┘   │
│           ↓  │
│  ┌─────────────────────────────────────┐ │
│  │  Response Validator              │   │
│  │  ├─ Socratic method verification    │   │
│  │  ├─ Tier appropriateness check│   │
│  │  ├─ Safety guardrail enforcement    │   │
│  │  └─ Quality metrics assessment  │   │
│  └─────────────────────────────────────┘   │
│         │
└─────────────────────────────────────────────┘
```

---

## 🧠 Socratic Method Implementation

### Core Principle: ALWAYS Start Socratic

**MANDATORY RULE:**
```
Query Tutor MUST NEVER:
❌ Immediately show a canonical query
❌ Jump to hints without questions first
❌ Provide answers to factual questions
❌ Explain solutions students should discover

Query Tutor MUST ALWAYS:
✅ Start with questions probing what student knows
✅ Build from student's existing understanding
✅ Guide toward discovery through reasoning
✅ Escalate scaffolding progressively
✅ Reserve direct answers as LAST resort
```

### Escalation Levels (NOT Abandonment)

**Critical Distinction:**
```
Level increases specificity and scaffolding.
Level does NOT abandon Socratic method.

Example: "What tables?" → "Which columns?" → 
"How combine?" → "TRY: SELECT..." → 
"Structure: SELECT [...] FROM [...]" → 
"Answer: SELECT..."

At EVERY level, start Socratic.
Escalation adds directiveness, not bypasses method.
```

---

## 📊 Tier-Specific Socratic Patterns

### TIER 1: Junior Data Analyst

#### Context Requirements
```
Student Characteristics:
- No prior SQL knowledge
- Needs high scaffolding
- Benefits from confidence building
- Responds to encouragement

Case Difficulty:
- Simple, single table
- 0 contradictions
- 0 red herrings
- Linear path to answer
```

#### Question Patterns (MANDATORY ORDER)

**Pattern 1: Table Identification**

```
LEVEL 1 (SOCRATIC - OPEN):
Q: "What information are we trying to find?"
   → Student identifies the goal

LEVEL 2 (SOCRATIC - GUIDED):
Q: "Which table(s) contain that information?"
 → Student names the table(s)

LEVEL 3 (SOCRATIC - STRUCTURED):
Q: "If we SELECT all columns FROM [table], 
    would that answer the question?"
   → Student realizes they need WHERE clause

LEVEL 4 (GUIDED - PARTIAL):
"We need to filter using WHERE. 
 What condition would identify [X]?"
   → Student suggests condition

LEVEL 5 (PARTIAL ANSWER):
"Here's the structure:
 SELECT [columns] FROM [table] WHERE..."
   → Student completes or refines

LEVEL 6 (ANSWER - LAST RESORT):
"The answer is: SELECT [columns] 
 FROM [table] WHERE [condition]"
   → Student sees solution
```

**Pattern 2: Column Selection**

```
LEVEL 1 (SOCRATIC):
Q: "Of all the columns available, 
    which ones actually answer the question?"

LEVEL 2 (SOCRATIC - STRUCTURED):
Q: "Do we need the person's address? 
    Their phone number? Their name?"
   → Student thinks through each

LEVEL 3 (GUIDED):
"We need: [Column A], [Column B]. 
 Do we need anything else?"

LEVEL 4 (PARTIAL):
"SELECT [Column A], [Column B] FROM..."

LEVEL 5 (ANSWER):
"SELECT [all columns] FROM..."
```

**Pattern 3: WHERE Clause Construction**

```
LEVEL 1 (SOCRATIC):
Q: "What's special about the records we want?"
   → Student identifies the condition

LEVEL 2 (SOCRATIC - STRUCTURED):
Q: "How would you describe [X] in numbers?"
   → Student provides threshold or value

LEVEL 3 (GUIDED):
"So we need Amount > [value]. 
 What operator would do that?"

LEVEL 4 (PARTIAL):
"WHERE Amount > [value]"

LEVEL 5 (ANSWER):
"WHERE Amount > 10000"
```

#### Response Templates (Junior Analyst)

**Correct Query Response:**
```
TEMPLATE:
"Excellent! You found it! 
 
You identified:
- The right table: [table]
- The important columns: [columns]
- The filter condition: WHERE [condition]

This tells SQL exactly what data to retrieve.

Ready for the next question?"

VARIATION (NEAR-CORRECT):
"Great reasoning! Your query is almost there.

You correctly identified [correct part].
Let's refine [incorrect part]. 
[Question to guide refinement]"
```

**Stuck After Multiple Attempts:**
```
TEMPLATE:
"You're thinking about this the right way, 
and I can see you're trying different approaches.

Let me help guide you. 
[Ask scaffolding question]"

ESCALATION:
Level 1 → Level 2 → Level 3 → Level 4 → Answer
(Each attempt moves one level)
```

---

### TIER 2: Senior Data Analyst

#### Context Requirements
```
Student Characteristics:
- Understanding of SELECT, WHERE basics
- Can write independent queries
- Ready to combine tables
- Expects less hand-holding

Case Difficulty:
- Multiple tables with relationships
- 1 clear contradiction
- 1-2 red herrings
- Some inference needed
```

#### Question Patterns (MANDATORY ORDER)

**Pattern 1: Multi-Table Investigation**

```
LEVEL 1 (SOCRATIC - OPEN):
Q: "What information do we need, 
  and which tables provide it?"
   → Student maps tables to requirements

LEVEL 2 (SOCRATIC):
Q: "How are these tables related?"
   → Student identifies relationships

LEVEL 3 (SOCRATIC - STRUCTURED):
Q: "Which columns would we use to JOIN them?"
   → Student identifies join keys

LEVEL 4 (GUIDED):
"A JOIN connects tables through shared columns.
 Which columns would you use?"

LEVEL 5 (PARTIAL):
"SELECT [...] FROM [table1] 
 JOIN [table2] ON..."

LEVEL 6 (ANSWER):
"SELECT [...] FROM [table1] 
 JOIN [table2] ON [table1.id] = [table2.id]"
```

**Pattern 2: Handling Contradictions**

```
LEVEL 1 (SOCRATIC):
Q: "Does the data tell a consistent story?"
   → Student looks for inconsistencies

LEVEL 2 (SOCRATIC):
Q: "What contradicts what?"
   → Student identifies the conflict

LEVEL 3 (SOCRATIC - STRUCTURED):
Q: "How would you investigate this contradiction?"
   → Student designs query to reveal it

LEVEL 4 (GUIDED):
"To see both sides of the contradiction,
 you'd need to SELECT [these columns]
 and compare them how?"

LEVEL 5 (PARTIAL):
"SELECT [...] FROM [...] WHERE..."

LEVEL 6 (ANSWER):
Full query with explanation of contradiction
```

#### Response Templates (Senior Analyst)

**Correct Query Response:**
```
TEMPLATE:
"Perfect! You not only got the answer,
 but you also:
 
- Connected the right tables
- Identified [specific insight]
- Resolved the contradiction

This shows solid analytical thinking."

VARIATION (STRATEGIC APPROACH):
"Your approach makes sense. 
 You're investigating [direction].
 
 What does that tell you about [insight]?"
```

**Partially Correct:**
```
TEMPLATE:
"You're on the right track with [correct part].

However, [incorrect part] needs adjustment.
What if you reconsidered [aspect]?"

NO DIRECT ANSWER YET - guide to discovery
```

**Stuck Pattern:**
```
TEMPLATE:
Level 1 → Level 2 → Level 3 → Level 4 → Answer
(Each attempt moves ONE level)
(Never skip levels, never jump to answer)
```

---

### TIER 3: Data Inspector

#### Context Requirements
```
Student Characteristics:
- Strong SQL fundamentals
- Can work with multiple tables
- Ready for complex patterns
- Expects sophisticated guidance

Case Difficulty:
- 3+ table relationships
- 2-3 contradictions
- 2-3 red herrings
- Pattern recognition needed
```

#### Question Patterns

**Pattern 1: Quality Verification Investigation**

```
LEVEL 1 (SOCRATIC):
Q: "What data quality issue are we investigating?"

LEVEL 2 (SOCRATIC):
Q: "What would 'correct' data look like?"

LEVEL 3 (SOCRATIC - STRUCTURED):
Q: "How would your query surface deviations 
    from correct data?"

LEVEL 4 (GUIDED):
"To detect [issue], consider using 
 GROUP BY and aggregation..."

LEVEL 5 (PARTIAL):
"SELECT [...], COUNT(*) 
 FROM [...] GROUP BY..."

LEVEL 6 (ANSWER):
Complete aggregation query
```

**Pattern 2: Multi-Layer Red Herring Navigation**

```
LEVEL 1 (SOCRATIC):
Q: "Which pieces of evidence are relevant 
    to the core question?"

LEVEL 2 (SOCRATIC):
Q: "Which are distractions?"

LEVEL 3 (SOCRATIC - STRUCTURED):
Q: "How would your query ignore 
    irrelevant information?"

LEVEL 4 (GUIDED):
"You might use WHERE to filter out 
 irrelevant records..."

LEVEL 5 (PARTIAL):
WHERE clause examples

LEVEL 6 (ANSWER):
Full filtering query
```

#### Response Templates (Data Inspector)

**Correct Response:**
```
TEMPLATE:
"Excellent verification approach.

You systematically:
- Identified the quality issue
- Designed a query to surface it
- Filtered out distracting information
- Drew the right conclusion

This is professional-level analysis."
```

**Sophisticated Thinking:**
```
TEMPLATE:
"That's an interesting approach. 
 You're investigating [angle].
 
What does that reveal about [pattern]?"

(Acknowledge multiple valid paths)
```

---

### TIER 4: Data Detective

#### Context Requirements
```
Student Characteristics:
- Expert SQL capability
- Comfortable with complex reasoning
- Handles ambiguity well
- Minimal guidance needed

Case Difficulty:
- Complex multi-table scenarios
- 3-5 cascading contradictions
- 3-6 red herrings
- Strategic reasoning required
```

#### Question Patterns

**Pattern 1: Complex Investigation Strategy**

```
LEVEL 1 (SOCRATIC):
Q: "What's your investigation strategy?"
   (Student designs own approach)

LEVEL 2 (SOCRATIC):
Q: "What evidence would support 
    each hypothesis?"

LEVEL 3 (SOCRATIC):
Q: "How would your queries test 
    each hypothesis?"

LEVEL 4 (GUIDED):
"Consider these query structures 
 for testing [hypothesis]..."

LEVEL 5 (PARTIAL):
Query patterns and structure suggestions

LEVEL 6 (ANSWER):
Example queries (acknowledge other valid approaches)
```

**Pattern 2: Ambiguity and Multiple Interpretations**

```
LEVEL 1 (SOCRATIC):
Q: "What's ambiguous about this evidence?"

LEVEL 2 (SOCRATIC):
Q: "What are the possible interpretations?"

LEVEL 3 (SOCRATIC):
Q: "How would you query to distinguish 
    between interpretations?"

LEVEL 4 (GUIDED):
"You might structure your query to show 
 evidence supporting each interpretation..."

LEVEL 5 (PARTIAL):
Query structure suggestions

LEVEL 6 (ANSWER):
Example queries for each interpretation
```

#### Response Templates (Data Detective)

**Expert Approach:**
```
TEMPLATE:
"That's a sophisticated strategy.

You're:
- Testing multiple hypotheses
- Accounting for ambiguity
- Designing efficient queries
- Drawing defensible conclusions

Excellent detective work."

(Validate the reasoning, not just the answer)
```

**Professional Judgment:**
```
TEMPLATE:
"Your interpretation makes sense 
 given [evidence].
 
An alternative interpretation could be [X]
because [reasoning].

What additional queries would help 
distinguish between them?"
```

---

### TIER 5: Director of Data Integrity

#### Context Requirements
```
Student Characteristics:
- Master-level SQL expertise
- Strategic thinking
- Handles professional ambiguity
- Self-directed investigation

Case Difficulty:
- Enterprise-scale scenarios
- 4-6+ contradictions
- 4-8+ red herrings
- Open-ended investigations
```

#### Question Patterns

**Pattern 1: Strategic Executive Analysis**

```
LEVEL 1 (SOCRATIC):
Q: "What strategic question does this data answer?"

LEVEL 2 (SOCRATIC):
Q: "What assumptions might be wrong?"

LEVEL 3 (SOCRATIC):
Q: "How would you validate 
    or challenge those assumptions?"

LEVEL 4 (GUIDED):
"Consider these strategic approaches..."

LEVEL 5 (PARTIAL):
"Query structures to explore [strategic angle]..."

LEVEL 6 (ANSWER - WITH CAVEATS):
"One possible query... 
 But other interpretations might suggest..."
```

**Pattern 2: Executive Communication**

```
LEVEL 1 (SOCRATIC):
Q: "How would you explain these findings 
    to executives?"

LEVEL 2 (SOCRATIC):
Q: "What trade-offs or caveats matter?"

LEVEL 3 (SOCRATIC):
Q: "What story does the data tell?"

LEVEL 4 (GUIDED):
"You might highlight [strategic implications]..."

LEVEL 5 (PARTIAL):
Guidance on synthesis and communication

LEVEL 6 (ANSWER):
Example executive summary
```

#### Response Templates (Director)

**Strategic Excellence:**
```
TEMPLATE:
"That's a director-level approach.

You've:
- Recognized the strategic context
- Balanced multiple interpretations
- Acknowledged limitations and caveats
- Designed queries for executive decision-making

This is professional consulting-level work."

(Recognize strategic sophistication)
```

**Multiple Valid Approaches:**
```
TEMPLATE:
"Your interpretation and approach are sound.

Alternative perspectives might include:
1. [Interpretation A] because [reasoning]
2. [Interpretation B] because [reasoning]

What additional analysis would you recommend
to inform the executive decision?"

(Acknowledge multiple valid paths)
```

---

## 🔄 Hint Escalation Algorithm

### When to Escalate

**TRIGGER CONDITIONS:**

```
Escalate when:
1. Student attempts same approach 3+ times unsuccessfully
2. Student shows confusion (unclear queries, wrong tables)
3. Student asks explicitly for help
4. 10+ minutes without progress
5. Query has fundamental misunderstanding (wrong table)
6. Student has tried 2+ different unsuccessful strategies

DO NOT escalate if:
✗ Student is thinking (silence is OK, 30 seconds is normal)
✗ Student just asked and got Level 1 response
✗ Student is on first attempt
✗ Query is close but not quite right (refine, don't escalate)
```

### Escalation Path (By Tier)

**Junior Data Analyst:**
```
Attempt 1: Q1 (What tables?)
Attempt 2: Q2 (Which columns?)
Attempt 3: Q3 (How combine?)
Attempt 4: Guide (Try SELECT...)
Attempt 5: Partial (Structure shown)
Attempt 6+: Answer (Full query)
```

**Senior Data Analyst:**
```
Attempt 1: Q1 (Open question about strategy)
Attempt 2: Q2 (Structured guidance)
Attempt 3: Q3 (Specific scaffolding)
Attempt 4: Guide (Approach suggestion)
Attempt 5: Partial (Query structure)
Attempt 6+: Answer (Full query)
```

**Data Inspector & Above:**
```
Attempt 1: Q1 (Strategic question)
Attempt 2: Q2 (Deep probe)
Attempt 3: Q3 (Refined scaffolding)
Attempt 4: Guided approach
Attempt 5: Partial patterns
Attempt 6+: Answer with alternatives
```

### Escalation Algorithm (Pseudocode)

```
FUNCTION escalate_hint(student, case, attempts, tier):
    
    current_level = student.hint_escalation_level
  
    IF attempts >= 3 AND current_level < 6:
        new_level = MIN(current_level + 1, 6)
        student.hint_escalation_level = new_level
        
        hint = get_hint_template(tier, case, new_level)
  response = generate_response(hint, tier, student)
        
        RETURN response
    
    ELSE IF attempts >= 6:
        # Force answer (should be rare for Tiers 4-5)
        response = get_canonical_query(case)
     RETURN response + "Here's the solution..."
    
    ELSE:
        # Return current level response
        hint = get_hint_template(tier, case, current_level)
        response = generate_response(hint, tier, student)
        RETURN response
    
END FUNCTION
```

---

## 📝 Question and Hint Templates

### Template Structure

```
TEMPLATE:
Q: [Socratic question]
├─ Purpose: [Why ask this]
├─ If answer suggests understanding:
│  └─ Next: [Follow-up or advance to next level]
└─ If answer suggests confusion:
   └─ Next: [Clarification or simpler question]

Hint: [Supportive hint without answer]
└─ Contains: [What student learns from this hint]

Escalation Path:
└─ If stuck after this: [What comes next]
```

### Template Library

#### Tables and Relationships

```
TEMPLATE: "What tables contain [X]?"
Purpose: Student identifies data sources
Tiers: All (tier 1: simple, tier 5: complex)

TEMPLATE: "How are [Table A] and [Table B] related?"
Purpose: Student discovers JOIN logic
Tiers: 2-5

TEMPLATE: "Which columns would you use to connect 
           these tables?"
Purpose: Student identifies join keys
Tiers: 2-5

TEMPLATE: "Could we get this from just [Table]?"
Purpose: Student realizes JOIN needed
Tiers: 2-5
```

#### Filtering and Conditions

```
TEMPLATE: "What's special about the records we want?"
Purpose: Student identifies WHERE clause logic
Tiers: All

TEMPLATE: "How would you express [condition] in numbers?"
Purpose: Student translates business logic to SQL
Tiers: 1-5

TEMPLATE: "Would Amount > [value] capture what we want?"
Purpose: Student evaluates proposed condition
Tiers: 2-5

TEMPLATE: "Do we need all records, or just [subset]?"
Purpose: Student recognizes filtering need
Tiers: 1-3
```

#### Aggregation and Grouping

```
TEMPLATE: "Are we looking for individual records 
           or summary statistics?"
Purpose: Student decides SELECT vs aggregation
Tiers: 2-5

TEMPLATE: "How would you count [X]?"
Purpose: Student recognizes COUNT() need
Tiers: 3-5

TEMPLATE: "Would GROUP BY [column] help organize the data?"
Purpose: Student considers aggregation structure
Tiers: 3-5
```

#### Pattern Recognition

```
TEMPLATE: "What pattern would prove/disprove [hypothesis]?"
Purpose: Student thinks strategically
Tiers: 4-5

TEMPLATE: "What data would an executive need to decide?"
Purpose: Student thinks about information hierarchy
Tiers: 4-5

TEMPLATE: "How would you verify [assumption]?"
Purpose: Student designs validation query
Tiers: 3-5
```

---

## 🎯 Error Handling Patterns

### Query Analysis Response

```
ERROR PATTERN: Wrong Table Selected

RESPONSE TEMPLATE:
"Interesting choice. Let me ask: 
 does [incorrect table] contain [information needed]?
 
 Let's think about which table would have [specific data]."

ACTION: Ask guiding question, not correction

---

ERROR PATTERN: Wrong Approach (Query Syntax)

RESPONSE TEMPLATE:
"Your logic is right, but the SQL syntax needs adjustment.

You're thinking correctly about [logic].
SQL expresses that as: [syntax explanation]"

ACTION: Affirm reasoning, correct syntax

---

ERROR PATTERN: Logic Error (Wrong Answer)

RESPONSE TEMPLATE:
"Let me trace through your logic:
 You're getting [X records] because [reason].
 
 But the question asks for [Y records].
 How would you adjust your query?"

ACTION: Help trace error source, guide to fix

---

ERROR PATTERN: Fundamental Misunderstanding

RESPONSE TEMPLATE:
"I notice you're approaching this as [wrong angle].

Actually, the case is asking [correct angle].
Let's start by identifying [first step]."

ACTION: Redirect to correct approach, gentle restart
```

---

## 🔐 Safety Guardrails

### Response Validation Checklist

**Before delivering ANY response, verify:**

```
✅ SOCRATIC METHOD CHECK
   - Does response start with question?
   - Is it tier-appropriate scaffolding?
   - Is it at correct escalation level?
   - Could student discover from this?

✅ TIER APPROPRIATENESS CHECK
   - Is complexity level correct for tier?
   - Is guidance level right (too much/too little)?
   - Are assumptions correct for tier knowledge?
   - Does it assume prior tier mastery?

✅ SAFETY CHECK
   - No direct answers (unless Level 6)
   - No spoilers or solutions
   - No dismissive or discouraging language
   - Respectful of student effort

✅ CLARITY CHECK
   - Is question clear and unambiguous?
   - Could student misunderstand intent?
   - Is language appropriate for tier?
   - Is response focused (not scattered)?

✅ PROGRESS CHECK
   - Does this move toward solution?
   - Is it actionable by student?
   - Can student respond productively?
   - Does it advance learning?
```

### Prohibited Responses

```
❌ NEVER respond with:
   - "That's wrong. The answer is..."
   - "You clearly don't understand..."
   - "Just use [command] without explaining why"
   - "SELECT * FROM..."
   - Sarcasm or frustration
   - Comparisons to other students
   - "Try random approaches until it works"
   - Very long, complex explanations

✅ INSTEAD:
   - Ask what student tried and why
   - Guide toward discovery
   - Celebrate near-correct attempts
   - Break down complex into simple steps
   - Be encouraging and supportive
   - Focus on learning, not perfection
```

---

## 💾 Conversation State Management

### State Tracking

**State Variables to Maintain:**

```
PER-STUDENT-PER-CASE:
├─ hint_escalation_level (1-6)
├─ attempt_count (0, 1, 2, ...)
├─ query_history (array of attempted queries)
├─ feedback_history (array of responses given)
├─ stuck_detection_flag (true/false)
├─ discovery_markers (what student has figured out)
└─ confidence_signal (high/medium/low - inferred)

PER-INTERACTION:
├─ student_query (SQL attempt)
├─ query_error_type (if error)
├─ suggested_direction (what to probe)
├─ escalation_triggered (true/false)
└─ response_template_used (which template)
```

### State Transitions

```
START STATE:
├─ hint_escalation_level = 1 (Socratic question)
├─ attempt_count = 0
└─ stuck_detection_flag = false

AFTER EACH ATTEMPT:
├─ attempt_count += 1
├─ Store query in history
├─ Evaluate correctness
├─ IF correct:
│  └─ Celebrate, suggest next case
├─ IF partially correct:
│  └─ Affirm correct part, guide refinement
├─ IF incorrect:
│  ├─ Check escalation triggers
│  ├─ IF should escalate:
│  │  └─ hint_escalation_level += 1
│  └─ Otherwise:
│   └─ Refine current level response
└─ Generate next response

STUCK DETECTION:
├─ IF attempt_count >= 6 AND still incorrect:
│  ├─ stuck_detection_flag = true
│  ├─ Set hint_escalation_level = 6 (answer coming)
│  └─ Generate final answer with explanation
```

---

## 🧪 Testing and Validation

### Response Validation Test Cases

**Test Case 1: Correct Query, First Attempt**

```
Input: Student submits correct query on first attempt
Expected: Celebration response, acknowledgment of thinking
Verify:
✓ Response shows what student did right
✓ Moves forward confidently
✓ Suggests next question naturally
```

**Test Case 2: Correct Query, After 3 Attempts**

```
Input: Correct query after multiple wrong attempts
Expected: Strong celebration, recognition of persistence
Verify:
✓ Acknowledges effort
✓ Shows what clicked
✓ Builds confidence for next challenge
```

**Test Case 3: Partially Correct Query**

```
Input: Query has right logic, small error
Expected: Affirms correct reasoning, guides fix
Verify:
✓ Shows which part is right
✓ Questions about wrong part
✓ Doesn't reveal answer yet
```

**Test Case 4: Fundamentally Wrong Approach**

```
Input: Student attempts wrong table or logic
Expected: Gentle redirection to correct approach
Verify:
✓ Doesn't shame student
✓ Questions to redirect thinking
✓ Restarts at Level 1 with correct approach
```

**Test Case 5: Stuck After 6+ Attempts**

```
Input: Student stuck and frustrated
Expected: Final answer with clear explanation
Verify:
✓ Answer is provided
✓ Explanation shows why
✓ Encouragement for next case
✓ Confidence restored
```

### Performance Requirements

```
RESPONSE TIME:
├─ User types query
├─ Query submitted to Query Tutor
├─ ✓ Must respond within 2 seconds
├─ ✓ Typical response: < 500ms
└─ ✓ Max acceptable: 5 seconds

ACCURACY:
├─ Socratic responses: 100% maintain method
├─ Tier appropriateness: 95%+ correct
├─ Escalation correctness: 98%+ on/off decisions
└─ Error detection: 99%+ catch real errors

QUALITY:
├─ Responses helpful to learning: 90%+ rating
├─ Student feels supported: 85%+ positive
├─ Students discover answers: 75%+ without direct answer
└─ Students progress independently: 60%+ by Tier 4-5
```

---

## 🔗 Integration Points

### Case Context Integration

**Query Tutor receives from Case System:**

```
{
  caseId: "case_001",
  caseName: "The Timeline Discrepancy",
  studentTier: "Senior Data Analyst",
  expectationType: "find contradictions",
  expectedTables: ["Transactions", "Accounts"],
  canonicalQuery: "SELECT...",
  caseContext: {
    narrative: "...",
    evidence: {...},
    storySteps: {...}
  },
  studentState: {
  caseProgress: "step 2 of 4",
    previousQueries: [...],
    timeSoFar: 480,  // seconds
    attemptCount: 3
  }
}
```

**Query Tutor provides to Response System:**

```
{
  responseType: "socratic_question",
  tier: "Senior Data Analyst",
  escalationLevel: 2,
  question: "...",
  hint: "...",
  tone: "encouraging",
  suggestsNext: "...",
  studentState: {
 progression: "discovering contradiction",
    confidenceLevel: "medium"
  }
}
```

### Database Agent Integration

**Query Tutor coordinates with Database Agent:**

```
When student asks about schema:
├─ Query Tutor: "What would [Database Agent] tell you?"
├─ Routes to Database Agent for schema questions
├─ Database Agent explains schema tier-appropriately
└─ Query Tutor: "Now that you understand, 
  what query would you try?"

When Query Tutor needs context:
├─ Asks Database Agent about schema
├─ Gets tier-appropriate explanation
├─ Incorporates into Socratic questions
```

---

## 📊 Success Metrics

### Learning Effectiveness

```
METRIC: Independent Discovery Rate
Definition: % of cases where student discovers answer 
            without seeing direct query
Target: 70% for Tiers 1-2, 80% for Tiers 3-4, 90% for Tier 5
Measurement: Track when student queries match expected logic

METRIC: Escalation Appropriateness
Definition: % of escalations that were needed
Target: 95%+ escalations are triggered appropriately
Measurement: Compare escalations to attempt counts

METRIC: Student Confidence
Definition: Self-reported confidence after solving
Target: 75%+ students feel confident after Query Tutor help
Measurement: Post-case survey

METRIC: Learning Retention
Definition: Students remember concepts in future cases
Target: 80%+ can apply concepts from previous Query Tutor help
Measurement: Success rates in tier progression
```

### Technical Performance

```
METRIC: Response Accuracy
Definition: % responses maintain Socratic method
Target: 100% for critical path, 98% overall
Measurement: QA review of sample responses

METRIC: Response Time
Definition: Time from query submission to response
Target: < 2 seconds, < 500ms typical
Measurement: System instrumentation

METRIC: Error Detection
Definition: % of actual query errors caught
Target: 99%+
Measurement: Compare detected vs actual errors
```

---

## 📚 Related Documents

**Core Standards:**
- `DataQuest-Tier-System-Official-Design-Guideline.md`
- `Agent-Prompt-Engineering-Standards.md`

**Integration Points:**
- `Database-Agent-Implementation-Specification.md`
- `Case-Lifecycle-and-State-Management.md`
- `UI-UX-Design-Specification.md`

**Case Design:**
- `Case-Design-Template-and-Examples.md`

**Testing:**
- `Testing-and-QA-Implementation-Guide.md`

---

## ✅ Implementation Checklist

### Before Development Starts

```
[ ] Understand Socratic method requirements
[ ] Review all question patterns and templates
[ ] Understand escalation algorithm and triggers
[ ] Review error handling patterns
[ ] Understand state management requirements
[ ] Understand safety guardrails and prohibited responses
```

### Development Tasks

```
[ ] Implement Context Analyzer component
[ ] Implement Socratic Engine component
[ ] Implement Response Generator component
[ ] Implement Response Validator component
[ ] Create question template database
[ ] Implement escalation algorithm
[ ] Implement state tracking and transitions
[ ] Integrate with Case System
[ ] Integrate with Database Agent
```

### Testing Tasks

```
[ ] Unit test each component
[ ] Test each response template with sample queries
[ ] Test escalation triggers and algorithm
[ ] Test error handling patterns
[ ] Test state transitions
[ ] Test Socratic method validation
[ ] End-to-end test with sample cases
[ ] Performance testing (response time, accuracy)
```

### QA and Validation

```
[ ] Code review for Socratic method compliance
[ ] QA test with all tier samples
[ ] Validate safety guardrails
[ ] Test edge cases and error conditions
[ ] Performance validation
[ ] User testing with sample students
[ ] Feedback incorporation
```

---

## 🎓 Conclusion

The Query Tutor Agent is the **heart of DataQuest's learning experience**. This specification operationalizes the Socratic method into concrete behavior patterns that guide students from any tier to discover SQL solutions through reasoning, not memorization.

**Key Success Factors:**

1. **NEVER abandon Socratic method** - This is non-negotiable
2. **Tier-appropriate scaffolding** - Not all students need all guidance
3. **Escalation only when needed** - Trust student reasoning first
4. **Safety and encouragement** - Create psychological safety for learning
5. **Clear state management** - Track progress and avoid loops

---

**IMPLEMENTATION SPECIFICATION COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR DEVELOPMENT**

