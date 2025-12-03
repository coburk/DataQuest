# DataQuest Development Roadmap - Official Guide

**Status:** OFFICIAL DEVELOPMENT GUIDE  
**Date:** December 2025  
**Purpose:** Authoritative roadmap for 10-week capstone development  
**Audience:** Solo developer (primary), Instructor (secondary)  
**Location:** docs/design-and-planning/ (Single source of truth)

---

## Executive Summary

DataQuest will be developed over 10 weeks using a **hybrid sequential-iterative approach**:

- **Structure:** Sequential phases (7 phases) from Phase 1 to Phase 7
- **Tracking:** Weekly User Stories (US-Data through US-09)
- **Delivery:** One complete, tested User Story per week
- **Reporting:** Weekly status reports to instructor with Git evidence
- **Timeline:** 10 weeks = 10 weekly deliverables

This roadmap ensures professional development, instructor visibility, and manageable weekly scope for a solo developer.

---

## Project Context

### Capstone Requirements
- **Duration:** 10 weeks
- **Team:** Solo developer
- **Reporting:** Weekly updates to instructor
- **Deliverable:** MVP (Minimum Viable Product) for capstone demonstration
- **Technology:** .NET 9, C#, WinForms, SQL Server, Ollama (local LLM)

### MVP Scope
```
LOCAL, OFFLINE-CAPABLE SYSTEM
├─ Four specialized AI agents
├─ Student investigative experience
├─ One complete SQL detective case
├─ Safe, read-only database access
└─ Secure MCP (Model Context Protocol) architecture
```

### Out of Scope (Future Expansion)
- Instructor/Admin case creation interfaces
- Cloud deployment and web hosting
- CI/CD pipeline automation
- Performance metrics and academic evaluation
- Additional investigative themes beyond SQL

---

## Development Approach

### Why This Approach?

**Sequential Phases:**
- ✅ Natural dependency order (each phase builds on previous)
- ✅ Professional structure (clear milestones)
- ✅ Matches design documents
- ✅ Easy to explain and understand

**Weekly User Stories:**
- ✅ Measurable progress every week
- ✅ Instructor sees completed features
- ✅ Traceable to design requirements
- ✅ Git evidence of work

**Solo Developer:**
- ✅ No parallel coordination needed
- ✅ Sequential execution naturally
- ✅ Clear task focus each week
- ✅ Build incrementally and test continuously

### Core Principles

1. **One User Story Per Week**
   - Complete implementation
   - Comprehensive testing
   - Documentation
   - Demonstrable to instructor

2. **Continuous Quality**
   - Write tests same week as code
   - All tests passing before instructor report
   - No accumulating technical debt
   - Code compiles without warnings

3. **Weekly Deliverables**
   - Instructor receives status every Saturday
   - Git commits provide evidence
   - Demo instructions included
   - Clear metrics (lines, files, tests)

4. **Risk Management**
   - Address technical risks early
   - Test infrastructure before features
   - Ollama/LLM research starts Week 1
   - Fallback plans identified

---

## 7-Phase Structure with 10-Week Timeline

### Phase 1: Domain Models (Week 1)

**Objective:** Establish foundational data structures

**User Story:** US-Data (Domain Models)

**Deliverables:**
- Investigative data models (Person, Location, Evidence, Communication)
- Agent control models (CasePlan, StoryStep, AnswerKey)
- Workflow models (QuerySubmissionResult, HintContext, MCPRequest)
- Strongly-typed C# POCOs
- Data transfer objects

**Success Criteria:**
- All models compile without errors
- No compilation warnings
- Comprehensive unit tests
- Ready for database integration

**Instructor Report Includes:**
- 480+ lines of code added
- 12+ files created
- 120+ unit tests (all passing)
- Git commits with links

---

### Phase 2: Data Infrastructure (Weeks 2-3)

**Objective:** Establish secure local database access

**Part A - Week 2: Database Layer (US-01)**

**User Story:** US-01 (Local Environment Setup)

**Deliverables:**
- Entity Framework Core setup
- DbContext configuration
- Database entities and schema
- SQLConnector for application
- Local SQL Server connection

**Success Criteria:**
- Can connect to local SQL Server
- Database initializes with correct schema
- Migrations working
- Connection string management

**Part B - Week 3: MCP Server (US-02)**

**User Story:** US-02 (Secure Database Access)

**Deliverables:**
- MCP Server (C# service process)
- JSON-RPC 2.0 protocol implementation
- `schema.describe` tool exposed
- `sql.execute_readonly` tool exposed
- Read-only enforcement validation
- Safety layer for AI agents

**Success Criteria:**
- MCP Server running locally
- Responds to tool calls correctly
- JSON-RPC messages properly formatted
- Tools return expected results
- Read-only enforcement verified

---

### Phase 3: MCP Client Integration (Week 4 - Begins)

**Objective:** Connect application to MCP Server

**User Story:** US-03 (Student Query Execution)

**Deliverables:**
- MCPClient component
- JSON-RPC 2.0 message handling
- Tool invocation and response processing
- Error handling and retry logic
- Integration with QueryValidator
- Basic UI for query entry

**Success Criteria:**
- Application can call MCP tools
- Receives correct responses
- Handles errors gracefully
- Student can enter and execute queries
- SQL Editor UI working

---

### Phase 4: Pipeline Services & Orchestration (Weeks 4-7)

**Objective:** Implement core workflows and business logic

**Week 4-5: Query Execution Pipeline (US-03 continued + US-04)**

**User Stories:** 
- US-03 (continued): Student Query Execution
- US-04: Database Agent - Schema Translation

**Deliverables:**
- QueryValidator service
- CaseManager service (start)
- Database Agent implementation
- Ollama integration started
- Schema browser UI
- Query execution UI completed

**Success Criteria:**
- Students can safely execute queries
- Schema descriptions from LLM
- UI responsive and intuitive
- Ollama integration working

**Week 5-6: Query Comparison & Hints (US-05, US-06)**

**User Stories:**
- US-05: Query Comparison
- US-06: Hint Generation

**Deliverables:**
- Query Tutor Agent
- Query comparison engine
- Canonical query execution
- Result comparison logic
- Mismatch detection
- Multi-level hint generation
- Hint Panel UI

**Success Criteria:**
- System detects query correctness
- Generates Socratic hints
- Hints at multiple levels
- Hint delivery working

**Week 6-7: Case Management & Generation (US-07, US-08)**

**User Stories:**
- US-07: Case Loading Pipeline
- US-08: SQL Enforcer Agent

**Deliverables:**
- CaseManager service (complete)
- Case Loading Pipeline
- JSON deserialization
- Case validation
- Case Planner Agent
- SQL Enforcer Agent
- Logic validation
- Contradiction checking
- Solvability verification

**Success Criteria:**
- Cases load from JSON
- Students navigate steps
- Cases generate correctly
- Case logic validates
- Solvability verified

---

### Phase 5: AI Agents (Weeks 8-9)

**Objective:** Implement and integrate four specialized AI agents

**Week 8: Case Generation & Orchestration (US-07, US-08 continued)**

**User Stories:** US-07, US-08

**Deliverables:**
- Case Planner Agent refinement
- SQL Enforcer Agent refinement
- AgentOrchestrator implementation
- Agent sequencing logic
- Agent communication protocol
- All 4 agents integration:
  - Database Agent
  - Case Planner Agent
  - Query Tutor Agent
  - SQL Enforcer Agent

**Success Criteria:**
- All 4 agents functioning
- Ollama integration complete
- Agents respond to orchestrator
- Agent collaboration working

**Week 9: End-to-End Integration (US-09)**

**User Story:** US-09 (Complete Investigative Case Experience)

**Deliverables:**
- AgentOrchestrator complete
- Full system integration
- "Plan → Verify → Tutor" cycle
- Student flows through complete case
- All UI elements integrated
- Case navigation complete
- Hint integration complete
- Agent responses in UI

**Success Criteria:**
- Student can complete one full case
- Start to finish without errors
- All features working together
- All 4 agents active
- Reproducible case completion

---

### Phase 6: Student Interface (Built Incrementally)

**Objective:** Deliver complete student investigative experience

**Built Throughout Phases 3-5**

**Components Developed Incrementally:**
- Week 4: SQL Editor, Results Grid
- Week 5: Schema Browser
- Week 6: Hint Panel
- Week 8-9: Case Navigator, Step Tracking

**Final Deliverables (by Week 9):**
- WinForms application
- SQL Editor for query entry
- Results Grid for output display
- Schema Browser for reference data
- Hint Panel for Socratic guidance
- Case Navigator for step tracking
- Log Panel for system information
- Case overview dashboard

**Success Criteria:**
- All UI elements responsive
- Student can navigate case
- Information clearly presented
- Student completes case successfully

**Note:** Instructor/Admin interfaces deferred to post-MVP (Phase 8)

---

### Phase 7: Integration Testing & Documentation (Week 10)

**Objective:** Verify system functionality and transfer knowledge

**User Story:** All (Comprehensive Testing)

**Deliverables:**
- Unit tests for all components
- Integration tests for pipelines
- End-to-end test scenarios
- Test coverage metrics
- Architecture documentation
- API documentation
- Setup and deployment guide
- Developer guide
- Instructor setup guide
- Demo walkthrough
- Known issues and limitations

**Success Criteria:**
- Test coverage > 80%
- All tests passing
- System stable
- Documentation complete
- Ready for capstone demonstration
- Instructor can reproduce all features

---

## Weekly Deliverable Schedule

### Week 1: Domain Models
```
User Story: US-Data
Deliverable: All domain models implemented and tested
Instructor Report: Models compile, ready for database integration
```

### Week 2: Database Layer
```
User Story: US-01
Deliverable: Can connect to local SQL Server, schema initialized
Instructor Report: Database working, EF Core configured
```

### Week 3: MCP Server
```
User Story: US-02
Deliverable: MCP Server running, tools responding
Instructor Report: Secure database access implemented
```

### Week 4: Query Execution & Schema
```
User Stories: US-03, US-04
Deliverable: Students can query, schema browser working
Instructor Report: Query execution and schema translation working
```

### Week 5: Query Verification
```
User Story: US-05
Deliverable: System compares queries, detects correctness
Instructor Report: Query comparison logic implemented
```

### Week 6: Hints
```
User Story: US-06
Deliverable: Multi-level hints generating from LLM
Instructor Report: Socratic hint system working
```

### Week 7: Case Management
```
User Stories: US-07, US-08
Deliverable: Cases load, generate, validate
Instructor Report: Case system and SQL Enforcer working
```

### Week 8: Agent Integration
```
User Stories: US-07, US-08 (continued)
Deliverable: All 4 agents integrated and working
Instructor Report: Agent orchestration complete
```

### Week 9: End-to-End
```
User Story: US-09
Deliverable: One complete case works start to finish
Instructor Report: Full MVP working end-to-end
```

### Week 10: Polish & Documentation
```
User Story: All (Testing)
Deliverable: Production-ready MVP with comprehensive tests and docs
Instructor Report: MVP complete, tested, documented, ready for demo
```

---

## Weekly Instructor Report Format

### Template (Use This Every Week)

```markdown
# DataQuest Weekly Status Report - Week [N]

## User Story Completed
**US-0X:** [Story Name]
- **Status:** ✅ COMPLETE
- **Tests:** [N] tests written, all passing
- **Code Quality:** No warnings, follows conventions

## What's Working This Week
- ✅ [Feature 1 - briefly describe]
- ✅ [Feature 2 - briefly describe]
- ✅ [Feature 3 - briefly describe]

## Code Metrics
| Metric | Value |
|--------|-------|
| Lines Added | [N] |
| Files Changed | [N] |
| New Tests | [N] |
| Test Pass Rate | 100% |
| Compilation Warnings | 0 |

## GitHub Evidence
**Commits this week:**
```
abc1234 - feat: [description] - US-0X
def5678 - test: [description] - US-0X
```
[View commits: https://github.com/coburk/DataQuest/commits/main]

## Demo Instructions
To see this week's completed work:
1. `git checkout main`
2. Open DataQuest.sln
3. [Step-by-step to test feature]

## Technical Summary
- **Architecture:** [Component changes]
- **Dependencies:** [New/modified dependencies]
- **Database:** [Schema changes if any]

## Challenges & Solutions
- **Challenge:** [If any challenges this week]
- **Solution:** [How addressed]

## Next Week's Plan
**US-0X:** [Next user story name]
- [Key deliverable 1]
- [Key deliverable 2]

## Metrics
- **Cumulative Lines Added:** [Running total]
- **Cumulative Tests:** [Running total]
- **Code Coverage:** [%]

---
**Report Date:** [Date]  
**Developer:** [Your name]  
**Status:** On Track / At Risk / Ahead of Schedule
```

---

## Commit Message Strategy

### Commit Format
```
<type>: <subject> - <US-ID>

<body>

<footer>
```

### Examples

**Feature commit:**
```
feat: implement Person and Location models - US-Data

Added Person class with PersonID, Name, Role, IsSuspect properties.
Added Location class with LocationID, Name, Address properties.
Both include validation and ToString() methods.

Relates to: US-Data (Domain Models)
```

**Test commit:**
```
test: add unit tests for domain models - US-Data

Added 120 tests covering:
- Person model validation
- Location model validation
- Model relationships
- Edge cases

All tests passing: 120/120 ✓

Relates to: US-Data
```

**Infrastructure commit:**
```
chore: update NuGet packages and add .gitignore

Updated xUnit to 2.7.1
Updated Moq to 4.20.70
Added .NET 9 specific ignores

All tests still passing.
```

### Commit Frequency
- **Daily:** Push commits daily (at least 1 per day)
- **Quality:** Logical units, not one giant commit per week
- **Messages:** Include US number for traceability
- **Clean History:** Instructor can review commit history

---

## Testing Strategy

### Unit Tests
- ✅ Write tests same week as feature code
- ✅ Test each component in isolation
- ✅ Cover happy path + edge cases
- ✅ All tests passing before report

### Integration Tests
- ✅ Test components working together
- ✅ Test pipelines end-to-end
- ✅ Test agent communication
- ✅ Cumulative: maintain all previous tests

### End-to-End Tests
- ✅ Test complete case scenarios (starting Week 8)
- ✅ Test user workflows
- ✅ Test all features together

### Testing Schedule
| Week | Unit Tests | Integration | E2E |
|------|-----------|-------------|-----|
| 1-3 | ✓ | - | - |
| 4-5 | ✓ | ✓ | - |
| 6-7 | ✓ | ✓ | - |
| 8-9 | ✓ | ✓ | ✓ |
| 10 | ✓ | ✓ | ✓ (Comprehensive) |

---

## Risk Management

### Critical Risks

#### Risk 1: Ollama/LLM Integration (Week 5-9)
**Severity:** 🔴 CRITICAL  
**Mitigation:**
- Research Ollama in Week 1-2
- Prototype prompt engineering early
- Have mock LLM fallback ready
- Start experiments before Week 5

**Contingency:** If Ollama fails, use mock agent responses

#### Risk 2: MCP Architecture Complexity (Week 3)
**Severity:** 🟡 HIGH  
**Mitigation:**
- Study JSON-RPC protocol early
- Prototype MCP server in Week 2
- Have reference implementations ready
- Test MCP thoroughly before Week 4

**Contingency:** Simplify if needed, focus on core tools

#### Risk 3: Query Comparison Logic (Week 6)
**Severity:** 🟡 HIGH  
**Mitigation:**
- Test with various SQL patterns
- Handle edge cases (NULL, empty sets, ordering)
- Write comprehensive tests
- Start early if time allows

**Contingency:** Accept some false positives, document them

#### Risk 4: Schedule Slip (Weeks 4+)
**Severity:** 🟡 MEDIUM  
**Mitigation:**
- Test each week (not Week 10)
- Small commits daily (easy to track)
- Communicate early if slipping
- Have scope reduction plan

**Contingency:** Reduce polish, focus on core features

### Risk Timeline
```
Week 1-2: Research Ollama, study MCP
Week 3: Validate MCP architecture works
Week 4: Validate query execution and LLM basics
Week 5: Validate LLM integration for agents
Week 6-7: Build features on proven tech
Week 8-9: Integrate and test everything
Week 10: Final validation and polish
```

---

## Success Metrics

### Weekly Success Criteria

**Every Week:**
- ✅ One User Story completed
- ✅ Code compiles without warnings
- ✅ All tests passing
- ✅ Git commits pushed to main
- ✅ Status report submitted

**Code Quality:**
- ✅ Follows naming conventions
- ✅ Code commented where needed
- ✅ No compilation warnings
- ✅ Tests comprehensive

### Project Success Criteria

**By Week 3:**
- ✅ Infrastructure working (database, MCP Server)
- ✅ 3 user stories delivered
- ✅ 3 instructor reports submitted

**By Week 7:**
- ✅ Core features working (query, schema, hints, cases)
- ✅ 7 user stories delivered
- ✅ 7 weeks of progress documented
- ✅ No breaking changes between weeks

**By Week 10:**
- ✅ MVP complete and working
- ✅ Student can complete one full case
- ✅ All 4 agents functioning
- ✅ Tests comprehensive (80%+ coverage)
- ✅ Documentation complete
- ✅ Ready for capstone demonstration

### Metrics Tracked

| Metric | Tracking | Target |
|--------|----------|--------|
| User Stories Completed | Weekly | 1 per week |
| Test Count | Cumulative | 500+ by Week 10 |
| Code Coverage | Cumulative | 80%+ by Week 10 |
| Lines of Code | Cumulative | 8000+ by Week 10 |
| Compilation Warnings | Weekly | 0 |
| Test Pass Rate | Weekly | 100% |

---

## Communication Plan

### Weekly Communication (Every Saturday)

**Send:** Status report to instructor
**Include:** 
- User Story completed
- Git commit links
- Demo instructions
- Code metrics
- Next week plan

**Format:** Email with status report template

### If Schedule Slips

**Communicate:** Immediately (don't wait until Saturday)
**Message:** 
- What's taking longer
- Why (technical challenge, unexpected complexity)
- New timeline
- Adjusted plan if needed

**Goal:** No surprises, instructor knows status always

### Capstone Presentation (Week 10)

**Demo:**
- One complete investigative case
- All 4 agents in action
- Full "Plan → Verify → Tutor" cycle
- Query execution, hints, validation
- Student scenario walkthrough

**Materials:**
- Architecture diagram
- Component overview
- Technical decisions made
- Lessons learned
- Potential improvements

---

## GitHub Repository Management

### Branching Strategy
```
main (development branch)
├─ Always deployable
├─ All tests passing
├─ Week 1 code here
├─ Week 2 code here
├─ ... continues through Week 10
└─ Final MVP here
```

**Note:** Solo developer, single branch (main) - no PRs needed

### Commit Practice
- Small, logical commits daily
- Push to main every day
- Meaningful commit messages
- Clean history for instructor review

### Repository Status
- Always on main branch
- All changes committed
- No uncommitted changes
- Latest code always pushed to GitHub

---

## Dependencies & Prerequisites

### External Dependencies
- ✅ .NET 9 SDK (already installed)
- ✅ Visual Studio 2022
- ✅ SQL Server LocalDB
- ✅ Ollama (local LLM)

### Project Dependencies
```
Week 1: Project infrastructure
  ↓
Week 2: Database + EF Core
  ↓
Week 3: MCP Server + communication protocol
  ↓
Week 4: Query execution + LLM basics
  ↓
Week 5: Database Agent + Ollama integration
  ↓
Week 6: Query comparison + hints
  ↓
Week 7: Case management + case generation
  ↓
Week 8: Agent orchestration
  ↓
Week 9: End-to-end integration
  ↓
Week 10: Testing & documentation
```

Each week depends on previous weeks' successful completion.

---

## Adaptation & Flexibility

### If You're Ahead of Schedule
- Advance to next user story early
- Add more comprehensive tests
- Improve UI polish
- Add documentation

### If You're Behind Schedule
**Option 1: Extend Phase (Preferred)**
- Continue working on US, deliver next Saturday
- Keep quality high
- Don't skip testing

**Option 2: Reduce Scope (If necessary)**
- Focus on core functionality
- Defer polish features
- Maintain quality
- Communicate with instructor

**Option 3: Combine User Stories**
- Weeks 8-9 already combine two stories
- Can combine others if needed

### If Technical Challenge Arises
**Process:**
1. Identify issue immediately
2. Research solutions
3. Try fallback approach if main fails
4. Update instructor in real-time
5. Adjust plan as needed

---

## Handoff & Documentation

### Final Deliverables (Week 10)

**Code:**
- ✅ Source code on GitHub
- ✅ All tests passing
- ✅ No compilation warnings
- ✅ Ready to run

**Documentation:**
- ✅ README.md with setup instructions
- ✅ Architecture.md with system design
- ✅ Contributing.md for guidelines
- ✅ Setup.md for environment setup
- ✅ Naming Conventions Guide

**Artifacts:**
- ✅ Solution file (DataQuest.sln)
- ✅ 9 project files (.csproj)
- ✅ Database scripts
- ✅ Configuration templates

**Tests:**
- ✅ Unit test suite
- ✅ Integration test suite
- ✅ End-to-end test scenarios
- ✅ Test data

---

## References

### Related Documents
- **README.md** - Project overview and quick links
- **Architecture.md** - System architecture and design
- **Core Domain Models.md** - Data model specifications
- **Application Structure - DataQuest.md** - Component architecture
- **Project Goals and Scope - DataQuest.md** - MVP definition
- **Testing Strategy for DataQuest.md** - Testing approach

### User Story Details
- See individual design documents in `/design-and-planning/`
- Each US has detailed requirements
- Success criteria defined per story

---

## Conclusion

This roadmap provides a clear, achievable path to delivering the DataQuest MVP in 10 weeks as a solo developer with weekly instructor visibility.

**Key Principles:**
- ✅ One User Story per week = manageable scope
- ✅ Weekly instructor updates = visibility
- ✅ Git evidence = accountability
- ✅ Sequential phases = professional structure
- ✅ Continuous testing = quality assurance
- ✅ Risk management = schedule protection

**Success requires:**
- Daily commits with clear messages
- Weekly completed User Stories
- Comprehensive unit tests
- Regular instructor communication
- Professional quality code

**The 10-week journey:**
```
Week 1:   Foundation (Models)
Weeks 2-3: Infrastructure (Database, MCP)
Weeks 4-7: Features (Queries, Hints, Cases, Agents)
Weeks 8-9: Integration (Full system working)
Week 10:  Polish & Delivery (MVP ready)
```

**Ready to build DataQuest!**

---

**Document Status:** Official Development Guide  
**Version:** 1.0  
**Last Updated:** December 2025  
**Location:** `docs/design-and-planning/Development Roadmap - DataQuest.md`  
**Audience:** Solo developer (primary), Instructor (reference)
