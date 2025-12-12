## 🎯 Defining Project Goals and Scope: DataQuest: SQL Detective

This document formally defines the **goals** and **scope** of the DataQuest: SQL Detective project, aligning them with the foundational principles and the 10-week timeline established in the original proposal.

---

### 1. Project Goals: Why DataQuest Exists

The primary goal of DataQuest is to transform SQL learning from a technical exercise into an engaging, analytical experience.

| **Goal Category**                | **Description**                                                                                                                                                                                                    | **Connection to Problem Statement**                                                                                                         |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Pedagogical Goal (Reasoning)** | To shift student focus from**SQL syntax memorization**to **critical thinking and data reasoning** . The system teaches students*how to ask*questions of the data, not just*how to write*a correct query. | Addresses the struggle students have in connecting technical proficiency with real-world analytical thinking.                                     |
| **Technical Goal (AI-Powered)**  | To successfully implement a**local, multi-agent AI system**that automates the generation, validation, and tutoring of SQL investigative cases.                                                                     | Demonstrates a responsible, transparent, and reproducible model for integrating AI into classroom environments without relying on cloud services. |
| **Deliverable Goal (Prototype)** | To deliver a**fully functional, self-contained, offline-capable prototype**suitable for a capstone demonstration and initial pilot testing.                                                                        | Ensures the project is achievable within the 10-week timeline and meets the standards for a viable educational tool.                              |

---

### 2. Project Scope: What DataQuest *Will* Deliver (MVP)

The scope for the Minimum Viable Product (MVP) is confined to the features necessary to demonstrate the **Plan **$\to$** Verify **$\to$** Tutor** loop using the four core AI agents.

#### Core Functionality:

1. **Local Environment Setup (US-01):** Establish a functional C# (.NET 9) WinForms application running locally with SQL Server and the Ollama LLM runtime.
2. **Secure Database Access:** Implement the custom C# **Model Context Protocol (MCP) server** to expose only `schema.describe` and `sql.execute_readonly` tools to the AI agents.
3. **Student Query Execution (US-03):** Provide a UI for students to write and safely execute SQL queries and display results in a grid.
4. **Multi-Agent System Implementation:**
   * **DB Agent (US-04):** Translate the schema into natural-language explanations.
   * **Case Planner Agent (US-07):** Automatically generate a **single, solvable case** with associated canonical SQL and story steps.
   * **Query Tutor Agent (US-05/US-06):** Compare student query results against the canonical answer and provide  **multi-level, Socratic hints** .
   * **SQL Enforcer (US-08):** Validate the generated case logic (e.g., checking for contradictions, ensuring solvability).
5. **Case Narrative:** Successfully guide a student through **one full investigative case** from start to finish.

---

### 3. Out-of-Scope (Not in the MVP)

The following items are explicitly **excluded** from the 10-week MVP scope. They are recognized as valuable  **Future Expansion and Stretch Goals** .

* **Cloud Deployment:** The MVP will be strictly  **local and offline-capable** . Cloud hosting, web interfaces, or containerization (Docker) are excluded.
* **Instructor Interface:** The Instructor Interface for creating or modifying cases will be limited or simple. The primary focus is on the **student experience** and the  **automated case generation** .
* **Performance Metrics:** Detailed performance analysis, optimization, or rigorous academic evaluation (e.g., measuring student learning gains vs. a control group) are beyond the MVP.
* **Non-SQL Quests:** The system will focus exclusively on **crime based** **SQL investigations** . The integration of other investigative themes (Digital Forensics, Medical Mystery) is excluded.
* **Advanced AI Features:** Features like **Conversational Tutor Mode** or **Agent Collaboration Visualization** are deferred.

This strict scoping ensures the core goal—a functional, AI-driven SQL tutoring loop—is achieved on time.
