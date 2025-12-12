## 📝 Building the Case Registry Handler

The **Case Registry Handler** is a fundamental component of the **`CaseManager`** responsible for maintaining an organized and up-to-date list of all available, validated investigative cases. It acts as the central index that the **Presentation Layer** uses to allow the student to select a case and ensures only solvable cases are presented.

This handler is crucial for fulfilling **US-07f** (Load cases from UI).

---

### 1. Responsibilities of the Case Registry Handler

| **Responsibility**       | **Description**                                                                                                                                                         | **Agent/Component Interaction**                                                    |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| **Indexing**             | Scans the designated file system directory (e.g.,`/Cases/`) for all stored `CasePlan.json`files.                                                                          | File System, Configuration Settings.                                                     |
| **Metadata Caching**     | Loads only the essential metadata (`CaseID`,`CaseTitle`,`InitialPrompt`) from each JSON file for display, avoiding the need to load the full, large `StorySteps`list. | `JsonCaseImportService`(used in a lightweight, metadata-only mode).                    |
| **Status Filtering**     | Filters the list to ensure only cases where**`IsSolvable: true`**are added to the registry. Rejected or unvalidated cases are excluded.                                     | **SQL Enforcer**(Implicitly, as it sets the `IsSolvable`flag during generation). |
| **UI Presentation**      | Provides the `Presentation Layer`with a structured list (the "registry") to populate the Case Selection screen.                                                             | Presentation Layer.                                                                      |
| **Lookup and Retrieval** | Allows the `CaseManager`to quickly retrieve the full file path or metadata for a case when the student selects it.                                                          | `CaseManager`.                                                                         |

---

### 2. Implementation Workflow

The handler operates primarily when the application starts or when the instructor generates a new case.

#### A. Initialization and Indexing

1. **Read Configuration:** The handler reads the configured **Case Storage Path** (a local directory) from the application settings.
2. **File System Scan:** It performs a recursive scan of the directory, identifying all files matching the pattern `*.json`.
3. **Lightweight Metadata Load:** For each file found:
   * It uses the **`JsonCaseImportService`** to read the JSON file.
   * It uses deserialization to load *only* the top-level  **`CaseID`** ,  **`CaseTitle`** , and **`IsSolvable`** properties.
4. **Filtering:** It checks the `IsSolvable` flag. If the flag is `false` or missing, the case is ignored (it's either broken or still under development).
5. **Registry Creation:** A final list of valid `CaseID` and `CaseTitle` pairs is stored in the handler's internal memory (the "Case Registry").

#### B. Case Selection

6. **UI Display:** The Presentation Layer requests the Case Registry list and displays the titles to the student in the Case Selection screen.
7. **Retrieval:** When the student clicks a title, the **`CaseManager`** uses the **Case Registry Handler** to retrieve the full file path.
8. **Loading Pipeline Trigger:** The `CaseManager` passes the path to the  **Case Loading Pipeline** , which then executes the full deserialization and initialization process.

By implementing this registry handler, DataQuest creates a reliable and user-friendly experience, ensuring students are never confronted with a case that is known to be unsolvable or corrupted.
