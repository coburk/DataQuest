## Detailed Test Plan: DataQuest: SQL Detective

### 5. External Pilot Testing

External Pilot Testing involves having at least one external user (a peer, classmate, or instructor, per  **US-09b** ) install and use the system. This evaluation is primarily **qualitative** and aims to expose flaws in the deployment process, configuration instructions, and any confusing elements of the AI-driven learning experience that were missed during internal testing.

This testing is scheduled for **Week 9** (Stabilization/Demo Prep).

#### A. Deployment and Environment Friction

| **ID**      | **Test Case / Procedure**                                                                                                         | **Expected Result / Success Criteria**                                                                                                                                                             | **Pass/Fail** |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| **EPT-001** | **Setup Guide Clarity:**Provide the external tester with only the**Setup Guide**and the final compiled application package. | The tester successfully installs Ollama, restores the `DataQuestDB`into their local MSSQL instance, and launches the application **without direct developer intervention** .                     | [ ]                 |
| **EPT-002** | **Configuration Pain Points:**Have the tester modify the `appsettings.json`file to match their environment.                           | The tester correctly locates and updates the `ConnectionStrings:DataQuestDB`entry using the guide. No confusion arises from the format of the JSON files.                                              | [ ]                 |
| **EPT-003** | **First Run Stability:**The tester launches the DataQuest application for the first time.                                               | The application successfully connects to all local services (**MSSQL** , **MCP Server** , **Ollama** ) and loads the**Case Registry**without crashing.                           | [ ]                 |
| **EPT-004** | **System Port Conflicts:**The tester runs DataQuest alongside other software.                                                           | The application does not encounter port conflicts with their existing local services (e.g., if another service is using the default Ollama port 11434, the system handles it or provides a clear error). | [ ]                 |

#### B. Usability and Pedagogical Effectiveness

| **ID**      | **Test Case / Procedure**                                                                                                                          | **Expected Result / Success Criteria**                                                                                                                                       | **Pass/Fail** |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| **EPT-005** | **Schema Accessibility:**Ask the tester to articulate how they would find the connection between two tables (e.g.,`Persons`and `WitnessStatements`). | The tester uses the**Schema Browser**and/or the **DB Agent** 's natural-language explanation to correctly identify the necessary Foreign Key (`PersonID`).           | [ ]                 |
| **EPT-006** | **Clue-to-Query Mapping:**Observe the tester's decision process for solving a single `StoryStep`.                                                      | The tester can successfully translate the narrative question in the `StepPrompt`into a logical SQL query, indicating the**gamified narrative**provides sufficient context. | [ ]                 |
| **EPT-007** | **Hint System Tone Check (US-06):**Observe the tester's reaction to the Level 1 Socratic Hint after a failure.                                           | The tester finds the hint "helpful" or "guiding" rather than "frustrating" or "too easy," confirming the**Socratic tone**is appropriate for the target audience.             | [ ]                 |
| **EPT-008** | **Full Case Completion Feedback:**After the tester solves a full case, ask for overall impression.                                                       | Qualitative feedback confirms that the experience was engaging and felt like a*mystery*rather than just a *worksheet* , validating the project's **gamified approach** . | [ ]                 |

---

**Next Step:** I will now document the test plan for the final evaluation area:  **Stability and Error Handling Testing** .
