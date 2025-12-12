## 🗄️ Case Data Structures for DataQuest

To support the investigative narrative and the functionalities of the **Case Planner Agent** and  **SQL Enforcer** , the DataQuest database needs a robust, normalized relational structure. These structures define the investigative world and enable complex SQL queries for students.

The following tables are required to model the "crime scene" and its relational data:

---

### 1. Core Investigative Entities

These tables represent the main subjects and setting of the investigation, directly supporting the entities in the  **High-Level Entity Relationship Diagram (ERD)** .

| **Table Name**    | **Description**                                            | **Key Fields & Purpose**                                                                                                             |
| ----------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| **Cases**         | Defines the main investigation scenario.                         | `CaseID`(PK),`CaseTitle`,`InitialPrompt`,`Conclusion`(used by the Case Planner Agent).                                             |
| **Persons**       | All individuals involved (victims, suspects, witnesses, police). | `PersonID`(PK),`Name`,`Address`,`Occupation`,`IsSuspect`(Boolean).                                                               |
| **Locations**     | Physical places where events occurred or evidence was found.     | `LocationID`(PK),`Name`,`Address`,`Type`(e.g., 'Apartment', 'Warehouse', 'Cafe').                                                  |
| **Relationships** | Defines the connections between individuals in the case.         | `RelationshipID`(PK),`PersonID_A`(FK to Persons),`PersonID_B`(FK to Persons),`Type`(e.g., 'Coworker', 'Neighbor', 'Acquaintance'). |

---

### 2. Evidence and Clue Data

These tables hold the "evidence" that students must query using SQL. They facilitate joins and time-based reasoning.

| **Table Name**           | **Description**                                              | **Key Fields & Purpose**                                                                                          |
| ------------------------------ | ------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| **Evidence**             | Physical or digital items collected during the investigation.      | `EvidenceID`(PK),`CaseID`(FK),`LocationID`(FK),`Type`(e.g., 'Fingerprint', 'Weapon'),`Description`.           |
| **WitnessStatements**    | Accounts provided by individuals, often containing contradictions. | `StatementID`(PK),`CaseID`(FK),`PersonID`(FK),`StatementText`,`TimeReported`.                                 |
| **TransactionLogs**      | Financial, security, or access control records.                    | `LogID`(PK),`PersonID`(FK, optional),`Timestamp`(critical for time window analysis),`ActionDetails`,`Amount`. |
| **CommunicationRecords** | Phone calls, emails, or messages between persons.                  | `RecordID`(PK),`CallerID`(FK to Persons),`ReceiverID`(FK to Persons),`Timestamp`,`Duration`.                  |

---

### 3. Case Planning and Tutoring Structures

These tables support the AI agents' workflow and are not directly queried by the student (they hold the answer key).

| **Table Name** | **Description**                                       | **Key Fields & Purpose**                                                                                                                                                                         |
| -------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **StorySteps** | The sequence of tasks the student must complete for a case. | `StepID`(PK),`CaseID`(FK),`StepPrompt`,`CanonicalQuery`(The correct SQL query used by the Tutor Agent).                                                                                        |
| **AnswerKeys** | The authoritative, canonical results for each step.         | `AnswerKeyID`(PK),`StepID`(FK to StorySteps),`ExpectedResultHash`(A hash of the canonical result set for comparison),`ExpectedClueValue`(The specific piece of data the student must extract). |

The relationships between  **Cases** ,  **Persons** ,  **Evidence** , and **StorySteps** are central to how the **Case Planner Agent** builds a logically consistent, solvable mystery. The resulting SQL database populated with data will represent the complete "case file" that the student explores.
