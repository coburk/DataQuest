# Commit Message Template


`<type>`(`<scope>`): `<short summary of change>`

[Optional extended summary in 1–3 sentences.
Explain the reason for the change and how it fits the DataQuest architecture
(C#, WinForms, MCP, SQL Server, Ollama LLM Agents).]

User Story: `<ID>` (e.g., US-04c)
Discovery Story: `<ID>` (optional)
Issue: <GitHub issue #> (optional)

Changes:

- Bullet point list of what actually changed (no guessing)
- Keep each bullet concise and factual
- Do not describe code that does not exist

Technical Notes:

- Mention interaction with MCP (schema.describe/sql.execute_readonly)
- Mention impact on SSOT (SQL Server)
- Mention agent-related logic (DB Agent, Planner, Tutor, Enforcer)
- Note any architectural considerations

Testing:

- Describe only the tests you performed (manual, UI, MCP calls)
- Include steps if relevant

Risks & Mitigations:

- List any realistic risks from this commit
- Describe mitigations applied


# Example Commit (Formatted)


feat(TutorAgent): add initial result comparison logic

Implements the core comparison between student result sets and canonical
results using MCP sql.execute_readonly. This supports the Tutor Agent's
ability to diagnose correctness and generate feedback.

User Story: US-05c

Changes:

- Added CompareResults method to TutorAgent class
- Implemented set-based equality check
- Added logging for comparison events
- Updated TutorPanel UI to show Correct/Incorrect status

Technical Notes:

- All SQL executed through MCP (read-only)
- No schema changes; SSOT maintained
- Made method async for responsive UI behavior

Testing:

- Verified canonical SQL executes successfully through MCP
- Tested student query comparison with matching and mismatching result sets

Risks & Mitigations:

- Possible false negatives if dataset grows complex
  → Mitigation: Added normalization step before comparison


# Supported `<type>` values

These follow the **Conventional Commits** spec, but tailored to DataQuest:

* **feat** — new feature
* **fix** — bug fix
* **refactor** — structural improvements without behavior change
* **chore** — build system, config, logging updates
* **docs** — documentation updates
* **test** — adding or fixing tests
* **perf** — performance improvements
* **ui** — UI-specific updates
* **agent** — updates to AI agents
* **mcp** — updates to Model Context Protocol server
* **db** — changes related to database initialization scripts or ERD updates
