## Detailed Test Plan: DataQuest: SQL Detective

### 4. Internal Usability Testing

Internal Usability Testing involves simulating the experience of a first-time student using the application. This is a qualitative assessment focusing on clarity, workflow friction, engagement, and the effectiveness of the interface in supporting the core learning objectives. This testing should be performed by the developer or a close team member acting as an unfamiliar user, focusing heavily on the  **Presentation Layer** .

#### A. Initial Setup and Interface Clarity

| **ID**      | **Test Case / Procedure**                                                                           | **Expected Result / Success Criteria**                                                                                                                                                                                                      | **Pass/Fail** |
| ----------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| **IUT-001** | **First Launch Flow:**Launch the compiled application for the first time.                                 | The main UI loads without error. All major panels are clearly labeled:**Schema Browser** , **SQL Editor** , **Results Grid** , and **Case Prompt** . The layout is logical and scannable ( **Risk Mitigation 4** ). | [ ]                 |
| **IUT-002** | **Schema Clarity (US-02):**Use the Schema Browser to understand relationships.                            | A first-time user can easily identify the tables, their columns, and the correct Foreign Key relationships necessary to perform a basic `JOIN`query (e.g., joining `Persons`and `TransactionLogs`).                                         | [ ]                 |
| **IUT-003** | **Agent Monitor Transparency (US-09d):**Observe the Admin/AI Agent Monitor Interface during initial load. | The log immediately shows successful connections to**MSSQL** , **MCP Server** , and **Ollama** . Log entries are appropriately**color-coded**(e.g., Errors are Red, Success is Green) and include timestamps.             | [ ]                 |

#### B. Investigative Workflow and Pacing

| **ID**      | **Test Case / Procedure**                                                                                                                 | **Expected Result / Success Criteria**                                                                                                                                                    | **Pass/Fail** |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| **IUT-004** | **Step Pacing and Gating:**Attempt to solve a 3-step case, failing steps 1 and 2 once.                                                          | The narrative progression (from one `StoryStep`to the next) feels natural. The system strictly prevents advancing until the correct clue is found, reinforcing the **Deduction Loop** . | [ ]                 |
| **IUT-005** | **Error Message Clarity:**Submit a query with a syntax error (e.g., misspelling `SELECT`).                                                    | The application catches the database error, displays a clear, user-friendly error message, and does**not**crash or display complex stack traces.                                          | [ ]                 |
| **IUT-006** | **Tutor Tone and Pacing (US-06):**Fail a step, request Hint Level 1, revise, fail again, and request Hint Level 2.                              | Hint 1 uses a**Socratic tone**and points to a general area of logic. Hint 2 is more specific but still avoids providing the solution, confirming**scaffolding**works.               | [ ]                 |
| **IUT-007** | **Discovery to Query Mapping:**Identify a required clue from the `StepPrompt`and successfully translate that need into the correct SQL logic. | The user feels a clear connection between the narrative objective ("find the timestamp for person X") and the technical query (`SELECT Timestamp FROM ...`).                                  | [ ]                 |

#### C. Finalization and Conclusion

| **ID**      | **Test Case / Procedure**                                               | **Expected Result / Success Criteria**                                                                                                                         | **Pass/Fail** |
| ----------------- | ----------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| **IUT-008** | **Case Completion Experience:**Successfully complete the final `StoryStep`. | The final `Conclusion`narrative is displayed immediately. A simple**Case Completion Summary (US-09h)**is shown (e.g., steps completed, hints used).                | [ ]                 |
| **IUT-009** | **System Reset:**After completing a case, attempt to load a new one.          | The `CaseManager`successfully clears the memory of the first case and initializes the application state correctly for the second case (e.g., Step ID resets to 1). | [ ]                 |

---

**Next Step:** I will now document the test plan for the fifth evaluation area:  **External Pilot Testing** .
