The Model Context Protocol (MCP) is the **critical middleware** in DataQuest, standardizing how our local AI agents will safely and consistently access the SQL database. This research confirms that the planned approach—building a custom C# MCP server to expose  **read-only SQL capabilities** —is technically sound and aligned with existing .NET/AI development practices.

---

## 🔗 Research: Model Context Protocol (MCP) Integration Possibilities

The Model Context Protocol (MCP) is an open-source standard that uses **JSON-RPC 2.0** to standardize communication between an **AI client** (our agents running on Ollama) and **external tools/data sources** (our local SQL Server).

This approach secures the database and provides a clear, structured interface for the AI agents, addressing the **US-01f, US-01g, US-03b, US-04a, and US-07d** user stories.

### 1. Architectural Role of MCP in DataQuest

In the DataQuest system, the MCP server acts as a single, secure gateway to the student's database.

* **MCP Client (The Agents):** Our  **Database Agent** ,  **Case Planner Agent** ,  **Query Tutor Agent** , and **SQL Enforcer** all act as the AI Client. They communicate a request (e.g., "Describe the schema") over JSON-RPC.
* **MCP Server (The C# Service):** This is a custom C# (.NET 9) application, running in the background, which receives the JSON-RPC request, translates it into a SQL command, executes the command against the local SQL Server, and returns a JSON result back to the AI Agent.
* **Transport:** The C# MCP server can use either **stdio (Standard Input/Output)** for local, single-user communication, or **HTTP** (the standard Ollama API uses HTTP). **Stdio** is simplest for an initial local-only C# application (Week 1 target).

### 2. Critical MCP Tools for DataQuest

The core functionality of DataQuest requires the C# MCP server to expose two primary tools for the AI agents:

| **MCP Tool Method** | **DataQuest Agent(s)**            | **Purpose**                                                                                                                                                           | **User Story**   |
| ------------------------- | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `schema.describe`       | DB Agent, Case Planner                  | **Exposes the database schema**(tables, columns, foreign keys) to the LLM so it can reason about the data structure and generate relevant queries/explanations.       | US-04a, US-07a         |
| `sql.execute_readonly`  | Query Tutor, Case Planner, SQL Enforcer | **Safely executes SELECT queries**against the database. The**readonly**constraint is essential for preventing the LLM or student from corrupting the case data. | US-03b, US-05b, US-07d |

### 3. Implementation Plan and C# Strategy

The C# language and .NET platform are well-supported for building both MCP clients and servers, with official SDKs available.

* **C# MCP Server Development:**
  * We will use the **.NET SDK** to create a simple console application that registers our `schema.describe` and `sql.execute_readonly` methods as  **tools** .
  * This server will host the **SQL Connection String** to the local database, ensuring the connection logic is centralized and secure.
  * The use of **attributes** (like `[McpServerTool]`) in the C# SDK simplifies the tool definition, automatically creating the tool's schema for the LLM.
* **Ollama/LLM Integration:**
  * We will use the LLM's **function-calling** or **tool-use** capability. The DataQuest main application will first retrieve the tool schemas (`schema.describe`, `sql.execute_readonly`) from the MCP server and pass them to the local Ollama model (e.g., Llama 3.1 8B) in the system prompt.
  * When the LLM decides it needs to query the database (e.g., to generate a canonical solution, per  **US-07c** ), it will output a JSON object specifying the tool (`sql.execute_readonly`) and its parameters (the SQL query).
  * The **Agent Orchestrator** in our C# application will intercept this JSON, pass it to the MCP server for execution, and return the database results back to the LLM for final reasoning/response generation.

This planned integration provides the **transparency, security, and structured communication** required for the multi-agent system to function effectively.

---

This video provides an overview of the Model Context Protocol and showcases its capabilities for building AI agents that interact with external tools and data sources using the C# SDK.

[Model Context Protocol: Let MCP Handle Your Development Workflows with GitHub and Jira!](https://www.youtube.com/watch?v=91_6PnC9oUU)
