## 💡 Hint Generation Pipeline: The Tutoring Stage

The **Hint Generation Pipeline** is the mechanism that delivers adaptive, Socratic feedback from the **Query Tutor Agent (US-06)** when a student is stuck on an incorrect query. Its primary goal is to provide a minimal, schema-grounded clue that encourages **reasoning and self-correction** without giving away the direct answer.

This pipeline is triggered by the student requesting a hint after a failed query submission.

---

### Phase 1: Context Aggregation and State Management  gathering necessary data

1. **Level Tracking (US-06c):** The **Query Tutor Agent** first checks the **`CaseManager`** to determine the current **Hint Level** (e.g., Level 1, Level 2) for the current  **`StoryStep`** . This is essential for ensuring  **incremental scaffolding** .
2. **Context Collection (I):** The Tutor gathers all necessary data points needed for the LLM prompt:
   * **Current `StepPrompt`:** The narrative instruction the student is trying to solve.
   * **Student's Failed Query:** The SQL the student last submitted.
   * **Relevant Schema (from Cache):** The output of `schema.describe` from the  **Database Agent** 's cache, restricted only to the tables and columns relevant to the current `StoryStep`.
   * **`ErrorContext`:** Specific guidance for the Tutor (e.g., "The student is missing a join condition on `PersonID`") stored in the `StoryStep`'s `AnswerKey`.
3. **Logging Usage (US-06f):** The system logs that a hint request has been initiated, recording the step and the requested level.

---

### Phase 2: LLM Inference and Hint Generation 🧠

This phase constructs the specialized prompt and uses the local LLM to generate the Socratic feedback.

1. **Prompt Construction (II - Socratic Style):** The **Query Tutor Agent** formats a highly specialized system prompt for the **Ollama Interface** and the local LLM:
   * **Instruction:** Explicitly tells the LLM to act as a **Socratic mentor** and to **NOT** provide the SQL answer, but instead ask a guiding question.
   * **Hint Level Constraint:** Includes the current Hint Level as a constraint (e.g., "For Level 1, only point to the necessary table or field in the schema.")
   * **Context Injection:** Injects the schema, the `StepPrompt`, and the `ErrorContext`.
2. **LLM Generation (III):** The **Ollama Interface** sends the prompt to the local LLM. The LLM processes the data and returns the generated  **hint text** .
   * *Example Hint (Level 1):* "The suspect's alibi is key. Which table holds the records of their movements between locations?"
3. **Safeguard Check:** The **Query Tutor** performs a quick check to ensure the LLM did not accidentally output the full `CanonicalQuery`. If it did, the output is blocked and logged as a failure.

---

### Phase 3: Delivery and State Update 📬

The final hint is delivered to the student, and the application state is updated for future requests.

1. **Delivery (V):** The generated hint text is displayed to the student in the dedicated **Hint Panel** of the Presentation Layer.
2. **Level Increment:** The **`CaseManager`** updates the state to increment the Hint Level counter for the current step (e.g., from Level 1 to Level 2). This prepares the system for a potentially more direct hint if the student requests help again.
3. **Return to Query:** The student is returned to the  **SQL Editor** , encouraged to **Revise their Query** based on the new analytical direction provided by the hint.
