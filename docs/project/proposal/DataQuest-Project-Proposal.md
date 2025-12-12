![A magnifying glass over a relational database icon]()

AI-generated content may be incorrect.]("file:///D:/GitHub-Repos/DataQuest_v2/docs/artifacts/logos/DataQuest Logo v2.png")

 Table of
 Contents

 [Executive Summary (Epic)4](#_Toc214702418)

 [Project Relevance. 4](#_Toc214702419)

 [Problem Statement5](#_Toc214702420)

 [Purpose. 5](#_Toc214702421)

 [Objectives. 6](#_Toc214702422)

 [Significance of the Project6](#_Toc214702423)

 [Mental Models. 7](#_Toc214702424)

 [Technology Stack. 8](#_Toc214702425)

 [System Context Diagram.. 9](#_Toc214702426)

 [High-Level Architecture. 10](#_Toc214702427)

 [AI Agent Workflow Diagram.. 11](#_Toc214702428)

 [High-Level Entity Relationship Diagram.. 12](#_Toc214702429)

 [User Stories. 14](#_Toc214702430)

 [US-01 - Week 1: Environment &amp; Core Setup. 14](#_Toc214702431)

 [US-02 - Week 2: Database Schema Browser. 14](#_Toc214702432)

 [US-03 - Week 3: Student SQL Query Execution. 14](#_Toc214702433)

 [US-04 - Week 4: DB Agent (Schema AI Helper)15](#_Toc214702434)

 [US-05 - Week 5: Tutor Agent (Result Comparison)15](#_Toc214702435)

 [US-06 - Week 6: Tutor Agent (Hint System)16](#_Toc214702436)

 [US-07 - Week 7: Case Planner Agent16](#_Toc214702437)

 [US-08 - Week 8: SQL Enforcer (Rule-Based Validator)16](#_Toc214702438)

 [US-09 - Week 9: Code Freeze / Stabilization / Final Demo Prep. 17](#_Toc214702439)

 [US-10 - Week 10: Presentation Preparation (No Coding)17](#_Toc214702440)

 [Research and Discovery. 18](#_Toc214702441)

 [Research Topics. 18](#_Toc214702442)

 [Discovery User Stories. 19](#_Toc214702443)

 [Build Methodology. 19](#_Toc214702444)

 [Deployment Plan. 21](#_Toc214702445)

 [Timeline (10-Week Breakdown)22](#_Toc214702446)

 [Evaluation Plan. 23](#_Toc214702447)

 [Expected Outcomes. 24](#_Toc214702448)

 [Success Indicators. 25](#_Toc214702449)

 [Risks and Mitigations. 26](#_Toc214702450)

 [Future Expansion and Stretch Goals. 28](#_Toc214702451)

 [A. Expanded Investigative Themes. 29](#_Toc214702452)

 [B. Enhanced AI Capabilities. 29](#_Toc214702453)

 [C. Pedagogical Enhancements. 29](#_Toc214702454)

 [D. Technical and Deployment Goals. 30](#_Toc214702455)

 [E. Research and Evaluation Opportunities. 30](#_Toc214702456)

 [Conclusion. 31](#_Toc214702457)

 [Acknowledgment32](#_Toc214702458)

 [References. 32](#_Toc214702459)

## [Executive Summary (Epic)]()

DataQuest: SQL Detective is an AI-assisted learning application that helps students learn the
Structured Query Language through interactive case investigations. Using
locally hosted language models, DataQuest creates solvable, story-based
challenges that teach data reasoning, pattern recognition, and query design in
an engaging, game-like environment.

## [Project Relevance]()

As a relational database instructor, I have seen how difficult it can be to engage students
with SQL beyond the basics. Many students can write correct queries, but I
believe that few learn to think critically with data. That is, to follow a
trail of logic, spot correlations or inconsistencies, and draw meaningful
conclusions. I want to change that.

DataQuest provides a platform that enforces the idea that learning SQL can feel like solving a
mystery rather than completing a worksheet. By blending AI-powered agents with
gamified investigation, this system transforms routine query practice into an
immersive experience that rewards curiosity and reasoning.

The primary users of DataQuest are the students. They will benefit from immediate,
context-aware feedback and a sense of progression through real investigative
challenges. In DataQuest, each SQL query is more than a command. It is a
question that uncovers a new piece of evidence in a case. Behind the scenes,
specialized AI agents will drive the experience:

The *Database Agent* maps the schema into natural language

The *Case Planner Agent* builds solvable storylines and verifies them with SQL

The *Query Tutor Agent* compares student work to canonical solutions, offering
personalized hints.

These agents will work together to simulate a team of digital teaching assistants that guide
students through each investigation following a guided learning loop: Plan → Verify → Tutor.

The secondary users are educators who, like me, want a smarter way to balance instruction,
engagement, and assessment. Traditional grading may show whether a student’s
SQL query is correct but not *how* they approached the problem. The AI
agents in DataQuest will help fill that gap by logging reasoning steps,
identifying misconceptions, and providing consistent tutoring feedback. This will
let instructors focus on higher-level mentoring and discussion while still
gaining insight into each student’s decision-making process.

DataQuest will be designed to make database learning more interactive, intelligent, human-centered,
and fun. By combining storytelling, problem-solving, and AI reasoning, the
system not only assesses SQL knowledge but also nurtures the curiosity,
persistence, and analytical skills that define great problem solvers. These are
valuable skills students need in the real world.

## [Problem Statement]()

As a database instructor, I’ve noticed that many students can learn SQL syntax but still
struggle to think critically with data. They often approach assignments as
isolated technical tasks rather than opportunities to uncover insight or solve
problems. Traditional SQL exercises tend to reinforce this pattern. They reward
getting the correct answer but rarely help students understand why it’s correct
or how to reason through the process. The result is that learners may leave a
course knowing how to write queries, but not how to use data to ask and answer
meaningful questions.

The challenge, then, is to find a way to make database learning more engaging,
exploratory, and reflective of real-world analytical thinking. I want students
to connect SQL to the logic of problem-solving, not just code execution. This
requires an approach that encourages curiosity, immediate feedback, and active
reasoning, something that goes beyond static lectures or auto-graded
assignments.

To address these challenges, I propose DataQuest. An interactive learning system
that merges AI, gamification, and SQL to teach not only *how* to query but
*how to think* with data.

## [Purpose]()

The purpose of DataQuest is to transform the SQL learning experience by combining AI-driven
agents and gamified storytelling into a single, self-contained platform. The
system will turn database practice into interactive investigations where
students take on the role of data detectives. Each SQL query will become part
of a larger case, revealing new clues or contradictions within the dataset.

AI agents will play a central role in shaping and supporting this experience.

A *Database Agent* will translate schema structures into natural-language
explanations.

A *Case Planner Agent* will design solvable and logically consistent
investigative storylines.

A *Query Tutor Agent* will evaluate the students’ queries and provide
personalized feedback in the form of hints.

A *SQL Enforcer* will ensure the logic of each case remains sound.

Together, these agents simulate a collaborative teaching assistant team that guides
students through learning in real time.

DataQuest will be designed to help close the gap between technical proficiency and
analytical thinking. It will use artificial intelligence, not to replace
instruction, but to extend it. DataQuest will create an engaging, intelligent
environment that encourages students to explore, experiment, and reason through
data.

## [Objectives]()

The following objectives define the specific goals of the DataQuest project. Each objective
connects directly to the project’s purpose which is to create an AI-assisted
learning platform that transforms SQL knowledge assessments into an engaging
process of discovery and reasoning.

1. **Develop an AI-driven SQL learning platform** that transforms query practice into interactive,
   narrative-based investigations.
2. **Design and implement specialized AI agents.** These will include a Database Agent, Case Planner
   Agent, Query Tutor Agent, and SQL Enforcer. These AI agents will automate
   explanation, generation, tutoring, and validation tasks.
3. **Integrate the Model Context Protocol (MCP)** as a secure, read-only communication bridge between the AI agents and the
   SQL database.
4. **Gamify SQL learning** by framing lessons as investigative “cases” that promote critical thinking,
   pattern recognition, and logical deduction.
5. **Deliver adaptive, real-time tutoring** through AI-generated hints, schema-based reasoning, and contextual
   feedback that supports self-directed learning.
6. **Enable instructors to assess student reasoning** by capturing and analyzing how learners construct,
   refine, and test their queries over time.
7. **Demonstrate a fully self-contained, offline-capable system** using local large language
   models (via Ollama), ensuring reliability and accessibility in classroom
   environments.

## [Significance of the Project]()

The DataQuest project carries significance on multiple levels: educationally,
technologically, and conceptually. From an educational standpoint, it
demonstrates how artificial intelligence can be used to promote *active
learning* rather than passive instruction. By combining local AI reasoning
with gamified investigation, DataQuest encourages students to move beyond
memorization and into a mindset of exploration and logical deduction. It offers
a way for students to apply SQL in meaningful, story-driven scenarios that
mirror real analytical work, helping them connect technical skills with
problem-solving and reasoning. These outcomes are often not achieved with traditional
exercises.

DataQuest supports this form of reasoning through guided questioning. The Query Tutor
Agent uses a light Socratic approach, asking short, targeted questions that
help students test assumptions, examine conditions, and reason through their
own discoveries. Instead of handing over answers, the system encourages
students to collect clues, resolve contradictions, verify time windows,
identify suspects, use evidence, and test their hypotheses through SQL. This
keeps the learning process centered on insight, reasoning, and discovery.

From a technological perspective, the project showcases a practical and responsible
approach to integrating AI into classroom environments. Instead of relying on
cloud-based services or opaque APIs, DataQuest uses local large language models
and a modular multi-agent architecture that is transparent, controllable, and
adaptable. Each agent performs a focused instructional task. They map the
schema, plan solvable cases, provide tutoring hints, or enforce logic. The AI
agents will operate safely within a contained environment. This structure not
only makes the system reliable and secure but also serves as a clear model for
how AI components can be orchestrated for educational purposes without
compromising privacy or data integrity.

Equally important is the system’s expandability. Although the current implementation
focuses on SQL investigations, the underlying framework is intentionally
modular. The same architecture could power future “quests” in data analysis,
cybersecurity, or even AI ethics. Any subject that benefits from guided
reasoning and structured exploration could potentially by used. By
demonstrating that AI agents can drive adaptable learning narratives, DataQuest
contributes to the ongoing evolution of AI-assisted education, offering a
blueprint for systems that are flexible, transparent, and student-centered.

This project differs from existing SQL tutors by embedding reasoning-focused AI
agents within a self-contained, ethical, and instructor-friendly environment.

## [Mental Models]()

To help non-technical readers understand how DataQuest operates, it can be useful
to describe the system through familiar investigative metaphors. These models
highlight how the AI agents collaborate, how students interact with the system,
and how each case unfolds like a structured investigation. This framing matches
the narrative design of DataQuest and helps explain the learning process in a
way that feels natural and intuitive.

At its core, DataQuest places the student in the role of an investigator. Students
collect clues, resolve contradictions, verify time windows, identify suspects,
use evidence, and test hypotheses through SQL. They do not simply memorize
syntax. They learn to reason, validate, cross-check, and prove claims. The
mental models below reinforce this investigative approach and show how the AI
agents work together to support the learner.

There are two complimentary cycles that appear throughout the system. On the agent
side, DataQuest operates in a Plan → Verify → Tutor pattern. On the learner
side, each case encourages Insight → Reasoning → Discovery. These two cycles
support one another, giving students a structured but flexible way to learn.

| **Model** | **Purpose** | **Explanation** |
| --------- | ----------- | --------------- |
| **Digital Detective Team**  | Frames the student as the lead investigator supported by AI specialists. |  In this model, the student acts as the lead detective, and the AI agents operate as members of a digital investigative team. The Database Agent retrieves facts and records, the Case Planner sets up the narrative structure, the SQL Enforcer checks statements for consistency, and the Query Tutor offers guidance when needed. This makes the system feel familiar and grounded, helping readers understand how the student is supported without losing ownership of the investigation. In this model, the Query Tutor often takes a gentle Socratic role, asking guiding questions that help students think like investigators. Rather than revealing answers, it prompts the learner to look closer at evidence, consider contradictions, or revisit a key detail. This makes the experience feel authentic to an investigative workflow while still supporting learning.  |
| **The Intelligence Unit**  | Shows how AI agents operate like a coordinated CSI or FBI analysis group.  |  In this model, each AI agent takes on the role of a specialized analyst within an intelligence unit. The Case Planner creates the case strategy. The SQL Enforcer ensures logical integrity, much like internal review. The Database Agent supplies background data, similar to a records analyst. The Query Tutor acts as a training officer who provides insight without revealing answers. This model helps illustrate how the agents collaborate while maintaining distinct areas of responsibility. |
| **Case Command Center**  | Describes how the system routes requests and responses during the investigation.  | This model frames DataQuest as a centralized command center. The student issues queries or questions, and the system routes them to the appropriate AI agent through the Agent Orchestrator. The agents return structured results, insights, or validations. The MCP serves as a secure data channel, similar to how investigators access controlled records systems. This model communicates the flow of information in a clear, straightforward way. As part of this flow, the Query Tutor Agent provides hints in the form of simple, reflective questions that encourage students to reason through their own next step.   |
| **DataQuest Framework**  | Highlights that cases operate as structured “quests” that can grow and evolve.  | This model shows how DataQuest acts as a framework for building investigative learning experiences. Each case is a contained quest, built from story steps, evidence, contradictions, and feedback loops. Because the framework is modular, new cases and new subject areas can be added over time. This model helps explain the long-term scalability and flexibility of the system. |

## [Technology Stack]()

These technologies were selected to keep DataQuest easy to run, easy to understand,
and easy to reproduce. The goal is to support a learning environment where
everything happens locally, remains transparent, and stays focused on helping
students build real SQL skills.

### Language and Framework
**C# with .NET 9 using WinForms.**
This provides a straightforward way to build a reliable desktop application without
needing cloud services or additional setup.

### Database
**Local Microsoft SQL Server**
A relational database gives students the same kind of environment they will encounter in real coursework and industry settings.

### AI Runtime
**Ollama with local models such as Llama 3.1 8B or Mistral 7B.**
Running models locally keeps the system private, predictable, and available even
without an internet connection.

### Communication Layer
**Model Context Protocol (MCP).**
This is the structured gateway the agents use to read from the database. This keeps all data access safe, consistent, and easy to follow.

### Development Tools:
**Visual Studio, GitHub Copilot using Claude and ChatGPT.**
These tools support the development process while still keeping the workflow approachable for instructional use.

### Testing and Logging
**xUnit and Serilog, along with lightweight custom testing.**
These tools help ensure predictable behavior during query evaluation and agent interaction. The tests will help verify behavior during development and provide clear feedback when something needs attention.

## [System Context Diagram]()

![DataQuest - System Context Diagram]()

This diagram shows the DataQuest system at a high level and the people and services around it. Students and instructors interact with DataQuest through their respective
interfaces, while the system itself coordinates the flow of information. The AI
agents work alongside the application, each contributing a different type of
support. All database access happens through the MCP, which provides a safe way
for both the application and the agents to read from and work with case data.
When natural-language reasoning is needed, the agents call the LLM. This view
helps illustrate how DataQuest stays connected to its users and to the
components that make its guided learning experience possible.

## [High-Level Architecture]()

![High-Level Architecture]()[]()

This diagram gives a broad view of how the main parts of DataQuest work together. The student and instructor interfaces connect to the core application, which manages case logic and coordinates the AI agents. Each agent plays a specific role and interacts with the database through the MCP to keep all access safe and consistent. When reasoning or explanation is needed, the agents call the LLM before returning
structured feedback. All of this follows a simple internal rhythm of Plan,
Verify, and Tutor, which keeps the system predictable and easy to understand at
a high level.

## AI Agent Workflow Diagram

![AI Agent Workflow]()

This diagram shows how
DataQuest’s AI agents work together to support the student experience. When the
student submits a query or asks for help, the request moves through the
application to the Agent Orchestrator, which decides which agent should respond.
Each agent has a specific role. The Database Agent explains the schema, the
Case Planner shapes the story, the Query Tutor reviews student queries and
offers feedback, and the SQL Enforcer checks the logic of the case. All agents
use the MCP to safely read from the database, and they call the LLM whenever
natural-language reasoning or explanation is needed. The result is a smooth,
guided learning process that feels intelligent without exposing any of the
underlying complexity.

## [High-Level Entity Relationship Diagram]()

![High-Level Entity Relationship Diagram]()

#### **Cardinal Connections in the DataQuest ERD**

The DataQuest Entity Relationship Diagram (ERD) represents the structure of an investigative learning experience. Each connection in the ERD reflects how elements of a case relate to one another in the story world.

#### **Locations -> Cases (1 to Many)**
A single Location can be the setting for many Cases. Each Case occurs at one
primary Location, such as a lab, warehouse, or apartment complex.

#### **Cases -> Evidence (1 to Many)**
Every Case may involve multiple pieces of Evidence. Evidence items help learners
analyze what happened and build a picture of events.

#### **Cases -> WitnessStatements (1 to Many)**
A Case can include many WitnessStatements. Each statement is an account provided
by a person and contributes clues, claims, or contradictions relevant to the
investigation.

#### **Cases -> Relationships (1 to Many)**
Each Case can contain many Relationships that define how people involved in the case
are connected (e.g., coworker, neighbor, assistant). These help illustrate the
social or professional context of the investigation.

#### **Cases -> StorySteps (1 to Many)**
A Case is broken into multiple StorySteps. These guide the learner through the
investigation in a structured sequence, from initial fact-finding to deeper
analysis.

#### **StorySteps -> AnswerKeys (1 to Many)**
Each StoryStep references an AnswerKey containing the expected SQL or logic for that
step. This serves as the authoritative reference that the AI Query Tutor uses
to compare student submissions.

#### **Persons -> Evidence (1 to Many)**
A Person can be linked to many pieces of Evidence (for example, fingerprints,
logs, or items pointing toward or implicating them). This connection helps
model suspicion and investigative leads.

#### **Persons -> WitnessStatements (1 to Many)**
A Person may give multiple WitnessStatements across different cases or contexts.
Each statement provides information that could support or contradict evidence.

#### **Persons -> Relationships (1 to Many)**
A Person can appear in many Relationship entries. These describe their
connections to other individuals within a case, providing additional context
for motive, means, or opportunity.

#### **Locations -> Evidence (1 to Many)**
A Location can be associated with multiple Evidence items. These may represent
where clues were found, where events occurred, or where suspects claim to have
been.

#### **Locations -> WitnessStatements (1 to Many)**
A Location can appear in multiple WitnessStatements, serving as the claimed
location for a witness or suspect at a particular time.

## [User Stories]()
The following user stories describe the functional and instructional goals of each system component broken down by week with several development tasks per week.

### [US-01 - Week 1: Environment & Core Setup]()
Goal: Establish full development environment and verify toolchain.

| **ID**  | **User Story** | **Hours** |
| ------- | -------------- | --------- |
| US-01a  | Install Visual Studio and confirm .NET 9 environment | 2 |
| US-01b  | Install SQL Server locally and run a basic query     | 2 |
| US-01c  | Install Ollama and verify local LLM inference        | 2 |
| US-01d  | Create GitHub repository and commit initial structure | 1 |
| US-01e  | Scaffold WinForms UI panels(schema, query editor, log panel) | 5 |
| US-01f  | Create MCP server project structure                  | 4 |
| US-01g  | Run a test MCP tool call via JSON-RPC                | 2 |
| US-01h  | Add baseline logging system (Console or Serilog)     | 1 |
| **Total Hours**   |                      | **19**    |

### [US-02 - Week 2: Database Schema Browser]()
Goal: Provide visibility into schema structure.

| **ID** | **User Story** | **Hours** |
| ------ | -------------- | --------- |
| US-02a | Display list of tables | 3 |
| US-02b | Display columns for selected table | 3 |
| US-02c | Show foreign key relationships | 3 |
| US-02d | Add collapsible/expandable table views | 3 |
| US-02e | Test schema browsing with sample data  | 3 |
| US-02f | Add schema refresh functionality | 3 |
| **Total Hours** |                      | **18** |

### [US-03 - Week 3: Student SQL Query Execution]()
Goal: Students can run safe SQL queries.

| **ID** | **User Story** | **Hours** |
| ------ | -------------- | --------- |
| US-03a | Build SQL query input box  | 3 |
| US-03b | Execute SQL using MCP sql.execute_readonly | 5 |
| US-03c | Display results in table grid | 4 |
| US-03d | Display SQL errors cleanly | 2 |
| US-03e | Add “Clear Query” button | 1 |
| US-03f | Block unsafe statements (DROP, DELETE, UPDATE) | 5 |
| **Total Hours** |                      | **20** |

### [US-04 - Week 4: DB Agent (Schema AI Helper)]()
Goal: AI agent explains database schema in plain English.

| **ID** | **User Story** | **Hours** |
| ------ | -------------- | --------- |
| US-04a | DB Agent calls schema.describe via MCP | 4 |
| US-04b | Convert schema into natural-language explanation | 5 |
| US-04c | Add “Explain Schema” button in UI | 2 |
| US-04d | Format AI explanations into readable paragraphs/lists | 3 |
| US-04e | Add JOIN examples with explanations | 4 |
| US-04f | Log all DB Agent actions for debugging | 2 |
| **Total Hours** |                      | **20** |

### [US-05 - Week 5: Tutor Agent (Result Comparison)]()
Goal: Compare student output to canonical results.

| **ID** | **User Story** | **Hours** |
| ------ | -------------- | --------- |
| US-05a | Store canonical SQL for each StoryStep | 3 |
| US-05b | Tutor runs canonical SQL via MCP | 4 |
| US-05c | Compare canonical vs student result sets | 5 |
| US-05d | Identify missing/extra rows | 2 |
| US-05e | Display Correct/Incorrect indicator or message | 2 |
| US-05f | Log comparison events for troubleshooting  | 3 |
| **Total Hours** |                      | **19** |

### [US-06 - Week 6: Tutor Agent (Hint System)]()
Goal: Provide schema-grounded, incremental hints.

| **ID** | **User Story** | **Hours** |
| ------ | -------------- | --------- |
| US-06a | Detect common SQL errors (wrong table/column) | 4 |
| US-06b | Generate minimal schema-based hints | 5 |
| US-06c | Allow multi-level hints (Hint 1, Hint 2, etc.) | 4 |
| US-06d | Allow students to request hints via UI button  | 2 |
| US-06e | Display hints in a UI panel | 3 |
| US-06f | Log all hint usage | 3 |
| **Total Hours**  |                      | **21** |

### [US-07 - Week 7: Case Planner Agent]()
Goal: AI automatically creates solvable investigation cases.

| **ID** | **User Story** | **Hours** |
| ------ | -------------- | --------- |
| US-07a | Analyze schema for story structure | 4 |
| US-07b | Generate CasePlan JSON (story steps + canonical SQL) | 5 |
| US-07c | Generate canonical SQL for each clue/step | 4 |
| US-07d | Validate solvability via MCP by running canonical SQL | 4 |
| US-07e | Save generated cases | 2 |
| US-07f | Load cases from UI | 1 |
| **Total Hours** |                      | **20** |

### [US-08 - Week 8: SQL Enforcer (Rule-Based Validator)]()
Goal: Ensure cases are logically consistent and solvable.

| **ID** | **User Story** | **Hours** |
| ------ | -------------- | --------- |
| US-08a | Detect contradictory witness statements | 4 |
| US-08b | Validate foreign key integrity | 4 |
| US-08c | Detect empty or unsolvable cases or SQL queries | 4 |
| US-08d | Add “Case Validation Summary” panel in UI | 2 |
| US-08e | Block invalid or inconsistent cases from loading | 3 |
| US-08f | Log validation results | 2 |
| **Total Hours** |                      | **19** |

### [US-09 - Week 9: Code Freeze / Stabilization / Final Demo Prep]()
Code Freeze begins at the start of Week 9.

No new features after Week 8. Week 9 is low-risk tasks only

| **ID** | **Allowed Task (OPTIONAL)** | **Hours** |
| ------ | --------------------------- | --------- |
| US-09a | Perform end-to-end internal installation testing | 5 |
| US-09b | Conduct limited end-user testing with at least one external tester | 4 |
| US-09c | Fix bugs discovered during testing (no new features) | 3 |
| US-09d | Add color-coding to existing MCP logs | 1 |
| US-09e | Add timestamps to log entries | 1 |
| US-09f | Perform minor UI polish (spacing, labels, alignment) | 2 |
| US-09g | Build the final demo case (content only) | 1 |
| US-09h | Integrate simple case completion summary | 1 |
| US-09i | Test full case flow from start to finish | 1 |
| US-09j | Update documentation (README, usage notes) | 1 |
| **Total Hours** |                | **20** |

### [US-10 - Week 10: Presentation Preparation (No Coding)]()
Goal: Prepare and deliver capstone presentation. No system development.

| **ID**  | **User Story** | **Hours** |
| ------- | -------------- | --------- |
| US-10a  | Create a polished slide deck summarizing the project | 4 |
| US-10b  | Write a demo script to guide the live demonstration | 3 |
| US-10c  | Record a backup demo video (“Plan B”) | 4 |
| US-10d  | Practice the full presentation several times | 3 |
| US-10e  | Prepare answers to expected Q&A questions | 2 |
| US-10f  | Compile all final project materials for submission | 2 |
| **Total Hours** |                      | **18**  |

## [Research and Discovery]()
The DataQuest project draws inspiration from several active areas of research in artificial intelligence, educational technology, and database pedagogy. The goal of this research phase is to identify effective design patterns and best practices that can inform both the technical implementation and instructional framework of the system.

### [Research Topics]()
* Local LLM integration via Ollama and MCP

    * This research explores how lightweight, local large language models can be embedded into applications for real-time reasoning and tutoring without depending on cloud-based services.

    * The Model Context Protocol (MCP) provides a secure communication bridge between the LLM and database, ensuring safe, read-only access.

    * Research in this area focuses on performance trade-offs, containerization (Docker), and security practices for local AI environments.

* AI tutoring systems and prompt design for education
  * Studies on intelligent tutoring systems (ITS) and AI-driven instruction highlight how conversational models can enhance learning through adaptive feedback and scaffolding.
  * Prompt design (how queries are structured for clarity, context, and intent) is critical to effective AI teaching.
  * This research area examines prompt engineering strategies, student-AI
    interaction patterns, and the ethical implications of using LLMs in
    formative assessment.
* SQL pedagogical models and adaptive learning
  * Database instruction research shows that students often learn SQL best through iterative practice, contextual application, and immediate feedback.
  * Gamified or scenario-based approaches improve retention by linking syntax with reasoning.
  * This area explores constructivist and inquiry-based models that align
    perfectly with DataQuest’s narrative and investigative learning format.
* Rule-based validation of LLM outputs
  * To maintain reliability and academic rigor, rule-based systems can act as a “logic safety net” for AI-generated content.
  * Research in hybrid AI systems (combining deterministic logic with probabilistic reasoning) supports the inclusion of a SQL Enforcer Agent to verify AI outputs.
  * This ensures that every generated case or solution remains logically
    consistent and pedagogically sound.

### [Discovery User Stories]()

|  **ID**    |  **Discovery Story**  |  **Expected Outcome**  |
| ---------- | --------------------- | ---------------------- |
| D-01       | Research how to integrate Ollama with C# for local inference. | Establish working LLM interface. |
| D-02       | Explore prompt patterns for tutoring feedback (Socratic, direct, scaffolded). | Choose best hint style. |
| D-03       | Investigate schema complexity needed for engaging case generation. | Create balanced datasets.  |
| D-04       | Test local model performance (latency vs. accuracy). | Select final model and quantization. |

The discovery process will combine literature review, small-scale experiments with prompt engineering, and prototype testing of MCP-based AI communication. Findings will directly inform design choices in agent behavior, schema design, and tutoring strategy.

## [Build Methodology]()

The development of DataQuest: SQL Detective will follow an iterative, structured build process that balances functionality, AI integration, and risk management. The methodology emphasizes frequent testing, incremental feature additions, and a full stabilization period prior to delivery. This approach ensures that the final product is both technically sound and usable in a real instructional setting.

1. Development Environment Setup

    The project will be built in Visual Studio using C# and .NET 9, with WinForms serving as the UI framework. Students and instructors will use a local SQL Server instance, enabling consistent development and deployment environments. Ollama will provide the local LLM runtime, and the MSSQL MCP Server will act as the secure tool interface between the AI agents and the database.

2. Database and Schema Design

    A normalized relational schema will be constructed and preloaded with synthetic case data. The design of tables such as Persons, Cases, Evidence, and WitnessStatements ensures the system can support investigative narratives and SQL reasoning challenges.

3. Incremental Agent Development

    Each AI agent (DB Agent, Case Planner Agent, Tutor Agent, and SQL Enforcer) will be implemented in a separate stage, ensuring that each component is independently functional before being integrated.

    * The DB Agent will interpret schema metadata.
    * The Tutor Agent will compare results and generate hints.
    * The Case Planner Agent will create solvable cases.
    * The SQL Enforcer will ensure logical consistency.

    Agents will run through the MCP server using the **schema.describe** and **sql.execute_readonly** tools.

4. Component Integration and Interface Construction

    As each agent is completed, it will be integrated into the DataQuest UI. This includes creating views for schema explanations, query results, hints, case plans, and the MCP activity log that visualizes the AI-driven Plan → Verify → Tutor cycle.

5. Research-Informed Development

    Discovery Stories (D-01 through D-04) guide key early decisions: how to integrate local LLMs, how to design effective tutoring prompts, how complex the schema should be for case planning, and how local model performance affects the user experience.

6. Stabilization and Code Freeze

    A full Code Freeze begins at the start of Week 9. From this point forward, no new features will be added. All work will focus on polishing the UI, improving logs, fixing bugs, refining documentation, and preparing the system for user testing and demonstration.

7. Deployment Preparation

    During Week 9, the application will be packaged as a self-contained .NET executable, and a SQL Server backup or seed script will be prepared. A Setup Guide will be finalized to ensure that students and instructors can install and run DataQuest without additional tooling.

8. End-User Testing

    Both internal and external end-user testing will be conducted:
    * Internal testing simulates a first-time user experience, validating the entire installation and case-solving workflow.

    * Limited external testing, involving at least one peer or instructor, provides real-world feedback on usability, clarity, and setup instructions.

9. Final Presentation Preparation

    Week 10 focuses entirely on assembling and rehearsing the final presentation, preparing demo materials and a backup video, and packaging final deliverables.

This methodology ensures that development remains structured, achievable, and aligned with academic expectations for a viable capstone project.

## [Deployment Plan]()

The deployment strategy for DataQuest: SQL Detective is intentionally designed to be simple, reproducible, and aligned with the existing relational database course environment. Since students are already required to install Microsoft SQL Server as part of relational database course, the system will build on that foundation rather than introducing entirely new infrastructure such as cloud services or fully containerized environments.

The application will be deployed as a native Windows desktop application running on student and instructor laptops. Each user will host three local components:

1. **The SQL Server database** containing the DataQuest schema, seed data, and investigative cases.
2. **The DataQuest application** ,published as a self-contained .NET executable (WinForms).
3. **The AI layer** ,consisting of a local LLM runtime (Ollama) and the MSSQL MCP server, which together provide safe, read-only access to the database for the AI agents.

To simplify installation, the deployment will be organized as an
instructor-provided “DataQuest Kit” that includes:

* A **database backup** file (DataQuest.bak) or SQL script (CreateDataQuestDb.sql) to restore or create the database.
* A **published application folder** for DataQuest (e.g., DataQuest_SQL_Detective.exe plus supporting files).
* The **MCP server binary or project executable** that exposes schema.describe and sql.execute_readonly.
* A short **Setup Guide** with step-by-step instructions for both
  instructors and students.

Students will restore the database into their local SQL Server instance, run the MCP server and Ollama in the background, and launch the DataQuest application from the provided folder. The application will read configuration values (such as the database connection string, MCP endpoint, and model name) from a simple configuration file, minimizing the need for manual editing.

For this initial capstone implementation, deployment will remain local and
non-containerized to keep the project achievable within the 10-week timeline and to ensure that students can run the system without needing additional tools such as Docker. Future versions of DataQuest may explore containerizing the backend as a stretch goal, allowing a one-command startup for SQL Server, Ollama, and the MCP server, but this is not required for the core capstone deliverable.

## [Timeline (10-Week Breakdown)]()

The following ten-week timeline outlines the major milestones, user stories, and deliverables for the DataQuest project. Each phase is aligned with the project objectives and builds logically toward a functional prototype capable of demonstrating the full AI reasoning cycle.

|  **Week**  |  **Focus / Milestone** |  **User Story Groups & Discovery Stories** | **Deliverables / Outcomes** |
| ---------- | ---------------------- | ---------------- | ----------- |
|  **1**  | **Environment Setup & Toolchain Verification** | US-01, D-01 | Visual Studio installed; SQL Server configured; Ollama tested; MCP Server scaffolded; baseline logging active; initial UI created; GitHub repo initialized; confirmed local LLM connectivity. Research Ollama integration with C# |
| **2** | **Database Schema Browser** | US-02, D-03 | Interactive schema viewer with tables/columns/foreign keys; collapsible views; schema refresh; early schema insights that will guide Case Planner Agent requirements. Investigate schema complexity needed for engaging case generation |
| **3** | **SQL Query Execution**  | US-03 | SQL input box; safe execution through MCP; results grid; SQL error handling; filtered/blocked unsafe commands; stable student query workflow. |
| **4** | **DB Agent: Schema Interpretation** | US-04 | DB Agent uses schema.describe; natural-language schema map; explain schema UI; join examples; schema explanation logs. |
| **5** | **Tutor Agent: Result Comparison** | US-05, D-02 | Canonical SQL executor; result set comparison engine; correctness indicator; comparison logs; validated prompt structures for next week's Hint System. Explore prompt patterns for tutoring feedback (Socratic, scaffolded direct) |
| **6** | **Tutor Agent: Multi-Level Hint System**  | US-06 | Multi-tier hints; detection of student SQL mistakes; hint panel; request-hint button; hints grounded in schema context; logs for hint usage. The  system provides hints written in a light Socratic style. Hints do not give away the answer but encourage the student to reconsider time windows, joins, filters, or evidence. Hints focus on guiding the student back to the logic of the case. The tone remains supportive and investigative, encouraging reasoning rather than recall. |
| **7** | **Case Planner Agent** | US-07, D04 | CasePlan JSON generator; canonical SQL creation; solvability validation; case storage/loading; model performance measurements inform optimization in Week 8. Test local model performance (latency vs. accuracy)  |
| **8**  | **SQL Enforcer: Rule-Based Validation**  | US-08 | Detection of contradictory/misaligned statements; FK validation; unsolvable query detection; validation summary panel; invalid cases blocked; case integrity confirmed. |
| **9**  | **Code Freeze/ Stabilization/Demo Prep** | US-09 | **Code Freeze** (start of week); log enhancements (timestamps, color coding); UI polish; final demo case built; simple case-completion summary added; full internal install test; limited external end-user test; feedback incorporated; documentation updated; bug fixes only. |
| **10** | **Presentation Preparation (No Coding)** | US-10 | Slide deck completed; demo script written; Plan-B backup demo video recorded; presentation rehearsed; Q&A prep completed; final deliverable package assembled. |

## [Evaluation Plan]()

The evaluation plan for DataQuest outlines how the system’s functionality,
instructional value, and AI-driven learning experience will be assessed.
Because the project integrates multiple AI agents, database components, and an interactive user interface, evaluation emphasizes reliability, usability, and the performance of the system as a whole. Functional Testing

**1.** **Functional Testing**

Each major feature, including schema browsing, SQL execution, MCP communication, schema explanation, result comparison, hint generation, and case validation, will undergo structured functional testing. These tests verify that individual components work as intended and that they perform correctly when combined into a complete investigative workflow.

**2.** **Installation and Deployment Testing**

The system is intended for use on student and instructor laptops, requiring a clean and predictable installation process. Evaluation includes validating the full setup instructions, confirming that SQL Server, the MCP server, Ollama, and the
WinForms application operate reliably on a fresh environment, and ensuring that the system remains completely local and offline-capable.

**3.** **AI Reasoning Validation**

A key part of evaluation involves confirming that the AI agent cycle (Plan → Verify → Tutor) behaves consistently and transparently. MCP logs will be reviewed to ensure that each stage executes accurately, produces stable outputs, and avoids
contradictory or hallucinated responses.

**4.** **Internal Usability Testing**

Internal tests will simulate the experience of a first-time student completing a full investigative case. This includes evaluating the clarity of schema visualizations, the quality of error messages, the pacing of hints, and the overall flow of the learning experience.

**5.** **External Pilot Testing**

At least one peer or instructor will complete a test run of DataQuest. Their experience, including installation, navigation, and case-solving, will help identify usability issues, gaps in clarity, or unexpected friction points in the workflow.

**6.** **Stability and Error Handling Testing**

Deliberate stress tests will be conducted using incorrect SQL queries, missing or malformed case files, invalid schema references, and similar edge cases. Evaluation will focus on ensuring that the system handles errors gracefully and
maintains a stable learning experience.

Together, these evaluation activities ensure that DataQuest operates reliably and supports meaningful SQL learning through its integrated AI components. Evaluation will also consider the extent to which students demonstrate insight, reasoning,
and discovery when responding to Socratic-style guidance from the Query Tutor Agent.

## [Expected Outcomes]()

DataQuest is expected to deliver a complete, functional, offline-capable prototype that demonstrates the instructional value of AI-assisted SQL learning through narrative-driven investigations. The system’s multi-agent design and local
execution model are intended to support a practical, engaging learning experience suitable for classroom use.

**1.** **A Fully Operational Offline Prototype**

    The final system is expected to run entirely on a local machine, with SQL Server, the MCP service, and the Ollama LLM runtime operating without any cloud dependencies.

**2.** **A Multi-Agent AI Learning Loop**

    The DB Agent, Case Planner, Tutor Agent, and SQL Enforcer will function collaboratively, forming a visible Plan → Verify → Tutor reasoning cycle logged through the MCP interface.

**3.** **An Engaging, Interactive SQL Learning Environment**

    Students will explore database schemas, execute SQL queries safely, follow a structured investigative narrative, receive contextual hints, and complete at least one full investigative case.

**4.** **Improved Learning Support and Engagement**

    Testing and feedback are expected to show higher engagement and clearer understanding compared to traditional worksheet-based SQL practice, particularly due to AI-generated explanations and hints.

**5.** **A Presentation-Ready Demonstration System**

    By the end of the development cycle, the project will include a polished UI, well-structured demo case, clear logs, and documentation suitable for a capstone presentation.

These outcomes reflect the project’s aim to bridge technical SQL skills with critical thinking, reasoning, and interactive problem-solving. Students not only improve their SQL accuracy but
also develop stronger analytical habits. Through Socratic-style prompts, they learn to reason about the structure of a query, cross-check assumptions, follow evidence, and reach conclusions independently. This shift from memorization to investigation is one of the most valuable educational outcomes of the system.

## [Success Indicators]()

Success indicators provide measurable criteria used to determine whether DataQuest meets its instructional and technical goals.

**1.** **Complete Offline Functionality**

    The system runs reliably—database, MCP server, UI, and LLM—entirely offline on multiple machines.

**2.** **Fully Solvable Investigative Case**

    At least one case can be generated, validated, loaded, and completed end-to-end using the AI agent workflow.

**3.** **Correct Behavior of All AI Agents**

    - The DB Agent produces accurate schema explanations.
    - The Case Planner generates solvable CasePlans.
    - The Tutor Agent correctly compares student and canonical results.
    - The SQL Enforcer flags inconsistencies or contradictions accurately.

**4.** **Visible AI Reasoning Cycle in Logs**

    MCP logs show the Plan → Verify → Tutor flow during task execution, confirming transparent and repeatable AI behavior.

**5.** **Successful Installation by External Testers**

    At least one external tester installs the system using the deployment guide and completes a case successfully.

**6.** **Positive Feedback from Test Users**

    Feedback confirms that the system is clear, engaging, and helpful for SQL learning.

**7.** **System Stability in Late-Stage Testing**

    No critical issues or blocking errors appear during Week 9 and Week 10 testing.

**8.** **Presentation-Ready Quality**
 
    Documentation, demo case, and final deliverables meet the standards for a capstone-level presentation.

These indicators establish a clear definition of success and ensure that DataQuest
delivers both educational value and technical reliability.

## [Risks and Mitigations]()

The development of DataQuest involves several technical, instructional, and project-management risks. The following table outlines the primary risks, their likelihood and impact, and the mitigation strategies that will be applied to keep the project on schedule and aligned with expected outcomes.

**1. Local LLM Performance Issues**

**Risk Level:** Medium

**Cost if Unmanaged:** High

Local models running through Ollama may exhibit slower response times, inconsistent answer quality, or difficulty generating stable explanations or hints.
    
**Mitigation:**
* Use smaller, optimized models (e.g., Llama 3.1 8B, Mistral 7B) to balance accuracy and speed
* Cache schema descriptions and repeated MCP responses
* Use prompt templates tested during Weeks 1–4
* Limit the scope of generated text (e.g., concise hints vs. long narratives)

**2. MCP Integration Complexity**

**Risk Level:** Medium

**Cost if Unmanaged:** Medium

Because the MCP server serves as the bridge between SQL Server and the AI agents, a misconfigured or unstable JSON-RPC service could block multiple features.

**Mitigation:**
* Build the MCP server early (Week 1–2)
* Use simple, minimal tool interfaces at first (schema.describe, sql.execute_readonly)
* Log all MCP calls for debugging
* Conduct isolated testing before integrating with agents

**3. AI Agents Producing Incorrect or Contradictory Results**

**Risk Level:** Medium

**Cost if Unmanaged:** High

LLMs may hallucinate schema details, generate invalid SQL, or produce contradictory hints that mislead students.

**Mitigation:**
* Keep all SQL generation and validation inside a structured MCP pipeline
* Use the SQL Enforcer to reject unsolvable or inconsistent cases
* Restrict LLM outputs using deterministic prompt formats and post-processing
* Test all AI components before Week 8 Code Freeze

**4. User Interface Complexity Becomes Overwhelming**

**Risk Level:** Low

**Cost if Unmanaged:** Medium

Because DataQuest combines schema browsing, SQL editing, logs, hints, and cases, the UI may become cluttered or confusing if not carefully structured.

**Mitigation:**
* Use simple WinForms layouts with clear panels and labeled sections
* Conduct internal usability walkthroughs in Week 4–6
* Apply UI polish and cleanup during Week 9
* Keep all enhancements low-risk after Code Freeze

**5. SQL Server Installation Differences Across Student Machines**

**Risk Level:** Medium

**Cost if Unmanaged:** High

Students may have different SQL Server configurations, causing installation or connectivity issues during deployment.

**Mitigation:**
* Provide a standardized SQL backup (.bak) and restore instructions
* Include troubleshooting notes in the deployment guide
* Test installation on at least one external machine during Week 9
* Use consistent naming conventions for databases and tables

**6. Time Constraints Due to Non-Coder Background**

**Risk Level:** Medium

**Cost if Unmanaged:** High

The project involves multiple agents, UI components, and a custom MCP server. Without careful planning, development may slip past weekly deadlines.

**Mitigation:**
* Structure all tasks into 4–6 hour units
* Use Copilot, ChatGPT, and Claude for rapid coding assistance
* Maintain strict weekly check-ins and velocity tracking
* Enforce the Week 9 Code Freeze to prevent feature creep
* Avoid “nice-to-have” features unless core functionality is complete

**7. Over-reliance on AI for Code Generation**

**Risk Level:** Low

**Cost if Unmanaged:** Medium

Copilot or ChatGPT may generate code that is partially correct, inefficient, or inconsistent with existing architecture.

**Mitigation:**
* Review all AI-generated code for accuracy and quality
* Keep a clear architectural document visible at all times
* Use smaller prompts to keep code generation precise
* Add unit tests to prevent regressions

**8. Case Generation Produces Unsolvable Scenarios**

**Risk Level:** Medium

**Cost if Unmanaged:** Medium

If the Case Planner produces ambiguous or contradictory stories, students may not be able to complete the investigation.

**Mitigation:**
* Use structured CasePlan JSON with strict fields
* Validate solvability by executing all canonical SQL via MCP
* Use the SQL Enforcer to detect contradictions
* Provide at least one manually curated fallback case

**9. Limited End-User Testing Availability**

**Risk Level:** Low

**Cost if Unmanaged:** Low–Medium

External testers may have limited availability during Week 9, reducing the amount of feedback.

**Mitigation:**
* Schedule testing early
* Prepare clear instructions and a test case to minimize their time commitment
* Optionally record a short walkthrough video
* Treat any amount of feedback as valuable but avoid relying on it for essential fixes

## [Future Expansion and Stretch Goals]()

While the first implementation of DataQuest: SQL Detective will focus on teaching SQL through narrative-driven case investigations, the system is intentionally designed to be modular and expandable. The project’s architecture and AI
foundation create opportunities for new “quests,” enhanced intelligence, and richer classroom integration in future iterations. These stretch goals illustrate the potential directions for growth, demonstrating how DataQuest can
evolve into a broad AI-assisted learning ecosystem.

### [A. Expanded Investigative Themes]()

The DataQuest framework supports a wide range of investigative narratives beyond SQL crime-solving. Each new quest would introduce a distinct dataset and domain while using the same multi-agent architecture to guide students through structured reasoning. Potential future quests include:

* **Treasure Hunt** - Follow data trails across maps and historical records to locate hidden artifacts or lost expeditions.
* **Digital Forensics** - Investigate log data and user events to identify a cyber intrusion or system breach.
* **Medical Mystery** - Analyze patient data or lab results to find the cause of an outbreak or medical anomaly.
* **Environmental Investigation** - Track pollution or wildlife data to uncover ecological causes and effects.
* **Corporate Audit** - Detect patterns of fraud or compliance violations buried in transaction records.

Each theme retains the core learning principles of inquiry, logic, and data literacy while keeping the experience
fresh and relevant across disciplines.

### [B. Enhanced AI Capabilities]()

Future versions of DataQuest could explore deeper AI functionality to create a more adaptive and transparent learning experience.

Potential enhancements include:

* **Adaptive Difficulty Adjustment** - Agents dynamically scale the complexity of cases based on student performance.
* **Agent Collaboration Visualization** - Show students how the AI agents plan, verify, and tutor in real time, promoting transparency in AI reasoning.
* **Conversational Tutor Mode** - Introduce local text-to-speech integration for natural voice guidance and conversational tutoring.
* **Model Comparison and Customization** - Support multiple local models (e.g., Llama 3, Mistral, Phi 3) to explore performance trade-offs or specialized reasoning.
* **Knowledge Graph Reasoning** - Implement graph-based logic to enable multi-step relational inference across large datasets.

These AI improvements would deepen both the pedagogical and technological sophistication of the platform, demonstrating scalable, responsible use of artificial intelligence in education.

### [C. Pedagogical Enhancements]()

To strengthen engagement and instructional value, several classroom-focused features could be added over time:

* **Instructor Dashboard** - Track student progress, query attempts, and AI hint usage for real-time formative assessment.
* **Achievement and Badge System** - Gamify learning with rewards for milestones like “First Case Solved” or “SQL Mastermind.”
* **Custom Case Builder** - Allow instructors to design or modify investigative cases without coding, using guided templates.
* **Collaborative Quests** - Enable group investigations where teams of students solve a shared case collaboratively.
* **Learning Analytics Reports** - Generate summaries of common errors or schema misunderstandings to inform teaching strategies.

These enhancements reinforce the educational mission of DataQuest, making it not just a fun way to learn SQL, but a meaningful, data-informed teaching tool.

### [D. Technical and Deployment Goals]()

To make DataQuest scalable and accessible in diverse learning environments, future development could also include:

* **Cross-Platform Support** - Extend compatibility to macOS and web-based interfaces using .NET MAUI or Blazor.
* **Dockerized Installation** - Package the complete environment (SQL Server, MCP, Ollama, and UI) into a single deployable image.
* **Optional Cloud Synchronization** - Allow instructors to save or share cases securely across classrooms.
* **Quest Repository Integration** - Create a “Quest Store” where educators can share or download new learning modules.
* **LMS Integration** - Connect DataQuest to learning management systems (Canvas, Moodle, Google Classroom) for grading automation and roster sync.

These technical enhancements support scalability while maintaining the project’s commitment to local control and data privacy.

### [E. Research and Evaluation Opportunities]()

As DataQuest matures, it can serve as a platform for studying the impact of AI-assisted learning and data reasoning skills. Future research opportunities include:

* **Evaluating Tutoring Effectiveness** - Measuring student learning gains compared to traditional SQL instruction.
* **Explainable AI Feedback Studies** - Exploring how visualizing AI reasoning affects trust and understanding.
* **Reflection and Metacognition Features** - Generating student prompts that encourage reflection after solving each case.
* **Cross-Disciplinary Pilots** - Expanding DataQuest into other fields such as data science, cybersecurity, or environmental analytics.

These research-oriented stretch goals would turn DataQuest into not just a teaching tool, but a foundation for ongoing educational innovation and AI literacy research.

The long-term vision for DataQuest is to evolve from a single-module SQL learning environment into a flexible, AI-powered platform for teaching reasoning across domains. By
expanding its investigative themes, enhancing its agent intelligence, and deepening its classroom integration, DataQuest can become a reusable and adaptable system that keeps students engaged, instructors informed, and learning outcomes measurable, all while showcasing the responsible use of AI in education.

## [Conclusion]()

The DataQuest project represents both a teaching innovation and a technical experiment in how artificial intelligence can enhance learning through narrative and reasoning.
What began as a search for a better way to teach SQL has evolved into a broader framework for engaging students in the logic of data-driven investigation. By integrating AI-powered agents into a gamified environment, the system helps students move beyond basic query writing and begin to *think like analysts* by
asking questions, testing ideas, and reasoning through evidence.

The proposal outlines a practical, achievable ten-week plan to develop a working prototype of DataQuest: SQL Detective The prototype will be include AI agents that plan, verify, and tutor in real time. The project demonstrates responsible use of local large language models to provide adaptive guidance, personalized
feedback, and transparent reasoning without relying on external cloud services.

While the initial version focuses on SQL education through solving crimes, the system’s modular design positions it for future growth. New “quests” can extend the framework into areas such as cybersecurity, environmental analysis, and data ethics, giving students across disciplines a way to build technical fluency through play and inquiry.

Ultimately, DataQuest aims to show that artificial intelligence can be more than a novelty in education. It can be a meaningful partner in teaching. By blending storytelling, investigation, and AI reasoning, the project hopes to create an experience that inspires curiosity, strengthens critical thinking, and redefines what it means to learn through data.

## [Acknowledgment]()

The development of this proposal was supported through the thoughtful use of AI-assisted tools, including OpenAI’s ChatGPT and GitHub Copilot. These tools were used to help organize ideas, refine writing, and structure technical explanations throughout the planning process. Project concepts, design
decisions, and analysis were conceived, authored, and verified by the student. The use of AI included language refinement and conceptual guidance to enhance clarity and coherence.

## [References]()

Amershi, S., Weld, D., Vorvoreanu, M., Fourney, A., Nushi, B., Collisson, P., … & Horvitz, E. (2019). Guidelines for human-AI interaction.  *Proceedings of the 2019 CHI Conference on Human Factors in Computing Systems* , 1-13. [https://doi.org/10.1145/3290605.3300233](https://doi.org/10.1145/3290605.3300233)

Chhetri, G., Somvanshi, S., Islam, M. M., Brotee, S., Sultana Mimi, M., Koirala, D., & Pandey, B. (2025, August 26). Model context protocols in adaptive transport systems: A survey.  *arXiv* . [https://arxiv.org/abs/2508.19239](https://arxiv.org/abs/2508.19239)

Ghallab, M., Nau, D., & Traverso, P. (2016).  *Automated planning and acting*. Cambridge University Press.

Graesser, A. C. (2018). *Intelligent tutoring systems.* University of Memphis Institutional Repository.

Kasneci, E., Sessler, K., Küchemann, S., Bannert, M., Dementieva, D., Fischer, F., & Kasneci, G. (2023). ChatGPT for good? On opportunities and challenges of large language models for education.  *Learning and Individual Differences* , 103,
102274. [https://doi.org/10.1016/j.lindif.2023.102274](https://doi.org/10.1016/j.lindif.2023.102274)

Mazzolini, M., & Maddison, S. (2020). Gamifying database learning: Encouraging engagement through play.  *Journal of Information Systems Education*, 31(3), 189-202.

Mitrovic, A. (2012). Fifteen years of constraint-based tutors: What we have achieved and where we are going.  *User Modeling and User-Adapted Interaction* , 22(1), 39-72. [https://doi.org/10.1007/s11257-011-9105-9](https://doi.org/10.1007/s11257-011-9105-9)

Model Context Protocol. (2025). Specification. Retrieved from [https://modelcontextprotocol.io/](https://modelcontextprotocol.io/?utm_source=chatgpt.com)

Nye, B. D. (2015). Intelligent tutoring systems by the numbers: A meta-analysis of meta-analyses. In R. Sottilare & A. Graesser (Eds.), *Design Recommendations for Intelligent Tutoring Systems: Volume 3 – Authoring Tools and Expert Modeling Techniques* (pp. 227-245). Army Research Laboratory.

“Quickstart – Ollama” (2025).  *Ollama Documentation* . Retrieved from [https://docs.ollama.com/](https://docs.ollama.com/?utm_source=chatgpt.com)

“Specification – Model Context Protocol (MCP)” (2025, June 18).  *ModelContextProtocol.io*. Retrieved from [https://modelcontextprotocol.io/specification/2025-06-18](https://modelcontextprotocol.io/specification/2025-06-18?utm_source=chatgpt.com)

## Appendix A – UI Mockups

#### Student Interface

This is the primary instructional experience.
* Run a Case as a narrative investigation
* Read the current StoryStep prompt
* Write and run SQL
* See query results
* Receive AI-based feedback and hints

![UI Mockup: Student Interface]()

#### Student Interface Requirements
* Case selection
* StoryStep prompt
* SQL editor
* Results grid
* Query Tutor feedback (natural language)
* Hint system button
* Ability to navigate steps (Next / Previous)

#### Instructor Interface

This is where instructors configure learning material. This interface supports authoring and quality control.
* Create and edit Cases
* Define StorySteps and their prompts
* Link StorySteps to AnswerKeys (ExpectedQueryRef)
* Inspect persons, locations, and evidence for each Case

![UI Mockup: Instructor Interface]()

#### Instructor Interface Requirements
* Create/edit Cases
* Create/edit StorySteps
* Associate AnswerKeys
* Manage persons, locations, evidence
* Review contradictions or errors detected by SQL Enforcer
* Optional: preview how the student will see it

#### Schema Browser / Case Browser Interface

This is a shared tool by both students and instructors to make the underlying world transparent.
* Help students understand the database schema
* Help instructors inspect or debug the case data
* Provide a UI surface where the Database Agent can shine with natural-language explanations
* This is a required interface for SQL learning.

![UI Mockup: Schema Browser / Case Browser]()

#### Admin / AI Agent Monitor Interface

This interface is extremely helpful for debugging, testing, and presentations.
* Shows faculty that your agents are real and functioning
* Assists debugging
* Great demo material
* Reinforces that DataQuest is an AI-powered platform

![UI Mockup: Admin and AI Agent Monitor Interface]()
