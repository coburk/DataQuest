## 🏗️ Main Application Structure: DataQuest: SQL Detective

The DataQuest application structure is designed to be **modular, transparent, and built around the multi-agent orchestration** required to drive the investigative learning experience. As a local C# WinForms application, it uses distinct layers to manage the UI, core logic, and communication with the local infrastructure (SQL Server, Ollama, MCP).

---

### 1. Application Layers (Conceptual)

The system is split into three high-level layers to ensure separation of concerns and maintainability.

| **Layer**                     | **Responsibility**                                                  | **Key Components**                                                       |
| ----------------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **Presentation Layer**        | Handles the User Interface (UI) and user input/output.                    | WinForms UI (Schema Browser, SQL Editor, Results Grid, Hint Panel, Log Panel). |
| **Business/Core Logic Layer** | Manages the application state, case flow, and orchestrates the AI agents. | `AgentOrchestrator`,`CaseManager`,`QueryValidator`.                      |
| **Data/Infrastructure Layer** | Manages communication with external local services (Database, LLM, MCP).  | `MCPClient`,`SQLConnector`,`OllamaInterface`.                            |

---

### 2. Core Components and Workflow

The heart of the application is the  **Core Logic Layer** , specifically the `AgentOrchestrator`, which manages the **Plan **$\to$** Verify **$\to$** Tutor** cycle.

#### A. Core Logic Components

* **`AgentOrchestrator`:** This is the traffic controller. It receives a request (e.g., a student query, a need for a hint) and decides which AI agent is best suited to handle the task. It manages the sequence of calls:
  1. Receives student SQL.
  2. Passes canonical SQL to **Query Tutor** for verification.
  3. If verification fails, passes the error context to the **Query Tutor** for hint generation.
* **`CaseManager`:** Manages the loading, storage, and progression of the case. It holds the current `CasePlan` (loaded from JSON, per  **US-07** ) and tracks the student's current `StoryStep` and success status.
* **`QueryValidator`:** A rule-based component that handles simple checks, such as blocking unsafe SQL statements (`DROP`, `DELETE`, `UPDATE`) as required by  **US-03f** .

#### B. Infrastructure Components (The Local Backend)

* **`MCPClient`:** The primary interface for all AI-to-Data communication. It manages the connection to the local C# **MCP Server** and handles the JSON-RPC messaging for tools like `schema.describe` and `sql.execute_readonly`.
* **`OllamaInterface`:** Manages communication with the local **Ollama** LLM runtime. It formats the system prompts, includes the necessary tool schema (from MCP), and handles the final LLM response generation for agents like the **Case Planner** and  **Query Tutor** .
* **`SQLConnector`:** Used by the application (not the agents) for basic, non-AI database tasks, such as loading case metadata or schema visualization ( **US-02** ).

---

### 3. Agent Mapping to Structure

Each AI agent is a specialized module that interacts with the Core Logic and Infrastructure layers:

| **AI Agent**           | **Function Location**         | **Primary Communication Method**                                                                                              |
| ---------------------------- | ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| **DB Agent**           | `OllamaInterface`+`MCPClient`   | Uses `MCPClient`to call `schema.describe`, then uses `OllamaInterface`for natural-language interpretation.                    |
| **Case Planner Agent** | `OllamaInterface`+`CaseManager` | Uses `OllamaInterface`to generate `CasePlan`JSON, then passes it to `CaseManager`for storage.                                 |
| **Query Tutor Agent**  | `OllamaInterface`+`MCPClient`   | Uses `MCPClient`to call `sql.execute_readonly`for comparison (US-05), then uses `OllamaInterface`for hint generation (US-06). |
| **SQL Enforcer**       | `MCPClient`+`QueryValidator`    | Uses `MCPClient`to verify solvability by executing canonical SQL (US-07d).                                                        |

This structure ensures that the complex task of integrating local AI reasoning is confined to predictable, traceable components, maximizing stability for the final demonstration ( **US-09** ).
