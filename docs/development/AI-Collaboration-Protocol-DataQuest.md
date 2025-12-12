
# **AI Collaboration Protocol for DataQuest**

### *How to Work with AI Coding Partners Across ChatGPT, Claude, and GitHub Copilot*

This document defines the official rules, workflows, and prompt structures for working with AI coding assistants on the **DataQuest: SQL Detective** project.

Its purpose is to ensure:

* predictable, consistent output
* alignment with the architecture and SSOT
* safe academic use of AI
* no hallucinated APIs or unsupported features
* traceability and reproducibility across the development lifecycle

This protocol applies to *all* AI tools used in development:

**ChatGPT, Claude, GitHub Copilot, CursorAI, and other LLM tools.**

---

# **1. Guiding Principles**

### ✔ AI assists with  *how* , but you control the *what*

The developer defines the goal, file, and constraints.

AI generates an implementation that fits the architecture.

### ✔ AI must obey the SSOT

No component may contradict the Single Source of Truth:

* Database schema
* MCP API
* Naming conventions
* Agent responsibilities
* Layer boundaries

### ✔ The AI may not invent APIs

If AI is unsure whether a method exists, it must ask.

### ✔ Keep tasks small

One file, one change.

This prevents cross-file hallucinations and simplifies testing.

### ✔ Traceability is required

Every change references:

* A **User Story**
* Or a **Discovery Story**

---

# **2. How to Engage the AI Coding Partner**

Every time you request code from an AI assistant, provide:

### **A) The file being modified**

* Include path and relevant code
* Example:

  `src/DataQuest/Agents/CasePlannerAgent.cs`

### **B) The goal**

Describe the required behavior.

### **C) The constraints**

Typical constraints for this project:

* All SQL must use MCP (never ADO.NET directly)
* No UI updates from agents
* async method names end with `Async`
* Must follow architecture boundaries (UI → Orchestrator → Agents → MCP)

### **D) The technologies involved**

Mention:

* C#, .NET 9
* WinForms
* SQL Server (local)
* MCP JSON-RPC
* Ollama LLM

### **E) Require the model to validate its own output**

You will say:

> "Review your code for correctness, missing namespaces, and compliance with the DataQuest SSOT."

This reduces errors dramatically.

---

# **3. Required Output Structure for AI Responses**

Every coding response must include:

1. **Step-by-step reasoning** (no code yet)
2. **Summary plan (3–6 bullets)**
3. **Full updated code block**
4. **Integration steps** (if needed)
5. **Self-validation**

This ensures clarity and predictable quality.

---

# **4. One File, One Change Rule**

To avoid cascading inconsistencies:

### ✔ Only modify **one file** per request

### ✔ If more files must change, break into multiple steps

1. Update File A
2. Then File B
3. Then wiring changes

This rule is critical for safe AI-driven development.

---

# **5. Debugging With AI**

When errors occur, provide:

* The **full error message**
* The file and the line number
* The code block around the error
* What you expected to happen

AI can then:

* Diagnose the failure
* Propose a fix
* Validate the updated code

Never paraphrase an error—copy/paste it.

---

# **6. Standard Coding Partner Request Template**

Use this for all development tasks.

```md
You are my AI coding partner for the DataQuest project (C#, .NET 9, WinForms, MSSQL, MCP, Ollama).  
Follow these rules exactly for every response:

1. Only modify the file I specify.  
2. Think step-by-step before writing code.  
3. Confirm you understand the goal, constraints, and integration context.  
4. Use the existing architecture:
   - WinForms UI Layer  
   - MCP Server (JSON-RPC)  
   - SQL DB as the SSOT  
   - Local LLM Agents  
5. Do not invent APIs or MCP methods. Ask if uncertain.  
6. All SQL must go through MCP tools (schema.describe or sql.execute_readonly).  
7. Follow naming conventions:
   - PascalCase for classes and public members  
   - camelCase for locals  
   - async method names end with “Async”  
8. Validate your output before finalizing.  
9. Provide integration steps if needed.

Task:
[PLACE YOUR REQUEST HERE]
```

---

# **7. Pair-Programming Mode Template**

Use this template when you want deliberate, step-by-step reasoning.

```md
Enter Pair-Programming Mode.

1. First think through the problem step-by-step (no code yet).  
2. Confirm:
   - goal  
   - constraints  
   - affected file  
   - expected interaction with MCP, Agents, or UI  
3. Identify uncertainties.  
4. Summarize the plan in bullet points.  
5. Then produce code following SSOT and conventions.  
6. Validate your output: syntax, architecture, naming, and MCP rules.
```

---

# **8. Pull Request & Commit Templates**

### **Commit Template**

```
feat(agent): implement solvability check for CasePlannerAgent

- Added MCP call to execute canonical SQL
- Added schema validation logic
- Updated logs with timestamps and agent context

User Story: US-07c
```

### **Pull Request Template**

```
## Summary
Explain what this PR changes and why.

## Linked User Stories
- US-07c
- D-03

## How to Test
Steps to verify behavior.

## Architecture Notes
Describe interactions with MCP, agents, or UI.

## Validation Checklist
- [ ] Code compiles
- [ ] Follows SSOT
- [ ] No invented APIs
- [ ] Uses MCP for SQL
- [ ] Naming conventions followed
```

---

# **9. Developer Onboarding Guide**

**Step 1 — Gather Context Before Asking AI for Code**

* The file
* The goal
* The constraints
* SSOT references
* Any error messages

**Step 2 — Choose the Appropriate Mode**

* Use **Standard Mode** for small tasks
* Use **Pair-Programming Mode** for complex logic
* Use **PR Mode** for review
* Use **Commit Template** for traceability

**Step 3 — Validate the Output**

Check for:

* Invented APIs
* Violated architecture boundaries
* MCP shortcuts
* Naming mismatches
* Missing comments

**Step 4 — Update SSOT When Architecture Changes**

SSOT → Code, never the reverse.

---

# **10. Recommended File Location**

Add this file to your repository:

```
/docs/development/AI-Collaboration-Protocol-DataQuest.md
```

Reference from:

* SSOT main document
* CONTRIBUTING.md
* Pull Request templates
* Developer onboarding materials

---

# ✔ This file is GitHub-ready and complete.

If you'd like, I can now:

* Generate the **CONTRIBUTING.md** that links to this
* Create a **Developer Onboarding Checklist**
* Add this to the SSOT’s Master Index cleanly
* Produce a **diagram that visualizes the AI development workflow**

Just tell me what you want next.
