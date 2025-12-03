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

### Phase 1: Domain Models (STARTING)
- Implement domain model classes
- Create data transfer objects
- Set up type safety and contracts

### Phase 2: Database Layer (PLANNED)
- Entity Framework Core setup
- Database context and entities
- Repository pattern implementation

### Phase 3: MCP Integration (PLANNED)
- MCP Server implementation
- MCP Client in main application
- Tool exposure and safety

### Phase 4: Pipeline Services (PLANNED)
- Query validation service
- Case manager
- Hint generator

### Phase 5: AI Agents (PLANNED)
- Implement four specialized agents
- Agent orchestration
- LLM integration with Ollama

### Phase 6: UI Layer (PLANNED)
- WinForms application
- Student interface
- Instructor/Admin interfaces

### Phase 7: Testing & Deployment (PLANNED)
- Comprehensive test suites
- CI/CD pipelines
- Deployment automation

---

## Project Standards

- **Naming:** Title Case for files and directories (see `Naming Conventions Guide`)
- **Code Style:** C# conventions defined in `.editorconfig`
- **Framework:** .NET 9 (specified in `global.json`)
- **Testing:** xUnit and Moq
- **Logging:** Serilog
- **Documentation:** Markdown in `docs/` folder

---

## Contributing

We welcome contributions! Please follow these steps:

1. Read `Contributing.md` for guidelines
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Follow the naming conventions in `Naming Conventions Guide`
4. Add tests for new functionality
5. Submit a pull request with clear description

For major changes, please open an issue first to discuss the proposed changes.

---

## License

MIT License - See LICENSE file for details

---

## Acknowledgments

This project is part of a Master of Applied Artificial Intelligence capstone.

Thank you to:
- Faculty advisors for guidance and feedback
- The open-source community for tools and libraries
- Contributors and collaborators

---

## Contact & Support

- **Issues & Bugs:** Open a GitHub issue
- **Discussions:** Use GitHub Discussions
- **Documentation:** See `docs/` folder and root-level documentation files

---

**Last Updated:** December 2025  
**Status:** Project initialization and planning complete - Ready for Phase 1 development
