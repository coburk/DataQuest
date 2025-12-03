## 🔁 Case Lifecycle

The Case Lifecycle in DataQuest is defined by a continuous loop between the **Case Planner Agent** (content creation) and the **Student Workflow** (investigation). It follows a structured process that ensures every mystery is logically sound and pedagogically valuable before it is presented to the student.

The lifecycle can be broken down into two main phases: **Case Generation & Validation** (driven by AI agents) and **Student Execution & Tutoring** (the learning experience).

---

### Phase 1: Case Generation & Validation (AI Agents) ⚙️

This phase is primarily driven by the **Case Planner Agent (US-07)** and the  **SQL Enforcer (US-08)** , and occurs before the student even opens the case. The goal is to guarantee the case is solvable and consistent.

1. **Schema Analysis (DB Agent):**
   * The **Case Planner Agent** requests the current database structure via the `schema.describe` MCP tool. The **Database Agent** provides a natural-language description of tables, columns, and foreign keys.
2. **CasePlan Generation:**
   * The **Case Planner Agent** uses the schema to generate the `CasePlan` JSON object. This includes the initial narrative, the sequential `StorySteps`, and the **canonical SQL query** for each step.
3. **Solvability Verification (SQL Enforcer):**
   * The **SQL Enforcer** takes the generated `CasePlan`. For every `StoryStep`, it executes the `CanonicalQuery` via the `sql.execute_readonly` MCP tool.
   * It verifies two things:
     * **Query runs without error.**
     * The query returns the **`ExpectedValue`** required for the next step of the narrative.
4. **Consistency Check (SQL Enforcer):**
   * The **SQL Enforcer** runs rule-based checks to detect contradictions (e.g., a witness statement timestamp contradicts a log entry) or empty result sets, ensuring the story is logically sound.
5. **Finalization & Storage:**
   * If validation passes, the `CasePlan`'s `IsSolvable` flag is set to  **true** , and the case data is saved, making it available to the student.

---

### Phase 2: Student Execution & Tutoring (Learning Loop) 🧑‍🎓

This phase describes the interactive, iterative process a student undergoes to solve a case.

1. **Case Start & Prompt:**
   * The student loads the case and receives the **`InitialPrompt`** and the instructions for  **Step 1** .
2. **Student Query Submission:**
   * The student writes their SQL query and clicks "Execute." The system verifies it is a safe, **read-only** query (US-03f) and sends it to the database.
3. **Result Comparison (Query Tutor):**
   * The **Query Tutor Agent (US-05)** executes the student's query and the **`CanonicalQuery`** (from the `AnswerKey`).
   * It compares the two result sets.
4. **Feedback:**
   * **If Correct:** The current step is marked complete, the student receives the extracted clue, and the system advances to the next `StoryStep` prompt.
   * **If Incorrect:** The student receives an **Incorrect Result** message.
5. **Hint Request (Query Tutor):**
   * If the student is stuck, they can request a hint. The **Query Tutor Agent (US-06)** generates a **Socratic, schema-grounded hint** (e.g., "Are you sure you joined the witness table to the correct location ID?") and displays it.
6. **Loop & Conclusion:**
   * The student **revises their query** (loops back to Step 2) until all `StorySteps` are solved. Upon completing the final step, the **`Conclusion`** narrative is displayed, and the case is closed.

---

### DataQuest Case Lifecycle Diagram

This diagram visually represents the two phases of the case lifecycle and the interaction between the core AI agents.
