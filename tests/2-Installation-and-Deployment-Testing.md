## Detailed Test Plan: DataQuest: SQL Detective

### 2. Installation and Deployment Testing

This evaluation area is critical because DataQuest is designed for student and instructor self-deployment on personal laptops. The goal is to ensure the setup process is clear, repeatable, and robust across common Windows environments. This testing validates the **Deployment Guide** and the **Configuration Files** (`appsettings.json`, `agentendpoints.json`).

#### A. Pre-Deployment and Environment Setup

| **ID**      | **Test Case / Procedure**                                                                                                  | **Expected Result / Success Criteria**                                                                                                                                                       | **Pass/Fail** |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| **IDT-001** | **Prerequisites Check:**Verify the presence of local MSSQL.                                                                      | The local SQL Server instance (used for the relational database class) is confirmed to be running and accessible (e.g., via SQL Server Management Studio).                                         | [ ]                 |
| **IDT-002** | **Ollama Installation:**Follow the deployment guide to install Ollama.                                                           | Ollama is installed, the default model (e.g.,`llama3:8b-instruct`) is successfully downloaded and loaded. The command `ollama run <modelname>`executes without error.                          | [ ]                 |
| **IDT-003** | **Repository and Data Extraction:**                                                                                        | The main application repository is downloaded, and the contents are extracted to a local project directory structure (e.g.,`C:\DataQuest`). All required executables and data files are present. | [ ]                 |
| **IDT-004** | **Database Seeding:**Execute the `DataQuestDB_Seed.sql`script (from the Test Data Directory) against the local MSSQL instance. | The `DataQuestDB`is created, and all required tables (`Persons`,`EvidenceRecord`, etc.) are successfully populated with the initial synthetic data.                                          | [ ]                 |

#### B. Configuration and Connectivity

| **ID**      | **Test Case / Procedure**                                                                                                                            | **Expected Result / Success Criteria**                                                                                                                                                           | **Pass/Fail** |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------- |
| **IDT-005** | **Configuration File Integrity:**Open and inspect `appsettings.json`and `agentendpoints.json`.                                                         | All required keys (`ConnectionStrings:DataQuestDB`,`OllamaEndpoint:Url`,`MCPServer:Protocol`) are present and use default values as defined in the documentation.                                | [ ]                 |
| **IDT-006** | **SQL Server Connectivity:**Launch the DataQuest application and attempt to load the Schema Browser.                                                       | The application successfully connects to the MSSQL instance using the connection string in `appsettings.json`. Table names and column details load without a connection error.                       | [ ]                 |
| **IDT-007** | **MCP Server Connectivity (Local):**Launch the `CaseManager`and trigger an event that requires a database connection (e.g., loading the schema browser). | The**MCP Client**successfully launches and connects to the C#**MCP Server**executable using the `stdio`protocol, demonstrating that the agent-to-database pipe is functioning.           | [ ]                 |
| **IDT-008** | **LLM/Ollama Connectivity:**Click the "Explain Schema" button (**DB Agent** ).                                                                       | The application successfully sends a request to the local `http://localhost:11434`Ollama endpoint. The Ollama service processes the request and returns a valid response to the **DB Agent** . | [ ]                 |
| **IDT-009** | **Case Registry Access:**Verify the Case Selection screen.                                                                                                 | The application successfully reads the configured `CaseStorageDirectory`and displays all available `CasePlan.json`files with `IsSolvable: true`in the Case Selection UI.                         | [ ]                 |

---

**Next Step:** I will now document the test plan for the third evaluation area:  **AI Reasoning Validation** .
