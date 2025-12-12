# API and Service Layer Architecture Specification

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - CRITICAL PATH  
**Version:** 1.0  
**Classification:** Binding Implementation Standard

---

**SOURCE OF TRUTH TRACKING**

**COMPLIANCE STATUS:** ✅ PROPOSAL-COMPLIANT  
**SOURCE OF TRUTH:** 
- Tier 1: `docs/proposal/DataQuest-Project-Proposal.md`
- Tier 3: This document

**CHANGE REQUESTS:** NONE  
**CAPSTONE IMPACT:** ZERO  
**LAST COMPLIANCE REVIEW:** December 3, 2025  
**REVIEWED BY:** Systematic Compliance Review

---

## 📋 Document Purpose

This specification defines the service layer architecture and API interfaces for DataQuest. It operationalizes the communication between frontend, backend, agents, and database systems into clear, implementable service contracts.

**This document enables:**
- ✅ Backend developers to implement services without ambiguity
- ✅ Frontend developers to integrate with known interfaces
- ✅ Agents to communicate with defined protocols
- ✅ QA to validate integrations systematically

---

## 🎯 Scope

### What This Document Covers

```
✅ Service layer architecture and organization
✅ Service interfaces (contracts and signatures)
✅ Request/response specifications (data models)
✅ Error handling and status codes
✅ Query validation and execution service
✅ Case management service
✅ Evidence and context service
✅ Hint and agent communication service
✅ Schema and metadata service
✅ Tier progression service
✅ Caching strategy
✅ Performance requirements
✅ Integration patterns
```

### What This Document Does NOT Cover

```
❌ Database schema design (see Technical Design)
❌ Agent prompt engineering (see Gap #8)
❌ UI implementation details (see UI/UX Specification)
❌ Case content design (see Case Design Template)
```

---

## 🏗️ Architecture Overview

### Service Layer Architecture

```
┌────────────────────────────────────────────────────────┐
│              Frontend / UI Layer       │
├────────────────────────────────────────────────────────┤
│  HTTP REST API      │
├────────────────────────────────────────────────────────┤
│   API Controller Layer    │
├────────────────────────────────────────────────────────┤
│          Service Layer (Core Business Logic)    │
│ ┌──────────────────────────────────────────────────┐  │
│ │       │  │
│ │  ┌─────────────────┐  ┌─────────────────┐      │  │
│ │  │ Case Service    │  │ Query Service   │ │  │
│ │  └────────┬────────┘  └────────┬────────┘      │  │
│ │           │         │ │  │
│ │  ┌─────────────────┐  ┌─────────────────┐ │  │
│ │  │Schema Service   │  │ Validation Svc  │      │  │
│ │  └────────┬────────┘  └────────┬────────┘      │  │
│ │           │        │    │  │
│ │  ┌─────────────────┐  ┌─────────────────┐      │  │
│ │  │Hint Service     │  │Progression Svc  │      │  │
│ │  └────────┬────────┘  └────────┬────────┘      │  │
│ │       │ │                │  │
│ │  ┌─────────────────────────────┴────────┐      │  │
│ │  │   Agent Communication Service        │      │  │
│ │  └─────────────────────────────┬────────┘      │  │
│ │           │ │  │
│ └────────────────────────────────┼────────────────┘  │
│ │      │
├──────────────────────────────────┼────────────────────┤
│       Repository/Data Access Layer    │
│     (Abstraction over DB)       │
└─────────────────────────────────────────────────────────┘
       ↓
┌─────────────────────────────────────────────────────────┐
│        Database Layer (SQL Server / etc.)       │
└─────────────────────────────────────────────────────────┘

External Systems:
       ↓
┌─────────────────────────────────────────────────────────┐
│  LLM Services (Query Tutor, Database Agent)        │
│  (OpenAI, Azure OpenAI, or equivalent)  │
└─────────────────────────────────────────────────────────┘
```

### Service Dependencies

```
CORE SERVICES (Independent):
├─ Case Service (can work standalone)
├─ Schema Service (can work standalone)
└─ Validation Service (can work standalone)

COMPOSITE SERVICES (Depend on core):
├─ Query Service
│  └─ Depends: Case Service, Validation Service, Schema Service
├─ Hint Service
│  └─ Depends: Query Service, Schema Service
└─ Progression Service
   └─ Depends: Case Service, Query Service

ORCHESTRATION SERVICE:
├─ Agent Communication Service
└─ Depends: All above services
```

---

## 📊 Core Service Specifications

### Service 1: Case Service

#### Purpose
```
Manage case lifecycle, state, and persistence
Coordinate case operations
Track case progress
```

#### Interface Specification

```csharp
public interface ICaseService
{
    // Initialize case
    Task<CaseExecutionResponse> InitializeCaseAsync(
    string caseId, 
        string studentTier);
    
    // Get current case state
    Task<CaseStateResponse> GetCaseStateAsync(
   string sessionId);
    
    // Record query attempt
  Task<QueryAttemptRecordedResponse> RecordQueryAttemptAsync(
   string sessionId,
        QueryAttemptRequest request);
    
    // Advance to next question
    Task<NextQuestionResponse> AdvanceToNextQuestionAsync(
      string sessionId);
    
    // Complete case
    Task<CaseCompletedResponse> CompleteCaseAsync(
        string sessionId);
  
    // Abandon case (Phase 2+)
    Task<CaseAbandonedResponse> AbandonCaseAsync(
        string sessionId,
        string abandonReason);
}
```

#### Request/Response Models

```csharp
// REQUEST: Initialize Case
public class InitializeCaseRequest
{
    public string CaseId { get; set; }  // "case_001"
    public string StudentTier { get; set; }    // "Junior Data Analyst"
    public string SessionId { get; set; }        // Generated by system
}

// RESPONSE: Case Initialization
public class CaseExecutionResponse
{
    public string SessionId { get; set; }
    public CaseState CurrentState { get; set; }  // NOT_STARTED
    public string CaseName { get; set; }
    public string CaseNarrative { get; set; }
    public QuestionDetail FirstQuestion { get; set; }
    public int TotalQuestions { get; set; }
    public int EstimatedMinutes { get; set; }
    public DateTime StartTime { get; set; }
}

// RESPONSE: Case State
public class CaseStateResponse
{
    public string SessionId { get; set; }
    public CaseState Status { get; set; }     // NOT_STARTED, IN_PROGRESS, etc.
    public int QuestionIndex { get; set; }
    public int TotalQuestions { get; set; }
    public List<QueryAttempt> QueryAttempts { get; set; }
    public int HintLevel { get; set; }
    public int ElapsedSeconds { get; set; }
    public QuestionDetail CurrentQuestion { get; set; }
    public double PercentComplete { get; set; }
    public DateTime StartTime { get; set; }
}

// REQUEST: Record Query Attempt
public class QueryAttemptRequest
{
    public string Query { get; set; }
    public int QuestionIndex { get; set; }
    public int HintLevelAtSubmission { get; set; }
}

// RESPONSE: Query Attempt Recorded
public class QueryAttemptRecordedResponse
{
public int AttemptNumber { get; set; }
    public bool IsCorrect { get; set; }
    public string Feedback { get; set; }
    public int? NextHintLevel { get; set; }
    public bool ShouldEscalate { get; set; }
    public CaseState NewStatus { get; set; }
}
```

#### Error Handling

```csharp
public class ServiceException : Exception
{
    public string ErrorCode { get; set; }
    public int HttpStatusCode { get; set; }
    
    // Examples:
    // "CASE_NOT_FOUND" (404)
    // "SESSION_EXPIRED" (401)
// "INVALID_CASE_STATE" (400)
    // "CASE_COMPLETION_FAILED" (500)
}
```

---

### Service 2: Query Service

#### Purpose
```
Validate and execute SQL queries
Evaluate results against expected outcomes
Coordinate with Query Tutor Agent
```

#### Interface Specification

```csharp
public interface IQueryService
{
    // Validate and execute query
    Task<QueryExecutionResponse> ExecuteQueryAsync(
     string sessionId,
        string query,
        int questionIndex);
    
 // Get query validation feedback
    Task<QueryValidationResponse> ValidateQueryAsync(
      string query,
        string caseId);
    
    // Cancel long-running query
    Task CancelQueryAsync(string executionId);
    
    // Get schema for query context
    Task<SchemaContextResponse> GetSchemaContextAsync(
        string caseId);
}
```

#### Request/Response Models

```csharp
// REQUEST: Execute Query
public class QueryExecutionRequest
{
    public string Query { get; set; }
  public string CaseId { get; set; }
    public int QuestionIndex { get; set; }
    public string StudentTier { get; set; }
    public int TimeoutSeconds { get; set; } = 30;
}

// RESPONSE: Query Execution
public class QueryExecutionResponse
{
    public string ExecutionId { get; set; }
 public QueryExecutionStatus Status { get; set; }  
    // QueryExecutionStatus: SUCCESS, SYNTAX_ERROR, DB_ERROR, TIMEOUT, etc.
    
    public int? ResultRowCount { get; set; }
    public List<Dictionary<string, object>> ResultRows { get; set; }
    public int ExecutionDurationMs { get; set; }
    
  public QueryEvaluationResult EvaluationResult { get; set; }
    
    // If error:
    public string ErrorMessage { get; set; }
    public int? ErrorLine { get; set; }
    public int? ErrorColumn { get; set; }
 public string Suggestion { get; set; }
}

// NESTED: Query Evaluation Result
public class QueryEvaluationResult
{
    public bool IsCorrect { get; set; }
    public int ExpectedRowCount { get; set; }
    public int ActualRowCount { get; set; }
    public List<string> ColumnMismatch { get; set; }
    public List<string> DataMismatch { get; set; }

    public string QueryTutorFeedback { get; set; }
    public int HintLevelRecommendation { get; set; }
    public bool ShouldEscalateHint { get; set; }
}

// REQUEST/RESPONSE: Query Validation
public class QueryValidationResponse
{
    public bool IsValid { get; set; }
    public List<ValidationWarning> Warnings { get; set; }
    public string SyntaxAnalysis { get; set; }
    public List<string> TablesUsed { get; set; }
    public List<string> ColumnsUsed { get; set; }
}
```

#### Execution Workflow

```
1. RECEIVE QUERY
   ├─ Validate non-empty
   └─ Trim whitespace
      ↓
2. SYNTAX VALIDATION
   ├─ Parse SQL syntax
   ├─ Check keywords
   └─ Validate structure
  ↓
   [ERROR] → Return SyntaxError
 ↓
3. CONTEXT VALIDATION
   ├─ Check tables exist in schema
   ├─ Check columns exist
   └─ Validate relationships
        ↓
   [ERROR] → Return ContextError
        ↓
4. EXECUTE QUERY
   ├─ Set execution timeout (default 30s)
   ├─ Execute against case database
   ├─ Capture results
   └─ Track execution duration
        ↓
   [DB_ERROR] → Return DatabaseError
   [TIMEOUT] → Return TimeoutError
        ↓
5. EVALUATE RESULTS
   ├─ Compare row count to expected
   ├─ Compare column values to canonical
   ├─ Validate data completeness
   └─ Generate feedback
        ↓
6. RETURN EVALUATION
├─ If correct: Return positive feedback
   ├─ If incorrect: Return guidance
 └─ Include escalation recommendations
```

---

### Service 3: Validation Service

#### Purpose
```
Validate queries for syntax and context
Provide validation feedback
Suggest corrections
```

#### Interface Specification

```csharp
public interface IValidationService
{
    // Validate query syntax
    Task<SyntaxValidationResponse> ValidateSyntaxAsync(
        string query);
    
    // Validate query context (tables, columns, etc.)
    Task<ContextValidationResponse> ValidateContextAsync(
        string query,
        string caseId);
    
    // Check query complexity
    Task<ComplexityAnalysisResponse> AnalyzeComplexityAsync(
   string query);
    
  // Get validation suggestions
    Task<ValidationSuggestionsResponse> GetSuggestionsAsync(
   string query,
        ValidationError error);
}
```

#### Error Categories

```csharp
public enum ValidationErrorType
{
    // Syntax Errors
    UNEXPECTED_TOKEN,
    INVALID_KEYWORD,
    MISSING_CLAUSE,
    MISMATCHED_PARENTHESES,
    
    // Context Errors
    TABLE_NOT_FOUND,
    COLUMN_NOT_FOUND,
    INVALID_JOIN,
    COLUMN_TYPE_MISMATCH,
    
    // Logical Errors
    AMBIGUOUS_COLUMN,
    INVALID_WHERE_CLAUSE,
    INVALID_ORDER_BY,
    
    // Performance Warnings
    SELECT_STAR_DETECTED,
    MISSING_WHERE_CLAUSE,
    POTENTIAL_FULL_TABLE_SCAN
}
```

---

### Service 4: Schema Service

#### Purpose
```
Provide schema information and metadata
Enable Database Agent schema navigation
Manage tier-appropriate schema explanations
```

#### Interface Specification

```csharp
public interface ISchemaService
{
    // Get case schema
    Task<CaseSchemaResponse> GetCaseSchemaAsync(
 string caseId,
    string studentTier);
    
  // Get specific table info
    Task<TableInfoResponse> GetTableInfoAsync(
      string caseId,
        string tableName,
      string studentTier);
    
    // Get column details
    Task<ColumnInfoResponse> GetColumnInfoAsync(
        string caseId,
     string tableName,
        string columnName,
        string studentTier);
    
    // Get relationships
    Task<RelationshipsResponse> GetTableRelationshipsAsync(
 string caseId,
     string tableName);
    
    // Get data quality info
    Task<DataQualityResponse> GetDataQualityInfoAsync(
        string caseId,
        string tableName);
}
```

#### Response Models

```csharp
// RESPONSE: Case Schema
public class CaseSchemaResponse
{
    public string CaseId { get; set; }
    public List<TableSchema> Tables { get; set; }
    public List<Relationship> Relationships { get; set; }
    public SchemaContext Context { get; set; }  // Investigation goal
}

// NESTED: Table Schema
public class TableSchema
{
    public string TableName { get; set; }
    public string Purpose { get; set; }  // Tier 1: concrete, Tier 5: strategic
    public List<ColumnSchema> Columns { get; set; }
    public int RowCount { get; set; }
    public List<string> PrimaryKeys { get; set; }
    public List<string> ForeignKeys { get; set; }
}

// NESTED: Column Schema
public class ColumnSchema
{
    public string ColumnName { get; set; }
    public string DataType { get; set; }
    public bool IsNullable { get; set; }
    public string Description { get; set; }
    public string[] ExampleValues { get; set; }
    public DataQualityNote QualityNote { get; set; }
}

// NESTED: Relationship
public class Relationship
{
    public string FromTable { get; set; }
    public string FromColumn { get; set; }
    public string ToTable { get; set; }
    public string ToColumn { get; set; }
    public string RelationType { get; set; }  // OneToMany, OneToOne, etc.
}

// RESPONSE: Table Info (Tier-Appropriate)
public class TableInfoResponse
{
    public string TableName { get; set; }
    
    // Tier 1 (Concrete):
    public string SimplePurpose { get; set; }     // "Customer list"
    public string SimpleExplanation { get; set; } // "Each row is one customer"
  
    // Tier 2+ (Technical):
    public string TechnicalPurpose { get; set; }
    public int RowCount { get; set; }
    public List<string> PrimaryKeys { get; set; }
    
    // Tier 3+ (Quality):
    public List<DataQualityIssue> KnownIssues { get; set; }
    
  // Tier 4+ (Strategic):
    public List<InvestigationPattern> RelevantPatterns { get; set; }
}
```

---

### Service 5: Hint Service

#### Purpose
```
Coordinate with Query Tutor Agent
Generate tier-appropriate hints
Manage hint escalation
```

#### Interface Specification

```csharp
public interface IHintService
{
    // Get hint for current situation
    Task<HintResponse> GetHintAsync(
        string sessionId,
        int currentHintLevel);
    
    // Request escalated hint
    Task<HintResponse> EscalateHintAsync(
        string sessionId);
    
    // Get Query Tutor feedback
    Task<QueryTutorResponse> GetQueryTutorFeedbackAsync(
        string sessionId,
        QueryExecutionResponse queryResult);
    
    // Evaluate if escalation triggered
    Task<EscalationDecisionResponse> EvaluateEscalationAsync(
 string sessionId,
        int attemptNumber);
}
```

#### Request/Response Models

```csharp
// RESPONSE: Hint
public class HintResponse
{
    public int HintLevel { get; set; }      // 1-6
    public string HintType { get; set; }            // QUESTION, PARTIAL, ANSWER, etc.
    
    // Content by type:
    public string Question { get; set; }   // Level 1-3
    public string PartialAnswer { get; set; }       // Level 4-5
  public string FullAnswer { get; set; }      // Level 6
    public string Explanation { get; set; }         // Why this approach works
    
    public bool CanEscalateFurther { get; set; }
    public string NextHintGuidance { get; set; }
}

// RESPONSE: Query Tutor Feedback
public class QueryTutorResponse
{
    public string Feedback { get; set; }
    
    // If correct:
    public string CelebrationMessage { get; set; }
    public string WhatYouDidRight { get; set; }
    
    // If incorrect:
    public string GuidingQuestion { get; set; }
    public string AnalysisOfYourQuery { get; set; }
    
    // If error:
    public string ErrorExplanation { get; set; }
    public string RecoverySuggestion { get; set; }
    
    public int RecommendedHintLevel { get; set; }
    public string TierAdaptedTone { get; set; }
}

// RESPONSE: Escalation Decision
public class EscalationDecisionResponse
{
public bool ShouldEscalate { get; set; }
    public string EscalationReason { get; set; }  // "3 attempts failed", etc.
    public int NewHintLevel { get; set; }
}
```

#### Hint Escalation Logic

```
ESCALATION ALGORITHM:

TRIGGER: Student submits incorrect query or requests hint

STEP 1: Count Attempts
├─ Get attempt count for current question
└─ Check hint level at submission

STEP 2: Evaluate Escalation
├─ IF attemptCount == 1:
│  └─ Return Level 1 (Socratic question)
├─ IF attemptCount == 2:
│  └─ Return Level 2 (Structured question)
├─ IF attemptCount == 3:
│  └─ Escalate to Level 3 (Specific scaffolding)
├─ IF attemptCount == 4:
│  └─ Return Level 4 (Guided approach)
├─ IF attemptCount == 5:
│  └─ Escalate to Level 5 (Partial answer)
└─ IF attemptCount >= 6:
   └─ Escalate to Level 6 (Full answer)

STEP 3: Generate Hint
├─ Retrieve appropriate hint template
├─ Apply tier-specific language
├─ Adapt tone for student state (frustrated, confused, etc.)
└─ Return hint response

STEP 4: Track Escalation
├─ Update student hint level
├─ Record escalation reason
└─ Log for analytics
```

---

### Service 6: Tier Progression Service

#### Purpose
```
Manage tier advancement logic
Determine when student progresses
Coordinate promotion ceremony
```

#### Interface Specification

```csharp
public interface ITierProgressionService
{
    // Check if tier is complete
    Task<TierProgressionResponse> CheckTierProgressionAsync(
        string studentTier,
        int completedCasesInTier);
    
    // Get tier advancement info
    Task<TierAdvancementResponse> GetTierAdvancementAsync(
        string fromTier);
    
    // Promote student
 Task<PromotionResponse> PromoteStudentAsync(
    string studentId,
        string fromTier);
}
```

#### Request/Response Models

```csharp
// RESPONSE: Tier Progression Check
public class TierProgressionResponse
{
    public string CurrentTier { get; set; }
    public int CompletedCases { get; set; }
    public int RequiredCases { get; set; }
    public bool IsTierComplete { get; set; }
    public double PercentComplete { get; set; }
    
 public int RemainingCases { get; set; }
    public string NextUnlockedCase { get; set; }  // If tier complete
}

// RESPONSE: Tier Advancement Info
public class TierAdvancementResponse
{
    public string FromTier { get; set; }
    public string ToTier { get; set; }
    
    // Promotion details:
    public string PromotionMessage { get; set; }
    public string TierMission { get; set; }
    public string TierResponsibilities { get; set; }
    public List<string> NewCasesUnlocked { get; set; }
    public string FirstNewCasePreview { get; set; }
    
    // Badge info:
    public string BadgeIcon { get; set; }
    public string BadgeColor { get; set; }
}

// RESPONSE: Promotion
public class PromotionResponse
{
    public bool PromotionSuccessful { get; set; }
    public string NewTier { get; set; }
    public DateTime PromotedAt { get; set; }
 public List<string> UnlockedCases { get; set; }
    public AchievementBadge Badge { get; set; }
}
```

---

### Service 7: Agent Communication Service

#### Purpose
```
Coordinate between frontend, backend, and LLM agents
Manage agent request/response routing
Handle agent timeouts and failures
```

#### Interface Specification

```csharp
public interface IAgentCommunicationService
{
    // Route to Query Tutor Agent
    Task<AgentResponse> RouteToQueryTutorAsync(
        QueryTutorRequest request);
    
    // Route to Database Agent
    Task<AgentResponse> RouteToDatabaseAgentAsync(
        DatabaseAgentRequest request);
    
    // Get agent response with fallback
    Task<AgentResponse> GetAgentResponseWithFallbackAsync(
        AgentRequest request,
        string fallbackResponse);
}
```

#### Request/Response Models

```csharp
// REQUEST: Query Tutor Request
public class QueryTutorRequest
{
    public string SessionId { get; set; }
    public string StudentQuery { get; set; }
    public string StudentTier { get; set; }
    public int AttemptNumber { get; set; }
    public int HintLevel { get; set; }
    public QueryExecutionResponse QueryResult { get; set; }
    public CaseContext CaseContext { get; set; }
}

// REQUEST: Database Agent Request
public class DatabaseAgentRequest
{
    public string StudentQuestion { get; set; }
    public string StudentTier { get; set; }
    public string CaseId { get; set; }
    public string CurrentInvestigation { get; set; }
    public SchemaContext SchemaInfo { get; set; }
}

// RESPONSE: Agent Response
public class AgentResponse
{
    public string ResponseText { get; set; }
    public string AgentName { get; set; }  // "QueryTutor", "DatabaseAgent"
 public int ResponseTimeMs { get; set; }
    public bool Success { get; set; }
    
    // If failed:
    public string ErrorMessage { get; set; }
    public string FallbackResponse { get; set; }
}
```

#### Retry and Fallback Logic

```
AGENT REQUEST WITH RETRY:

1. SEND REQUEST
   ├─ Timeout: 10 seconds
   └─ Retry up to 2 times

2. ON SUCCESS
   ├─ Return agent response
   └─ Log success and timing

3. ON TIMEOUT/FAILURE
   ├─ First retry: Immediate
   ├─ Second retry: After 1 second
   ├─ If all fail: Use fallback response
   └─ Log failures for monitoring

FALLBACK RESPONSES (by scenario):
├─ Query Tutor unavailable:
│  └─ "Let me help you think through this..."
├─ Database Agent unavailable:
│  └─ "That's an interesting question about the schema..."
└─ General system failure:
   └─ Redirect to manual mode or next step
```

---

## 🔄 Integration Patterns

### Pattern 1: Query Submission Flow (Service Coordination)

```
FRONTEND REQUEST:
├─ User submits query
└─ POST /api/queries/submit

CONTROLLER:
├─ Route to QueryService.ExecuteQueryAsync()

QUERY SERVICE ORCHESTRATION:
1. ValidationService.ValidateSyntaxAsync(query)
   → If error, return validation error
   
2. ValidationService.ValidateContextAsync(query, caseId)
   → If error, return context error
   
3. Execute query
   → Call database
   
4. Evaluate results
   → Compare to canonical query
   
5. AgentCommunicationService.RouteToQueryTutorAsync(request)
   → Get feedback from Query Tutor Agent
   
6. CaseService.RecordQueryAttemptAsync(...)
   → Record attempt with feedback
   
7. Check if correct
   → If yes: CaseService.AdvanceToNextQuestionAsync()
   → If no: Return feedback

RESPONSE BACK TO FRONTEND:
├─ QueryExecutionResponse with evaluation
└─ UI displays feedback
```

### Pattern 2: Schema Request Flow (Service Coordination)

```
STUDENT QUESTION: "What is the Amount column?"

FRONTEND REQUEST:
├─ POST /api/schema/column
└─ {caseId, tableName, columnName, studentTier}

CONTROLLER:
├─ Route to SchemaService.GetColumnInfoAsync()

SCHEMA SERVICE:
1. Load schema metadata
   
2. Format response based on studentTier
   ├─ Tier 1: Concrete, simple language
   ├─ Tier 2: Technical, structured
   ├─ Tier 3: Quality-focused
   └─ Tier 4+: Strategic, ambiguity-aware
   
3. Return tier-appropriate response

IF COMPLEX EXPLANATION NEEDED:
├─ AgentCommunicationService.RouteToDatabaseAgentAsync()
└─ Get detailed explanation from Database Agent

RESPONSE BACK TO FRONTEND:
├─ ColumnInfoResponse with explanation
└─ UI displays schema information
```

### Pattern 3: Tier Advancement Flow (Service Coordination)

```
CASE COMPLETED:

CASE SERVICE:
├─ Case status → COMPLETED
└─ Call TierProgressionService.CheckTierProgressionAsync()

TIER PROGRESSION SERVICE:
1. Get completed cases in tier: 3
2. Get required cases: 3
3. Compare: 3 >= 3 → Tier complete!
4. Call PromoteStudentAsync()

PROMOTION LOGIC:
1. Get promotion info via TierAdvancementResponse
2. Update student tier in database
3. Unlock next tier cases
4. Award achievement badge
5. Return promotion details

RESPONSE TO FRONTEND:
├─ PromotionResponse
└─ UI displays promotion ceremony
```

---

## 🔐 Error Handling Strategy

### Service Exception Hierarchy

```csharp
ServiceException (Base)
├─ ValidationException (400)
│  ├─ SyntaxValidationException
│  ├─ ContextValidationException
│  └─ BusinessRuleException
├─ NotFoundException (404)
│  ├─ CaseNotFoundException
│  ├─ SessionNotFoundException
│  └─ SchemaNotFoundException
├─ StateException (409)
│  ├─ InvalidCaseStateException
│  └─ InvalidTransitionException
├─ ExternalServiceException (503)
│  ├─ DatabaseException
│  ├─ AgentCommunicationException
│  └─ LLMServiceException
└─ SystemException (500)
   ├─ UnexpectedException
   └─ ConfigurationException
```

### Error Response Format

```csharp
public class ErrorResponse
{
    public string ErrorCode { get; set; }        // "VALIDATION_ERROR"
    public string Message { get; set; }
  public string UserMessage { get; set; }  // For display to user
    public int HttpStatusCode { get; set; }
    public string TraceId { get; set; }
    public List<ErrorDetail> Details { get; set; }
}

public class ErrorDetail
{
    public string Field { get; set; }
 public string Message { get; set; }
    public string Suggestion { get; set; }
}
```

---

## 💾 Caching Strategy

### What to Cache

```
SCHEMA (Cache Duration: 1 hour)
├─ Case schema metadata
├─ Table definitions
└─ Column information

HINTS (Cache Duration: 24 hours)
├─ Question patterns by tier
├─ Hint templates
└─ Agent responses (if deterministic)

CASE DEFINITIONS (Cache Duration: 24 hours)
├─ Case narrative
├─ Questions
├─ Expected results
└─ Canonical queries

USER PROGRESS (Cache Duration: 1 minute)
├─ Current case state (short TTL, frequent changes)
└─ Tier information

VALIDATION RESULTS (Cache Duration: 5 minutes)
├─ Query validation results (for identical queries)
└─ Schema validation results
```

### Cache Invalidation

```
INVALIDATE CACHE WHEN:
├─ Admin updates case content
├─ Schema changes (dev/test only, not production)
├─ Tier progression rules change
├─ New agent version deployed
└─ Student explicitly clears progress (manual reset)
```

---

## 📊 API Endpoints Summary

### Case Management Endpoints

```
POST   /api/cases/initialize        → Start case
GET    /api/cases/{sessionId}         → Get case state
POST   /api/cases/{sessionId}/submit  → Submit query
GET    /api/cases/{sessionId}/next  → Advance question
POST   /api/cases/{sessionId}/complete → Complete case
POST   /api/cases/{sessionId}/abandon → Abandon case (Phase 2+)
```

### Query Execution Endpoints

```
POST /api/queries/execute           → Execute and evaluate query
POST   /api/queries/validate          → Validate without executing
POST   /api/queries/{id}/cancel       → Cancel long-running query
GET    /api/queries/{id}/result    → Get query results
```

### Schema Endpoints

```
GET    /api/schema/cases/{caseId}     → Get full schema for case
GET    /api/schema/tables/{caseId}/{table}    → Get table info
GET    /api/schema/columns/{caseId}/{table}/{column} → Get column info
GET    /api/schema/relationships/{caseId}     → Get relationships
GET    /api/schema/quality/{caseId}/{table}   → Get data quality info
```

### Hint & Agent Endpoints

```
GET    /api/hints/current → Get current hint
POST   /api/hints/escalate   → Request escalated hint
POST   /api/agents/query-tutor → Route to Query Tutor
POST   /api/agents/database-agent     → Route to Database Agent
```

### Tier Management Endpoints

```
GET    /api/tiers/progression     → Check tier progression
GET    /api/tiers/advancement         → Get advancement info
POST   /api/tiers/promote   → Promote student
```

---

## 🧪 Testing Considerations

### Unit Testing

```
✓ Service interfaces can be mocked
✓ Dependency injection enables testing
✓ Each service testable independently
✓ Validation logic testable without DB
✓ Error scenarios testable via mock failures
```

### Integration Testing

```
✓ Services coordinate correctly
✓ Data flows through service layer properly
✓ Database operations work correctly
✓ Agent communication works with mocks
✓ Error handling works end-to-end
```

### Performance Testing

```
✓ Query execution: < 30 seconds
✓ Service response: < 500ms (typical)
✓ Agent response: < 10 seconds
✓ Schema queries: < 200ms
✓ Caching improves repeated requests by 50%+
```

---

## 📚 Related Documents

**Core Standards:**
- `DataQuest-Tier-System-Official-Design-Guideline.md`
- `Query-Tutor-Agent-Implementation-Specification.md`
- `Database-Agent-Implementation-Specification.md`

**Integration Points:**
- `UI-UX-Design-Specification.md`
- `Case-Lifecycle-and-State-Management.md`
- `Agent-Prompt-Engineering-Standards.md` (Gap #8)

**Case Design:**
- `Case-Design-Template-and-Examples.md` (Gap #6)

---

## ✅ Implementation Checklist

### Design Phase

```
[ ] Review service architecture
[ ] Validate service boundaries
[ ] Review interface contracts
[ ] Plan caching strategy
[ ] Design error handling approach
```

### Development Phase

```
[ ] Implement Case Service
[ ] Implement Query Service
[ ] Implement Validation Service
[ ] Implement Schema Service
[ ] Implement Hint Service
[ ] Implement Tier Progression Service
[ ] Implement Agent Communication Service
[ ] Create service interfaces (contracts)
[ ] Implement dependency injection
[ ] Implement error handling
[ ] Implement caching layer
```

### Testing Phase

```
[ ] Unit test each service
[ ] Unit test error scenarios
[ ] Integration test service coordination
[ ] Integration test with agents
[ ] Performance test service responses
[ ] Test caching behavior
[ ] Test cache invalidation
```

### QA Validation

```
[ ] Verify all services follow specification
[ ] Verify error handling is correct
[ ] Verify performance metrics met
[ ] Verify caching works correctly
[ ] Verify agent communication works
[ ] Verify tier progression works
```

---

## 🎓 Conclusion

The API and Service Layer Architecture is the **backbone of DataQuest's backend**. This specification ensures that all components communicate efficiently, errors are handled gracefully, and the system scales effectively.

**Key Success Factors:**

1. **Clear contracts** - Well-defined service interfaces
2. **Proper separation of concerns** - Each service has single responsibility
3. **Robust error handling** - Graceful failure recovery
4. **Performance** - Meet all response time targets
5. **Testability** - All services independently testable
6. **Scalability** - Support concurrent users
7. **Agent integration** - Seamless LLM coordination

---

**IMPLEMENTATION SPECIFICATION COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR BACKEND DEVELOPMENT**

