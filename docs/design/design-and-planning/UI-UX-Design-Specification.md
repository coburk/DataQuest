# UI/UX Design Specification

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - CRITICAL PATH  
**Version:** 1.0  
**Classification:** Binding Implementation Standard

---

**SOURCE OF TRUTH TRACKING**

**COMPLIANCE STATUS:** ✅ PROPOSAL-COMPLIANT (with approved extensions)  
**SOURCE OF TRUTH:** 
- Tier 1: `docs/proposal/DataQuest-Project-Proposal.md` (Appendix A: UI Mockups)
- Tier 3: This document

**CHANGE REQUESTS:** CR002 (Approved Extensions - Phase 2/3 forward-looking design)  
**CAPSTONE IMPACT:** ZERO (all extensions clearly marked Phase 2/3+)  
**LAST COMPLIANCE REVIEW:** December 3, 2025  
**REVIEWED BY:** Systematic Compliance Review

---

## 📋 Document Purpose

This specification defines the user interface and user experience for DataQuest: SQL Detective. It operationalizes the tier system, agent coordination, and pedagogical principles into concrete visual and interaction patterns that make learning SQL engaging and intuitive.

**This document enables:**
- ✅ Developers to build UI without ambiguity
- ✅ QA to validate UX without clarification
- ✅ Designers to maintain consistency
- ✅ Stakeholders to understand student experience

---

## 🎯 Scope

### What This Document Covers

```
✅ Overall application layout and structure
✅ Dashboard/home screen design
✅ Case selection interface
✅ Case execution interface
✅ Query editor and submission
✅ Evidence/timeline display
✅ Hint system UI
✅ Achievement and progression display
✅ Tier advancement messaging
✅ Navigation patterns
✅ Responsive design guidelines
✅ Accessibility standards
✅ Error and feedback display
✅ Agent coordination indicators
✅ Student context awareness
```

### What This Document Does NOT Cover

```
❌ Specific visual style/branding (color palette, fonts)
❌ Detailed code implementation
❌ Backend architecture
❌ Database schema
❌ Agent implementation details
❌ Mobile app (future Phase 3)
```

---

## 🏗️ Architecture Overview

### Application Structure

```
DataQuest Application
│
├─ AUTHENTICATION LAYER (Phase 2+)
│  └─ Session management
│
├─ NAVIGATION LAYER
│  ├─ Main navigation
│  ├─ Breadcrumb trail
│  └─ Context indicators
│
├─ MAIN CONTENT AREA
│  ├─ Dashboard (Phase 2+)
│  ├─ Case Selection
│  ├─ Case Execution
│  └─ Results/Achievement Display
│
├─ AGENT COORDINATION LAYER
│  ├─ Query Tutor display
│  ├─ Database Agent display
│  └─ Context sharing
│
└─ CONTEXTUAL ELEMENTS
   ├─ Current tier display
   ├─ Progress indicators
   ├─ Time tracking
   └─ Help/support
```

### Screen Hierarchy

```
TIER 1 (MVP - Phase 1):
├─ Home/Start Screen
├─ Case Selection Screen
├─ Case Execution Screen
└─ Completion Screen

TIER 2 (Enhanced - Phase 2):
├─ Login Screen
├─ Dashboard Screen (Progression tracking)
├─ Case Selection (Updated)
├─ Case Execution (Updated)
└─ Achievement Display

TIER 3+ (Advanced - Phase 3+):
├─ Career Dashboard
├─ Analytics Dashboard
├─ Custom case creation
└─ Social features
```

---

## 📐 Core Screen Designs

### Screen 1: Home/Start Screen

#### Purpose
```
First impression, case selection entry point
Communicates tier system and progression concept
Sets tone for learning experience
```

#### Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective    [?]                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  "Welcome to DataQuest!"                                    │
│  "You're beginning your data career                         │
│   as a Junior Data Analyst"                                 │
│                                                             │
│  [Hero Section: Career Progression Visual]                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ Junior    Senior    Data        Data        Director  │  │
│  │ Data    → Data    → Inspector → Detective → Of Data   │  │
│  │ Analyst   Analyst                           Integrity │  │
│  │   ✓         ○          ○           ○           ○      │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  Your Current Role: Junior Data Analyst [Bronze ◆]          │
│  Progress: 0/3 cases complete                               │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    [START A CASE]                     │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│  "In DataQuest, you advance through authentic               │
│   career roles by solving data mysteries using SQL"         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

#### Key Elements

**Tier Progression Visual:**
```
PURPOSE: Show career path visually
DESIGN:
- 5 tier boxes with icons/badges
- Current tier highlighted (Bronze medal for Tier 1)
- Locked appearance for future tiers
- Clear advancement pathway

INTERACTION:
- Hover to see tier details
- Click to see upcoming tier requirements
- Click to see tier characteristics
```

**Role Display:**
```
PURPOSE: Reinforce current career position
DESIGN:
- Prominent: "Your Current Role: Junior Data Analyst"
- Badge icon matching tier (Bronze, Silver, Gold, etc.)
- Tier description short blurb
- Progress: X of Y cases complete

MESSAGING:
- Tier 1: "You're beginning your data career"
- Tier 2: "You're developing specialization"
- Tier 3: "You're mastering quality verification"
- Tier 4: "You're solving complex investigations"
- Tier 5: "You're leading data strategy"
```

**Call-to-Action Button:**
```
PURPOSE: Clear primary action
DESIGN:
- Large, prominent button
- Text: "START A CASE" (not "Play", not "Begin Level")
- Professional appearance
- Clearly clickable

STATE:
- Default: Active and inviting
- Hover: Subtle animation
- Disabled: If no cases available (rare)
```

---

### Screen 2: Case Selection Screen

#### Purpose
```
Show available cases
Display current tier cases prominently
Show locked future tier cases
Enable case filtering/organization
```

#### Layout Structure

```
┌─────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective    [?]  [←Back]           │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Select Your Investigation                          │
│  ─────────────────────────────────────────────────  │
│                                                     │
│  Your Current Tier: Junior Data Analyst             │
│  Progress: 1/3 cases complete → [Continue tier]     │
│                                                     │
│  ┌─────────────────────────────────────────────┐    │
│  │ AVAILABLE CASES (Your Tier)                 │    │
│  └─────────────────────────────────────────────┘    │
│                                                     │
│  ┌──────────────────┐  ┌──────────────────┐         │
│  │ [✓] The Missing  │  │ [ ] Timeline     │         │
│  │     Code         │  │Discrepancy       │         │
│  │ Simple case      │  │ Simple case      │         │
│  │ 5-7 min          │  │ 5-7 min          │         │
│  │ Junior Analyst   │  │ Junior Analyst   │         │
│  │    [START]       │  |                  │         |
│  └──────────────────┘  └──────────────────┘         │
│                                                     │
│  ┌──────────────────┐                               │
│  │ [ ] The Account  │                               │
│  │     Mystery      │                               │
│  │ Simple case      │                               │
│  │ 7-9 min          │                               │
│  │ Junior Analyst   │                               │
│  │ [START]          │                               │
│  └──────────────────┘                               │
│                                                     │
│  ─────────────────────────────────────────────────  │
│  NEXT TIER PREVIEW                                  │
│  ─────────────────────────────────────────────────  │
│  Complete 3/3 cases to unlock Senior Data Analyst   │
│                                                     │
│  ┌───────────────────────────────────────────────┐  │
│  │ [🔒] Data Quality Check    [Unlock at Tier 2] │  │
│  │ [🔒] Transaction Patterns  [Unlock at Tier 2] |  │
│  └───────────────────────────────────────────────┘  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

#### Key Elements

**Tier Header:**
```
PURPOSE: Remind student of current tier and progress
DESIGN:
- Clear tier name
- Progress bar or counter: "1/3 cases complete"
- Link to continue current tier
- Visual tier badge

INTERACTION:
- Click badge to see tier characteristics
- Click progress to see promotion criteria
```

**Case Card (Available):**
```
PURPOSE: Show case option that's available
DESIGN:
- Card layout with:
  ├─ Checkmark if completed (✓)
  ├─ Case title (professional, not gamified)
  ├─ One-line description
  ├─ Estimated time (5-7 min, 10-15 min, etc.)
  ├─ Tier designation (Junior Data Analyst)
  └─ START button

STATES:
- New case: Available, clickable START button
- In progress: Checkmark + "CONTINUE" button
- Completed: Checkmark + "REVIEW" button (optional)

INTERACTION:
- Hover: Subtle highlight
- Click START: Launch case
- Click title: Show case description popup
```

**Case Card (Locked):**
```
PURPOSE: Show future cases and unlock criteria
DESIGN:
- Card layout with:
  ├─ Lock icon (🔒)
  ├─ Case title (grayed out)
  ├─ Gray background
  ├─ "Unlock at [Tier Name]" label
  └─ No clickable button

INTERACTION:
- Hover: Show "Complete current tier to unlock"
- Click: Show tier requirements popup
```

**Tier Progression Section:**
```
PURPOSE: Show remaining cases and unlock path
DESIGN:
- Section header: "NEXT TIER PREVIEW"
- Short message: "Complete 3/3 cases to unlock 
  Senior Data Analyst"
- Grid of 2-3 locked case cards
- Shows clear progression path

INTERACTION:
- Click any locked case: Show unlock requirements
- Shows what tier/cases needed
```

---

### Screen 3: Case Execution Screen (Primary)

#### Purpose
```
Core learning interface where student solves SQL cases
Coordinate Query Tutor and Database Agent
Display evidence/context
Enable query submission
INLINE RESULTS DISPLAY with collapsible panels
```

#### Layout Structure

```
┌────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective [?]  [Tier] [←Back]              │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  Case: The Missing Code    ⏱ 12:34 / 15 min               │
│  Junior Data Analyst  |  Step 1 of 3                       │
│  ──────────────────────────────────────────────────────────│
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ CASE NARRATIVE [−]                                  │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │ You're a Junior Data Analyst investigating a        │   │
│  │ customer complaint. A code was entered but never    │   │
│  │ recorded in the system. Find all missing codes      │   │
│  │ from the CodeLog table.                             │   │
│  │                                                     │   │
│  │ Available tables: CodeLog, Customers                │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
││ CURRENT QUESTION [−]                                  │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │ Q: Which customer codes have Status = 'Missing'?    │   │
│  │                                                     │   │
│  │ [? Help]  [💡 Hint]  [📊 Schema]                    │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ YOUR QUERY [−] [↔ Split View]                       │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │ SELECT CustomerID, Code                             │   │
│  │ FROM CodeLog                                        │   │
│  │ WHERE Status = 'Missing'                            │   │
│  │                                                     │   │
│  │ [SUBMIT QUERY] [CLEAR] [Copy from earlier]          │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ RESULTS [−] (23 rows)   ✅ CORRECT!                 │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │ CustomerID  Code                                    │   │
│  │ ──────────────────────                              │   │
│  │ 101       ABC123                                    │   │
│  │ 102     DEF456                                      │   │
│  │ 103         GHI789                                  │   │
│  │ ...     ...                                         │   │
│  │                                                     │   │
│  │ ✅ You identified all 23 missing codes!             │   │
│  │                                                     │   │
│  │ [NEXT QUESTION] [REVIEW QUERY]                      │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  Agent Responses:                                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ QUERY TUTOR HINTS [+]                               │   │
│  ├─────────────────────────────────────────────────────┤   |
│  │ (Collapsed - click to expand)                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ DATABASE SCHEMA [+]                                 │   │
│  ├─────────────────────────────────────────────────────┤   |
│  │ (Collapsed - click to expand)                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

#### Key Elements

**Header Section:**
```
PURPOSE: Situate student in case and tier
DESIGN:
├─ Case title: "The Missing Code"
├─ Tier badge: "Junior Data Analyst"
├─ Progress indicator: "Step 1 of 3"
├─ Timer: "12:34 / 15 min"
└─ Navigation: Back button, tier info

INTERACTIVE ELEMENTS:
- Click timer: Show case time estimate details
- Click step: Show investigation map
- Click tier badge: Show tier requirements
```

**Case Narrative Panel:**
```
PURPOSE: Set investigation context and tone
DESIGN:
├─ Collapsible: Click [−] to collapse, [+] to expand
├─ Professional, investigative language
├─ Clear investigation goal
├─ Available tables listed
├─ 2-3 paragraphs max (keep focused)
└─ Default state: EXPANDED

EXAMPLE (Tier 1):
"You're a Junior Data Analyst investigating a customer 
complaint. A code was entered but never recorded in the 
system. Find all missing codes from the CodeLog table."

EXAMPLE (Tier 4):
"As a Data Detective, you're investigating a complex pattern 
of inconsistencies. The CodeLog table shows codes, but 
there's a deeper issue. Your investigation should reveal 
the underlying contradiction."
```

**Question Display:**
```
PURPOSE: Show current investigation step
DESIGN:
├─ Collapsible: Click [−] to collapse
├─ Clear question phrasing
├─ Links to help resources (Hint, Schema)
├─ Focuses student on specific task
└─ Default state: EXPANDED

TIER ADAPTATION:
Tier 1: "Which customer codes have Status = 'Missing'?
Tier 3: "What data quality issues can you identify in 
      the CodeLog table? How would you verify them?"
Tier 5: "What multiple interpretations of this data are 
         possible? What would you recommend strategically?"
```

**Query Editor:**
```
PURPOSE: Enable SQL query writing
DESIGN:
├─ Collapsible: Click [−] to collapse
├─ Syntax-highlighted text area
├─ Line numbers
├─ Monospace font (SQL standard)
├─ Auto-indent support
├─ Split View toggle button: [↔ Split View]
└─ Default state: EXPANDED

FEATURES:
- Syntax highlighting for SQL keywords
- Line numbers for error reference
- Copy/paste support
- Clear button to reset
- Option to load prior queries
- Character count or size indicator

HEIGHT: 200-300px (enough to see queries)

SPLIT VIEW (Desktop 1200px+):
- [↔ Split View] button in header
- Toggles to side-by-side layout
- Editor on left (50%), Results on right (50%)
- Responsive: Tablet/Mobile use stacked layout
```

**Query Editor Controls:**
```
PURPOSE: Submit, manage, and reference queries
DESIGN:
├─ [SUBMIT QUERY] - Primary action (prominent)
├─ [CLEAR] - Secondary action
└─ [Copy from earlier] - Tertiary action

STATES:
- Submit button: Active when query present
- Disabled if query is empty
- Loading state while processing
- Success/error state after submission
```

**Results Panel (NEW - INLINE):**
```
PURPOSE: Display query results immediately on same screen
DESIGN:
├─ Collapsible: Click [−] to collapse, [+] to expand
├─ Appears immediately after query submission
├─ Shows on Screen 3 (not separate Screen 4)
├─ Visual status indicator: ✅ CORRECT! / ⚠️ Not quite / ❌ Error
└─ Default state: EXPANDED (when results available)

DISPLAY ELEMENTS:
- Result count: "23 rows"
- Status message: "✅ You identified all 23 missing codes!"
- Data table: Column headers + first 20-50 rows
- Pagination: If more than 50 rows
- Action buttons: [NEXT QUESTION] [REVIEW QUERY]

VISUAL HIERARCHY:
1. Status (✅/⚠️/❌) - Most prominent
2. Results table - Secondary
3. Feedback message - Below results
4. Action buttons - Bottom
```

**Query Tutor Panel:**
```
PURPOSE: Display agent guidance
DESIGN:
├─ Collapsible: Click [−] to collapse, [+] to expand
├─ Label: "QUERY TUTOR HINTS"
├─ Shows current hint or question
├─ Escalation level indicator: "Level 1/6"
├─ [MORE] button for next level
└─ Default state: COLLAPSED (save screen space)

DISPLAY PATTERNS:
- Question at Level 1: "What tables contain...?"
- Hint at Level 3: "You might use SELECT..."
- Partial answer at Level 5: "SELECT [...] FROM [table] WHERE..."
- Full answer at Level 6: "SELECT CustomerID..."

INTERACTION:
- [MORE] button: Request next hint level
- Click header to expand when needed
- Auto-escalate if stuck (configurable)
- Clear history button (optional)
```

**Database Schema Panel:**
```
PURPOSE: Provide schema information on demand
DESIGN:
├─ Collapsible: Click [−] to collapse, [+] to expand
├─ Label: "DATABASE SCHEMA"
├─ Relevant table descriptions
├─ Key columns listed
├─ Data type and constraints
└─ Default state: COLLAPSED (save screen space)

DISPLAY:
- Show only relevant tables for current question
- Expandable/collapsible sections
- [View full schema] link
- [Ask about column] action

INTERACTION:
- Click table: Expand to show columns
- Click column: Show details and examples
- Search for specific table/column
```

**Collapsible Panel Behavior:**
```
MECHANICS:
- Click [−] in header → Section collapses, shows [+]
- Click [+] → Section expands, shows [−]
- Animation: 200ms slide transition
- State persists during session
- State resets on new question

DEFAULT STATES (MVP):
✓ EXPANDED:  Case Narrative (context needed)
✓ EXPANDED:  Current Question (primary focus)
✓ EXPANDED:  Your Query (where student works)
✓ EXPANDED:  Results (feedback when available)
✗ COLLAPSED: Query Tutor (expand for help)
✗ COLLAPSED: Database Schema (expand for reference)

REASONING:
- Show critical elements by default
- Hints/Schema collapse to reduce visual clutter
- Student controls what they see
```

---

### Screen 4: Query Results Screen (OPTIONAL - For Review/History)

#### Purpose
```
DEPRECATED - Results now display inline on Screen 3
This screen is now OPTIONAL, used only for:
- Detailed result review (if student clicks [REVIEW QUERY])
- Historical query results browsing
- Advanced analysis view (Phase 2+)

PRIMARY WORKFLOW: All results shown on Screen 3
```

#### Layout Structure (Optional Review View)

```
┌────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective     [?]  [Tier] [←Back]          │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ✅ CORRECT! Excellent Query!                              │
│  ──────────────────────────────────────────────────────────│
│                                                            │
│  Your Query:                                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ SELECT CustomerID, Code                              │  │
│  │ FROM CodeLog                                         │  │
│  │ WHERE Status = 'Missing'                             │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  Results (23 rows):                                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ CustomerID  Code                                     │  │
│  │ ──────────────────────                               │  │
│  │ 101    ABC123                                        │  │
│  │ 102         DEF456                                   │  │
│  │ 103       GHI789                                     │  │
│  │ ...         ...                                      │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                            │
│  ✅ You identified all 23 missing codes!                   │
│                                                            │
│  What you did right:                                       │
│  • Selected relevant columns                               │
│  • Filtered for correct status                             │
│  • Retrieved all matching records                          │
│                                                            │
│  Ready for next question?                                  │
│                                                            │
│[NEXT QUESTION] [REVIEW QUERY] [CONTINUE INVESTIGATION]     │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

---

### Screen 5: Case Completion Screen

#### Purpose
```
Celebrate completion
Display tier advancement opportunity
Show achievement badge
Suggest next case
```

#### Layout Structure

```
┌──────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective                [?]  [Tier] [←Back] │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  🎉 CASE COMPLETE! Excellent Investigation!                  │
│  ════════════════════════════════════════════════════════════│
│                                                              │
│  Case: The Missing Code      ⏱ 8:32 / 15 min                │
│  Junior Data Analyst              ✓ SOLVED                   │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ INVESTIGATION SUMMARY                                  │  │
│  ├────────────────────────────────────────────────────────┤  │
│  │                                                        │  │
│  │ ✓ Found 23 missing codes                               │  │
│  │ ✓ Identified root cause (Status = 'Missing')           │  │
│  │ ✓ Verified result accuracy                             │  │
│  │                                                        │  │
│  │ Key SQL Skills Demonstrated:                           │  │
│  │ • SELECT with specific columns                         │  │
│  │ • WHERE clause with conditions                         │  │
│  │ • Filtering data effectively                           │  │
│  │                                                        │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ TIER PROGRESS                                          │  │
│  ├────────────────────────────────────────────────────────┤  │
│  │                                                        │  │
│  │ You've completed 2 of 3 Junior Data Analyst cases      │  │
│  │                                                        │  │
│  │ [██████░░░░░░] 66% complete                            │  │
│  │                                                        │  │
│  │ 1 more case to unlock: Senior Data Analyst             │  │
│  │ • Gain specialization skills with JOINs                │  │
│  │ • Work with multiple data sources                      │  │
│  │ • Resolve data contradictions                          │  │
│  │                                                        │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  [NEXT CASE] [BACK TO CASES] [VIEW STATISTICS]               │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

#### Key Elements

**Celebration Header:**
```
PURPOSE: Celebrate achievement
DESIGN:
- 🎉 Emoji for celebration
- Congratulatory message
- Professional tone (not gamified)
- Case title and result

MESSAGING:
"CASE COMPLETE! Excellent Investigation!"
"You've solved [case name]"
"Time: 8:32 (well under 15 min estimate)"
```

**Investigation Summary:**
```
PURPOSE: Reflect on learning accomplished
DESIGN:
- ✓ Accomplishments listed
- ✓ SQL skills demonstrated
- ✓ Concepts mastered
- Brief reflection on investigation

EXAMPLE:
"✓ Found 23 missing codes
✓ Identified root cause (Status = 'Missing')
✓ Verified result accuracy

Key SQL Skills Demonstrated:
• SELECT with specific columns
• WHERE clause with conditions
• Filtering data effectively"
```

**Tier Progress Display:**
```
PURPOSE: Show advancement toward next tier
DESIGN:
- Progress bar (visual percentage)
- Counter: "2 of 3 cases complete"
- Clear unlock criteria
- Next tier preview

MESSAGING:
"1 more case to unlock: Senior Data Analyst"
[Show next tier benefits]
[Show next tier case preview]
```

**Action Buttons:**
```
PURPOSE: Enable next action
DESIGN:
- [NEXT CASE] - Primary action (advance through tier)
- [BACK TO CASES] - Return to case selection
- [VIEW STATISTICS] - Show stats (optional, Phase 2+)
```

---

### Screen 6: Phase 2 Dashboard (Progress Tracking)

#### Purpose
```
Show career progression (Phase 2+)
Display achievements and badges
Enable case recommendations
Show analytics (Phase 3+)
```

#### Layout Structure (Phase 2)

```
┌────────────────────────────────────────────────────────────────┐
│  DataQuest: SQL Detective     [📊 Dashboard] [?] [⚙️] [👤]    │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  Welcome back, Data Detective!                                 │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ YOUR CAREER PROGRESSION                                  │  │
│  │                                                          │  │
│  │ ✓ Junior Data Analyst      (Bronze ◆)  Dec 1             │  │
│  │ ✓ Senior Data Analyst  (Silver ◆)Dec 5                   │  │
│  │ ● Data Inspector    (Gold ◆)    In Progress              │  │
│  │   2 of 5 cases complete                                  │  │
│  │ ○ Data Detective           (Platinum ◆) Locked           │  │
│  │ ○ Director of Data         (Diamond ◆) Locked            │  │
│  │   Integrity                                              │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ ACHIEVEMENTS                                             │  │
│  │ Bronze ◆    Silver ◆    Gold ◆    [Platinum ◆]           │  │
│  │      Locked    [Diamond ◆]                               │  │
│  │ Locked                                                   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ CURRENT TIER: Data Inspector                             │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │ Progress: [██████░░░░░░░░░░] 40% complete                │  │
│  │ 2 of 5 cases complete                                    │  │
│  │ 3 more cases to unlock Data Detective                    │  │
│  │                                                          │  │
│  │ [CONTINUE CURRENT TIER] [VIEW ALL CASES]                 │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ RECOMMENDED NEXT CASE                                    │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │                                                          │  │
│  │ Quality Assurance Investigation (Data Inspector)         │  │
│  │ Estimated time: 20-30 minutes                            │  │
│  │ Difficulty: Moderate (2-3 contradictions)                │  │
│  │ Focus: Multi-table queries and pattern detection         │  │
│  │                                                          │  │
│  │ [START CASE]                                             │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ LEARNING STATISTICS (Phase 3+)                           │  │
│  │ Total time invested: 3 hours 27 minutes                  │  │
│  │ Cases completed: 7                                       │  │
│  │ Average query attempts: 2.3 per case                     │  │
│  │ SQL skills: Intermediate (improving)                     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## 🎨 Design Principles

### 1. Career Progression Over Gamification

```
✅ DO:
- "Your Role: Senior Data Analyst"
- "Advance to Data Inspector"
- Professional tier names
- Career-focused language

❌ DON'T:
- "Level 2 Unlocked!"
- "Achievement: 50 XP earned!"
- "Streak: 7 days!"
- Game-centric language
```

### 2. Clarity Over Complexity

```
✅ DO:
- Clear SQL syntax highlighting
- Simple, professional layout
- One question at a time
- Obvious affordances (buttons, links)

❌ DON'T:
- Cluttered interface
- Too many options at once
- Confusing navigation
- Hidden or unclear actions
```

### 3. Support Over Judgment

```
✅ DO:
- "Let me ask..." (Socratic)
- "You're thinking correctly..."
- "That's an interesting approach..."
- Encouraging tone always

❌ DON'T:
- "That's wrong!"
- "Obviously..."
- "You should know this..."
- Dismissive language
```

### 4. Context Over Isolation

```
✅ DO:
- Show tier and progress always
- Connect to case investigation
- Reference prior queries
- Show time and estimate

❌ DON'T:
- Isolated query editor (no context)
- No tier reference
- Generic, decontextualized hints
- Time pressure without estimate
```

---

## 📱 Responsive Design Guidelines

### Breakpoints

```
DESKTOP (1200px+):
- Full multi-panel layout with collapsible sections
- Split View option available: [↔ Split View] toggles editor/results side-by-side
- Large query editor (300px+ height)
- All panels visible (user can collapse as needed)
- Side-by-side: Editor (50%) | Results (50%)

TABLET (768px - 1199px):
- Single column with collapsible sections
- Stacked agent panels
- Medium query editor (250px height)
- Scrollable content with collapse/expand management
- Tabs: [Query Editor | Results] when split view active

MOBILE (< 768px):
- Single column layout with collapsible sections
- Modal dialogs for schema/hints (Phase 3+)
- Full-width query editor
- Stacked layout: Query → Results (scrollable)
- Bottom navigation
```

### Query Editor Adaptation

```
DESKTOP (1200px+):
- Default: 300px+ height
- Split View option: Editor (50% width) | Results (50% width)
- Syntax highlighting: Full
- Side-by-side comparison view

TABLET (768px - 1199px):
- Height: 250px
- Width: 100% (full column)
- Tabs: [Query Editor | Results]
- Syntax highlighting: Simplified (less visual overhead)
- Collapsible results above/below as needed

MOBILE (< 768px):
- Height: 200px (keyboard-aware on mobile)
- Width: 100% (full screen)
- Results below (scrollable)
- Stacked layout (no side-by-side)
```

### Collapsible Panel Behavior

```
DESKTOP (1200px+):
- User can collapse/expand any panel
- Collapse state persists during session
- Recommended: Keep Results expanded (primary feedback)
- Recommended: Collapse Hints/Schema (on demand)

TABLET (768px - 1199px):
- Panel collapse/expand essential for space management
- Default: Only show 1-2 expanded panels
- Others available via collapse/expand
- Swipe gestures optional (Phase 3+)

MOBILE (< 768px):
- Collapse/expand critical for usability
- Smaller screens benefit from panel hiding
- Default: Query and Results expanded
- Hints/Schema collapsed by default
- One-finger scroll through collapsed sections
```

### Split View Toggle

```
LOCATION: [↔ Split View] button in Query Editor header

DESKTOP (1200px+):
- Button visible and functional
- Click toggles: Stacked ↔ Side-by-side
- Side-by-side: 50% | 50% split
- Preference persists during session

TABLET (768px - 1199px):
- Button visible but less useful
- Default: Stacked layout (limited width)
- Optional: Could enable tablet split at landscape orientation
- Graceful degradation: Ignores if space insufficient

MOBILE (< 768px):
- Button visible for consistency
- Disabled: No split possible (too narrow)
- Tooltips: "Split view available on larger screens"
```

---

## 🔐 Accessibility Standards

### WCAG 2.1 Level AA Compliance

```
✅ COLOR:
- Not relying on color alone for meaning
- Sufficient contrast ratios (4.5:1)
- Color-blind friendly palette

✅ TEXT:
- Font size: 14px minimum (body text)
- Line height: 1.5x minimum
- Adequate word spacing

✅ INTERACTION:
- Keyboard navigation
- Focus indicators visible
- Skip to main content link
- Tab order logical

✅ SEMANTICS:
- Proper heading hierarchy
- Form labels associated
- Images with alt text
- ARIA labels where needed
```

---

## 🧪 Testing and Validation

### Test Scenarios

**Test 1: First-Time User (Tier 1)**
```
User lands on home screen
- Can understand tier system
- Can see current tier (Junior Data Analyst)
- Can see progress (0/3 cases)
- Can click START A CASE
- Case selection shows available cases
- Can start a case
```

**Test 2: Case Execution**
```
User in active case
- Case narrative is clear
- Question is answerable
- Query editor is usable
- Can access Query Tutor hints
- Can access Database Schema
- Can submit query
- Results display correctly
```

**Test 3: Tier Advancement (Phase 2)**
```
User completes tier
- Case completion shows progress
- Progress bar updates
- Shows "1 more case to unlock next tier"
- After completing tier:
  - Promotion message displays
  - New badge shown
  - Next tier unlocked
  - Cases become available
```

**Test 4: Responsive Design**
```
Desktop (1200px+): Full layout
Tablet (768px): Tabbed layout
Mobile (< 768px): Single column (if supported)
```

### Performance Requirements

```
PAGE LOAD: < 2 seconds
INTERACTION: < 100ms response time
QUERY SUBMISSION: < 5 seconds (with feedback)
NAVIGATION: Instant (< 500ms transitions)
```

---

## 📊 Information Hierarchy

### Visual Hierarchy

```
PRIMARY (Most Important):
1. Case narrative/question
2. Query editor (student action)
3. Submit button

SECONDARY:
4. Query results
5. Agent guidance

TERTIARY:
6. Schema reference
7. Progress indicators
8. Time tracking
```

### Content Hierarchy

```
MOST CRITICAL:
- Case question (what to solve)
- Query editor (how to solve it)
- Submit button (take action)

VERY IMPORTANT:
- Query results (feedback)
- Agent hints (guidance)
- Query errors (problem indication)

IMPORTANT:
- Case narrative (context)
- Schema (reference)
- Progress (motivation)

NICE TO HAVE:
- Time tracking
- Statistics
- Achievement badges
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

**Case Design:**
- `Case-Design-Template-and-Examples.md`

**Testing:**
- `Testing-and-QA-Implementation-Guide.md`

---

## ✅ Implementation Checklist

### Design Phase

```
[ ] Create low-fidelity wireframes
[ ] Validate information hierarchy
[ ] Test responsive breakpoints
[ ] Plan color scheme (accessibility-focused)
[ ] Define typography system
[ ] Create component library
[ ] Design collapsible panel states (collapsed/expanded)
[ ] Design split view layouts
[ ] Validate information density with panels
```

### High-Fidelity Design

```
[ ] Design all screen states (including collapsed states)
[ ] Create interactive prototypes with collapse/expand
[ ] Prototype split view for desktop
[ ] Validate with accessibility tools
[ ] Test with users (sample students)
[ ] Iterate based on feedback
[ ] Document panel default states
[ ] Create animation specifications (200ms transitions)
```

### Development Handoff

```
[ ] Provide design specifications
[ ] Document component interactions
[ ] Create design system documentation
[ ] Prepare visual assets
[ ] Define CSS standards
[ ] Specify collapse/expand animations
[ ] Document split view breakpoints
[ ] Define responsive behavior per screen size
```

### Development Tasks

```
[ ] Implement Screen 3 with inline results display
[ ] Implement collapsible panel components
[ ] Implement expand/collapse state management
[ ] Implement split view toggle (desktop 1200px+)
[ ] Implement responsive layouts
[ ] Implement state persistence (session-based)
[ ] Connect Query Service to Results Panel
[ ] Handle all result states (correct/incorrect/error)
[ ] Test animation performance
[ ] Ensure accessible keyboard navigation
```

### Quality Assurance

```
[ ] Test on multiple browsers
[ ] Test responsive design (all breakpoints)
[ ] Validate accessibility (WCAG 2.1 AA)
[ ] Test keyboard navigation
[ ] Test collapse/expand functionality
[ ] Test split view on desktop
[ ] Test state persistence
[ ] Validate performance (no lag on collapse/expand)
[ ] Test touch interactions (tablet)
[ ] Validate mobile scrolling behavior
[ ] Test all result types (correct/incorrect/error/timeout)
[ ] Verify information hierarchy maintained
```

---

## 🎓 Conclusion

The UI/UX Design is where DataQuest's pedagogical mission becomes reality. This specification ensures that every interface element—from tier badges to agent responses—reinforces the core principle: students are progressing through authentic career roles by solving real SQL challenges, not playing a game.

**Enhanced by Approved UX Improvements (December 3, 2025):**
- ✅ Inline results display on Screen 3 (no screen switching)
- ✅ Collapsible panels for efficient space management
- ✅ Split view option for professional IDE experience (desktop)
- ✅ Immediate feedback loop (pedagogically sound)
- ✅ Professional SQL workflow alignment

**Key Success Factors:**

1. **Career focus** - Professional language and progression
2. **Clarity** - Every element serves a purpose
3. **Support** - Encouragement at every interaction
4. **Context** - Always show tier, progress, time
5. **Accessibility** - WCAG 2.1 AA compliance
6. **Responsiveness** - Works on all devices
7. **Agent coordination** - Seamless Query Tutor + Database Agent
8. **Efficient Space Management** - Collapsible panels for clean UI
9. **Professional Workflow** - Inline results match real SQL IDEs
10. **Immediate Feedback** - Results displayed instantly for faster learning

---

**IMPLEMENTATION SPECIFICATION COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR DESIGN & DEVELOPMENT** (WITH APPROVED ENHANCEMENTS)

