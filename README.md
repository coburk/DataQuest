# DataQuest

### A story-driven SQL investigation tool for learning through insight, reasoning, and discovery.

DataQuest transforms SQL learning into an interactive investigative experience. Students take on the role of an investigator and use SQL to collect clues, check timelines, resolve contradictions, and interpret evidence. The goal is to help learners build real reasoning skills rather than memorize commands.

A coordinated group of AI agents supports the process. These agents plan each case, validate logic, offer guidance, and explain how the data fits together. The result is a simple and engaging system where students learn through insight, reasoning, and discovery.

---

# Features

### Story-driven SQL cases

Students solve cases built from people, evidence, locations, timelines, and witness statements.

### AI-supported learning

A set of small, focused AI agents work together through the MCP to help guide the investigation.

### Gentle Socratic hints

The Query Tutor Agent asks guiding questions instead of giving away the answer.

### Safe and transparent architecture

The MCP provides controlled, read-only database access so students learn with real data without risk.

### Clear and approachable UI

Simple interfaces for students, instructors, and administrators keep the focus on learning.

---

# AI Agents

DataQuest uses four specialized agents, each with a specific role.

* **Database Agent**
  Converts schema and table structures into natural language explanations.

* **Case Planner Agent**
  Designs case structure and keeps the narrative consistent.

* **Query Tutor Agent**
  Gives hints and guiding questions. Encourages students to reason and discover.

* **SQL Enforcer Agent**
  Checks timelines, contradictions, and logical consistency of student conclusions.

---

# How It Works

Every investigation follows two simple cycles.

### System Cycle

Plan, Verify, Tutor

* The Case Planner sets the structure
* The SQL Enforcer checks claims
* The Query Tutor provides guidance

### Student Cycle

Insight, Reasoning, Discovery

* Students collect clues
* Test hypotheses with SQL
* Resolve contradictions
* Reach their own conclusions

These cycles create a learning environment that feels natural and investigative.

---

# Technology Stack

DataQuest uses tools that are easy to set up, transparent, and accessible.

* Language and Framework: C Sharp (.NET 9, WinForms)
* Database: Local MSSQL Server
* AI Runtime: Ollama (Llama 3.1 8B or Mistral 7B)
* Communication Layer: Model Context Protocol (MCP)
* Development Tools: Visual Studio, GitHub Copilot
* Testing and Logging: xUnit, Serilog

---

# Screenshots

Place your screenshots here. Suggested images:

* Student Interface
* Instructor Interface
* Schema and Case Browser
* AI Agent Monitor
* Case Overview Dashboard
* Login Screen

---

# Directory Structure

This is a suggested structure. Adjust as needed.

```
/DataQuest
    /src
        /DataQuest.App
        /DataQuest.Agents
        /DataQuest.Database
        /DataQuest.Models
        /DataQuest.Services
    /docs
        diagrams/
        ui-mockups/
        proposal/
    /sql
        create_dataquest_db.sql
        seed_data.sql
    /artifacts
        ai-agent-icons/
        workflows/
    README.md
```

---

# Installation

### 1. Clone the repository

```
git clone https://github.com/yourusername/DataQuest.git
cd DataQuest
```

### 2. Set up MSSQL

* Install a local SQL Server instance
* Run the SQL scripts in the sql folder

  * create_dataquest_db.sql
  * seed_data.sql

### 3. Install Ollama

Download from [https://ollama.com](https://ollama.com)

Install the model:

```
ollama pull llama3.1:8b
```

### 4. Launch the WinForms application

Open the solution in Visual Studio
Run the project

---

# Usage

* Select a case
* Review the evidence, people, locations, and timelines
* Run SQL queries to test your hypotheses
* Use the Query Tutor Agent when you need guidance
* Follow the steps in the case until you reach a conclusion
* Review your reasoning and compare it with the answer key

---

# Roadmap

### Short Term

* Finish core student interface
* Add more cases
* Expand the hint system
* Improve schema explanations

### Medium Term

* Instructor grading tools
* Case versioning and authoring tools
* Additional AI guardrails

### Long Term

* Larger investigation themes
* More advanced agent collaboration
* Expansion to other subjects that benefit from guided reasoning

---

# Contributing

Pull requests are welcome.
Open an issue for discussions about larger changes.

---

# License

MIT License (or your preferred license)

---

# Acknowledgments

This project is part of a capstone for the Master of Applied Artificial Intelligence.
Thank you to the faculty, peers, and mentors who provided guidance during design and development.

---

If you want, I can also generate:

* a section with badges
* a short animated GIF workflow graphic
* versioning and build instructions
* a CONTRIBUTORS.md
* a clean LICENSE file

Just let me know what you want next.
