# DataQuest Capstone Overview

## Project Summary

DataQuest is an interactive SQL learning platform designed to teach relational database reasoning through guided investigation rather than rote query repetition. The system combines a structured relational database, a rule-based validation layer, and locally hosted AI agents to provide scaffolded, Socratic-style tutoring while preserving student agency and data safety.

The project is implemented as a Windows-based application using C#, .NET 9, and Microsoft SQL Server, with all database access mediated through a Model Context Protocol (MCP). Local large language models are integrated via Ollama to ensure offline operation and ethical use of AI in an educational setting.

This capstone emphasizes **how students think**, not just whether they produce correct SQL syntax.

---

## Educational Problem Addressed

Traditional SQL instruction often focuses on isolated queries with immediate right or wrong answers. While effective for syntax memorization, this approach provides limited insight into:

• How students reason about schemas
• Why a query fails conceptually
• How intermediate mistakes evolve
• Whether understanding improves over time

As a result, instructors frequently see correct answers without understanding, or incorrect answers without clarity on where reasoning broke down.

DataQuest addresses this gap by reframing SQL practice as an investigative process with progressive difficulty, guided feedback, and explicit reasoning checkpoints.

---

## Core Concept

Students interact with a structured investigative case rather than a static problem set. Each case unfolds in steps, requiring the student to explore schemas, form hypotheses, execute queries, and interpret results.

The system follows a consistent instructional cycle:

**Plan → Verify → Tutor**

• **Plan**: The system establishes the investigative context and expected reasoning path.
• **Verify**: Student queries are safely executed and compared to canonical results.
• **Tutor**: Targeted hints are generated that guide thinking without revealing answers.

This cycle repeats until the case is resolved.

---

## System Architecture Overview

DataQuest is intentionally designed with a clear separation of deterministic and probabilistic components.

### Deterministic Core

• Microsoft SQL Server as the single source of truth
• Rule-based SQL validation and enforcement
• Case solvability and integrity checks
• Canonical answer verification

### Probabilistic Layer

• Local LLM agents hosted via Ollama
• Schema explanation and reasoning support
• Socratic hint generation
• Case planning assistance

All database reads occur through MCP tools (`schema.describe`, `sql.execute_readonly`) to ensure safety, consistency, and auditability.

---

## Ethical and Pedagogical Principles

The project explicitly avoids cloud-based AI services and opaque model behavior. Design decisions are guided by the following principles:

• Offline-first execution
• Read-only database access
• Transparent AI reasoning boundaries
• AI as tutor, not answer generator
• Instructor visibility into system behavior

The system is intended to **augment instruction**, not replace it.

---

## Intended Outcomes

By the completion of this project, DataQuest aims to demonstrate:

• A functional, offline SQL tutoring platform
• A verifiable Plan → Verify → Tutor reasoning loop
• Improved student engagement with database reasoning
• Reduced instructor grading overhead
• Responsible, transparent use of local AI in education

---

## How to Navigate This Repository

This repository contains extensive documentation produced during design, validation, and compliance analysis. To reduce cognitive load, a curated entry point is provided in: docs/_core/README.md

That directory serves as the authoritative navigation hub and links to all single-source-of-truth documents used by the system.

---

## Project Status

DataQuest is developed as a solo capstone project with a structured weekly delivery plan, documented testing strategy, and defined evaluation criteria. The system is designed to be deployable on student and instructor machines using local SQL Server installations.

---

## Conclusion

DataQuest demonstrates how AI-assisted systems can support deeper technical learning without compromising safety, transparency, or instructional integrity. By focusing on reasoning rather than answers, the project offers a scalable model for responsible AI use in computer science education.
