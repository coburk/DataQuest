# GitHub Pull Request Prompt Template

*(Paste this into a PR description OR use it with Copilot Chat when generating PR text.)*

```
Title: [Short, Clear Description of the Change]

## Overview
Provide a concise summary of what this PR does and why the change was needed.
Explain the goal in context of the DataQuest architecture 
(C#, .NET 9 WinForms, MCP, SQL Server, Ollama LLM Agents).

## What Was Changed
Describe the specific changes, focusing on the *what*, not the *how*:
- New features added
- Bugs fixed
- Files created or modified
- Architectural or design updates

## How It Works
Explain the logic of the change, highlighting interactions with:
- MCP (schema.describe, sql.execute_readonly)
- Local SQL Server (SSOT)
- AI Agents (DB Agent, Case Planner, Tutor Agent, SQL Enforcer)
- UI Components (WinForms panels, controls)
This section should clarify how the update fits the project structure.

## Related User Stories / Discovery Stories
List the IDs that this PR addresses, such as:
- US-04b
- US-06c
- D-02
This provides traceability to your timeline and capstone plan.

## Testing Performed
Describe the tests you did:
- Manual tests
- Data flow tests
- MCP validation calls
- Agent reasoning checks
Include test steps if needed.

## Screenshots (Optional)
Attach UI screenshots only if the change affects the interface.

## Risks & Mitigations
Identify potential issues introduced by this PR:
- Breaking schema assumptions
- Invalid MCP interactions
- UI layout regressions
- Performance concerns with LLM calls

Describe mitigation steps taken:
- Verified schema assumptions
- Logged MCP calls
- Followed code freeze rules (if Week 9)

## Checklist
Before submitting, confirm:
- [ ] Code compiles with .NET 9
- [ ] Follows naming conventions and style guide
- [ ] No invented APIs
- [ ] MCP is used for all SQL access
- [ ] Adds comments where logic is not obvious
- [ ] Ties back to SSOT (SQL Server)
- [ ] Includes only one logical change per PR
- [ ] Includes necessary documentation updates

## Additional Notes
Optional space for any clarifications or future considerations.
```

---

# Why This Template Works

This PR template:

* enforces consistent, professional communication
* aligns changes with your **User Stories, Discovery Stories, and Timeline**
* reduces risk by embedding mitigation awareness
* reinforces MCP boundaries and SSOT principles
* uses language appropriate for both instructors and technical reviewers
* is compatible with GitHub Classroom expectations

---
