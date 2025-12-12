Below is the **Master Index** version of the SSOT. This organizes the specific filenames by their functional domain, allowing you to locate the exact technical contract for any specific task.

---

# DataQuest Master SSOT Index

**Project Status:** Phase 1 Ready (All 8 Core Specs + 5 Infrastructure Specs Complete),.
**Codebase Strategy:** Traditional Separate Tables (No JSON in Schema).

---

## 1. Core Architecture & Backend

*Use these files when defining system structure, API endpoints, or service layers.*

| Component                     | Critical Design Document                   | Description                                                                       |
| :---------------------------- | :----------------------------------------- | :-------------------------------------------------------------------------------- |
| **System Architecture** | `Application Structure - DataQuest.md`   | High-level modular layering (Presentation, Logic, Data).                          |
| **API Endpoints**       | `API-Specification.md`                   | **The Contract:**Endpoint definitions, request/response schemas, and error codes. |
| **Service Layer**       | `API-and-Service-Layer-Architecture.md`  | Internal service interfaces (QueryService, ValidationService).                    |
| **MCP Integration**     | `MCP-Integration-Design.md`              | Design for the secure SQL bridge (Middleware).                                    |
| **State Machine**       | `Case-Lifecycle-and-State-Management.md` | Rules for case progression and state transitions.                                 |

## 2. Database & Data Model

*Use these files when modifying the schema, writing migrations, or creating seed data.*

| Component                 | Critical Design Document                             | Description                                                                |
| :------------------------ | :--------------------------------------------------- | :------------------------------------------------------------------------- |
| **Schema Strategy** | `Database-Schema-And-Migrations-Strategy.md`       | **Definitive Schema:**Table definitions, indexing, and the "No JSON" rule. |
| **Data Dictionary** | `Data Dictionary - DataQuest.md`                   | Detailed definitions of columns, keys, and business rules.                 |
| **Design Decision** | `Database-Design-Decision-Traditional-Approach.md` | Context on why we chose separate tables over JSON.                         |
| **Security**        | `Database-Security-And-Data-Protection.md`         | Strategy for hiding AnswerKeys and preventing shortcuts.                   |

## 3. AI Agents & Logic

*Use these files when tuning prompts, adjusting agent behavior, or debugging logic.*

| Component                    | Critical Design Document                              | Description                                                                      |
| :--------------------------- | :---------------------------------------------------- | :------------------------------------------------------------------------------- |
| **Prompt Engineering** | `Agent-Prompt-Engineering-Standards.md`             | **The Brains:**System prompts, few-shot examples, and guardrails for all agents. |
| **Query Tutor**        | `Query-Tutor-Agent-Implementation-Specification.md` | Logic for the Socratic method and hint escalation levels.                        |
| **Database Agent**     | `Database-Agent-Implementation-Specification.md`    | Logic for explaining schema to students in natural language.                     |
| **Logic & Planning**   | `Implementing Schema Validation.md`                 | How the SQL Enforcer validates case logic and prevents broken states.            |

## 4. Content & Case Design

*Use these files when writing new cases or defining the narrative structure.*

| Component                 | Critical Design Document                               | Description                                                                      |
| :------------------------ | :----------------------------------------------------- | :------------------------------------------------------------------------------- |
| **Case Templates**  | `Case-Design-Template-and-Examples.md`               | **The Content Guide:**JSON structure and narrative templates for creating cases. |
| **Tier Guidelines** | `DataQuest-Tier-System-Official-Design-Guideline.md` | Rules for what SQL concepts belong in which difficulty tier.                     |
| **Example Cases**   | `Case-Design-Examples-Downtown-SLC-CS-University.md` | Complete narrative examples for Tiers 1–5.                                      |

## 5. UI/UX & Frontend

*Use these files when building WinForms components or designing screens.*

| Component               | Critical Design Document                    | Description                                                                   |
| :---------------------- | :------------------------------------------ | :---------------------------------------------------------------------------- |
| **Screen Design** | `UI-UX-Design-Specification.md`           | **The Visuals:**Layouts for the Schema Browser, SQL Editor, and Results Grid. |
| **Design System** | `Naming Conventions Guide - DataQuest.md` | Standards for naming files, variables, and UI elements.                       |

## 6. Infrastructure, DevOps & Security

*Use these files when deploying, configuring, or securing the application.*

| Component            | Critical Design Document                         | Description                                                  |
| :------------------- | :----------------------------------------------- | :----------------------------------------------------------- |
| **Deployment** | `Deployment-and-Environment-Configuration.md`  | Docker setups, environment variables, and startup sequences. |
| **Security**   | `Authentication-and-Authorization-Strategy.md` | JWT implementation, RBAC, and secrets management.            |
| **CI/CD**      | `CI-CD-Pipeline-Configuration.md`              | GitHub Actions workflows for automated build and test.       |
| **Logging**    | `Logging-and-Observability-Strategy.md`        | Telemetry standards, log levels, and monitoring dashboards.  |

## 7. Quality Assurance (QA)

*Use these files when writing tests or verifying features.*

| Component                  | Critical Design Document                    | Description                                                     |
| :------------------------- | :------------------------------------------ | :-------------------------------------------------------------- |
| **Testing Strategy** | `Testing-and-QA-Implementation-Guide.md`  | **The Test Plan:**Unit, integration, and E2E test requirements. |
| **Performance**      | `Performance-And-Scalability-Strategy.md` | Metrics for query execution times and API latency targets.      |

---

### How to Execute a Task Using This Index

**Example: "I need to fix a bug where the Hint System isn't giving the right clue."**

1. **Logic:** Check `Query-Tutor-Agent-Implementation-Specification.md` to understand how hints are selected.
2. **Prompts:** Check `Agent-Prompt-Engineering-Standards.md` to see the actual text sent to the LLM.
3. **Data:** Check `Case-Design-Template-and-Examples.md` to ensure the `AnswerKey` JSON is structured correctly.

**Example: "I need to add a new table for a specific case."**

1. **Schema:** Update `Database-Schema-And-Migrations-Strategy.md`.
2. **Definitions:** Update `Data Dictionary - DataQuest.md`.
3. **Explanation:** Update `Database-Agent-Implementation-Specification.md` so the AI knows how to explain the new table.
