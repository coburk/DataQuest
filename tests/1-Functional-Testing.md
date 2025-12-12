## Detailed Test Plan: DataQuest: SQL Detective

### 1. Functional Testing

This document defines the structured, end-to-end tests required to verify that all core application features and agent interactions work both individually and as part of the complete investigative workflow.

#### A. Core Feature Test Cases

| ID               | Feature Under Test                                                       | Expected Result / Success Criteria                                                                                                                                                                                                | Pass/Fail |
| :--------------- | :----------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------- |
| **FT-001** | **Database Schema Browser (US-02):** Display & refresh.            | The Schema Browser panel accurately lists all tables (`Cases`, `Persons`, `TransactionLogs`, etc.). Clicking a table shows the correct columns and Foreign Key (FK) relationships. Refresh button updates the view quickly. | [ ]       |
| **FT-002** | **SQL Query Execution (US-03):** Read-only execution.              | Student submits a valid `SELECT` query. Results are displayed correctly in the table grid. System blocks `UPDATE`, `DELETE`, or `DROP` commands (**US-03f**) with a clear error message.                            | [ ]       |
| **FT-003** | **DB Agent Explanation (US-04):** Natural language schema mapping. | User clicks "Explain Schema." The**DB Agent** uses the LLM to generate clear, concise, natural-language descriptions of the schema and relevant `JOIN` examples.                                                          | [ ]       |
| **FT-004** | **Case Loading (US-07f):** Successful data initialization.         | System loads a verified `CasePlan.json` file. The UI updates to show the correct **`CaseTitle`**, **`InitialPrompt`**, and **Step 1 prompt**. The internal `CaseManager` sets `StepID = 1`.           | [ ]       |

#### B. Agent Workflow Test Cases (End-to-End)

| ID               | Agent Interaction Under Test                                            | Expected Result / Success Criteria                                                                                                                                                                                                                 | Pass/Fail |
| :--------------- | :---------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-------- |
| **FT-005** | **Result Comparison (US-05):** Correct query.                     | Student submits the**exact canonical query**. The **Query Tutor Agent** confirms a perfect match between the Student Result Set and the Canonical Result Set. The system advances to the next `StoryStep`.                           | [ ]       |
| **FT-006** | **Result Comparison (US-05):** Incorrect query (Mismatch).        | Student submits a query that returns the correct*number* of rows but the *wrong* columns (e.g., forgets a `JOIN`). The Query Tutor flags a **Mismatch**. System displays "Incorrect" message; step does not advance.                   | [ ]       |
| **FT-007** | **Hint Generation (US-06):** Multi-level Socratic hint.           | After a failure, student requests a hint. The**Query Tutor Agent** delivers a **Socratic question** (Hint Level 1). The internal log shows the Hint Level incremented to 2.                                                            | [ ]       |
| **FT-008** | **Case Planning & Validation (US-07/08):** Full generation cycle. | System is triggered to generate a new case. The**Case Planner Agent** creates a `CasePlan.json`. The **SQL Enforcer** executes all canonical SQL and sets **`IsSolvable: true`**. The new case appears in the Case Registry. | [ ]       |
| **FT-009** | **Full End-to-End Flow:** Solving a case.                         | A user solves a complete 5-step case from start to finish, relying on the agents for schema help and tutoring. All steps advance correctly, culminating in the display of the**`Conclusion`** narrative.                                         | [ ]       |

---
