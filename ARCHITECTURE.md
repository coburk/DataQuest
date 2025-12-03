# DataQuest Architecture Overview

**Version:** 1.0  
**Status:** Foundation Document  
**Purpose:** High-level understanding of DataQuest system architecture

---

## System Context

DataQuest is an **AI-assisted SQL learning platform** that transforms SQL education into a gamified, investigative experience. Students solve narrative-driven mysteries by writing SQL queries, with AI agents providing guidance and validation.

### Core Value Proposition

- **For Students:** Learn SQL through engaging detective work, not rote memorization
- **For Instructors:** Automated case generation and validation with minimal overhead
- **For Developers:** Transparent, local AI integration using Model Context Protocol (MCP)

---

## Architecture Layers

```
┌─────────────────────────────────────────────────────┐
│       Presentation Layer    │
│              (WinForms UI - DataQuest.App)           │
└─────────────────────────────────────────────────────┘
               ↑
          ↓
┌─────────────────────────────────────────────────────┐
│          Application Orchestration Layer           │
│  (Pipelines, AgentOrchestrator - DataQuest.Orch.   │
└─────────────────────────────────────────────────────┘
       ↑
         ┌────────────────┼────────────────┐
      ↓    ↓        ↓
    ┌─────────┐    ┌─────────┐ ┌──────────┐
    │ Services│      │  Agents │    │   MCP    │
    │         │      │       │    │  Client  │
    └─────────┘      └─────────┘    └──────────┘
         ↑      ↑     ↓
      └────────────────┼───────────────┘
          ↓
┌─────────────────────────────────────────────────────┐
│           Business Logic & Core Services   │
│  (QueryValidator, CaseManager, HintGenerator, etc.) │
└─────────────────────────────────────────────────────┘
     ↑
   ↓
┌─────────────────────────────────────────────────────┐
│            Data Access Layer (EF Core)             │
│ (DataQuest.Database - DbContext) │
└─────────────────────────────────────────────────────┘
        ↑
       ↓
┌─────────────────────────────────────────────────────┐
│      SQL Server Database (Local)    │
│        (Cases, Persons, Evidence, Logs, etc.)       │
└─────────────────────────────────────────────────────┘
  ↑
  ┌────────────────┴───────────────┐
         ↓   ↓
    ┌────────────┐          ┌──────────────────┐
    │ MCP Server │            │ Ollama (Local    │
    │ (C# svc)   │       │  LLM Runtime)    │
    └────────────┘       └──────────────────┘
```

---

## Key Components

### 1. **DataQuest.Models** (Domain Models)

**Purpose:** Define the core data structures of the application

**Key Classes:**
- `CasePlan` - Complete investigation case
- `StoryStep` - Sequential task within a case
- `Person`, `Location`, `Evidence` - Domain entities
- `QuerySubmissionResult` - Result comparison
- `HintContext` - Data for hint generation

**Responsibility:** Structure and contract for data throughout the system

---

### 2. **DataQuest.Database** (Data Access)

**Purpose:** Persistent storage and retrieval of case data

**Key Components:**
- `DataQuestContext` - EF Core DbContext
- Repositories (IRepository pattern)
- Migrations

**Responsibility:** Database operations, schema management, data persistence

---

### 3. **DataQuest.Services** (Business Logic)

**Purpose:** Implement core workflows and business rules

**Key Services:**
- `QueryValidator` - Safety checks, prevent DML attacks
- `CaseManager` - Load and manage cases
- `JsonCaseImportService` - Load cases from JSON
- `QueryComparator` - Compare student vs. canonical results
- `HintGenerator` - Generate Socratic hints

**Responsibility:** Application logic, data processing, workflow coordination

---

### 4. **DataQuest.Orchestration** (Pipelines)

**Purpose:** Implement the three core pipelines

**Key Pipelines:**
- **Case Loading Pipeline** - JSON → Deserialization → Validation → Ready State
- **Query Submission Pipeline** - Safety → Dual Execution → Comparison → Feedback
- **Hint Generation Pipeline** - Level tracking → Context aggregation → LLM inference → Delivery

**Responsibility:** Workflow orchestration, step sequencing, state management

---

### 5. **DataQuest.MCP** (Model Context Protocol)

**Purpose:** Secure bridge between AI agents and database

**Components:**
- **MCP Server** (C# service process)
  - Exposes `schema.describe` tool
  - Exposes `sql.execute_readonly` tool
  - Uses JSON-RPC 2.0 protocol
  - Blocks unsafe commands

- **MCP Client** (in main app)
  - Sends JSON-RPC requests from agents
  - Receives results
  - Manages server lifecycle

**Responsibility:** Agent-database communication, query safety enforcement

---

### 6. **DataQuest.Agents** (AI Agents)

**Purpose:** Specialized AI agents for different roles

**Four Agents:**

1. **DatabaseAgent**
   - Calls `schema.describe` via MCP
   - Translates schema to natural language
   - Caches descriptions for reuse

2. **CasePlannerAgent**
   - Generates `CasePlan` JSON structures
   - Creates solvable, logical cases
   - Tests queries via `sql.execute_readonly`

3. **QueryTutorAgent**
   - Compares student query to canonical
   - Generates multi-level Socratic hints
   - Tracks hint level per step

4. **SQLEnforcerAgent**
   - Validates case logic
   - Checks for contradictions
   - Verifies `IsSolvable` flag

**Responsibility:** AI-powered reasoning and feedback

---

### 7. **DataQuest.App** (Presentation)

**Purpose:** User interface for students and instructors

**Components:**
- SQL Editor (input)
- Results Grid (output)
- Schema Browser (reference)
- Case Navigator (tracking)
- Hint Panel (feedback)

**Responsibility:** User interaction, UI management, result display

---

## Data Flow: Query Submission Pipeline

```
Student Input (SQL Query)
         ↓
[QueryValidator]
- Check for unsafe commands
- Verify table access
         ↓
[MCP Client]
- Send student query to MCP Server
- Send canonical query to MCP Server
- Get results from database
         ↓
[QueryComparator]
- Compare row counts
- Compare columns
- Compare data content
         ↓
     Match?
    /      \
  YES      NO
   ↓   ↓
Success   [HintGenerator]
         - Aggregate context
         - Generate Socratic hint
         - Display to student
  ↓
      Request Hint?
       /     \
     YES NO
      ↓          ↓
  More Hints  [Retry Query]
```

---

## Technology Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **UI** | WinForms (.NET 9) | Desktop application |
| **Backend** | C# (.NET 9) | Core logic, services |
| **Database** | SQL Server (LocalDB) | Case data persistence |
| **ORM** | Entity Framework Core | Data access abstraction |
| **AI** | Ollama (Local LLM) | Local AI inference |
| **AI Protocol** | Model Context Protocol | Agent-DB communication |
| **Testing** | xUnit, Moq | Unit and integration tests |
| **Logging** | Serilog | Application logging |
| **Config** | appsettings.json | Configuration management |

---

## Key Design Decisions

### 1. **Local Deployment**
- All components run locally (no cloud)
- SQL Server LocalDB for development
- Ollama for local LLM
- Better privacy and control

### 2. **Model Context Protocol (MCP)**
- Secure, read-only database access
- Transparent agent-database communication
- Prevents data corruption
- Clear contract between components

### 3. **Pipeline-Driven Architecture**
- Three well-defined pipelines
- Sequential, reproducible workflows
- Clear entry/exit points
- Easy to test and debug

### 4. **Multi-Agent System**
- Specialized agents for specific roles
- Parallel potential for future scaling
- Clear separation of concerns
- Replaceable components

### 5. **JSON-Based Case Definition**
- Platform-independent format
- Easy to version and share
- Can be generated by Case Planner
- Validated by SQL Enforcer

---

## Deployment Architecture

```
┌──────────────────────────────────────────────────┐
│            Student's Machine (Windows)           │
├──────────────────────────────────────────────────┤
│        │
│  ┌────────────────────────────────────────────┐  │
│  │     DataQuest.App (WinForms)       │  │
│  │  - SQL Editor     │  │
││  - Results Grid        │  │
│  │  - Case Navigator    │  │
│  └────────────────────────────────────────────┘  │
│ ↑  ↑         │
│           │    └──────────────┐       │
│  ┌────────┴────────┐      ┌───────────┐ │  │
│  │ MCP Client │      │ Services  │ │        │
│  │ Agent Interface │ │ Manager   │ │   │
│  └─────┬──────┬────┘      └──────┬────┘ │  │
│        │      │           │      │        │
│  ┌─────┴──────┴─────────────────┴──┐   │        │
│  │ DataQuestContext (EF Core)       │   │        │
│  │ Database Access Layer    │   │        │
│  └──────────────┬────────────────────┘   │     │
│           │        │        │
│  ┌──────────────┴──────────────────────┐ │   │
│  │ SQL Server LocalDB        │ │        │
│  │ - Cases Table          │ │        │
│  │ - Persons Table     │ │     │
│  │ - Evidence Table  │ │        │
│  │ - etc.         │ │        │
│  └─────────────────────────────────────┘ │        │
│            │     │
│  ┌─────────────────────────────────────┐ │        │
│  │ MCP Server (Subprocess)       │ │        │
│  │ - schema.describe tool              │─┤        │
│  │ - sql.execute_readonly tool         │  │
│  │ - JSON-RPC handler      │          │
│  └─────────────────────────────────────┘    │
│    ↑           │
│          │ stdio    │
│  ┌───────┴──────────────────────────┐         │
│  │ Ollama (Local LLM Runtime)        │             │
│  │ - Port 11434         │             │
│  │ - Model: llama3:8b-instruct  │             │
│  │ - Agent Inference           │             │
│  └───────────────────────────────────┘│
│               │
└──────────────────────────────────────────────────┘
```

---

## Performance Considerations

| Operation | Target | Strategy |
|-----------|--------|----------|
| **Query Execution** | < 2 seconds | Indexed queries, read-only |
| **Hint Generation** | < 5 seconds | Local LLM, cached schema |
| **Case Loading** | < 1 second | JSON deserialization |
| **Schema Description** | Cached | DatabaseAgent caches descriptions |
| **MCP Communication** | < 500ms | Stdio protocol, local |

---

## Security Considerations

### Query Safety
- No DML commands (INSERT, UPDATE, DELETE, DROP)
- Table whitelist validation
- Read-only MCP tool

### Data Protection
- Local SQL Server (encrypted connection strings)
- No network transmission by default
- Student data stays on machine

### AI Safety
- Local Ollama (no data to cloud services)
- Sandboxed agent execution
- Explicit tool access only

---

## Future Extensibility

### Planned Enhancements
- [ ] Web UI (ASP.NET Core)
- [ ] Cloud deployment option
- [ ] Additional investigative themes
- [ ] Performance analytics
- [ ] Instructor dashboard
- [ ] Community case library

### Architecture Supports
- Plugin system for new agents
- Custom pipeline implementations
- Alternative UI frameworks
- Different database backends
- Multi-user scenarios

---

## Development Phases

See `docs/design-and-planning/` for detailed phase breakdown:

1. **Phase 1:** Domain Models
2. **Phase 2:** Database Layer
3. **Phase 3:** MCP Integration
4. **Phase 4:** Pipeline Services
5. **Phase 5:** AI Agents
6. **Phase 6:** UI Layer
7. **Phase 7:** Configuration & Testing

---

## References

- [Project Goals and Scope](docs/design-and-planning/Project%20Goals%20and%20Scope%20-%20DataQuest%20SQL%20Detective.md)
- [Core Domain Models](docs/design-and-planning/Core%20Domain%20Models.md)
- [Data Dictionary](docs/design-and-planning/Data%20Dictionary%20-%20DataQuest.md)
- [Pipelines](docs/design-and-planning/) (all pipeline documents)
- [MCP Integration](docs/design-and-planning/MCP%20Integration%20Possibilities.md)
- [Naming Conventions](docs/design-and-planning/Naming%20Conventions%20Guide%20-%20DataQuest.md)

---

**Document Version:** 1.0  
**Last Updated:** December 2025  
**Next Review:** January 2026
