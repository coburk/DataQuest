## 🏛️ Building Core Domain Models

Defining the **Core Domain Models** means translating the entries in the **Data Dictionary** and **JSON Case Schema** into robust, strongly-typed C# classes (or **POCOs** - Plain Old CLR Objects). These models are the foundational data structures used throughout the application, ensuring that data passed between the UI, the `CaseManager`, and the AI agents is consistent and reliable.

The models fall into two main categories: **Investigative Data Models** (database entities) and **Agent Control Models** (AI workflow structures).

---

### 1. Investigative Data Models (Database Entities)

These models mirror the structure of the relational database tables, enabling the application to read and write case data (though writes are primarily limited to the Case Planner and Case Enforcer).

| **C# Class**                | **Purpose**                                      | **Key Properties**                                                              | **Data Dictionary Reference** |
| --------------------------------- | ------------------------------------------------------ | ------------------------------------------------------------------------------------- | ----------------------------------- |
| **`Person`**              | Represents any individual involved in the case.        | `PersonID`(int),`Name`(string),`Role`(string),`IsSuspect`(bool).              | `Persons`Table                    |
| **`Location`**            | Represents a physical setting or place of interest.    | `LocationID`(int),`Name`(string),`Address`(string).                             | `Locations`Table                  |
| **`EvidenceRecord`**      | Represents a piece of evidence or a log entry found.   | `EvidenceID`(int),`CaseID`(int),`LocationID`(int),`TimestampFound`(DateTime). | `Evidence`Table                   |
| **`CommunicationRecord`** | Represents logs of communication (e.g., phone, email). | `RecordID`(int),`CallerID`(int),`ReceiverID`(int),`Timestamp`(DateTime).      | `CommunicationRecords`Table       |

---

### 2. Agent Control Models (Case & Workflow)

These models are critical for the **`CaseManager`** and the  **`AgentOrchestrator`** , as they contain the flow logic and the canonical answers required for tutoring.

#### A. The Case Structure

| **C# Class**      | **Purpose**                                                  | **Key Properties**                                                                                                 | **JSON Schema Reference**   |
| ----------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | --------------------------------- |
| **`CasePlan`**  | The root container for the entire investigation.                   | `CaseID`,`CaseTitle`,`InitialPrompt`,`IsSolvable`(bool),`List<StoryStep> StorySteps`,`List<Person> Persons`. | Root JSON Object                  |
| **`StoryStep`** | A single sequential task the student must solve.                   | `StepID`(int),`StepPrompt`(string),`CanonicalQuery`(string),`ExpectedValue`(string).                             | `StorySteps`Array               |
| **`AnswerKey`** | The authoritative data against which student results are compared. | `ExpectedResultHash`(string),`ExpectedClueValue`(string),`ErrorContext`(string, for hint generation).              | `AnswerKeys`Table / JSON fields |

#### B. Workflow & Communication

| **C# Class**                  | **Purpose**                                                                       | **Key Properties**                                                                                                                     | **Pipeline Reference** |
| ----------------------------------- | --------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| **`QuerySubmissionResult`** | Captures the outcome of the**Query Submission Pipeline** .                        | `IsCorrect`(bool),`StudentResult`(DataTable/List of Objects),`CanonicalResult`(DataTable/List of Objects),`MismatchDetails`(string). | Query Submission Pipeline    |
| **`HintContext`**           | Packages the data required for the**Hint Generation Pipeline** .                  | `CurrentHintLevel`(int),`SchemaFragment`(string),`LastFailedQuery`(string),`ErrorContext`(string).                                   | Hint Generation Pipeline     |
| **`MCPRequest`**            | The standardized JSON-RPC object sent from the**MCP Client**to the C# MCP Server. | `Method`(string, e.g., "sql.execute_readonly"),`Params`(list of objects),`ID`(int).                                                    | MCP Integration              |

By defining these strong, explicit models, we enforce type-safety across the application, which is crucial when handling data generated by the probabilistic LLM agents and comparing precise SQL results.
