Documenting the database structure is crucial for the **Database Agent (US-04)** and the  **Case Planner Agent (US-07)** . Below is the **Data Dictionary** and a conceptual representation of the **Logical Data Model** using  **Crow's Foot Notation** , which will serve as the blueprint for the DataQuest database.

---

## 💾 Data Dictionary (Logical Model)

The Data Dictionary defines the purpose, constraints, and data types for all core entities (tables) in the DataQuest system.

### Core Investigative Entities

| **Table**         | **Column Name** | **Data Type** | **Key/Constraint** | **Definition / Business Rule**                     |
| ----------------------- | --------------------- | ------------------- | ------------------------ | -------------------------------------------------------- |
| **Cases**         | `CaseID`            | `INT`             | PK, Not Null             | Unique identifier for the investigation.                 |
|                         | `CaseTitle`         | `VARCHAR(100)`    | Not Null                 | Narrative title of the case.                             |
|                         | `InitialPrompt`     | `VARCHAR(MAX)`    | Not Null                 | The starting story prompt for the student.               |
|                         | `Conclusion`        | `VARCHAR(MAX)`    | Nullable                 | The resolved narrative upon solving the case.            |
| **Persons**       | `PersonID`          | `INT`             | PK, Not Null             | Unique ID for any individual (suspect, witness, victim). |
|                         | `Name`              | `VARCHAR(50)`     | Not Null                 | Full name of the person.                                 |
|                         | `Role`              | `VARCHAR(50)`     | Not Null                 | E.g., 'Suspect', 'Witness', 'Victim'.                    |
|                         | `IsSuspect`         | `BIT`             | Not Null                 | Boolean flag (0=No, 1=Yes).                              |
| **Locations**     | `LocationID`        | `INT`             | PK, Not Null             | Unique ID for a physical place.                          |
|                         | `Name`              | `VARCHAR(100)`    | Not Null                 | E.g., 'Warehouse A', 'Cafe Corner'.                      |
|                         | `Address`           | `VARCHAR(255)`    | Not Null                 | Physical location for mapping.                           |
| **Relationships** | `RelationshipID`    | `INT`             | PK, Not Null             | Unique ID for the relationship link.                     |
|                         | `PersonID_A`        | `INT`             | FK to Persons            | The first person in the relationship.                    |
|                         | `PersonID_B`        | `INT`             | FK to Persons            | The second person in the relationship.                   |
|                         | `Type`              | `VARCHAR(50)`     | Not Null                 | E.g., 'Coworker', 'Sibling', 'Acquaintance'.             |

### Evidence and Log Data

| **Table**             | **Column Name** | **Data Type** | **Key/Constraint** | **Definition / Business Rule**                       |
| --------------------------- | --------------------- | ------------------- | ------------------------ | ---------------------------------------------------------- |
| **Evidence**          | `EvidenceID`        | `INT`             | PK, Not Null             | Unique ID for a piece of evidence.                         |
|                             | `CaseID`            | `INT`             | FK to Cases, Not Null    | Links evidence to a specific case.                         |
|                             | `LocationID`        | `INT`             | FK to Locations          | Where the evidence was found.                              |
|                             | `Type`              | `VARCHAR(50)`     | Not Null                 | E.g., 'CCTV_Log', 'Financial_Record'.                      |
|                             | `TimestampFound`    | `DATETIME2`       | Not Null                 | Date and time the evidence was collected.                  |
| **WitnessStatements** | `StatementID`       | `INT`             | PK, Not Null             | Unique ID for a statement.                                 |
|                             | `CaseID`            | `INT`             | FK to Cases, Not Null    | Links statement to a case.                                 |
|                             | `PersonID`          | `INT`             | FK to Persons, Not Null  | The person who provided the statement.                     |
|                             | `StatementText`     | `VARCHAR(MAX)`    | Not Null                 | The full text of the witness account.                      |
| **TransactionLogs**   | `LogID`             | `INT`             | PK, Not Null             | Unique ID for a transaction or access event.               |
|                             | `PersonID`          | `INT`             | FK to Persons, Nullable  | The person who executed the transaction/access (if known). |
|                             | `Timestamp`         | `DATETIME2`       | Not Null                 | The exact time of the logged event (critical for joins).   |
|                             | `Amount`            | `DECIMAL(10, 2)`  | Nullable                 | Financial amount, if applicable.                           |

### AI and Tutoring Control

| **Table**      | **Column Name**  | **Data Type** | **Key/Constraint**   | **Definition / Business Rule**                            |
| -------------------- | ---------------------- | ------------------- | -------------------------- | --------------------------------------------------------------- |
| **StorySteps** | `StepID`             | `INT`             | PK, Not Null               | Sequential order of the steps within a case.                    |
|                      | `CaseID`             | `INT`             | FK to Cases, Not Null      | The case this step belongs to.                                  |
|                      | `StepPrompt`         | `VARCHAR(MAX)`    | Not Null                   | The investigative question presented to the student.            |
|                      | `CanonicalQuery`     | `VARCHAR(MAX)`    | Not Null                   | The correct SQL query for the Tutor Agent (US-05).              |
| **AnswerKeys** | `AnswerKeyID`        | `INT`             | PK, Not Null               | Unique ID for the canonical answer.                             |
|                      | `StepID`             | `INT`             | FK to StorySteps, Not Null | The step this answer corresponds to.                            |
|                      | `ExpectedResultHash` | `VARCHAR(64)`     | Not Null                   | Hash of the canonical result set for comparison.                |
|                      | `ExpectedClueValue`  | `VARCHAR(MAX)`    | Not Null                   | The specific text/number clue the student must find to proceed. |

---

## 🗺️ Logical Data Model (Crow's Foot Notation)

The Logical Data Model below visually represents the tables and their required cardinality. This structure is essential for the **Database Agent** to explain joins and for the **Case Planner Agent** to build complex, multi-table queries.

### Key Relationships and Cardinality

| **Relationship**                            | **Cardinality (Minimum**                                | **Maximum)**                                                                                                                                                  | **Interpretation** |
| ------------------------------------------------- | ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| **Cases**$\to$**StorySteps**        | (1**$\mid$**Many)**$\to$**(1**$\mid$**Many) | A**Case** *must*have**one or more** `StorySteps`. A `StoryStep` *must*belong to**exactly one** `Case`.                                  |                          |
| **StorySteps**$\to$**AnswerKeys**   | (1**$\mid$**Many)**$\to$**(1**$\mid$**One)  | A**StoryStep** *must*have**exactly one** `AnswerKey`. An `AnswerKey` *must*map to**exactly one** `StoryStep`.                           |                          |
| **Cases**$\to$**Persons**           | (1**$\mid$**Many)**$\to$**(0**$\mid$**Many) | A**Case**involves**zero or more** `Persons`. A `Person` *may*be involved in**zero or more** `Cases`. (Implicit join via logs/statements). |                          |
| **Persons**$\to$**TransactionLogs** | (1**$\mid$**Many)**$\to$**(0**$\mid$**Many) | A**Person** *may*be responsible for**zero or more** `TransactionLogs`. A `TransactionLog` *may*be linked to**zero or one** `Person`.    |                          |
