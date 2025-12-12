Here is the content for the  **Tier 2 Approved Working Plan** , titled `docs/design-and-planning/DataQuest-Development-Roadmap-Capstone-Focus.md`.

This document acts as your  **Living Requirements Log** . It integrates the original Proposal scope with the specific modifications mandated by approved Change Requests (CR001, CR003, CHG-001, CHG-002).

---

# DataQuest Development Roadmap (Capstone Focus)

**Tier 2: Approved Working Plan & Living Requirements Log**

**Status:** ✅ ACTIVE & BINDING
**Last Updated:** December 5, 2025
**Supersedes:** `DataQuest-Project-Proposal.md` (Tier 1) for all operational details.

---

## 1. Executive Summary & Current Scope

This document defines the **current, active requirements** for the DataQuest MVP. It aggregates the original proposal goals with all approved Change Requests to provide a definitive "Build This" list for developers.

### MVP Definition (Phase 1)

A local, offline-capable Windows Desktop application (.NET 9 WinForms) where students solve SQL investigations assisted by a multi-agent AI system.

* **Database:** Local MSSQL (Traditional Schema per  **[CHG-001]** ).
* **AI:** Local Ollama (Llama 3.1) + MCP Bridge.
* **Scope:** One fully functional "Plan-Verify-Tutor" cycle with solvable cases.

---

## 2. Living Requirements Log (User Stories + CR Modifications)

### Phase 1: Infrastructure & Data (Weeks 1-3)

| ID              | Requirement / User Story                                                                   | Current Status & Modifications                                                                                                                                                                                                                      | Ref |
| :-------------- | :----------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-- |
| **US-01** | **Environment & Toolchain**Setup Visual Studio, SQL Server, Ollama, and GitHub repo. | **Modified by [CHG-002]:**Must include `IDatabaseManager`service for automated DB creation/reset in Dev mode.**Modified by [Spec #9]:**Must include specific `DataQuest.MCP`project structure.                                                  | ,   |
| **US-02** | **Database Schema & Browser**Implement Schema Browser UI and core database tables.   | **Modified by [CHG-001]:**Schema must use**Traditional Separate Tables**(BadgeAccess, ParkingLotAccess).**NO JSON**columns allowed in student schema.**Modified by [CR003]:**Schema must support simpler JOIN paths for Tier 1-2. | ,,  |
| **US-03** | **Secure Query Execution**Implement SQL Editor and Results Grid.                     | **Modified by [Spec #9]:**Must use**MCP Protocol**(`sql.execute_readonly`) for all executions. Direct connection prohibited for Agents.**Modified by [Spec #5]:**Must block unsafe DML (DROP, DELETE) via `QueryValidator`.         | ,   |

### Phase 2: Core Logic & AI Agents (Weeks 4-7)

| ID              | Requirement / User Story                                                 | Current Status & Modifications                                                                                                                                                               | Ref |
| :-------------- | :----------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-- |
| **US-04** | **Database Agent**AI explains schema in natural language.          | **Modified by [Spec #8]:**Must use specific tier-aware system prompts (e.g., Tier 1 explanation vs. Tier 5 strategy).                                                                        | ,   |
| **US-05** | **Query Tutor (Comparison)**Compare student result vs. canonical result. | **Unchanged:**Compare ResultSets (rows/cols), not SQL text.                                                                                                                                  |     |
| **US-06** | **Query Tutor (Hints)**Generate Socratic hints for stuck students.       | **Modified by [Spec #1]:**Must follow 6-level Socratic escalation path (Safety -> Guidance -> Direct). Never give answers immediately.                                                       | ,   |
| **US-07** | **Case Planner Agent**Generate solvable case JSON.                 | **Modified by [CR003]:**Tier 4/5 cases must**NOT**require CTEs or Subqueries. Complexity must come from "Investigation Methodology" (multi-table JOINs, 6-8 tables), not syntax. | ,   |
| **US-08** | **SQL Enforcer Agent**Validate case logical consistency.           | **Clarified by [CR001]:**Defines the "Rule-Based Validator" role explicitly within the agent architecture.**Modified by [CHG-001]:**Validation must ensure no JSON artifacts are referenced. | ,   |

### Phase 3: Integration & Polish (Weeks 8-10)

| ID              | Requirement / User Story                                           | Current Status & Modifications                                                                                                                                                    | Ref |
| :-------------- | :----------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-- |
| **US-09** | **Stabilization & Testing**End-to-end testing and bug fixes. | **Modified by [Spec #7]:**Must pass specific performance targets (Simple Query < 200ms, Complex < 3s).**Modified by [Spec #3]:**UI must meet WCAG 2.1 AA accessibility standards. | ,   |
| **US-10** | **Presentation Prep**Final slide deck and demo.              | **Unchanged:**Deliverables are Deck, Demo Script, Video Backup.                                                                                                                   |     |

---

## 3. Architecture & Technical Constraints (Current)

### A. Database Strategy (Source of Truth: [CHG-001])

* **Pattern:** Traditional Relational (Separate Tables).
* **Forbidden:** Polymorphic associations, JSON blobs in student-facing tables.
* **Required Tables:** `BadgeAccess`, `ParkingLotAccess`, `Incidents`, `WitnessStatements`, `TransactionLogs`.
* **Management:** Controlled via `IDatabaseManager` (Dev only),.

### B. AI Architecture (Source of Truth: [Spec #9])

* **Runtime:** Local Ollama (Llama 3.1 8B).
* **Middleware:** C# MCP Server (Model Context Protocol).
* **Tools:** `schema.describe` (Read Schema), `sql.execute_readonly` (Run Query).
* **Security:** Agents interact via MCP  *only* , never direct connection string.

### C. Tier System (Source of Truth: [CR003])

* **Tier 1-3:** Focus on JOINs, Aggregates, and Data Quality.
* **Tier 4:** Complex JOINs (5-6 tables). **NO Subqueries required.**
* **Tier 5:** Executive Synthesis (6-8+ tables). **NO CTEs required.**
* *Rationale:* Focus on investigation logic over syntactic complexity.

---

## 4. Change Management Log (The "Why")

| CR ID             | Title                      | Impact                                                                    | Status  |
| :---------------- | :------------------------- | :------------------------------------------------------------------------ | :------ |
| **CR001**   | Agent Count Correction     | Corrected "3 Agents" typo to "4 Agents" in documentation.                 | ✅ Done |
| **CR002**   | UI/UX Extensions           | Approved Dashboard/Responsive design as Phase 2 features.                 | ✅ Done |
| **CR003**   | Tier System Simplification | Removed CTE/Subquery requirements from Tiers 4/5.                         | ✅ Done |
| **CHG-001** | Database Modernization     | **CRITICAL:**Enforced Traditional Table structure, banned JSON in schema. | ✅ Done |
| **CHG-002** | DB Management Service      | Added `IDatabaseManager`for automated dev workflows.                    | ✅ Done |

---

## 5. Implementation Roadmap (Timeline)

* **Week 1:** Domain Models & `IDatabaseManager` Integration **[Active]**
* **Week 2:** Database Schema (Traditional) & MCP Server Setup
* **Week 3:** MCP Client & Safe Query Execution UI
* **Week 4:** Database Agent & Schema Browser
* **Week 5:** Query Tutor (Comparison Logic)
* **Week 6:** Query Tutor (Hint Generation)
* **Week 7:** Case Planner & Enforcer (Solvability Checks)
* **Week 8:** Agent Orchestration & Full Integration
* **Week 9:** Code Freeze & End-to-End Testing
* **Week 10:** Final Presentation Prep
