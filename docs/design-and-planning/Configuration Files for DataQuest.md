Since we are using the **existing local MSSQL installation** and focusing on  **local services (Ollama, MCP)** , the configuration files will prioritize connectivity and environment management.

Here are the required configuration files, reflecting the decision to use the student's existing local MSSQL server.

---

## ⚙️ Configuration Files for DataQuest

Defining configuration files is essential for managing the application's environment, local service endpoints, and user settings. We will use three primary files to ensure flexibility, security, and ease of deployment.

### 1. `appsettings.json` (Application Settings and Database Connection)

This standard .NET configuration file manages the connection to the student's **existing local SQL Server installation** and general application paths. This is the only file that requires user/instructor modification during deployment setup.

| **Section / Key**                     | **Purpose**                                                                                           | **Example Value**                                                             | **Use Case**                                                                     |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| **`ConnectionStrings:DataQuestDB`** | The connection string for the**local Microsoft SQL Server database**where `DataQuestDB`is restored. | `"Server=(localdb)\\mssqllocaldb;Database=DataQuestDB;Integrated Security=True;"` | Used by the `SQLConnector`and the C#**MCP Server**to connect to the case data. |
| **`Paths:CaseStorageDirectory`**    | The file path where the validated `CasePlan.json`files are stored.                                        | `"C:\\DataQuest\\Cases"`                                                          | Used by the**Case Registry Handler**to discover available cases.                 |
| **`Logging:SerilogConfiguration`**  | Configuration for Serilog logging (e.g., sink paths, minimum levels).                                       | *Internal JSON structure*                                                         | Used by the**Logging Skeleton**to ensure logs are written to file and console.   |

---

### 2. `agentendpoints.json` (AI Communication and Local Services)

This file centralizes the local network endpoints for the AI agents' infrastructure, critical for the **Ollama Interface** and  **MCP Client** .

| **Key**                                    | **Purpose**                                                                                                          | **Example Value**              | **Use Case**                                                              |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ | ------------------------------------------------------------------------------- |
| **`OllamaEndpoint:Url`**                 | The URL of the local**Ollama API**server.                                                                            | `"http://localhost:11434"`         | Used by the**Ollama Interface**to send LLM prompts.                       |
| **`OllamaEndpoint:ModelName`**           | The default local Large Language Model (LLM) to be used by the agents.                                                     | `"llama3:8b-instruct"`             | Used by the**Ollama Interface**to initialize agent communication.         |
| **`MCPServer:Protocol`**                 | The transport protocol used to communicate with the C# MCP Server. We prioritize**`stdio`**for local, offline stability. | `"stdio"`                          | Defines how the**MCP Client**communicates with the custom C# MCP service. |
| **`MCPServer:ExecutablePath`**           | The local path to the compiled C# MCP Server executable.                                                                   | `"C:\\DataQuest\\MCP\\server.exe"` | Used by the**MCP Client**to launch and manage the local server process.   |
| **`AITimeouts:InferenceTimeoutSeconds`** | Maximum time to wait for an LLM response.                                                                                  | `15`                               | Prevents the application from freezing if the LLM is slow or stalls.            |

---

### 3. `userpreferences.json` (Optional Client-Side Settings)

This file stores user-specific UI settings that do not impact core agent functionality.

| **Key**                                    | **Purpose**                                                    | **Example Value** | **Use Case**                                                    |
| ------------------------------------------------ | -------------------------------------------------------------------- | ----------------------- | --------------------------------------------------------------------- |
| **`Theme:ColorMode`**                    | The preferred UI color theme.                                        | `"Dark"`              | Used by the**Presentation Layer**for UI appearance.             |
| **`Window:LastPositionX`**               | Stores the last screen position of the main window.                  | `300`                 | Used for restoring the window layout upon restart.                    |
| **`Tutor:AutomaticHintCooldownSeconds`** | Time delay (in seconds) before the hint button can be clicked again. | `10`                  | Used by the**Query Tutor Agent**to prevent rapid hint attempts. |

This updated structure ensures that deployment involves only two main manual steps: restoring the database and configuring the `ConnectionStrings` to point to the student's existing local SQL server instance.
