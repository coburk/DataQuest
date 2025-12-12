# DataQuest: SQL Detective

### A story-driven SQL investigation tool for learning through insight, reasoning, and discovery.

DataQuest transforms SQL learning into an interactive investigative experience. Students take on the role of an investigator and use SQL to collect clues, check timelines, resolve contradictions, and interpret evidence. The goal is to help learners build real reasoning skills rather than memorize commands.

A coordinated group of AI agents supports the process. These agents plan each case, validate logic, offer guidance, and explain how the data fits together. The result is a simple and engaging system where students learn through insight, reasoning, and discovery.

---

## Quick Links

- **Getting Started:** See [00 Start Here.md](00%20Start%20Here.md)
- **Setup Guide:** See [Setup.md](Setup.md) for local development setup
- **Architecture:** See [Architecture.md](Architecture.md) for system design
- **Contributing:** See [Contributing.md](Contributing.md) for guidelines
- **Project Structure:** See [Project Structure Visual.md](Project%20Structure%20Visual.md) for directory layout
- **Design Docs:** See [docs/README.md](docs/README.md) for all documentation
- **📋 OFFICIAL ROADMAP:** See [docs/design-and-planning/Development Roadmap - DataQuest.md](docs/design-and-planning/Development%20Roadmap%20-%20DataQuest.md) **← START HERE FOR DEVELOPMENT**

---

## Project Status

### ✅ Completed
- Project structure and directory organization
- Naming conventions established and documented
- Design and planning documentation
- Architecture specification
- Testing strategy
- Configuration templates

### 🔄 In Progress
- Phase 1: Domain Models (Starting Soon)

### 📋 Planned
- Phase 2: Database Layer
- Phase 3: MCP Integration
- Phase 4: Pipeline Services
- Phase 5: AI Agents
- Phase 6: UI Layer
- Phase 7: Testing & Deployment

---

## Features

### Story-driven SQL Cases

Students solve cases built from people, evidence, locations, timelines, and witness statements.

### AI-Supported Learning

A set of small, focused AI agents work together through the MCP to help guide the investigation.

### Gentle Socratic Hints

The Query Tutor Agent asks guiding questions instead of giving away the answer.

### Safe and Transparent Architecture

The MCP provides controlled, read-only database access so students learn with real data without risk.

### Clear and Approachable UI

Simple interfaces for students, instructors, and administrators keep the focus on learning.

---

## AI Agents

DataQuest uses four specialized agents, each with a specific role.

- **Database Agent**
  - Converts schema and table structures into natural language explanations
  - Caches schema descriptions for reuse

- **Case Planner Agent**
  - Designs case structure and keeps the narrative consistent
  - Tests queries to ensure cases are solvable

- **Query Tutor Agent**
  - Compares student queries against canonical answers
  - Provides multi-level Socratic hints
  - Tracks hint level per investigation step

- **SQL Enforcer Agent**
  - Validates case logic and consistency
  - Checks for contradictions in evidence
  - Verifies cases are truly solvable

---

## How It Works

Every investigation follows two simple cycles.

### System Cycle: Plan → Verify → Tutor

- The Case Planner sets the structure
- The SQL Enforcer checks claims
- The Query Tutor provides guidance

### Student Cycle: Insight → Reasoning → Discovery

- Students collect clues
- Test hypotheses with SQL
- Resolve contradictions
- Reach their own conclusions

These cycles create a learning environment that feels natural and investigative.

---

## Technology Stack

DataQuest uses tools that are easy to set up, transparent, and accessible.

- **Language & Framework:** C# (.NET 9, WinForms)
- **Database:** SQL Server (LocalDB for development)
- **AI Runtime:** Ollama (Local LLM - Llama 3.1 8B or Mistral 7B)
- **Communication:** Model Context Protocol (MCP) with JSON-RPC 2.0
- **Development:** Visual Studio 2022, GitHub Copilot
- **Testing & Logging:** xUnit, Moq, Serilog
- **ORM:** Entity Framework Core 9.0

---

## Current Directory Structure

```
DataQuest/
├── .github/workflows/  # CI/CD pipelines (ready for setup)
├── config/         # Configuration templates
│   ├── appsettings.json
│   ├── agent-endpoints.json
│   └── user-preferences.json
├── docs/       # Documentation (flattened structure)
│   ├── design-and-planning/    # Design specifications
│   ├── diagrams/        # Architecture diagrams
│   ├── research/    # Research materials
│   ├── proposal/        # Capstone proposal
│   ├── ui-mockups/          # UI mockups
│   ├── artifacts/          # Visual assets
│   ├── process-documentation/  # Restructuring documentation
│   └── README.md      # Documentation index
├── sql/      # Database scripts
│   ├── create_dataquest_db.sql
│   ├── seed_data.sql
│   └── migrations/
├── src/    # Production source code
│   ├── DataQuest.Models/
│   ├── DataQuest.Database/
│   ├── DataQuest.Services/
│   ├── DataQuest.Orchestration/
│   ├── DataQuest.Mcp/
│   ├── DataQuest.Agents/
│   └── DataQuest.App/
├── tests/                  # Test projects
│   ├── DataQuest.Tests.Unit/
│   ├── DataQuest.Tests.Integration/
│└── DataQuest.Tests.Data/
│       ├── case-plans/
│       ├── llm-prompts/
│       ├── data-seed/
│       ├── schemas/
│       └── sql-examples/
├── tools/             # Utility scripts
│
├── 00 Start Here.md       # Entry point - READ FIRST
├── Architecture.md         # System architecture
├── Setup.md      # Development setup guide
├── Contributing.md        # Contribution guidelines
├── Project Structure Visual.md  # Detailed structure reference
│
├── .editorconfig    # Code style rules
├── global.json      # .NET 9 SDK version
├── Directory.Build.props  # Shared build settings
└── DataQuest.sln          # Solution file (to be created)
```

---

## Getting Started

### Prerequisites

- .NET 9 SDK (download from [dotnet.microsoft.com](https://dotnet.microsoft.com/download))
- Visual Studio 2022 (Community Edition minimum)
- SQL Server (LocalDB or full installation)
- Ollama (download from [ollama.com](https://ollama.com))

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/coburk/DataQuest.git
   cd DataQuest
   ```

2. **Follow Setup.md**
   ```bash
   See Setup.md for detailed development environment setup
   ```

3. **Configure Ollama**
   ```bash
   ollama pull llama3:8b-instruct
   ollama serve
   ```

4. **Review Documentation**
   - Start: `00 Start Here.md`
   - Architecture: `Architecture.md`
   - Naming Standards: `docs/design-and-planning/Naming Conventions Guide - DataQuest.md`

### Quick Links for Developers

- **Starting Development?** → See `00 Start Here.md`
- **Setting up environment?** → See `Setup.md`
- **Understand the architecture?** → See `Architecture.md`
- **Contributing code?** → See `Contributing.md`
- **Naming conventions?** → See `docs/design-and-planning/Naming Conventions Guide - DataQuest.md`
- **Need design specs?** → See `docs/design-and-planning/`

---

## Usage

1. Select a case from the case browser
2. Review the evidence, people, locations, and timelines
3. Write SQL queries to test your hypotheses
4. Use the Query Tutor Agent when you need guidance
5. Follow the steps in the case until you reach a conclusion
6. Review your reasoning and compare it with the answer key

---

## Development Roadmap

### 10-Week MVP Timeline

DataQuest follows a **10-week Minimum Viable Product (MVP)** timeline aligned with the capstone requirements. This roadmap delivers core functionality within this timeframe for a local, offline-capable SQL investigation system.

**MVP Scope:**
- Local, offline-capable system with SQL Server and Ollama
- Four specialized AI agents for case generation, validation, and tutoring
- Student investigative experience and UI
- One complete case narrative from start to finish

**Out of Scope (Future Expansion):**
- Instructor/Admin case creation interfaces (deferred to future phases)
- Cloud deployment and web hosting
- CI/CD pipeline automation
- Performance metrics and academic evaluation
- Additional investigative themes beyond SQL

---

### Phase 1: Domain Models (US-Data)
**Objective:** Establish the foundational data structures

- Implement investigative data models (Person, Location, Evidence, Communication)
- Implement agent control models (CasePlan, StoryStep, AnswerKey)
- Implement workflow models (QuerySubmissionResult, HintContext, MCPRequest)
- Create strongly-typed C# POCOs for type safety
- Create data transfer objects

**Success Criteria:** All models compile, type-safe, ready for database and agent integration

---

### Phase 2: Data Infrastructure (US-01, US-02, US-03)
**Objective:** Establish secure local database access

**Components:**
- Entity Framework Core setup and DbContext configuration
- Database entities and schema creation
- **MCP Server implementation** (C# service process)
  - Expose `schema.describe` tool
  - Expose `sql.execute_readonly` tool
  - JSON-RPC 2.0 protocol implementation
- SQLConnector for application database operations
- Safety validation for read-only enforcement

**User Stories:**
- US-01: Local environment setup
- US-02: Secure database access via MCP
- US-03: Student query execution with safety

**Success Criteria:** Database initializes, MCP Server responds to tool calls, queries execute safely

---

### Phase 3: MCP Client Integration (US-02, US-03)
**Objective:** Connect application to MCP Server

**Components:**
- MCPClient for AI-to-MCP communication
- JSON-RPC 2.0 message handling
- Tool invocation and response processing
- Error handling and retry logic

**User Stories:**
- US-02: MCP client for database queries
- US-03: Integration with query execution

**Success Criteria:** Application can call MCP tools, receives correct responses, handles errors gracefully

---

### Phase 4: Pipeline Services & Orchestration (US-03, US-05, US-06, US-07)
**Objective:** Implement core workflows and orchestration

**Components:**
- **QueryValidator service** - Safety checks, prevent unsafe SQL
- **CaseManager service** - Load, store, and manage cases
- **HintGenerator service** - Multi-level Socratic hint generation
- **AgentOrchestrator** - Traffic controller managing agent calls and sequencing
- **Three Core Pipelines:**
  - Query Submission Pipeline (student query → validation → execution → comparison)
  - Case Loading Pipeline (JSON → deserialization → validation → ready state)
  - Hint Generation Pipeline (context aggregation → LLM inference → delivery)

**User Stories:**
- US-03: Query validation and execution
- US-05: Query comparison against canonical answers
- US-06: Hint generation and delivery
- US-07: Case loading and management

**Success Criteria:** Pipelines execute end-to-end, cases load correctly, hints generate appropriately

---

### Phase 5: AI Agents (US-04, US-05, US-06, US-07, US-08)
**Objective:** Implement four specialized AI agents

**Agents:**
- **Database Agent** (US-04)
  - Translates schema to natural language
  - Caches descriptions for reuse
  
- **Case Planner Agent** (US-07)
  - Generates solvable investigative cases
  - Tests queries to ensure correctness
  - Creates case structure and narrative
  
- **Query Tutor Agent** (US-05, US-06)
  - Compares student queries to canonical answers
  - Provides multi-level Socratic hints
  - Tracks hint progression
  
- **SQL Enforcer Agent** (US-08)
  - Validates case logic and consistency
  - Checks for contradictions
  - Verifies solvability

**Integration:**
- OllamaInterface for LLM communication
- MCPClient for database access
- AgentOrchestrator for sequencing

**Success Criteria:** All four agents functioning, Ollama integration working, agents respond to orchestrator calls

---

### Phase 6: Student Interface (US-09)
**Objective:** Deliver complete student investigative experience

**Components:**
- WinForms application
- SQL Editor for query entry
- Results Grid for output display
- Schema Browser for reference data
- Hint Panel for Socratic guidance
- Case Navigator for step tracking
- Log Panel for system information

**User Story:**
- US-09: Guide student through complete investigative case

**Note:** Instructor/Admin interfaces are deferred to future expansion phases

**Success Criteria:** Student can complete one full case from start to finish, all UI elements responsive

---

### Phase 7: Integration Testing & Documentation (Testing Throughout)
**Objective:** Verify system functionality and document knowledge

**Components:**
- Unit tests for models, services, agents
- Integration tests for pipelines
- End-to-end tests for complete case scenarios
- Documentation of architecture, APIs, and processes
- Knowledge transfer and developer guides

**Note:** Testing occurs throughout all phases (not just at the end). This phase focuses on comprehensive verification and final polish.

**Success Criteria:** Test coverage meets standards, all documented, system stable and ready for demonstration

---

### Future Expansion (Beyond 10-Week MVP)

**Phase 8: Instructor & Admin Interfaces**
- Case creation and modification tools
- Student progress tracking and analytics
- Grade management

**Phase 9: Cloud Deployment & CI/CD**
- Docker containerization
- GitHub Actions pipelines
- Cloud hosting options
- Automated testing and deployment

**Phase 10: Advanced Features**
- Conversational tutor mode
- Agent collaboration visualization
- Additional investigative themes
- Performance optimization
