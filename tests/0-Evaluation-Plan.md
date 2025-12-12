# **Evaluation Plan**

The evaluation strategy for DataQuest focuses on verifying that the system works reliably, supports real learning, and demonstrates the instructional value of its AI-driven features. Because this is a hands-on, applied capstone project, the evaluation emphasizes practical testing, user experience, and the performance of the AI agents across the full investigative workflow.

Evaluation will include:

**1. Functional Testing**

We will perform structured, end-to-end tests of all core features, including schema browsing, SQL execution, MCP communication, AI-driven schema explanations, result comparisons, hint generation, and case validation. Each feature will be tested individually and then again as part of complete case flow.

**2. Installation and Deployment Testing**

Since students and instructors will run DataQuest on their own laptops, part of the evaluation includes installing the system on a clean machine and verifying that setup instructions are clear, repeatable, and trouble-free. This includes confirming local SQL Server availability, MCP connectivity, and LLM inference through Ollama.

**3. AI Reasoning Validation**

A key part of the evaluation is ensuring that the multi-step agent cycle (Plan → Verify → Tutor) works as intended. MCP logs will be reviewed to verify that each stage of reasoning is triggered at the right time, produces consistent results, and supports student learning without hallucinations or contradictory feedback.

**4. Internal Usability Testing**

I will conduct internal walkthroughs using the perspective of a first-time student, working through at least one investigative case while monitoring clarity, pacing, UI flow, and the quality of AI-generated hints and explanations.

**5. External Pilot Testing**

At least one peer or instructor will use the system in Week 9. I will observe their setup experience, gather feedback about the interface and agent responses, and identify any hidden pain points. Their insights will guide the final round of polishing.

**6. Stability and Error Handling Testing**

The evaluation includes deliberately providing incorrect queries, malformed SQL, missing case files, and other error conditions to ensure that the system handles them gracefully and continues operating without breaking the learning experience.

Together, these evaluation steps will demonstrate that DataQuest functions as a reliable, helpful learning tool and that the AI components meaningfully enhance the student experience.
