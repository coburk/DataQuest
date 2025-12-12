## 📊 Logging and Telemetry Skeleton

Implementing a structured logging and telemetry system is essential for debugging, performance analysis, and, crucially, for demonstrating the transparent operation of the AI agents during the capstone presentation ( **US-01h, US-09d-e** ).

We will use **Serilog** as the primary logging framework due to its flexibility, structured output capabilities (JSON format), and ease of integration into a .NET application.

---

### 1. Logging Tiers and Severity Levels

We will use standard logging levels to categorize events, enabling easy filtering during debugging and demonstration.

| **Level**       | **Purpose**                                                         | **DataQuest Use Case**                                                                          |
| --------------------- | ------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| **Fatal**       | Application is dead; immediate crash or unrecoverable error.              | Database connection loss; unhandled exception in the `AgentOrchestrator`.                           |
| **Error**       | Function failed; critical operational failure that does not stop the app. | **SQL Enforcer**rejects a case;**Query Submission Pipeline**blocks an unsafe query.       |
| **Warning**     | Potential issue or non-critical failure.                                  | **Query Tutor**detects a query performance issue; student struggles (multiple failed attempts). |
| **Information** | Standard operational events; critical success messages.                   | Case loaded;`StoryStep`successfully completed;**Hint**delivered; **MCP call success** . |
| **Debug**       | Detailed technical information for troubleshooting.                       | Full JSON request/response from the**MCP Client** ; deserialization successful.                 |

---

### 2. Required Log Fields (Structured Telemetry)

Structured logging (e.g., using Serilog's JSON output) is vital for recording the full context of AI agent activity. Every critical log entry will include these fields:

| **Field Name** | **Data Type** | **Purpose in DataQuest**                                                      |
| -------------------- | ------------------- | ----------------------------------------------------------------------------------- |
| `Timestamp`        | `DATETIME2`       | **US-09e:**Enables accurate chronological tracking of events.                       |
| `SourceContext`    | `STRING`          | Identifies the component (e.g.,`MCPClient`,`QueryTutorAgent`,`CaseManager`).  |
| `CaseID`           | `STRING`          | Tracks the event to the current investigation.                                      |
| `StoryStepID`      | `INT`             | Tracks the event to the current investigative step.                                 |
| `AgentID`          | `STRING`          | Identifies which AI agent performed the action (e.g.,`DB_AGENT`,`TUTOR_AGENT`). |
| `EventCategory`    | `STRING`          | Categorizes the event (e.g.,`QUERY_SUBMIT`,`HINT_REQUEST`,`CASE_REJECTION`).  |
| `DurationMs`       | `INT`             | Records latency (e.g., how long the LLM or database query took).                    |
| `Message`          | `STRING`          | The human-readable event description.                                               |

---

### 3. Agent and Pipeline Logging Skeletons

These skeletons define the minimum log events required to demonstrate the **Plan **$\to$** Verify **$\to$** Tutor** cycle in the  **Admin/AI Agent Monitor Interface** .

#### A. Case Generation and Validation (Plan/Verify)

| **Log Message**                           | **Level** | **SourceContext** | **Key Event**                    |
| ----------------------------------------------- | --------------- | ----------------------- | -------------------------------------- |
| "Starting CasePlan generation via LLM."         | Information     | `CasePlannerAgent`    | Beginning the**Plan**phase.      |
| "MCP call: schema.describe initiated."          | Debug           | `MCPClient`           | Showing the agent fetching the schema. |
| "CasePlan JSON generated. Entering validation." | Information     | `CasePlannerAgent`    | **Plan**phase complete.          |
| "Executing canonical SQL for StoryStep: 3."     | Debug           | `SQL_ENFORCER`        | Step in the**Verify**phase.      |
| "Validation passed. IsSolvable set to True."    | Information     | `SQL_ENFORCER`        | **Verify**phase complete.        |

#### B. Query Execution and Tutoring (Tutor)

| **Log Message**                                 | **Level** | **SourceContext** | **Key Event**                              |
| ----------------------------------------------------- | --------------- | ----------------------- | ------------------------------------------------ |
| "Student query received for Step 2."                  | Information     | `AgentOrchestrator`   | Beginning the**Tutoring**cycle.            |
| "Student query blocked: Contains 'DROP'."             | Error           | `QueryValidator`      | **US-03f**violation.                       |
| "Query comparison complete. Result: Mismatch."        | Information     | `QueryTutorAgent`     | Failure event leading to hint option.            |
| "Hint Level 1 requested. Generating Socratic prompt." | Information     | `QueryTutorAgent`     | Starting the**Hint Generation Pipeline** . |
| "LLM Inference time: 780ms."                          | Debug           | `OllamaInterface`     | Performance telemetry.                           |
| "StoryStep 4 completed successfully."                 | Information     | `CaseManager`         | Successful advancement.                          |

By adhering to this structure, the application will produce a clean, filterable log that clearly illustrates the intelligence and safety features of the DataQuest system. The log panel in the UI will use **US-09d** (Color-Coding) to make these events visually distinct.
