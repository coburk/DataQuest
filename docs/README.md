# DataQuest Documentation

Welcome to the DataQuest documentation! This folder contains all design specifications, research, diagrams, and reference materials for the DataQuest: SQL Detective project.

## Quick Navigation

### 📋 Design & Planning
All architectural, design, and planning documents. **Start here to understand the project.**

- **[Project Goals and Scope](design-and-planning/Project%20Goals%20and%20Scope%20-%20DataQuest%20SQL%20Detective.md)** - Project vision and scope
- **[Core Domain Models](design-and-planning/Core%20Domain%20Models.md)** - Data structures and entities
- **[Data Dictionary](design-and-planning/Data%20Dictionary%20-%20DataQuest.md)** - Database schema definitions
- **[Naming Conventions Guide](design-and-planning/Naming%20Conventions%20Guide%20-%20DataQuest.md)** - Coding and naming standards

### 🔄 Pipelines (Core Workflows)

- **[Query Submission Pipeline](design-and-planning/Pipeline%20-%20Query%20Submission%20-%20The%20Verification%20Stage.md)** - How student queries are validated and compared
- **[Case Loading Pipeline](design-and-planning/Pipeline%20-%20Case%20Loading%20-%20From%20JSON%20to%20Ready%20State.md)** - Loading cases from JSON files
- **[Hint Generation Pipeline](design-and-planning/Pipeline%20-%20Hint%20Generation.md)** - Multi-level Socratic hint generation

### 🏗️ Architecture & Integration

- **[High-Level Concept](design-and-planning/Draft%20High-Level%20Concept.md)** - System overview
- **[MCP Integration](design-and-planning/MCP%20Integration%20Possibilities.md)** - Model Context Protocol design
- **[JSON Case Schema](design-and-planning/Draft%20JSON%20case%20schema.md)** - Case structure specification
- **[JSON Import Service](design-and-planning/JSON%20Case%20Import%20Service.md)** - Case loading implementation
- **[Configuration Files](design-and-planning/Configuration%20Files%20for%20DataQuest.md)** - Application configuration

### 🧪 Implementation & Quality

- **[Testing Strategy](design-and-planning/Testing%20Strategy%20for%20DataQuest.md)** - Comprehensive testing approach
- **[Application Structure](design-and-planning/Application%20Structure%20-%20DataQuest.md)** - Project organization
- **[Case Lifecycle](design-and-planning/Case%20Lifecycle.md)** - Case state management
- **[Logging & Telemetry](design-and-planning/Logging%20and%20Telemetry%20Skeleton.md)** - Observability

### 🎨 Diagrams & Visual References

```
diagrams/
├── DataQuest_System_Context_Diagram.png
├── DataQuest_High_Level_Architecture.png
├── DataQuest_High_Level_ERD.png
├── DataQuest Case Lifecycle Diagram.png
├── AI Agent Workflow v3.png
└── DataQuest Diagrams.vsdx (Visio source)
```

### 🔬 Research & Reference

```
research/
├── Similar SQL Educational Systems.md
├── SQL Pedagogical Patterns.md
├── MCP Integration Possibilities.md
├── Detective or Investigative Learning Games.md
└── Future Expansion and Stretch Goals.md
```

### 🎯 User Experience

```
ui-mockups/
├── UI Mockup - Student Interface.png
├── UI Mockup - Instructor Interface.png
├── UI Mockup - Schema and Case Browser.png
├── UI Mockup - Admin and AI Agent Monitor.png
├── UI Interfaces.docx
└── UI Style Guides.docx
```

### 📝 Proposal & History

```
proposal/
└── Burk_DataQuest_Capstone_Proposal_v5.docx
```

### 🎨 Visual Assets

```
artifacts/
├── ai-agent-icons/  (AI agent visual representations)
└── workflows/       (Workflow diagrams and assets)
```

---

## How to Use These Documents

### For New Contributors
1. Start with **[Project Goals and Scope](design-and-planning/Project%20Goals%20and%20Scope%20-%20DataQuest%20SQL%20Detective.md)**
2. Read **[Core Domain Models](design-and-planning/Core%20Domain%20Models.md)**
3. Review **[Naming Conventions Guide](design-and-planning/Naming%20Conventions%20Guide%20-%20DataQuest.md)**
4. Check the **[diagrams](diagrams/)** for visual understanding

### For Implementation Work
1. Check the relevant **pipeline document** for your feature
2. Review **[Data Dictionary](design-and-planning/Data%20Dictionary%20-%20DataQuest.md)** for database structure
3. Reference **[Application Structure](design-and-planning/Application%20Structure%20-%20DataQuest.md)** for project layout
4. See **[Testing Strategy](design-and-planning/Testing%20Strategy%20for%20DataQuest.md)** for test requirements

### For Architecture Questions
1. Review **[High-Level Concept](design-and-planning/Draft%20High-Level%20Concept.md)**
2. Check **[MCP Integration](design-and-planning/MCP%20Integration%20Possibilities.md)** for AI communication
3. See **[diagrams](diagrams/)** for visual architecture

### For Configuration & Deployment
1. Review **[Configuration Files](design-and-planning/Configuration%20Files%20for%20DataQuest.md)**
2. Check root-level `config/` folder for templates
3. See `SETUP.md` for local development setup

---

## Document Relationships

```
Project Goals & Scope
    ↓
Core Domain Models
    ↓
Data Dictionary
    ↓
├─→ Database Design
├─→ Application Structure
└─→ Pipelines
    ├─→ Query Submission
    ├─→ Case Loading
    └─→ Hint Generation
    ↓
MCP Integration
    ↓
Agents & Configuration
    ↓
Testing Strategy
```

---

## Standards & Conventions

All documents in this folder follow:
- **Naming:** [Naming Conventions Guide](design-and-planning/Naming%20Conventions%20Guide%20-%20DataQuest.md)
- **Formatting:** Markdown with clear headers and structure
- **Language:** Technical but accessible to the target audience
- **Version Control:** Documented in git with clear commit messages

---

## Contributing to Documentation

To contribute or update documentation:

1. Follow the **[Naming Conventions](design-and-planning/Naming%20Conventions%20Guide%20-%20DataQuest.md)**
2. Use **Markdown** format (`.md` files)
3. Use **Title Case** for document filenames
4. Add **version** and **last updated** dates
5. Update this README if adding new sections
6. See `CONTRIBUTING.md` at repository root

---

## Quick Links

- **Repository:** https://github.com/coburk/DataQuest
- **Setup Guide:** `SETUP.md` (at root)
- **Architecture Overview:** `ARCHITECTURE.md` (at root)
- **Contributing Guide:** `CONTRIBUTING.md` (at root)

---

**Last Updated:** December 2025  
**Version:** 1.0
