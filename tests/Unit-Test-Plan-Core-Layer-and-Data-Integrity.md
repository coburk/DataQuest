## Unit Test Plan: Core Layer and Data Integrity

We will begin documenting the unit tests, focusing on the foundation of the DataQuest application: the **MCP/SQL Layer** and the  **Case Management Layer** . These components must be 100% reliable before we integrate the probabilistic LLM agents. We will use the **xUnit** framework for C#.

---

### 1. Unit Tests for the SQL Connector and Query Validator

These tests ensure the application can safely and correctly interact with the local MSSQL database via the `SQLConnector` and that the application's rule-based security layer (`QueryValidator`) is airtight, fulfilling  **US-03f** .

| **ID**        | **Component / Method**           | **Test Description**                                                                            | **Input / Condition**                                                   | **Expected Result**                                                     |
| ------------------- | -------------------------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **UT-SQ-001** | `QueryValidator.IsSafe(string sql)`  | **Pass - Valid SELECT Query:** Ensures a standard, safe query is allowed.                       | `"SELECT * FROM Persons WHERE Name = 'Alice';"`                             | **`True`**                                                            |
| **UT-SQ-002** | `QueryValidator.IsSafe(string sql)`  | **Fail - Dangerous DML:** Ensures `DELETE`is blocked, regardless of case.                     | `"DELETE FROM Persons WHERE PersonID = 5;"`                                 | **`False`**                                                           |
| **UT-SQ-003** | `QueryValidator.IsSafe(string sql)`  | **Fail - Obfuscated Command:** Ensures command is blocked even with obfuscation.                | `"UPDATE [Evidence] SET Type = 'Fake';"`                                    | **`False`**                                                           |
| **UT-SQ-004** | `SQLConnector.Execute(string query)` | **Connection Failure Handling:** Tests behavior when the database connection string is invalid. | Invalid `appsettings.json`connection string.                                | Throws a specific `SqlException`or returns a**`ConnectionFailure`**state. |
| **UT-SQ-005** | `SQLConnector.GetSchema()`           | **Schema Retrieval:** Confirms the connector can read table metadata.                           | Valid connection string; query:`"SELECT * FROM INFORMATION_SCHEMA.TABLES;"` | Returns a list containing expected tables (`Persons`,`Cases`, etc.).      |

---

### 2. Unit Tests for the Model Context Protocol (MCP) Client

These tests ensure the `MCPClient` correctly formats the JSON-RPC messages required to interact with the C# MCP Server, which handles the database tools.

| **ID**         | **Component / Method**                                                     | **Test Description**                                                                                          | **Input / Condition**                                                                            | **Expected Result**                                                                                   |
| -------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| **UT-MCP-001** | `MCPClient.BuildRequest(string method, Dictionary<string, object> parameters)` | **Build `sql.execute_readonly`Request:** Verifies the structured JSON-RPC output.                           | `method`:`"sql.execute_readonly"`;`params`:`{"query": "SELECT * FROM Logs;"}`                  | Returns a string matching the required JSON-RPC 2.0 format, including `"method": "sql.execute_readonly"`. |
| **UT-MCP-002** | `MCPClient.BuildRequest(string method, ...)`                                   | **Build `schema.describe`Request:** Verifies the format for the schema tool call.                           | `method`:`"schema.describe"`;`params`:`{}`                                                     | Returns a string matching JSON-RPC 2.0 format with `"method": "schema.describe"`.                         |
| **UT-MCP-003** | `MCPClient.HandleResponse(string jsonResponse)`                                | **Parse Success Response:** Verifies the client correctly extracts the result from the MCP Server's response. | Input JSON:`{"jsonrpc": "2.0", "result": [ {"id": 1, "name": "Alice"} ], "id": 1}`                   | Returns the structured data object (`[ {"id": 1, "name": "Alice"} ]`).                                    |
| **UT-MCP-004** | `MCPClient.HandleResponse(string jsonResponse)`                                | **Parse Error Response:** Verifies the client handles a structured MCP error gracefully.                      | Input JSON:`{"jsonrpc": "2.0", "error": {"code": -32603, "message": "SQL Error: Timeout"}, "id": 1}` | Throws a custom `MCPException`containing the error message.                                               |

---

### 3. Unit Tests for Case Registry and Import Service

These tests ensure the application can reliably discover, filter, and load the investigative case files from the file system.

| **ID**        | **Component / Method**                | **Test Description**                                                                 | **Input / Condition**                                                                                                          | **Expected Result**                                                                   |
| ------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- |
| **UT-CR-001** | `CaseRegistryHandler.GetAvailableCases()` | **Filter Solvable Cases:** Ensures only validated cases are indexed.                 | `/CasePlans/`directory contains `CASE_001_Final.json`(`IsSolvable: true`) and `CASE_003_Broken.json`(`IsSolvable: false`). | The registry list contains**only** `CASE_001_Final`.                                |
| **UT-CR-002** | `JsonCaseImportService.Load(path)`        | **Load Malformed Case:** Tests resilience to corrupt JSON data (**SET-007** ). | Attempt to load a `.json`file that is missing a closing bracket.                                                                   | Throws a `JsonException`or returns a**`Failure`**state; application does not crash.     |
| **UT-CR-003** | `JsonCaseImportService.Load(path)`        | **Successful Deserialization:** Verifies conversion to C# POCOs.                     | Load `CASE_001_Final.json`(known good).                                                                                            | Returns a valid `CasePlan`object where `StorySteps.Count`matches the JSON array length. |
| **UT-CR-004** | `CaseManager.Initialize(CasePlan)`        | **Initial State Setup:** Ensures the application is ready to start.                  | Successful load of `CasePlan`.                                                                                                     | `CaseManager.CurrentStepID`is set to **`1`** .                                    |

---

## 4. Next Step: Unit Tests for Query Tutor Agent (Comparison Logic)

These tests ensure that the  **Query Tutor Agent** 's internal comparison engine correctly evaluates two result sets (`Student Result` vs. `Canonical Result`), regardless of factors like column order or row order, which are irrelevant in SQL result set equality. This directly addresses the core logic of  **US-05** .

We will use mock data structures (e.g., C# `DataTable` or `List<object>`) to simulate the results returned from the database via the MCP.

### A. Core Comparison Logic Tests (Data Equivalence)

| **ID**        | **Component / Method**  | **Test Description**                                                                                                                                   | **Input Condition**                                                           | **Expected Result**                                                         |
| ------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **UT-QT-001** | `CompareResultSets(R1, R2)` | **Perfect Match (Success Case):** Both result sets are identical in content, row count, and column count.                                              | R1:`[{'ID': 1, 'Name': 'Alice'}]`vs. R2:`[{'ID': 1, 'Name': 'Alice'}]`          | **`True`**                                                                |
| **UT-QT-002** | `CompareResultSets(R1, R2)` | **Row Order Mismatch (Should Pass):** Tests that reordering rows does not fail the comparison.                                                         | R1:`[{'ID': 1}, {'ID': 2}]`vs. R2:`[{'ID': 2}, {'ID': 1}]`                      | **`True`**                                                                |
| **UT-QT-003** | `CompareResultSets(R1, R2)` | **Column Order Mismatch (Should Pass):** Tests that reordering columns does not fail the comparison.                                                   | R1:`[{'ID': 1, 'Name': 'Bob'}]`vs. R2:`[{'Name': 'Bob', 'ID': 1}]`              | **`True`**                                                                |
| **UT-QT-004** | `CompareResultSets(R1, R2)` | **Missing Row (Failure Case - US-05d):** Student query missed a `WHERE`condition.                                                                    | R1:`[{'ID': 1}, {'ID': 2}]`vs. R2:`[{'ID': 1}]`                                 | **`False`**(Mismatch Details: "Missing Row with ID 2")                    |
| **UT-QT-005** | `CompareResultSets(R1, R2)` | **Extra Row (Failure Case - US-05d):** Student query missed a `WHERE`condition.                                                                      | R1:`[{'ID': 1}]`vs. R2:`[{'ID': 1}, {'ID': 3}]`                                 | **`False`**(Mismatch Details: "Extra Row with ID 3")                      |
| **UT-QT-006** | `CompareResultSets(R1, R2)` | **Missing Column:** Student query forgot to select a required field (e.g.,`Timestamp`).                                                              | R1:`[{'ID': 1, 'Name': 'Bob', 'Time': 900}]`vs. R2:`[{'ID': 1, 'Name': 'Bob'}]` | **`False`**(Mismatch Details: "Missing required column: Time")            |
| **UT-QT-007** | `CompareResultSets(R1, R2)` | **Data Type Inconsistency:** Tests handling of differing data types (e.g., string vs. int) that should still be considered equal for loose comparison. | R1:`[{'Value': '123'}]`vs. R2:`[{'Value': 123}]`                                | **`True`**(If comparison logic uses culture-invariant string comparison). |

### B. Hint Context Preparation Tests

These tests verify that the **Query Tutor Agent** correctly packages the necessary data before calling the LLM (per the  **Hint Generation Pipeline** ).

| **ID**        | **Component / Method**      | **Test Description**                                                           | **Input Condition**                                              | **Expected Result**                                                                                           |
| ------------------- | --------------------------------- | ------------------------------------------------------------------------------------ | ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **UT-QT-008** | `BuildHintContext(failureData)` | **Context Assembly:** Ensures all required fields are included for the prompt. | Failure on Step 3;`ErrorContext`from `AnswerKey`is "Missing JOIN". | Returns a `HintContext`object with the correct `StepPrompt`,`LastFailedQuery`, and `ErrorContext`populated. |
| **UT-QT-009** | `GetNextHintLevel()`            | **Level Increment:** Verifies the logic for scaffolding the hints (US-06c).    | Current hint state is Level 1; student requests new hint.              | Returns**Level 2** ; internal state is updated.                                                               |

---

## 5. Next Step: Unit Tests for SQL Enforcer Agent

These tests verify the rule-based logic that acts as the final safety net for every generated case. The Enforcer's primary job is to check the `CasePlan` for logical integrity and solvability before deployment, fulfilling  **US-08** .

### A. Solvability and Data Integrity Tests

These tests focus on the Enforcer's ability to check the structural integrity of the case's data references.

| **ID**        | **Component / Method**            | **Test Description**                                                                                                                     | **Input Condition**                                                                | **Expected Result**                                                                                    |
| ------------------- | --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **UT-SE-001** | `Enforcer.CheckSolvability(CasePlan)` | **Pass - All Steps Solvable:** Confirms that all canonical queries run and return an expected value.                                     | `CasePlan`where all `CanonicalQueries`are valid and return non-empty sets.           | **`IsSolvable: True`**                                                                               |
| **UT-SE-002** | `Enforcer.CheckSolvability(CasePlan)` | **Fail - Broken Canonical Query:** Tests the Enforcer's handling of bad SQL generated by the Case Planner.                               | `CasePlan`where Step 3's `CanonicalQuery`contains a syntax error.                    | **`IsSolvable: False`**(Detailed reason: "Syntax Error in Step 3 Canonical Query")                   |
| **UT-SE-003** | `Enforcer.CheckSolvability(CasePlan)` | **Fail - Unsolvable Step (Empty Set):** Confirms that a query returning zero results is flagged.                                         | `CasePlan`where Step 4's `CanonicalQuery`runs but returns zero rows (no clue found). | **`IsSolvable: False`**(Detailed reason: "Canonical Query for Step 4 returned an empty result set.") |
| **UT-SE-004** | `Enforcer.CheckFKIntegrity(CasePlan)` | **Fail - Missing Data/Orphaned Record:** Tests if a required `PersonID`in `WitnessStatements`does not exist in the `Persons`table. | Data in the database violates Foreign Key constraint required for a critical JOIN.       | **`IsSolvable: False`**(Detailed reason: "Critical Foreign Key link is broken by missing data.")     |

### B. Contradiction Detection Tests (Case Logic)

These tests verify the Enforcer's ability to detect story-breaking logical inconsistencies, which rely on the Enforcer running specific comparison queries against the underlying database.

| **ID**        | **Component / Method**                | **Test Description**                                                                                                                                                            | **Input Condition**                                                  | **Expected Result**                                                                                       |
| ------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| **UT-SE-005** | `Enforcer.DetectContradictions()`         | **Detect Conflicting Timestamps (US-08a):** A witness statement places a suspect at Location A at 8:00 AM, but a `TransactionLog`places the suspect at Location B at 8:05 AM. | Data inserted into the database creates a narrow, conflicting time window. | **`IsSolvable: False`**(Detailed reason: "Contradiction detected: Suspect cannot be at two locations.") |
| **UT-SE-006** | `Enforcer.DetectContradictions()`         | **Detect Trivial Case:** Ensures the mystery is complex enough to require a multi-step investigation.                                                                           | A single `CanonicalQuery`could solve the entire mystery in one step.     | **`IsSolvable: False`**(Detailed reason: "Case is too trivial; requires fewer than 3 steps.")           |
| **UT-SE-007** | `Enforcer.ValidateSchemaReference(Query)` | **Detect Non-Existent Reference:** Ensures the canonical SQL does not reference fake tables.                                                                                    | `CanonicalQuery`contains `SELECT * FROM FAKE_ALIEN_TABLES;`            | **`IsSolvable: False`**(Detailed reason: "Query references non-existent table: FAKE_ALIEN_TABLES.")     |

---

## 6. Next Step: Unit Tests for Ollama Interface

The **Ollama Interface** is the key component responsible for reliable communication with the local LLM runtime (Ollama) and managing the complexity of prompt engineering and tool invocation. Since the LLM's *output* is probabilistic, we cannot unit test its generated  *content* . Instead, we must unit test the **Interface's deterministic functions** that handle formatting, connectivity, and response parsing.

These tests ensure that our C# application correctly speaks the language of the Ollama API, preparing the infrastructure for all AI Agent interactions.

---

### A. Connectivity and Service Status Tests

These tests verify that the interface can establish a stable connection with the local Ollama service and handle failures gracefully, fulfilling  **SET-005** .

| **ID**        | **Component / Method**                          | **Test Description**                                                                                                      | **Input Condition**                                                   | **Expected Result**                                                                      |
| ------------------- | ----------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| **UT-OI-001** | `OllamaInterface.CheckStatus()`                     | **Successful Connection:** Verifies the local service is running and accessible (e.g., checks the `/api/tags`endpoint). | Ollama service is running locally on the configured port.                   | Returns**`ServiceStatus: Running`**(`True`).                                               |
| **UT-OI-002** | `OllamaInterface.CheckStatus()`                     | **Connection Refused:** Tests error handling when the service is offline or unreachable.                                  | Ollama service is intentionally shut down or the endpoint URL is incorrect. | Returns**`ServiceStatus: Offline`**(`False`) or throws a specific `ConnectionException`. |
| **UT-OI-003** | `OllamaInterface.CheckModelAvailability(modelName)` | **Model Verification:** Ensures the required model (e.g.,`llama3:8b-instruct`) is downloaded and ready for use.         | The model is downloaded in Ollama's local storage.                          | Returns**`ModelAvailable: True`** .                                                          |
| **UT-OI-004** | `OllamaInterface.CheckModelAvailability(modelName)` | **Model Missing:** Tests handling when the user configured a model that hasn't been pulled.                               | A non-existent model name is passed.                                        | Returns**`ModelAvailable: False`** .                                                         |

### B. Prompt and Tool Formatting Tests

These tests ensure the interface constructs the API payloads exactly as the Ollama service expects, including embedding the MCP tool schemas for function calling.

| **ID**        | **Component / Method**                          | **Test Description**                                                                                                    | **Input Condition**                                                       | **Expected Result**                                                                                                                          |
| ------------------- | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| **UT-OI-005** | `OllamaInterface.FormatPrompt(system, user, tools)` | **Standard Prompt Formatting:** Verifies basic formatting for non-tool-use requests (e.g., a simple hint request).      | `system`: "You are a tutor.";`user`: "What is SQL?"                         | Returns a valid JSON payload containing the system and user messages.                                                                              |
| **UT-OI-006** | `OllamaInterface.FormatPrompt(system, user, tools)` | **Tool Schema Injection (Critical):** Verifies the payload correctly embeds the MCP tool schema.                        | `system`: "You are a planner.";`tools`:`[schema.describe]`MCP definition. | Returns a JSON payload where the `tools`array is correctly populated with the `schema.describe`structure, enabling the LLM to choose the tool. |
| **UT-OI-007** | `OllamaInterface.FormatPrompt(...)`                 | **Timeout Configuration:** Ensures the configured `AITimeouts`value is correctly included in the API request payload. | `AITimeouts: 15`seconds is configured.                                        | Returns a JSON payload element correctly setting the request timeout.                                                                              |

### C. Response Parsing and Safety Tests

These tests verify that the interface can reliably handle and parse the LLM's response, especially when the LLM attempts to use a tool.

| **ID**        | **Component / Method**                | **Test Description**                                                                                                                                     | **Input Condition**                                                                 | **Expected Result**                                                                                              |
| ------------------- | ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **UT-OI-008** | `OllamaInterface.ParseTextResponse(json)` | **Standard Text Parsing:** Extracts a simple text response (e.g., a generated hint).                                                                     | Ollama JSON response containing only a standard text `message.content`.                 | Returns the clean, extracted string of the hint text.                                                                  |
| **UT-OI-009** | `OllamaInterface.ParseToolCall(json)`     | **Tool Call Parsing:** Verifies the interface extracts the requested tool and parameters (e.g., the `CanonicalQuery`from the **Case Planner** ). | Ollama response containing a structured `tool_call`object for `sql.execute_readonly`. | Returns a structured C# object (`MCPRequest`) containing the method name and parameters ready for the `MCPClient`. |
| **UT-OI-010** | `OllamaInterface.ParseToolCall(json)`     | **Tool Call Safety:** Ensures the LLM did not try to call a disallowed or unknown tool.                                                                  | Ollama response attempts to call a non-defined tool like `system.shutdown`.             | Throws a specific `ToolViolationException`.                                                                          |

---
