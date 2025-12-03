## 🔍 Query Submission Pipeline: The Verification Stage

The **Query Submission Pipeline** is the core process that validates a student's investigative step. It defines the application's response when a student executes an SQL query, ensuring the query is safe, executed against the database, and its results are immediately compared against the canonical expected answer set.

This pipeline is executed by the **Agent Orchestrator** and involves the  **Query Validator** , the  **MCP Client** , and the  **Query Tutor Agent (US-05)** .

---

### Phase 1: Pre-Execution Validation (Safety Check) 🛡️

The primary goal is to ensure the integrity of the data and the application by preventing harmful commands.

1. **Safety Check (Rule-Based):** The **Query Validator** component receives the raw SQL string from the student's  **SQL Editor** . It scans the string for **unsafe Data Manipulation Language (DML) commands** such as `DROP`, `DELETE`, `UPDATE`, and `INSERT` ( **US-03f** ).
2. **Access Verification:** The system also verifies that the query does not attempt to access any tables outside of the allowed case schema.
3. **Action:**
   * **If Unsafe:** Block the query. Display an error message ("Unsafe command detected. You can only run SELECT queries.") and log the event. **Pipeline terminates.**
   * **If Safe:** Proceed to execution.

---

### Phase 2: Dual Execution (Student vs. Canonical) ⚖️

To compare results, both the student's query and the verified correct query must be executed simultaneously.

1. **Retrieve Canonical Query:** The **Query Tutor Agent** retrieves the `CanonicalQuery` string associated with the student's current **`StoryStep`** from the **`CaseManager`** (which holds the loaded `CasePlan`).
2. **Student Query Execution (II):**
   * The **MCP Client** sends the student's `SELECT` query to the local C# **MCP Server** via the **`sql.execute_readonly`** tool.
   * The database executes the query and returns the **Student Result Set** (a table structure containing rows and columns).
   * The **Presentation Layer** displays this result set in the results grid ( **US-03c** ).
3. **Canonical Query Execution (III):**
   * The **MCP Client** sends the retrieved `CanonicalQuery` to the local C# **MCP Server** via the **`sql.execute_readonly`** tool.
   * The database executes the canonical query and returns the **Canonical Result Set** (the expected correct answer).

---

### Phase 3: Result Comparison and Feedback (Verification) ✅

The **Query Tutor Agent** takes the lead in this phase, determining if the student has successfully completed the investigative step.

1. **Result Comparison (IV - US-05):**
   * The **Query Tutor Agent** compares the **Student Result Set** against the  **Canonical Result Set** . The comparison checks for:
     * **Row Count:** Do both result sets have the same number of rows?
     * **Columns:** Do both result sets contain the required columns?
     * **Data Content:** Is the data in all matching columns identical (regardless of row/column order, to allow for flexible SQL syntax)?
2. **Determine Outcome:**
   * **If Match (V - Success):** The Query Tutor confirms the successful completion of the step.
   * **If Mismatch (V - Failure):** The Query Tutor notes the mismatch and potentially logs key differences (missing rows, extra columns).
3. **Action:**
   * **Success:** The **Case Manager** advances the student to the  **next `StoryStep`** , displays the new prompt, and logs the step completion. The **pipeline restarts** for the next step.
   * **Failure:** The **Presentation Layer** displays a "Query Incorrect" message. The student is prompted to review their query or request a hint (triggering the  **Hint Generation Pipeline** ).

The entire process is logged via Serilog, providing a complete record of the student's attempt, the canonical answer, and the comparison result.
