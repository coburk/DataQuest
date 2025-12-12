---
name: "User Story"
about: "Create a new User Story for the DataQuest project"
title: "US-XX: [Short Title]"
labels: ["user-story"]
assignees: ""
---

# User Story  
As a **[type of user]**, I want **[specific action or feature]** so that **[benefit or purpose]**.

# Description  
Provide a clear summary of the feature or capability.  
Explain how this aligns with the DataQuest architecture:
- WinForms UI  
- MCP Server (schema.describe / sql.execute_readonly)  
- SQL Server as SSOT  
- Local LLM Agents (DB Agent, Case Planner, Tutor Agent, SQL Enforcer)

# Acceptance Criteria  
Checklist of conditions that must be met for this story to be complete:

- [ ] Feature matches the intent of the User Story  
- [ ] Consistent with existing UI layout and patterns  
- [ ] All database access occurs through MCP only  
- [ ] No invented methods or APIs  
- [ ] Naming conventions follow project standards  
- [ ] Logging added for important actions (if applicable)  
- [ ] Error cases handled gracefully  

# Non-Functional Requirements (Optional)
- Performance expectations  
- UI responsiveness  
- Logging or instrumentation  
- Security or safety constraints (read-only SQL, no schema mutation)  

# Dependencies  
Link any relevant items:
- Related User Stories (e.g., US-03, US-05)  
- Discovery Stories (e.g., D-02)  
- Architecture components (MCP, Agents, UI panels)  

# Traceability  
This User Story supports the following project objectives:
- Objective #: [short description]  
- Objective #: [short description]

# Tasks  
Break into small development tasks (4–8 hours each):

- [ ] Task 1  
- [ ] Task 2  
- [ ] Task 3  

# Testing Plan  
Describe how this feature will be tested:
- Manual UI test steps  
- MCP validation calls  
- SQL output verification  
- Agent behavior responses  

# Risks & Mitigations  
Identify any known risks and how they will be managed.

- **Risk:**  
- **Mitigation:**  

# Done When  
This story is complete when:
- All acceptance criteria are met  
- Tasks are complete  
- Code compiles cleanly  
- Story is demo-ready  
- Documentation is updated if needed

