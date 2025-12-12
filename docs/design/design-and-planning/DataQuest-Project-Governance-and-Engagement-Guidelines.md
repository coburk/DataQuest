
# **DataQuest: Project Governance & AI Engagement Guidelines**

**Version:** 1.0

**Status:** Official Project Guideline

**Last Updated:** December 6, 2025

**Applies To:** All future development, writing, design, and architectural discussions related to DataQuest

---

## **1. Purpose of This Document**

This guideline defines the **official workflow** for collaborating with AI tools (ChatGPT, Claude, GitHub Copilot) during the development of DataQuest. Its goal is to:

* Maintain alignment with the **Single Source of Truth (SSOT)**
* Ensure consistency across documentation, architecture, and implementation
* Prevent scope drift
* Protect the conceptual integrity of the DataQuest design
* Provide repeatable methods for prompt structure, change management, and validation

This document is binding for all future updates until superseded.

---

## **2. The Foundation: Using the SSOT as the Primary Reference**

All collaboration with AI must begin by referencing the SSOT:

```
Context: Using the DataQuest SSOT v1.0 and Tier 2 Approved Working Plan…
```

This ensures that:

* AI-generated output respects architecture, design choices, and constraints
* No unauthorized features are introduced
* Agents, database schema, and UI remain aligned with specifications

Any work produced without anchoring to the SSOT must be treated as **draft** and cannot be merged into project documents until validated.

---

## **3. Change Control: Required Workflow for Modifications**

### **3.1 All major updates must be logged as a Change Request (CR)**

Use this required format:

```
CR ID:
Title:
Summary:
Impact Areas:
Tier Classification:
Acceptance Criteria:
Approval Status:
```

Once approved, the CR must be reflected in:

* The Tier 2 Working Plan
* The SSOT
* The Roadmap
* The Master Index

### **3.2 Never implement architecture-level changes without a CR**

Examples requiring a CR:

* Adding or modifying an AI agent
* Adjusting the database schema
* Adding new UI components or panels
* Changing deployment strategy
* Modifying the Tier system
* Expanding MCP functionality

---

## **4. Prompting Standards for AI Collaboration**

To ensure consistency, every substantial AI request must follow this structure:

### **4.1 Context Block (Required)**

```
Context: Refer to the DataQuest SSOT, Tier 2 Working Plan, and Change Log.
```

### **4.2 Task Request (Required)**

Example:

```
Task: Produce an SSOT-compliant version of the Case Planner Agent prompt.
```

### **4.3 Constraints (Optional but Recommended)**

```
Constraints:
- Must not modify schema tier rules.
- Must respect MCP-only access.
- Must remain within Phase 1 MVP scope.
```

### **4.4 Output Expectations (Optional)**

Example:

```
Deliverable Format: Provide the updated prompt as a code block with annotations.
```

---

## **5. Design Consistency Checks**

AI should be asked to validate design fit before adopting new ideas:

```
Please evaluate whether this proposed change violates any constraints in the SSOT or Tier 2 Working Plan. If it does, list conflicts and propose compliant alternatives.
```

This protects against:

* Scope creep
* Architecture drift
* Inadvertent design contradictions

This process must be followed before accepting any AI-generated redesign.

---

## **6. Document Update Workflow**

When new design documents are added or existing ones updated:

1. Place the document in the correct folder under `/docs/`
2. Announce the change to the AI using:

```
A new revision has been added. Please integrate this into the SSOT and reflect updates in the Master Index.
```

3. AI updates:
   * SSOT
   * Tier 2 Plan
   * Master Index
   * Timeline (if needed)
   * Change Log
4. Only after this synchronization can new work begin.

---

## **7. Use of the Master Index**

The **Master Index** determines which documents govern which decisions.

When asking for AI assistance, you may direct explicitly:

```
Use the Query Tutor Implementation Spec and the Prompt Engineering Standards as your guides.
```

or

```
Reference the Data Dictionary and Schema Strategy when writing the DB Agent prompt.
```

This ensures output remains consistent with the correct layer of the system.

---

## **8. Weekly “System Summary Refresh” Requirement**

Every 1–2 weeks (or after major CRs), run:

```
Please generate a refreshed Master System Summary based on all documents in the SSOT and Tier 2 Working Plan.
```

This ensures alignment and prevents historical drift.

---

## **9. Diff Review Procedure**

When you submit new content:

```
Please compare this version to the previous SSOT section and generate a diff highlighting additions, deletions, and modifications.
```

This allows for PR-style review and helps maintain clarity.

---

## **10. Rules for AI-Generated Code**

All AI-generated code must:

* Obey SSOT architecture
* Follow naming conventions in `Naming Conventions Guide - DataQuest.md`
* Use only approved technologies (.NET 9, WinForms, SQL Server, MCP, Ollama)
* Not introduce new packages without a CR
* Respect Tier constraints (no CTEs/subqueries unless allowed)
* Never bypass MCP for database access

Noncompliant code must be discarded or rewritten.

---

## **11. Enforcement: What Must Never Be Violated**

These rules are non-negotiable:

* No agent may access SQL directly (MCP only)
* No JSON or polymorphic designs in student schema
* Case Planner must not validate its own cases
* SQL Enforcer must always be the final logic authority
* Hint System must follow Socratic escalation rules
* UI must remain WinForms for the MVP
* All LLM inference must remain local (Phase 1)

If AI proposes something that violates these constraints, it must be rejected.

---

## **12. How to Ask AI for Multi-Step Reasoning**

Use:

```
Please walk through each step explicitly and reference SSOT sections when making decisions.
```

This improves accuracy and preserves alignment with design documents.

---

## **13. Engagement Protocol for Creative Work**

When asking for logos, metaphors, diagrams, or conceptual framing:

Include:

```
Ensure conceptual metaphors do not contradict DataQuest’s core structure:
- Investigation model
- Plan-Verify-Tutor cycle
- Multi-agent architecture
- Traditional relational database design
```

AI creativity must not confuse or distort technical architecture.

---

## **14. Summary: The Governance Rules (Quick View)**

* Always anchor prompts to **SSOT + Tier 2 Plan + CR Log**
* Never modify architecture without a **CR**
* Use **Design Consistency Checks** before accepting changes
* Keep all updates synchronized with SSOT and Master Index
* Use standardized prompt templates for major requests
* Validate all AI output against system-level constraints

This governance system ensures DataQuest remains a coherent, stable, professionally managed project.

---
