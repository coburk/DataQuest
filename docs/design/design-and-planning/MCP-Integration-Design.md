# MCP (Model Context Protocol) Integration Design

**Date:** December 3, 2025  
**Status:** DESIGN SPECIFICATION - MCP INTEGRATION STRATEGY  
**Version:** 1.0  
**Classification:** Implementation Guidance

---

## 📋 Document Purpose

This specification defines the strategy for integrating an existing MSSQL MCP (Model Context Protocol) server into DataQuest, enabling AI agents to execute database queries and introspect schema through a standardized protocol.

**This document addresses:**
- ✅ What is the existing MCP and can it be reused
- ✅ How to integrate it into DataQuest
- ✅ Architecture and design patterns
- ✅ Implementation roadmap
- ✅ Integration with existing specifications

---

## 🎯 Executive Summary

### Existing MCP Asset

**Repository:** `D:\GitHub-Repos\mcp-mssql-server-repo`  
**Status:** ✅ Production-ready  
**Language:** C# / .NET 9  
**Protocol:** Model Context Protocol (JSON-RPC 2.0)

### Reusability Assessment

| Criterion | Status | Notes |
|-----------|--------|-------|
| Language Match (.NET 9) | ✅ Perfect | Already targets .NET 9 |
| Database Support (MSSQL) | ✅ Complete | Full MSSQL support |
| MCP Compliance | ✅ Standard | Follows MCP spec |
| Agent Integration Ready | ✅ Ready | Can integrate with agents |
| Existing Codebase | ✅ Usable | ~15KB, well-structured |

### Recommendation

✅ **YES - HIGHLY REUSABLE**

The existing MSSQL MCP is **directly reusable** in DataQuest with minimal modifications. It provides the exact functionality needed for:
- Query execution
- Schema introspection
- Database tool exposure to AI agents

---

## 🏗️ Existing MCP Architecture

### Project Structure

```
mcp-mssql-server-repo/
├── Servers/
│   └── MSSQLMCPServer.cs    (15.5 KB - Main implementation)
├── Models/
│   ├── MCPRequest.cs (Request model)
│   ├── ToolDefinition.cs   (Tool definitions)
│   ├── SQLExecuteResponse.cs    (Response model)
│   └── SchemaDescribeResponse.cs (Schema response model)
├── GlobalUsings.cs             (Global using statements)
├── mcp-mssql-server.csproj      (Project file)
└── README.md       (Documentation)
```

### Key Components

**MSSQLMCPServer.cs** (Main Server)
- Implements MCP protocol
- Handles JSON-RPC 2.0 communication
- Exposes database tools
- Manages SQL execution

**Models** (Data Contracts)
- `MCPRequest` - Protocol request structure
- `ToolDefinition` - Tool metadata and schemas
- `SQLExecuteResponse` - Query execution results
- `SchemaDescribeResponse` - Database schema information

### Current Capabilities

```
✅ Tool Exposure:
├─ SQL query execution
├─ Schema introspection
├─ Table listing
└─ Column metadata retrieval

✅ Protocol Support:
├─ JSON-RPC 2.0
├─ MCP specification compliance
├─ Standard request/response patterns
└─ Error handling

✅ Database Support:
├─ Microsoft SQL Server
├─ Connection pooling
├─ Query timeout handling
└─ Transaction support
```

---

## 🔄 Integration Strategy

### How to Integrate into DataQuest

#### Option 1: Direct Reuse (RECOMMENDED)

**Approach:** Copy the entire MCP project as a submodule or separate package

```
DataQuest_v2/
├── src/
│   ├── DataQuest.Backend/
│   ├── DataQuest.Agents/
│   ├── DataQuest.Services/
│   └── DataQuest.MCP/        ← Copy MCP here
│ ├── Servers/
│       ├── Models/
│       └── mcp-mssql-server.csproj
└── ...
```

**Advantages:**
- ✅ Minimal changes required
- ✅ Easy to maintain separately
- ✅ Can publish as NuGet package
- ✅ Version independently
- ✅ Reusable in other projects

**Integration Points:**
```csharp
// In DataQuest.Backend project

// 1. Reference MCP project
<ProjectReference Include="..\DataQuest.MCP\mcp-mssql-server.csproj" />

// 2. In startup:
var mcpServer = new MSSQLMCPServer(
    connectionString: configuration.GetConnectionString("DataQuest"),
    logger: logger);

// 3. Agents use MCP tools:
var queryResult = await mcpServer.ExecuteTool("execute_sql", parameters);
```

#### Option 2: As NuGet Package

**Approach:** Publish existing MCP as NuGet package, reference in DataQuest

```xml
<!-- DataQuest.csproj -->
<PackageReference Include="MCP.MSSQL.Server" Version="1.0.0" />
```

**Advantages:**
- ✅ Clean separation
- ✅ Binary distribution
- ✅ Version management
- ✅ Easy upgrades

#### Option 3: Extract and Integrate

**Approach:** Extract MCP concepts into DataQuest

```
Less recommended - loses separation of concerns
```

### Recommendation: **Option 1 - Direct Reuse**

Copy the MCP repository to `src/DataQuest.MCP/` and reference it as a project dependency. This provides:
- Easy modification if needed
- Clear integration path
- Easy to version control
- Simple to maintain

---

## 🔌 How MCP Fits into DataQuest Architecture

### Integration Points

```
DataQuest Architecture:

┌────────────────────────────────────────────────┐
│      Query Tutor Agent / Database Agent  │
├────────────────────────────────────────────────┤
│   Agent Communication Service (from Spec #5)  │
├────────────────────────────────────────────────┤
│         ↓ Routes tool requests to MCP          │
├────────────────────────────────────────────────┤
│    MCP Server (SQL Execution & Schema)     │  ← MCP Fits Here
│    ┌─────────────────────────────────────┐   │
│    │ Tool: execute_sql        │   │
│    │ Tool: describe_schema         │   │
│    │ Tool: list_tables                 │   │
│    │ Tool: get_column_info    │   │
│    └─────────────────────────────────────┘   │
├────────────────────────────────────────────────┤
│     ↓ Executes against database            │
├────────────────────────────────────────────────┤
│              SQL Server / MSSQL         │
└────────────────────────────────────────────────┘
```

### Service Layer Integration (from Spec #5)

The MCP becomes a backend tool that services use:

```csharp
// In IQueryService (from API & Service Layer spec)
public class QueryService : IQueryService
{
    private readonly IMSSQLMCPServer _mcpServer;
    
    public async Task<QueryExecutionResponse> ExecuteQueryAsync(
        string query, int timeoutSeconds)
    {
        // Use MCP to execute query
      var result = await _mcpServer.ExecuteTool(
      "execute_sql",
          new { query, timeout = timeoutSeconds });
        
        return MapResult(result);
    }
}

// In ISchemaService (from API & Service Layer spec)
public class SchemaService : ISchemaService
{
    private readonly IMSSQLMCPServer _mcpServer;
    
    public async Task<CaseSchemaResponse> GetCaseSchemaAsync(string caseId)
    {
 // Use MCP to get schema
        var schema = await _mcpServer.ExecuteTool(
      "describe_schema",
   new { databaseOrCase = caseId });
   
    return MapSchema(schema);
    }
}
```

### Agent Integration (from Agents Spec)

Agents call MCP tools directly through protocol:

```
Query Tutor Agent Interaction:

1. Student submits query
2. Query Service calls MCP.ExecuteTool("execute_sql", ...)
3. MCP executes against database
4. Results returned to Query Service
5. Query Service evaluates results
6. Query Tutor Agent gets evaluation via Agent Communication Service
```

---

## 📋 Required Modifications

### Minimal Changes Needed

#### 1. Connection String Configuration

**Current:** Likely hardcoded or config-based  
**Needed:** Support DataQuest connection strings

```csharp
// MSSQLMCPServer.cs - Constructor modification
public MSSQLMCPServer(
    string connectionString,
    ILogger<MSSQLMCPServer>? logger = null,
    int queryTimeoutSeconds = 30)
{
    _connectionString = connectionString 
     ?? throw new ArgumentNullException(nameof(connectionString));
    _logger = logger;
    _queryTimeoutSeconds = queryTimeoutSeconds;
}
```

#### 2. Tool Definitions

**Current:** Likely generic SQL tools  
**Needed:** DataQuest-specific tools

```csharp
// Add tools specific to DataQuest:
- execute_student_query (with validation)
- get_case_schema (case-specific)
- list_available_tables (for current case)
- validate_query_syntax (pre-execution)
```

#### 3. Error Handling

**Current:** Generic SQL errors  
**Needed:** DataQuest error codes

```csharp
// Map to DataQuest error types (from Testing & QA Spec)
- QueryExecutionStatus.SYNTAX_ERROR
- QueryExecutionStatus.CONTEXT_ERROR
- QueryExecutionStatus.TIMEOUT
- QueryExecutionStatus.DB_ERROR
```

#### 4. Timeout Enforcement

**Current:** Configurable timeout
**Needed:** DataQuest-specific (30 seconds from Spec #5)

```csharp
const int DEFAULT_QUERY_TIMEOUT_SECONDS = 30; // Per API spec
```

### Code Changes Summary

```
Files to Modify:
├── MSSQLMCPServer.cs (Add methods, update error handling)
├── Models/SQLExecuteResponse.cs (Add DataQuest response types)
└── mcp-mssql-server.csproj (May need to add dependencies)

Files to Add:
├── DataQuestMCPAdapter.cs (Bridge between DataQuest and MCP)
└── MCPConfiguration.cs (Configuration settings)

Total Changes: ~15-20% of codebase
Effort: ~4-6 hours
```

---

## 🔌 Tool Definitions (MCP Expose These Tools)

### Tool 1: execute_sql

**Purpose:** Execute SQL query against database

```json
{
  "name": "execute_sql",
  "description": "Execute a SQL query against the DataQuest database",
  "inputSchema": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
   "description": "SQL query to execute"
      },
      "timeout_seconds": {
        "type": "integer",
        "description": "Query timeout in seconds (default: 30, max: 30)",
        "default": 30
      }
    },
  "required": ["query"]
  }
}
```

### Tool 2: describe_schema

**Purpose:** Get schema information for case database

```json
{
  "name": "describe_schema",
  "description": "Get schema information for DataQuest case database",
  "inputSchema": {
    "type": "object",
    "properties": {
      "case_id": {
   "type": "string",
        "description": "Case ID to get schema for"
      }
    },
    "required": ["case_id"]
  }
}
```

### Tool 3: list_tables

**Purpose:** List available tables in case database

```json
{
  "name": "list_tables",
  "description": "List all tables available in case database",
  "inputSchema": {
    "type": "object",
 "properties": {
      "case_id": {
        "type": "string",
        "description": "Case ID"
      }
    },
    "required": ["case_id"]
}
}
```

### Tool 4: get_column_info

**Purpose:** Get detailed column information

```json
{
  "name": "get_column_info",
  "description": "Get column information for a specific table",
  "inputSchema": {
    "type": "object",
    "properties": {
      "case_id": { "type": "string" },
      "table_name": { "type": "string" },
      "column_name": { "type": "string" }
    },
  "required": ["case_id", "table_name", "column_name"]
  }
}
```

---

## 📊 Implementation Roadmap

### Phase 1: Setup (1 day)

```
□ Copy mcp-mssql-server-repo to DataQuest_v2/src/DataQuest.MCP
□ Update project references and namespaces
□ Add to DataQuest solution
□ Verify compilation
□ Update project file metadata
```

### Phase 2: Configuration (1 day)

```
□ Create MCPConfiguration class
□ Add to dependency injection
□ Configure connection string
□ Set query timeout defaults
□ Configure logger
```

### Phase 3: Integration (2-3 days)

```
□ Create DataQuestMCPAdapter
□ Integrate with QueryService (from Spec #5)
□ Integrate with SchemaService (from Spec #5)
□ Update tool definitions for DataQuest
□ Add error mapping
```

### Phase 4: Testing (1-2 days)

```
□ Unit tests for MCP adapter
□ Integration tests with services
□ Performance tests (query execution)
□ Error scenario testing
□ Timeout handling verification
```

### Phase 5: Agent Integration (2 days)

```
□ Update Query Tutor agent prompts to call MCP tools
□ Update Database Agent prompts to call MCP tools
□ Test agent → MCP → database flow
□ Verify response handling
□ Error recovery testing
```

**Total Effort:** ~1 week

---

## 🛡️ Safety and Security Considerations

### SQL Injection Prevention

```csharp
// MCP should ONLY accept parameterized queries
// Never allow raw string concatenation

// ✅ GOOD
var command = new SqlCommand(
"SELECT * FROM CodeLog WHERE Status = @status", 
    connection);
command.Parameters.AddWithValue("@status", status);

// ❌ BAD (Don't do this)
var query = $"SELECT * FROM CodeLog WHERE Status = '{status}'";
```

### Query Validation

From Testing & QA Spec (Spec #7), all queries should be validated:

```csharp
// Before MCP executes:
1. Syntax validation (no SQL keywords except SELECT, FROM, WHERE, etc.)
2. Context validation (table/column names exist in schema)
3. Timeout enforcement (30 second limit)
4. Character limit (prevent DOS)
```

### Connection Security

```csharp
// Use secure connection strings (from configuration)
// Connection pooling to reduce overhead
// Transaction isolation levels appropriate
// No logging of sensitive data (passwords, full results)
```

---

## 📈 Performance Considerations

### Query Execution Performance

**Target (from Spec #5):**
- Simple queries: < 200ms
- Complex queries: < 3 seconds
- Acceptable failure: < 2% timeout rate

**MCP Considerations:**
- JSON serialization/deserialization overhead: ~5ms
- Connection pooling: Critical for performance
- Query compilation: Cached where possible

### Optimization Strategies

```csharp
// 1. Connection pooling (built into SqlClient)
"Data Source=server;Initial Catalog=database;Min Pool Size=5;Max Pool Size=20"

// 2. Prepared statements for common queries
private static Dictionary<string, SqlCommand> _preparedQueries = new();

// 3. Result caching for schema queries
private IMemoryCache _schemaCache;

// 4. Async/await for non-blocking execution
public async Task<string> ExecuteQueryAsync(string query, int timeout)
```

---

## 🔄 MCP Integration with Existing Specifications

### How MCP Relates to Other Specs

| Specification | MCP Integration |
|---|---|
| Query Tutor Agent (#1) | Uses MCP to execute queries, get feedback data |
| Database Agent (#2) | Uses MCP to describe schema for student explanations |
| UI/UX (#3) | Not directly - service layer uses MCP behind scenes |
| Case Lifecycle (#4) | Not directly - state management independent |
| API & Services (#5) | **Direct integration** - QueryService and SchemaService use MCP |
| Case Design (#6) | Not directly - case data model independent |
| Testing & QA (#7) | Tests verify MCP meets performance/accuracy targets |
| Prompt Engineering (#8) | Agent prompts instruct agents which MCP tools to call |

### Key Integration: API & Service Layer (Spec #5)

The MCP becomes the database abstraction layer:

```
┌─────────────────────────────────────────┐
│ Service Layer (from Spec #5)      │
├─────────────────────────────────────────┤
│     │
│  QueryService    SchemaService     │
│  CaseService     HintService     │
│  ValidationService  etc.          │
│   ↓              │
├─────────────────────────────────────────┤
│  MCP Server (Query & Schema Tools)      │  ← MCP Layer
├─────────────────────────────────────────┤
│   ↓       │
│     SQL Server   │
└─────────────────────────────────────────┘
```

---

## ✅ Implementation Checklist

### Phase 1: Setup

```
□ Copy repository
□ Update namespace to MCP.DataQuest
□ Add to solution
□ Verify compilation in .NET 9
□ Update documentation
```

### Phase 2: Configuration

```
□ Create MCPConfiguration settings
□ Add to appsettings.json
□ Implement IOptions pattern
□ Add to dependency injection
□ Verify configuration loading
```

### Phase 3: Integration

```
□ Create DataQuestMCPAdapter
□ Implement execute_sql tool
□ Implement describe_schema tool
□ Implement list_tables tool
□ Implement get_column_info tool
□ Update error mapping
```

### Phase 4: Service Integration

```
□ Update QueryService to use MCP
□ Update SchemaService to use MCP
□ Update ValidationService integration
□ Verify service layer tests pass
□ Performance test
```

### Phase 5: Agent Integration

```
□ Update Query Tutor prompts
□ Update Database Agent prompts
□ Test end-to-end flow
□ Verify error handling
□ Test timeout scenarios
```

### Phase 6: Testing

```
□ Unit tests for adapter
□ Integration tests
□ Performance tests
□ Security tests (SQL injection)
□ Error scenario tests
□ Load tests
```

---

## 📚 Files to Copy

From `D:\GitHub-Repos\mcp-mssql-server-repo` to `DataQuest_v2\src\DataQuest.MCP`:

```
✅ Servers/MSSQLMCPServer.cs          (Main implementation)
✅ Models/MCPRequest.cs         (Request model)
✅ Models/ToolDefinition.cs         (Tool definitions)
✅ Models/SQLExecuteResponse.cs    (Response model)
✅ Models/SchemaDescribeResponse.cs        (Schema response)
✅ GlobalUsings.cs              (Global usings)
✅ mcp-mssql-server.csproj             (Project file - rename to DataQuest.MCP.csproj)
✅ .gitignore         (Git ignore rules)

Optional:
⚠️ README.md       (Update with DataQuest context)
⚠️ Tests (if any exist)    (Copy and update)
```

---

## 🎯 Success Criteria

MCP integration is successful when:

✅ **Compilation:** DataQuest solution compiles without errors  
✅ **Configuration:** MCP can be configured via appsettings.json  
✅ **Execution:** Queries execute through MCP → SQL Server successfully  
✅ **Performance:** Query execution meets targets (200ms-3s)  
✅ **Integration:** Services use MCP correctly  
✅ **Agents:** Query Tutor and Database Agents can call MCP tools  
✅ **Testing:** 90%+ test coverage for MCP adapter  
✅ **Security:** SQL injection prevention verified  
✅ **Error Handling:** Errors map to DataQuest error codes  
✅ **Timeouts:** 30-second timeout enforced consistently  

---

## 📞 Next Steps

### Immediate Actions

1. **Decision:** Confirm to proceed with Option 1 (Direct Reuse)
2. **Setup:** Create `src/DataQuest.MCP/` folder in DataQuest solution
3. **Copy:** Copy files from existing MCP repository
4. **Update:** Update namespaces and project references
5. **Integrate:** Follow Phase 1-6 roadmap

### Questions to Clarify

1. Should MCP be a separate class library or integrated?
2. Does existing MCP have any tests we should copy?
3. What connection string format should we use?
4. Should MCP be published as NuGet package?
5. Any existing MCP tools we need to preserve/enhance?

---

## 🎓 Conclusion

The existing MSSQL MCP is **highly reusable** and **directly applicable** to DataQuest. With ~1 week of integration effort, it can serve as the database abstraction layer for all DataQuest services and agents.

**Recommendation:** Proceed with integration using Option 1 (Direct Reuse with project reference).

---

**DESIGN SPECIFICATION COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR MCP INTEGRATION**

