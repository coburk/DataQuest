# DataQuest: Fresh Start - Building to Specification

## Status: RESET COMPLETE ?

All incorrectly created code has been removed. The repository is now clean and ready to build the architecture **as specified in the design documents**.

### What Was Removed
- ? Generic domain models (CaseDefinition, Query, TutorFeedback)
- ? Generic DbContext and repositories
- ? Generic CRUD services
- ? Generic agent placeholders
- ? Incorrect test files
- ? Incorrect documentation files

### What Remains (Preserved)
- ? `/docs` - All design and planning documentation
- ? `/sql` - Database scripts
- ? `/src` - Empty project structure (ready for correct implementation)
- ? `README.md` - Original project overview

---

## Next: Build According to Design Specification

The design documents define the **correct architecture**:

### Phase 1: Domain Models (DataQuest.Models)
Models that match the **JSON Case Schema** and **Data Dictionary**:
- `CasePlan`, `StoryStep`, `Person`, `Location`
- `EvidenceRecord`, `WitnessStatement`, `TransactionLog`
- `AnswerKey`, `QuerySubmissionResult`, `HintContext`
- `MCPRequest` (JSON-RPC)

### Phase 2: Database Layer (DataQuest.Database)
EF Core DbContext matching actual schema:
- `Cases`, `Persons`, `Locations`, `Relationships`
- `Evidence`, `WitnessStatements`, `TransactionLogs`
- `StorySteps`, `AnswerKeys`

### Phase 3: MCP Integration (DataQuest.MCP)
- **MCP Server**: `schema.describe`, `sql.execute_readonly`, JSON-RPC 2.0
- **MCP Client**: Agent communication bridge

### Phase 4: Pipeline Services (DataQuest.Services)
- `QueryValidator` - Safety checks
- `CaseManager` - Case lifecycle
- `JsonCaseImportService` - Load from JSON
- `QueryComparator` - Result comparison
- `HintGenerator` - Socratic hints
- `AgentOrchestrator` - Workflow coordination

### Phase 5: AI Agents (DataQuest.Agents)
- `DatabaseAgent` - Schema explanation via MCP
- `CasePlannerAgent` - Case generation via MCP
- `QueryTutorAgent` - Multi-level hints
- `SQLEnforcerAgent` - Logic validation via MCP

### Phase 6: Presentation Layer (DataQuest.App)
- WinForms UI
- Orchestration integration

### Phase 7: Configuration & Testing
- `appsettings.json`, `agentendpoints.json`, `userpreferences.json`
- Unit tests for each layer
- Integration tests for pipelines
- End-to-end workflow tests

---

## Ready to Proceed

**The path is clear. We have:**
1. ? Cleaned repository
2. ? Documented design specifications
3. ? Empty project structure awaiting correct code
4. ? No technical debt or incorrect code to remove

**Next step: Wait for confirmation on whether to start with Phase 1 (Domain Models) or another phase.**

Which phase should I begin with?
