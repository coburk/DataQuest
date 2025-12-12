## Detailed Test Plan: DataQuest: SQL Detective

### 3. AI Reasoning Validation

This evaluation area is central to the project's success, focusing on the integrity and transparency of the  **multi-agent reasoning cycle (Plan → Verify → Tutor)** . The goal is to ensure the agents produce consistent, logical, and non-hallucinated results that directly support student learning, primarily by inspecting the output logged in the  **Admin/AI Agent Monitor Interface** .

#### A. Case Planner Agent (The "Plan" Stage)

| **ID**      | **Test Case / Procedure**                                                                                                            | **Expected Result / Success Criteria**                                                                                                                                     | **Pass/Fail** |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| **AIV-001** | **Query Generation Accuracy (US-07c):**Trigger the**Case Planner Agent**to generate a `CasePlan`JSON for a new, simple case. | The generated JSON contains `CanonicalQuery`strings for all `StorySteps`. These queries are syntactically valid MSSQL and directly reference tables listed in the schema.    | [ ]                 |
| **AIV-002** | **Logical Flow Integrity:**Review the generated `StorySteps`to ensure sequential logic.                                                  | Step 1's clue (`ExpectedValue`) is a key piece of information (e.g., a `PersonID`) required to filter the query in Step 2. The narrative progression makes analytical sense. | [ ]                 |
| **AIV-003** | **Hallucination Check:**Inspect the `CasePlan`for references to non-existent data points.                                                | The generated story narrative and the `CanonicalQuery` **do not**reference tables, columns, or people that are outside of the loaded database schema.                    | [ ]                 |

#### B. SQL Enforcer Agent (The "Verify" Stage)

| **ID**      | **Test Case / Procedure**                                                                                                                                                                | **Expected Result / Success Criteria**                                                                                                                                         | **Pass/Fail** |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------- |
| **AIV-004** | **Solvability Confirmation (US-07d):**Test the Enforcer on a verified-good `CasePlan`.                                                                                                       | The Enforcer executes**all** `CanonicalQuery`values via MCP without error. The `IsSolvable`flag is successfully set to **`true`** .                                | [ ]                 |
| **AIV-005** | **Contradiction Detection (US-08a):**Load a manually prepared "broken" case with a known data contradiction (e.g., log time contradicts witness time).                                         | The Enforcer detects the contradiction, generates a log entry under the**Error**level, and sets**`IsSolvable`**to **`false`** , blocking the case from the registry. | [ ]                 |
| **AIV-006** | **FK/Data Integrity (US-08b):**Test the Enforcer on a case where an essential `JOIN`fails due to missing data (i.e., the foreign key in one table has no matching primary key in the other). | The Enforcer's internal logic flags the broken link, preventing the case from being deployed as the investigative path is a dead-end.                                                | [ ]                 |

#### C. Query Tutor Agent (The "Tutor" Stage)

| **ID**      | **Test Case / Procedure**                                                                                                                                 | **Expected Result / Success Criteria**                                                                                                                                                  | **Pass/Fail** |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| **AIV-007** | **Result Comparison Correctness (US-05):**Submit a query that is syntactically different (e.g., uses `JOIN`vs. subquery) but yields the identical result set. | The**Query Tutor Agent**correctly confirms a**Match**and advances the step, demonstrating flexibility beyond pure string comparison.                                              | [ ]                 |
| **AIV-008** | **Socratic Hint Quality (US-06):**Submit a query with a single, clear error (e.g., wrong column in the `WHERE`clause). Request the Level 1 hint.              | The generated hint is a**Socratic question**(no SQL provided), is relevant to the required schema table, and guides the student toward the missing condition, per the `ErrorContext`. | [ ]                 |
| **AIV-009** | **Schema Guidance (US-04):**Test the**DB Agent** 's ability to interpret schema context.                                                            | Ask the DB Agent, "Why do I need to join the `TransactionLogs`table to the `Persons`table?" The response correctly explains the FK link via `PersonID`.                                 | [ ]                 |

---

**Next Step:** I will now document the test plan for the fourth evaluation area:  **Internal Usability Testing** .
