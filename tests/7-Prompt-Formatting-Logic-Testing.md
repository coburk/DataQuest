## Detailed Test Plan: DataQuest: SQL Detective

### 7. Prompt Formatting Logic Testing

We previously documented unit tests for the  **Ollama Interface** 's ability to handle network status and parse responses. Now, we must ensure the application layer correctly **packages the context** *before* sending it to the interface. This logic is highly deterministic and belongs in the **Query Tutor Agent** and **Database Agent** classes.

### A. Query Tutor Prompt Formatting Tests (Hint Generation)

These tests ensure the necessary context for the Socratic hint is correctly assembled according to the **Hint Generation Pipeline** (Phase 1).

| ID                  | Component / Method                           | Test Description                                                                                    | Input Condition                                                                         | Expected Result                                                                                                                   |
| ------------------- | -------------------------------------------- | --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| **UT-PT-001** | `QueryTutorAgent.BuildHintPrompt(context)` | **Context Integration:** Verify the prompt string contains all required narrative components. | Input `HintContext`includes `StepPrompt`,`LastFailedQuery`, and `ErrorContext`. | The final prompt string contains all three pieces of input data, structured exactly as required by the**Prompt Template** . |
| **UT-PT-002** | `QueryTutorAgent.BuildHintPrompt(context)` | **Socratic Constraint Check:** Ensures the prompt explicitly forbids the answer.              | Standard context is provided.                                                           | The prompt string includes the mandate:**"DO NOT provide the answer or the canonical SQL."**                                |
| **UT-PT-003** | `QueryTutorAgent.BuildHintPrompt(context)` | **Schema Grounding Check:** Ensures the prompt includes relevant schema snippets.             | `HintContext`includes a snippet of two related tables (`Persons`and `Logs`).      | The final prompt string includes the schema snippet, directing the LLM to ground the hint in the data structure.                  |
| **UT-PT-004** | `QueryTutorAgent.BuildHintPrompt(context)` | **Level Scaffolding Check:** Verifies the Level constraint is passed to the LLM.              | `HintContext`reports `CurrentHintLevel: 2`.                                         | The prompt string explicitly instructs the LLM:**"This is Hint Level 2. Provide a more specific clue than Level 1."**       |
