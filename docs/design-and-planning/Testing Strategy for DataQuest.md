## 🧪 Recommended Testing Strategy for DataQuest MVP

A comprehensive testing strategy is critical for the success of the DataQuest MVP, especially given the integration of local AI agents, a custom communication protocol (MCP), and a relational database. Our strategy will prioritize  **functional correctness, data integrity, and the stability of the AI reasoning cycle** .

This strategy covers the mandatory testing tasks defined in **US-09** (Stabilization/Demo Prep) and aligns with the goals of the  **Evaluation Plan** .

---

### 1. Unit Testing and Core Component Verification (Weeks 1-6)

Before integration, we must ensure each component is independently robust. This aligns primarily with development tasks in the early weeks.

* **Database/SQL Layer Testing (xUnit):**
  * **Goal:** Verify the **AnswerKeys** and core data manipulation.
  * **Focus:** Test canonical SQL queries against the sample database to ensure they consistently return the **Expected Result Set** and  **Expected Clue Value** .
* **MCP Communication Testing (US-01g):**
  * **Goal:** Verify the secure read-only bridge.
  * **Focus:** Send simulated JSON-RPC requests directly to the C# MCP server for both `schema.describe` and `sql.execute_readonly`. Verify that the server correctly executes the command and returns valid JSON responses, and that  **unsafe statements (DROP, DELETE, UPDATE) are blocked (US-03f)** .
* **Query Tutor Comparison Logic (US-05):**
  * **Goal:** Ensure the comparison engine works.
  * **Focus:** Use mock student results (Missing Row, Extra Column, Wrong Data) against the canonical result. Verify that the comparison logic correctly flags the result as **Correct** or **Incorrect** and identifies the specific difference.

---

### 2. AI Agent Integration and Validation Testing (Weeks 7-8)

This phase focuses on the stability and quality of the LLM-driven components and their interaction with the MCP.

* **Case Planner Solvability Test (US-07d):**
  * **Goal:** Verify the core output of the content-generating AI.
  * **Focus:** After the **Case Planner Agent** generates a new `CasePlan` JSON, immediately run the **SQL Enforcer** on it. Verify that the Enforcer can execute **every `CanonicalQuery`** in the plan and that they resolve to the intended `ExpectedValue`, thus confirming `IsSolvable: true`.
* **SQL Enforcer Logic Test (US-08):**
  * **Goal:** Validate the rule-based safety net.
  * **Focus:** Test the Enforcer with manually injected, known bad data (e.g., contradictory witness statement timestamps, broken Foreign Key references, cases where the final query returns zero results) to ensure it correctly **flags inconsistencies** and blocks the case from deployment.
* **DB Agent Clarity Test (US-04):**
  * **Goal:** Ensure the natural-language explanations are accurate.
  * **Focus:** Provide the **Database Agent** with the schema metadata and prompt it to explain specific joins (e.g., "How do I link `Persons` to `TransactionLogs`?"). Verify that the explanation is  **correct, clear, and non-hallucinated** .
* **Hint Quality Test (US-06):**
  * **Goal:** Verify the pedagogical value of the  **Query Tutor** .
  * **Focus:** Submit known-error queries (e.g., forgetting a WHERE clause, wrong JOIN type). Request the  **multi-level hints** . Verify the hints are **Socratic** (asking guiding questions) and **schema-grounded** (referencing the correct table/column).

---

### 3. End-to-End and Stabilization Testing (Week 9 - Code Freeze) 🚢

This is the final, high-risk testing phase focused on the complete user experience and deployment readiness ( **US-09a-c** ).

| **Test Type**                            | **Focus Area**                                                          | **Success Indicator**                                                                                                                                                                                    |
| ---------------------------------------------- | ----------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Full Workflow Test**                   | **The entire Plan**$\to$**Verify**$\to$**Tutor cycle.** | Run a case from AI generation**$\to$**load**$\to$**full student attempt**$\to$**final conclusion. Verify that the **MCP logs show the transparent agent flow (Success Indicator 4)** . |
| **Installation/Deployment Test**         | **Off-site, clean-machine setup (US-09a).**                             | Test on at least one machine without a prior development environment to ensure the SQL Server, Ollama, and C# app launch and connect using the**Setup Guide** .                                          |
| **Limited External Pilot Test (US-09b)** | **Usability and clarity with an external user.**                        | Have at least one peer/instructor install the system and complete a case. Collect qualitative feedback on UI, prompt clarity, and hint effectiveness.                                                          |
| **Stress/Edge Case Testing**             | **Error Handling and system stability.**                                | Deliberately input syntactically incorrect SQL, inject large data sets, and attempt to break the flow to ensure the system handles errors gracefully (e.g., no crashes, clear error messages).                 |

By adopting this phased and comprehensive approach, we ensure that DataQuest is not only functionally correct but also reliable and effective as an instructional tool.
