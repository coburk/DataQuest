## 💡 High-Level Concept: DataQuest: SQL Detective

**DataQuest: SQL Detective** is an **AI-assisted learning application** that transforms SQL education into a dynamic,  **gamified investigative experience** .

The core concept is to shift the student's perception of SQL from a rigid programming language to a **powerful forensic tool** used to solve story-based mysteries. Every SQL query the student writes is framed as a question that uncovers a crucial piece of evidence, driving a narrative-driven learning loop.

### 1. The Core Experience: Student as Detective 🕵️

Students operate as the lead detective in a criminal investigation. The learning process is not about rote memorization but about  **analytical reasoning and hypothesis testing** .

* **The Case:** The student is given a mystery (`Case`) broken down into sequential steps (`StorySteps`).
* **The Clue:** The goal of each step is to find a single, vital piece of evidence (e.g., a witness ID, a time stamp, an alibi) hidden in the database.
* **The Query:** The student must consult the database schema and write a precise `SELECT` query to extract the required clue.
* **The Progress:** Only when the student's query correctly matches the **canonical result** (validated by the AI) does the story advance to the next step, providing immediate, meaningful feedback. This enforces a **Deduction Loop** where progress is gated by correct data analysis.

---

### 2. The Multi-Agent Architecture: The Digital Detective Team 🤖

The investigative experience is powered by a team of specialized, local AI agents. These agents communicate internally using the  **Model Context Protocol (MCP)** , which provides a secure, read-only interface to the SQL database. This architecture simulates a guided learning loop:  **Plan **$\to$** Verify **$\to$** Tutor** .

| **Agent Name**                | **Role**                 | **Core Function**                                                                                                                                                               |
| ----------------------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Case Planner Agent**        | **The Storyteller**      | Generates solvable, logically consistent investigation narratives and the required canonical SQL for each step. (Plan)                                                                |
| **SQL Enforcer**              | **The Logic Checker**    | Validates the generated cases and canoncial solutions to ensure the story is consistent, the foreign keys are sound, and the case is solvable. (Verify)                               |
| **Query Tutor Agent**         | **The Mentor**           | Compares the student’s query result against the canonical result, identifies errors, and provides**Socratic, multi-level hints**grounded in the schema and case logic. (Tutor) |
| **Database Agent (DB Agent)** | **The Technical Expert** | Translates the technical database schema (tables, columns, joins) into clear, natural language explanations for the student.                                                          |

---

### 3. Key Technical Pillars (The "Why")

DataQuest is defined by its intentional use of technology to solve pedagogical problems:

* **Local LLMs (Ollama):** Ensures  **privacy, predictability, and offline capability** , making the system ideal for classroom environments where internet access or cloud costs may be concerns.
* **Model Context Protocol (MCP):** Provides a **secure gateway** between the AI agents and the local SQL database, exposing only read-only query capabilities (`sql.execute_readonly`), preventing data corruption.
* **Focus on Reasoning:** By using the Query Tutor Agent to ask *guiding questions* ("Did you filter the evidence to the correct time window?") rather than just correcting syntax, the system encourages **critical analytical thinking** over simple code compliance.

The video below demonstrates a similar gamified approach to learning SQL by solving a murder mystery, which aligns with DataQuest's narrative concept.

[Learn SQL | Solve the SQL Murder Mystery](https://www.youtube.com/watch?v=w8DSLB8Wa2o)
