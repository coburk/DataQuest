## 🗂️ Case Loading Pipeline: From JSON to Ready State

The Case Loading Pipeline describes the exact flow of data from the static JSON file to the application's readiness state, where the student can begin querying. This process ensures data integrity and prepares the **`CaseManager`** to control the learning loop for the first  **`StoryStep`** .

This pipeline is a critical function executed by the **`CaseManager`** utilizing the **`JsonCaseImportService`** and the  **SQL Enforcer** .

---

### 1. High-Level Pipeline Stages

The pipeline consists of three sequential stages:  **Extraction** ,  **Validation** , and  **Initialization** .

| **Stage**               | **Goal**                             | **Key Action**                                                                                                                 | **Component Responsible**  |
| ----------------------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------- |
| **I. Extraction**       | Retrieve and deserialize the case data.    | Read the selected JSON file and convert it into a strongly-typed C#**`CasePlan`**object.                                           | `JsonCaseImportService`        |
| **II. Validation**      | Confirm the integrity of the case logic.   | Perform a**final check**on the `IsSolvable`flag and schema references to prevent loading a broken case.                      | `SQL Enforcer`/`CaseManager` |
| **III. Initialization** | Set the application state for the student. | Load the `CasePlan`into the **`CaseManager`** , set the current step to **Step 1** , and display the initial prompt. | `CaseManager`                  |

---

### 2. Detailed Pipeline Steps

#### Stage I: Extraction (JSON **$\to$** C# Object)

1. **File Selection/Retrieval:** The application locates the validated `CasePlan.json` file.
2. **File Read:** The file contents are read into a string.
3. **Deserialization:** The **`JsonCaseImportService`** attempts to deserialize the string into the C# **`CasePlan`** object, which includes lists of `StorySteps`, `Persons`, etc.
4. **Error Check:** If a `JsonException` occurs (malformed JSON), the file is rejected, and an error is logged.

#### Stage II: Validation (Integrity Check)

5. **Solvability Check:** The **`CaseManager`** inspects the deserialized `CasePlan` object. It checks the `IsSolvable` property, which must be  **`true`** .
   * *Note:* The intensive solvability check (running all canonical queries) was performed earlier by the **SQL Enforcer** during  **Case Generation** . This step is a final confirmation.
6. **Schema Reference Check:** The **`CaseManager`** performs a quick, rule-based check to ensure all tables referenced in the `StorySteps`' `CanonicalQuery` strings still exist in the current database schema.
7. **Rejection:** If the `IsSolvable` flag is `false` or the schema check fails, the case is rejected, the UI shows an error, and the process terminates.

#### Stage III: Initialization (Ready State)

8. **Case State Loading:** The validated `CasePlan` object is permanently loaded into the **`CaseManager`** memory.
9. **Step Pointer Setup:** The **`CaseManager`** sets its internal state pointer to the **first `StoryStep`** (`StepID = 1`).
10. **UI Update:** The **Presentation Layer** is notified:
    * The **Schema Browser** is updated with the current case's data dictionary (via the DB Agent).
    * The **Initial Prompt** and the **Step 1 Prompt** are displayed in the UI.
    * The **SQL Editor** is enabled.
11. **Ready State:** The pipeline is complete. The student is now positioned to write their first query. The application is ready to accept user input and engage the  **Query Tutor Agent** .
