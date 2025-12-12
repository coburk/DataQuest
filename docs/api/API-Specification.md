# API Specification & OpenAPI/Swagger Documentation

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - API CONTRACTS  
**Version:** 1.0  
**Classification:** Critical - Required Before Phase 1

---

## 📋 Document Purpose

This specification provides complete API documentation for DataQuest, including detailed endpoint specifications, request/response contracts, authentication, rate limiting, and error handling. It serves as the single source of truth for all API consumers (frontend, mobile, external integrations).

**This document enables:**
- ✅ Frontend developers to implement client code
- ✅ External integrations to connect reliably
- ✅ QA to validate endpoints
- ✅ API monitoring and documentation tools
- ✅ SDK generation (if needed)

---

## 🎯 Scope

### What This Document Covers

```
✅ Complete API endpoint reference (all 7 services)
✅ Request/response contracts (JSON Schema)
✅ Authentication & authorization
✅ Rate limiting strategy
✅ Error handling & status codes
✅ Pagination standards
✅ Versioning strategy
✅ Examples for each endpoint
✅ OpenAPI 3.0 specification
✅ Performance requirements per endpoint
```

### What This Document Does NOT Cover

```
❌ Frontend implementation details
❌ Backend service implementation
❌ Database queries or schema
❌ Internal service-to-service communication
```

---

## 🏗️ API Architecture Overview

### Service Layer (from Spec #5: API & Service Layer Architecture)

```
HTTP Client
    ↓
┌──────────────────────────────────────┐
│        API Layer (ASP.NET Core)      │
│      │
│  Controllers / Route Handlers        │
└──────────────────────────────────────┘
    ↓
┌──────────────────────────────────────┐
│   7 Core Services         │
│           │
│  • QueryService     │
│  • SchemaService         │
│  • CaseService               │
│  • ValidationService            │
│  • HintService    │
│  • TierService     │
│  • SessionService    │
└──────────────────────────────────────┘
    ↓
┌──────────────────────────────────────┐
│   MCP Layer (Database)      │
│     │
│  MSSQL Server        │
└──────────────────────────────────────┘
```

### Base URL

```
Development:  http://localhost:5000
Staging: https://staging-api.dataquest.dev
Production:   https://api.dataquest.dev

API Version:  /api/v1/
```

---

## 🔐 Authentication & Authorization

### Authentication Strategy

**Method:** JWT (JSON Web Tokens)

```
All API endpoints require authentication (except /api/v1/auth/login)

Header Format:
Authorization: Bearer <JWT_TOKEN>

Token Format:
{
  "alg": "HS256",
  "typ": "JWT",
  "header": {
    "kid": "current-key-id",
    "alg": "HS256"
  },
  "payload": {
    "sub": "student_123",  // Student ID
    "tier": "Junior Data Analyst", // Current tier
    "session_id": "session_abc",   // Session ID
    "iat": 1733191200,        // Issued at
    "exp": 1733277600             // Expires in 24 hours
  },
  "signature": "..."
}

Token Lifetime: 24 hours
Refresh Strategy: Use refresh token endpoint (see Auth Service)
```

### Authorization Model

**Role-Based Access Control (RBAC)**

```
Roles:
├─ Student (default)
│  └─ Can: View cases, submit queries, progress through tiers
│  └─ Cannot: Create cases, manage other students
│
├─ Instructor (Phase 2+)
│  └─ Can: View student progress, create cases, manage content
│  └─ Cannot: Modify system configuration
│
└─ Admin (Phase 2+)
   └─ Can: All operations
   └─ Cannot: Create elevated privileges
```

**Header Usage:**

```
GET /api/v1/cases HTTP/1.1
Host: api.dataquest.dev
Authorization: Bearer eyJhbGc...
X-Request-ID: uuid-for-tracing
Accept: application/json
```

---

## 🚦 Rate Limiting

### Rate Limit Strategy

```
Per-Student Limits (per hour):
├─ Query submissions: 100 requests
├─ Schema queries: 500 requests
├─ Schema introspection: 1000 requests
└─ General API calls: 1000 requests

Headers Returned:
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1733277600

Exceeded Limit Response:
HTTP 429 Too Many Requests
{
"status": 429,
  "message": "Rate limit exceeded",
  "retry_after": 3600
}

Sliding Window: 1 hour
Grace Period: None (strict limits)
Burst Handling: No burst allowance
```

### Per-Endpoint Limits

```
Query Execution:
├─ Students: 100/hour
├─ Tier multiplier: 1.0x (all tiers equal)
└─ Burst: Not allowed

Schema Queries:
├─ Students: 500/hour
├─ Tier multiplier: 1.0x
└─ Burst: Not allowed

Hint Requests:
├─ Students: 200/hour
├─ Tier multiplier: 1.0x
└─ Burst: Not allowed
```

---

## 📊 Core API Endpoints

### 1. Authentication Service Endpoints

#### POST /api/v1/auth/login

**Purpose:** Authenticate student and receive JWT token

**Request:**
```json
{
  "email": "student@university.edu",
  "password": "secure_password_hash"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
"refresh_token": "refresh_token_xyz",
  "expires_in": 86400,
  "student": {
    "id": "student_123",
    "name": "John Doe",
    "tier": "Junior Data Analyst",
 "email": "student@university.edu"
  }
}
```

**Error (401 Unauthorized):**
```json
{
  "status": 401,
  "error": "INVALID_CREDENTIALS",
  "message": "Email or password is incorrect"
}
```

**Rate Limit:** 10/hour per IP  
**Authentication:** None (public endpoint)  
**Performance Target:** < 200ms

---

#### POST /api/v1/auth/refresh

**Purpose:** Refresh expired JWT token

**Request:**
```json
{
  "refresh_token": "refresh_token_xyz"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 86400
}
```

**Rate Limit:** 20/hour per student  
**Authentication:** Required (refresh token)  
**Performance Target:** < 100ms

---

### 2. Query Service Endpoints

#### POST /api/v1/queries/execute

**Purpose:** Execute student's SQL query and return results

**Request:**
```json
{
  "session_id": "session_abc123",
  "query": "SELECT CustomerID, Code FROM CodeLog WHERE Status = 'Missing'",
  "question_index": 0,
  "case_id": "case_tier1_001"
}
```

**Response (200 OK):**
```json
{
  "execution_id": "exec_xyz789",
  "status": "SUCCESS",
  "query_submitted": "SELECT CustomerID, Code FROM CodeLog WHERE Status = 'Missing'",
  "results": {
    "column_names": ["CustomerID", "Code"],
    "row_count": 23,
    "rows": [
      {"CustomerID": 101, "Code": "ABC123"},
      {"CustomerID": 102, "Code": "DEF456"},
      "... 21 more rows"
    ]
  },
  "execution_time_ms": 145,
  "evaluation": {
    "is_correct": true,
    "expected_row_count": 23,
    "actual_row_count": 23,
    "feedback": "Excellent! You found all 23 missing codes!"
  }
}
```

**Error Responses:**

**400 Bad Request - Syntax Error:**
```json
{
  "status": 400,
  "error": "SYNTAX_ERROR",
  "message": "Unexpected token 'SLECT' on line 1",
  "line": 1,
  "column": 1,
  "suggestion": "Did you mean: SELECT?"
}
```

**400 Bad Request - Context Error:**
```json
{
  "status": 400,
  "error": "CONTEXT_ERROR",
  "message": "Table 'InvalidTable' not found in case schema"
}
```

**408 Request Timeout:**
```json
{
  "status": 408,
  "error": "QUERY_TIMEOUT",
  "message": "Query exceeded 30 second timeout",
  "suggestion": "Try adding a WHERE clause to narrow results"
}
```

**429 Too Many Requests:**
```json
{
  "status": 429,
  "error": "RATE_LIMIT_EXCEEDED",
  "message": "Rate limit exceeded: 100 queries per hour",
  "retry_after": 3600
}
```

**Rate Limit:** 100/hour per student  
**Authentication:** Required (JWT)  
**Performance Target:** < 3 seconds (simple), < 30 seconds (complex)

---

#### GET /api/v1/queries/{execution_id}

**Purpose:** Retrieve previous query execution result

**Response (200 OK):**
```json
{
  "execution_id": "exec_xyz789",
  "status": "SUCCESS",
  "query": "SELECT CustomerID, Code FROM CodeLog WHERE Status = 'Missing'",
  "results": { ... },
  "execution_time_ms": 145,
  "created_at": "2025-12-03T10:30:00Z"
}
```

**Rate Limit:** 500/hour  
**Authentication:** Required  
**Performance Target:** < 100ms

---

### 3. Schema Service Endpoints

#### GET /api/v1/schema/case/{case_id}

**Purpose:** Get database schema for a specific case

**Response (200 OK):**
```json
{
  "case_id": "case_tier1_001",
  "schema": {
  "tables": [
      {
        "name": "CodeLog",
        "description": "Records of codes entered into the system",
        "row_count": 1247,
        "columns": [
          {
     "name": "CodeID",
  "type": "INT",
      "description": "Unique code identifier",
     "nullable": false,
       "is_primary_key": true,
    "indexed": true
        },
   {
            "name": "Code",
            "type": "VARCHAR(10)",
    "description": "The code value",
       "nullable": false,
   "indexed": false
          },
       {
     "name": "Status",
   "type": "VARCHAR(20)",
  "description": "Current status (Active, Missing, Closed)",
    "nullable": false,
   "values": ["Active", "Missing", "Closed"]
      },
       {
 "name": "CreatedDate",
        "type": "DATETIME",
         "description": "When code was entered",
            "nullable": false
  },
          {
     "name": "CustomerID",
     "type": "INT",
    "description": "Which customer entered code",
        "nullable": false,
          "is_foreign_key": true,
    "references": {
        "table": "Customers",
          "column": "CustomerID"
      }
          }
    ]
      },
      {
     "name": "Customers",
        "description": "Customer information",
        "row_count": 47,
    "columns": [
          {
            "name": "CustomerID",
         "type": "INT",
  "description": "Unique customer identifier",
            "nullable": false,
   "is_primary_key": true
          },
          {
            "name": "CustomerName",
            "type": "VARCHAR(100)",
    "description": "Customer name",
     "nullable": false
 }
        ]
      }
    ],
    "relationships": [
 {
        "from_table": "CodeLog",
        "from_column": "CustomerID",
        "to_table": "Customers",
     "to_column": "CustomerID",
        "type": "ManyToOne",
        "description": "Each code belongs to one customer"
      }
    ]
  },
  "cached": true,
  "cache_expires_at": "2025-12-03T11:30:00Z"
}
```

**Rate Limit:** 500/hour  
**Authentication:** Required  
**Performance Target:** < 200ms (cached)  
**Caching:** 1 hour TTL

---

#### GET /api/v1/schema/case/{case_id}/table/{table_name}

**Purpose:** Get details about a specific table in case schema

**Response (200 OK):**
```json
{
  "case_id": "case_tier1_001",
  "table": {
    "name": "CodeLog",
    "description": "Records of codes entered into the system",
    "row_count": 1247,
    "columns": [ ... ],
    "indexes": [
   {
        "name": "IX_CodeLog_Status",
        "columns": ["Status"],
        "type": "Non-clustered"
      }
    ],
    "constraints": [
      {
        "name": "PK_CodeLog",
        "type": "Primary Key",
        "columns": ["CodeID"]
  },
      {
  "name": "FK_CodeLog_Customer",
        "type": "Foreign Key",
        "columns": ["CustomerID"],
        "references": "Customers(CustomerID)"
      }
    ]
  }
}
```

**Rate Limit:** 1000/hour  
**Authentication:** Required  
**Performance Target:** < 100ms

---

### 4. Case Service Endpoints

#### GET /api/v1/cases

**Purpose:** Get list of available cases for student's tier

**Query Parameters:**
```
?tier=Junior Data Analyst (optional - uses student's current tier if omitted)
?status=available|completed (optional - filter by status)
?limit=10 (optional - default 20, max 100)
?offset=0 (optional - for pagination)
```

**Response (200 OK):**
```json
{
  "cases": [
    {
      "case_id": "case_tier1_001",
      "name": "The Missing Code",
      "description": "Find all missing codes in the system",
      "tier": "Junior Data Analyst",
      "status": "available",
      "estimated_duration_minutes": 12,
      "difficulty": "simple",
    "questions_count": 3,
      "progress": {
        "completed": false,
        "current_question": 0,
"total_questions": 3
      }
 },
    {
    "case_id": "case_tier1_002",
 "name": "Timeline Discrepancy",
  "description": "Analyze transaction timeline inconsistencies",
      "tier": "Junior Data Analyst",
      "status": "available",
      "estimated_duration_minutes": 15,
 "difficulty": "simple",
      "questions_count": 3
    }
  ],
  "pagination": {
    "limit": 20,
    "offset": 0,
    "total": 45,
    "has_more": true
  }
}
```

**Rate Limit:** 100/hour  
**Authentication:** Required  
**Performance Target:** < 200ms  
**Pagination:** Offset-based, max 100 per page

---

#### GET /api/v1/cases/{case_id}

**Purpose:** Get detailed case information

**Response (200 OK):**
```json
{
  "case_id": "case_tier1_001",
  "name": "The Missing Code",
  "tier": "Junior Data Analyst",
  "narrative": {
    "title": "Investigation Title",
    "context": "You're a Junior Data Analyst investigating a customer complaint...",
    "investigation_goal": "Find all missing codes in the system"
  },
  "schema": { ... },
  "questions": [
    {
   "question_index": 0,
   "question_id": "q_001",
      "text": "Which customer codes have Status = 'Missing'?",
      "hints": [
        "What tables contain the information we need?",
        "The CodeLog table has Status and Code columns",
 "You might use SELECT... FROM... WHERE..."
      ]
    },
    { ... }
  ],
  "estimated_duration_minutes": 12
}
```

**Rate Limit:** 200/hour  
**Authentication:** Required  
**Performance Target:** < 300ms

---

#### POST /api/v1/cases/{case_id}/start

**Purpose:** Initialize a case and create a session

**Request:**
```json
{
  "student_tier": "Junior Data Analyst"
}
```

**Response (200 OK):**
```json
{
  "session_id": "session_abc123",
  "case_id": "case_tier1_001",
  "started_at": "2025-12-03T10:00:00Z",
  "expires_at": "2025-12-03T18:00:00Z",
  "current_question": 0,
  "case_details": { ... }
}
```

**Rate Limit:** 50/hour  
**Authentication:** Required  
**Performance Target:** < 300ms

---

#### POST /api/v1/cases/{case_id}/complete

**Purpose:** Mark case as completed

**Request:**
```json
{
  "session_id": "session_abc123",
  "completion_time_seconds": 412
}
```

**Response (200 OK):**
```json
{
  "session_id": "session_abc123",
  "status": "COMPLETED",
  "completion_summary": {
    "completed_at": "2025-12-03T10:06:52Z",
    "total_time_seconds": 412,
    "questions_answered": 3,
    "accuracy_rate": 1.0,
    "tier_progress": {
      "cases_completed": 2,
      "cases_required": 3,
  "tier_complete": false
    }
  }
}
```

**Rate Limit:** 20/hour  
**Authentication:** Required  
**Performance Target:** < 500ms

---

### 5. Hints & Feedback Service Endpoints

#### POST /api/v1/hints/request

**Purpose:** Request hint from Query Tutor agent

**Request:**
```json
{
  "session_id": "session_abc123",
  "question_index": 0,
  "hint_level": 1,
  "query_submitted": "SELECT * FROM CodeLog"
}
```

**Response (200 OK):**
```json
{
  "hint_id": "hint_xyz789",
  "level": 1,
  "content": "What tables contain the information we need?",
  "context": "Socratic level 1 - asking clarifying questions",
  "next_level_available": true,
  "can_request_more": true
}
```

**Rate Limit:** 200/hour  
**Authentication:** Required  
**Performance Target:** < 10 seconds (includes LLM call)

---

#### GET /api/v1/hints/history/{session_id}

**Purpose:** Get hint history for a session

**Response (200 OK):**
```json
{
  "session_id": "session_abc123",
  "case_id": "case_tier1_001",
  "hints": [
    {
      "question_index": 0,
      "level": 1,
      "content": "What tables contain the information we need?",
    "requested_at": "2025-12-03T10:05:00Z"
    },
    {
      "question_index": 0,
      "level": 2,
      "content": "The CodeLog table has Status and Code columns",
      "requested_at": "2025-12-03T10:06:00Z"
    }
  ]
}
```

**Rate Limit:** 500/hour  
**Authentication:** Required  
**Performance Target:** < 200ms

---

### 6. Session Service Endpoints

#### GET /api/v1/sessions/current

**Purpose:** Get current active session

**Response (200 OK):**
```json
{
  "session_id": "session_abc123",
  "case_id": "case_tier1_001",
  "student_id": "student_123",
  "started_at": "2025-12-03T10:00:00Z",
  "last_activity": "2025-12-03T10:30:45Z",
  "expires_at": "2025-12-03T18:00:00Z",
  "state": "ACTIVE",
  "current_question": 1,
  "progress": {
    "questions_completed": 1,
    "total_questions": 3
  }
}
```

**Rate Limit:** 100/hour  
**Authentication:** Required  
**Performance Target:** < 100ms

---

#### POST /api/v1/sessions/{session_id}/save

**Purpose:** Save session state

**Request:**
```json
{
  "current_question": 1,
  "query_attempts": [
    {
      "question_index": 0,
      "query": "SELECT CustomerID, Code FROM CodeLog WHERE Status = 'Missing'",
      "result": "correct",
      "hint_level_at_submission": 1
    }
  ]
}
```

**Response (200 OK):**
```json
{
  "session_id": "session_abc123",
  "saved_at": "2025-12-03T10:31:00Z",
  "state": "SAVED"
}
```

**Rate Limit:** 50/hour  
**Authentication:** Required  
**Performance Target:** < 500ms

---

### 7. Tier Service Endpoints

#### GET /api/v1/tiers/current

**Purpose:** Get student's current tier information

**Response (200 OK):**
```json
{
  "student_id": "student_123",
  "current_tier": "Junior Data Analyst",
  "tier_number": 1,
  "progress": {
    "cases_completed": 2,
    "cases_required": 3,
    "tier_complete": false,
    "percentage": 66
  },
  "next_tier": {
    "name": "Senior Data Analyst",
    "tier_number": 2,
    "unlock_requirements": "Complete 3 Junior Data Analyst cases",
    "benefits": "Multi-table queries, JOINs, GROUP BY operations"
  }
}
```

**Rate Limit:** 200/hour  
**Authentication:** Required  
**Performance Target:** < 100ms

---

#### GET /api/v1/tiers

**Purpose:** Get all tier information and progression

**Response (200 OK):**
```json
{
  "tiers": [
    {
      "tier_number": 1,
      "name": "Junior Data Analyst",
      "status": "COMPLETED",
      "completed_at": "2025-12-01T15:30:00Z",
      "badge": "bronze"
    },
    {
   "tier_number": 2,
   "name": "Senior Data Analyst",
      "status": "IN_PROGRESS",
      "progress": 40,
      "badge": "silver"
    },
    {
      "tier_number": 3,
      "name": "Data Inspector",
      "status": "LOCKED",
      "badge": "gold"
    },
    { ... }
  ],
  "total_cases_completed": 2,
  "total_time_hours": 2.5
}
```

**Rate Limit:** 100/hour  
**Authentication:** Required  
**Performance Target:** < 200ms

---

## 📋 Error Handling

### Standard Error Response Format

```json
{
  "status": 400,
  "error": "ERROR_CODE",
  "message": "Human-readable error message",
  "request_id": "uuid-for-tracing",
  "timestamp": "2025-12-03T10:30:00Z",
  "details": {
    "field": "optional field-specific details"
  }
}
```

### HTTP Status Codes

```
✅ 2xx Success:
  200 OK      - Request successful
  201 Created    - Resource created
  204 No Content         - Request successful, no content

⚠️  4xx Client Error:
  400 Bad Request   - Invalid request format
  401 Unauthorized         - Authentication failed
  403 Forbidden        - Authorization failed
  404 Not Found      - Resource not found
  408 Request Timeout      - Query/processing timeout
  409 Conflict             - State conflict (e.g., duplicate)
  429 Too Many Requests    - Rate limit exceeded

❌ 5xx Server Error:
  500 Internal Server Error      - Unexpected server error
  502 Bad Gateway   - Gateway error
  503 Service Unavailable        - Service temporarily down
  504 Gateway Timeout         - Service not responding
```

### Error Code Reference

```
Authentication:
  INVALID_CREDENTIALS  - Email or password incorrect
  TOKEN_EXPIRED           - JWT token expired
  TOKEN_INVALID             - JWT token invalid
  UNAUTHORIZED         - Not authenticated

Authorization:
  INSUFFICIENT_PERMISSIONS  - Not authorized for operation
  TIER_LOCKED_CASE         - Case locked for student's tier

Query Execution:
  SYNTAX_ERROR  - SQL syntax error
  CONTEXT_ERROR     - Table/column not found
  QUERY_TIMEOUT             - Query exceeded time limit
  DB_CONNECTION_ERROR       - Cannot connect to database
  QUERY_TOO_LONG       - Query exceeds max length

Validation:
  VALIDATION_ERROR        - Request validation failed
  INVALID_JSON   - Request body not valid JSON

Resource:
  NOT_FOUND       - Resource doesn't exist
  DUPLICATE_RESOURCE     - Resource already exists
  STATE_CONFLICT      - Invalid state for operation

Rate Limiting:
  RATE_LIMIT_EXCEEDED       - Too many requests

Server:
  INTERNAL_ERROR      - Unexpected server error
  SERVICE_UNAVAILABLE       - Service temporarily unavailable
  GATEWAY_ERROR   - Gateway/proxy error
```

---

## 📝 Request/Response Schemas (JSON Schema)

### Query Execution Request

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["session_id", "query", "question_index", "case_id"],
  "properties": {
    "session_id": {
      "type": "string",
      "pattern": "^session_[a-z0-9]{12}$",
      "description": "Valid session ID"
    },
    "query": {
"type": "string",
      "minLength": 1,
   "maxLength": 50000,
      "description": "SQL query to execute"
    },
    "question_index": {
      "type": "integer",
      "minimum": 0,
   "maximum": 10,
 "description": "Question index (0-based)"
    },
    "case_id": {
      "type": "string",
      "pattern": "^case_[a-z0-9_]{8,}$",
   "description": "Valid case ID"
    }
  }
}
```

### Query Execution Response

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["execution_id", "status", "query_submitted", "results"],
  "properties": {
    "execution_id": {
      "type": "string",
      "description": "Unique execution identifier"
    },
    "status": {
      "type": "string",
      "enum": ["SUCCESS", "SYNTAX_ERROR", "CONTEXT_ERROR", "TIMEOUT", "DB_ERROR"],
      "description": "Execution status"
    },
    "query_submitted": {
      "type": "string",
      "description": "The query that was executed"
    },
    "results": {
 "type": "object",
      "properties": {
        "column_names": {"type": "array", "items": {"type": "string"}},
        "row_count": {"type": "integer"},
        "rows": {"type": "array"}
      }
    },
    "evaluation": {
      "type": "object",
      "properties": {
        "is_correct": {"type": "boolean"},
        "feedback": {"type": "string"}
      }
    }
  }
}
```

---

## 🔄 Pagination Standard

### Request Format

```
GET /api/v1/cases?limit=20&offset=0

Query Parameters:
- limit: Number of items per page (default: 20, max: 100)
- offset: Number of items to skip (default: 0)
```

### Response Format

```json
{
  "data": [ ... ],
  "pagination": {
    "limit": 20,
    "offset": 0,
    "total": 87,
    "has_more": true,
    "page_number": 1,
    "total_pages": 5
  }
}
```

---

## 🏃 Performance & Monitoring

### Performance Targets Per Endpoint

```
Authentication:
  POST /auth/login          < 200ms
  POST /auth/refresh < 100ms

Cases:
  GET /cases            < 200ms
  GET /cases/{id}           < 300ms
  POST /cases/{id}/start    < 300ms
  POST /cases/{id}/complete < 500ms

Queries:
  POST /queries/execute     < 3 seconds (simple)
         < 30 seconds (complex)
  GET /queries/{id}         < 100ms

Schema:
  GET /schema/case/{id}     < 200ms (cached)
  GET /schema/table/{id}    < 100ms

Hints:
  POST /hints/request       < 10 seconds (includes LLM)
  GET /hints/history     < 200ms

Sessions:
  GET /sessions/current     < 100ms
  POST /sessions/save       < 500ms

Tiers:
  GET /tiers/current        < 100ms
  GET /tiers         < 200ms
```

### Monitoring Headers

All responses include:

```
X-Request-ID: <uuid>     - Unique request identifier
X-Response-Time: <milliseconds>         - Response time in ms
X-API-Version: 1         - API version
X-RateLimit-Limit: <number>            - Rate limit
X-RateLimit-Remaining: <number>        - Remaining requests
X-RateLimit-Reset: <unix_timestamp>    - When limit resets
```

---

## 🚀 OpenAPI 3.0 Specification

**File:** `openapi.yaml` (separate file, included in deployment)

**Location:** `docs/api/openapi.yaml`

```yaml
openapi: 3.0.0
info:
  title: DataQuest API
  version: 1.0.0
  description: SQL learning platform API

servers:
  - url: https://api.dataquest.dev
    description: Production
  - url: https://staging-api.dataquest.dev
    description: Staging
  - url: http://localhost:5000
    description: Development

paths:
  /api/v1/auth/login:
    post:
      # ... Full endpoint definition
  # ... All other endpoints

components:
  schemas:
    QueryExecutionRequest:
      # ... Schema definition
    QueryExecutionResponse:
      # ... Schema definition
    Error:
      # ... Error schema

  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
```

---

## 📱 Client Implementation Examples

### JavaScript/TypeScript

```typescript
// Example using fetch
const response = await fetch('https://api.dataquest.dev/api/v1/queries/execute', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
    'X-Request-ID': generateUUID()
  },
  body: JSON.stringify({
    session_id: 'session_abc123',
    query: 'SELECT * FROM CodeLog WHERE Status = ?',
    question_index: 0,
    case_id: 'case_tier1_001'
  })
});

const data = await response.json();
```

### C# / .NET

```csharp
// Example using HttpClient
using var client = new HttpClient();
client.DefaultRequestHeaders.Authorization = 
    new AuthenticationHeaderValue("Bearer", token);

var request = new { 
    session_id = "session_abc123",
query = "SELECT * FROM CodeLog WHERE Status = ?",
    question_index = 0,
    case_id = "case_tier1_001"
};

var response = await client.PostAsJsonAsync(
    "https://api.dataquest.dev/api/v1/queries/execute", 
    request);

var result = await response.Content.ReadAsAsync<QueryExecutionResponse>();
```

---

## ✅ Implementation Checklist

### API Specification

```
□ All 7 services have endpoints documented
□ Request/response contracts defined (JSON Schema)
□ Authentication & authorization specified
□ Rate limiting per endpoint defined
□ Error codes and messages documented
□ Performance targets per endpoint set
□ Pagination standards defined
□ Examples provided for each endpoint
□ OpenAPI 3.0 spec generated (openapi.yaml)
□ Monitoring headers specified
```

### Documentation

```
□ API docs hosted and searchable
□ Swagger UI available for exploration
□ Code samples in multiple languages
□ Troubleshooting guide created
□ API versioning strategy documented
□ Deprecation policy defined
□ SDK generation approach defined (if needed)
```

### Testing

```
□ All endpoints tested (unit tests)
□ Integration tests for workflows
□ Performance tests run
□ Rate limiting tested
□ Error scenarios tested
□ Security tests (JWT, CORS, etc.)
```

---

## 🔗 Related Documents

**Core Specifications:**
- `API-and-Service-Layer-Architecture.md` (Spec #5)
- `Testing-and-QA-Implementation-Guide.md` (Spec #7)

**Infrastructure Documentation (To Be Created):**
- Logging & Observability Strategy
- Security & Authentication Strategy
- CI/CD Pipeline Configuration

---

## 📞 Usage

### For Frontend Developers

1. Read this specification
2. Review OpenAPI spec (openapi.yaml) in IDE
3. Import into Postman or similar tool
4. Use code examples as reference
5. Follow rate limits and retry logic
6. Handle errors per spec

### For Backend Developers

1. Implement each endpoint per spec
2. Validate request schemas
3. Return response schemas as specified
4. Track performance metrics
5. Return monitoring headers
6. Implement rate limiting

### For DevOps/Infrastructure

1. Configure API gateway with rate limiting
2. Set up monitoring for performance targets
3. Configure logging for all requests
4. Set up alerting for error rates
5. Implement CORS policy
6. Configure TLS/HTTPS

---

**API SPECIFICATION COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR IMPLEMENTATION**

