# GitHub Pull Request Template (Optimized for AI-Generated PRs)

# AI-Generated Pull Request Summary

Generate a clear and accurate pull request description following the structure below.
Do NOT invent details. Only describe changes that actually appear in the diff.

---

## 1. Overview

Provide a brief explanation of what this PR changes and why.
Keep this tied to the DataQuest architecture:

- C# / .NET 9 / WinForms
- MCP Server (schema.describe, sql.execute_readonly)
- SQL Server (Single Source of Truth)
- Local LLM Agents (DB Agent, Case Planner, Tutor Agent, SQL Enforcer)

Do not describe features that are not in this PR.

---

## 2. What Was Changed

List the real, specific updates made in this PR.
Examples:

- Added new class or method
- Updated MCP server logic
- Modified UI component
- Adjusted SQL query handling
- Added logging, comments, or refactoring

Do not guess. Only list what exists in the code diff.

---

## 3. Why This Change Was Needed

Explain the purpose:

- Link to User Stories (ex: US-04e, US-06b)
- Link to Discovery Stories (ex: D-02)
- Describe how this supports system development

Do not invent stories or requirements.

---

## 4. How It Works

Explain the technical behavior of the change.
Ensure the explanation follows these rules:

- All database reads must go through MCP
- No new APIs should be used unless defined in the project
- Respect the Single Source of Truth in the SQL database
- Follow project naming conventions

If unsure, ask for clarification instead of assuming.

---

## 5. Testing Completed

Describe only the tests actually performed:

- UI behavior tests
- MCP call validation
- SQL execution tests
- LLM response handling
- Logging verification

Do not claim testing that was not performed.

---

## 6. Screenshots (Optional)

Include ONLY if UI was modified.

---

## 7. Risks and Mitigations

Identify any realistic risks introduced by this PR:

- Possible UI regressions
- Incorrect MCP interaction
- Logic inconsistencies
- Performance considerations

List mitigations that were actually applied.
Do not fabricate risk handling.

---

## 8. Checklist

Ensure all items are checked ONLY if true:

- [ ] Code compiles with .NET 9
- [ ] MCP tool usage is correct
- [ ] SQL access goes through MCP only
- [ ] Naming conventions followed
- [ ] No invented APIs or magic methods
- [ ] Comments added where needed
- [ ] UI changes tested manually
- [ ] All changes traceable to User/Discovery Stories
- [ ] No new features added during Code Freeze (Week 9)

---

## 9. Additional Notes

Add any clarifications needed for the reviewer.

---

# Instructions for Copilot:

When writing this PR description:

1. Use only information from the actual code diff.
2. Do not assume or invent features, tests, or behaviors.
3. Follow the structure EXACTLY as shown.
4. If something is ambiguous, ask for clarification before completing the PR.
