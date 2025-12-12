# DataQuest – Architecture Overview

This document provides a concise, reviewer-friendly overview of how the DataQuest system is structured, how its major components interact, and why the architecture was designed this way.

It is intentionally high-level.
Detailed specifications live elsewhere and are referenced through the SSOT Index.

---

## Architectural Goals

The DataQuest architecture was designed to achieve the following:

- **Safe SQL execution in an AI-assisted environment**
- **Clear separation between deterministic logic and probabilistic AI reasoning**
- **Offline-first, local execution suitable for classroom environments**
- **Pedagogical clarity over technical cleverness**
- **Extensibility without architectural drift**

---

## High-Level System Layers

DataQuest follows a layered, modular architecture with explicit responsibility boundaries.

### 1. Presentation Layer (WinForms UI)

**Purpose:**
Provide a focused learning interface for students.

**Responsibilities:**

- Schema Browser
- SQL Editor
- Results Grid
- Hint and feedback display
- Case progression controls

**Constraints:**

- No direct database access
- No AI logic
- No business rules

The UI only communicates with application services.

---

### 2. Application & Service Layer

**Purpose:**
Act as the orchestration and coordination layer.

**Key components:**

- CaseManager
- AgentOrchestrator
- Query submission pipeline
- Result comparison services
- Validation services

**Responsibilities:**

- Enforce workflow sequencing (Plan → Verify → Tutor)
- Route requests to the correct agent or service
- Maintain application state
- Apply deterministic business rules

This layer contains no direct LLM calls and no raw SQL execution.

---

### 3. AI Agent Layer (Probabilistic Reasoning)

**Purpose:**
Provide reasoning, explanation, and guidance without direct system control.

**Agents:**

- Database Agent – explains schema in plain language
- Case Planner Agent – generates narrative cases and canonical queries
- Query Tutor Agent – provides Socratic guidance
- SQL Enforcer Agent – validates logical integrity (rule-based, not generative)

**Key rule:**

> AI agents never directly access the database.

All data access is mediated by MCP tools.

---

### 4. Model Context Protocol (MCP) Layer

**Purpose:**
Serve as the mandatory security and control boundary between AI and SQL.

**Characteristics:**

- Local C# JSON-RPC service
- Read-only SQL enforcement
- Explicit tool whitelist
- No network exposure

**Exposed tools:**

- `sql.execute_readonly`
- `schema.describe`
- `schema.list_tables`
- `schema.get_column_info`

This layer converts AI intent into safe, verifiable actions.

---

### 5. Data Layer (Microsoft SQL Server)

**Purpose:**
Serve as the single source of truth for all learning data.

**Characteristics:**

- Traditional relational schema
- Separate tables (no JSON exposure to students)
- Hidden tutoring and validation tables
- Deterministic query behavior

The database is never accessed directly by AI or UI components.

---

## Core Data Flow (Plan → Verify → Tutor)

1. **Plan**

   - Case Planner Agent generates a structured CasePlan
   - SQL Enforcer validates solvability before activation
2. **Verify**

   - Student submits SQL
   - Query is validated
   - MCP executes read-only query
   - Results are returned to the application
3. **Tutor**

   - Query Tutor compares student results to canonical results
   - Deterministic comparison logic determines success or failure
   - AI provides Socratic hints when needed

This cycle repeats until the case is solved.

---

## Architectural Safeguards

- All unsafe SQL is blocked before execution
- All AI output is validated before use
- All case logic is pre-validated for solvability
- All probabilistic components are contained and supervised

These safeguards ensure the system remains reliable, explainable, and teachable.

---

## Relationship to Other Documents

This overview is intentionally concise.

For authoritative detail:

- System truth: **SSOT.md**
- Document map: **SSOT-Index.md**
- Agent behavior: **AI-Agent-Workflow.md**
- Build sequence: **Development-Roadmap.md**

---

## Architectural Maturity Statement

This architecture is designed not only to function, but to be **defensible** in an academic or professional review.

Every major decision favors:

- clarity over cleverness
- safety over convenience
- pedagogy over raw automation
