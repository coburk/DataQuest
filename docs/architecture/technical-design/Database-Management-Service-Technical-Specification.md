# 📐 TECHNICAL SPECIFICATION - Application-Level Database Management Service

**Document:** CHG-002 Technical Specification  
**Date:** December 5, 2025  
**Status:** PROPOSED FOR IMPLEMENTATION  
**Version:** 1.0  

---

## 🎯 OVERVIEW

This document provides detailed technical specifications for implementing the application-level database management service in the DataQuest .NET 9 application.

---

## 📋 REQUIREMENTS SPECIFICATION

### Functional Requirements

**FR-001: Database Creation**
```
Requirement: Application must be able to create DataQuest database schema
Inputs: Database connection string, migration script path
Outputs: Successfully created database with all tables
Behavior:
  1. Validate connection string
  2. Connect to SQL Server
  3. Execute V001_InitialSchema.sql
  4. Verify all tables created
  5. Return success status
Error Handling: Log and return descriptive error if creation fails
Performance: Must complete within 5 seconds
```

**FR-002: Database Deletion**
```
Requirement: Application must be able to delete DataQuest database
Inputs: Database connection string, user confirmation
Outputs: Database deleted
Behavior:
  1. Validate environment (Development only)
  2. Require explicit user confirmation
  3. Check rate limiting (no delete within 5 minutes)
  4. Connect to SQL Server
  5. Drop all DataQuest tables
  6. Log operation with timestamp and user
  7. Return success status
Error Handling: Log failures, display to user, prevent cascade errors
Performance: Must complete within 2 seconds
Constraint: ONLY allowed in Development environment
```

**FR-003: Database Recreation**
```
Requirement: Application must be able to recreate entire database
Inputs: Database connection string, user confirmation
Outputs: Empty, initialized database
Behavior:
  1. Call DeleteDatabaseAsync()
  2. Call CreateDatabaseAsync()
  3. Call SeedDataAsync()
  4. Verify state
  5. Return success status
Error Handling: Atomic operation - all or nothing
Performance: Must complete within 10 seconds
```

**FR-004: Seed Data Population**
```
Requirement: Application must populate seed data for Tier 1 cases
Inputs: Database connection string
Outputs: Database populated with test data
Behavior:
  1. Execute V001_SeedData_Tier1.sql
  2. Verify data inserted
  3. Return record counts
Data Inserted:
  - 2 Cases (1.1, 1.2)
  - 10 Persons
  - 6 Locations
  - 78+ records (BadgeAccess, ParkingLotAccess, etc.)
  - 4 StorySteps
  - 4 AnswerKeys
Performance: Must complete within 3 seconds
```

**FR-005: Database Status**
```
Requirement: Application must report current database state
Inputs: Database connection string
Outputs: Status object with details
Returns:
  - Is database initialized: true/false
  - Number of tables
  - Number of records per table
- Last operation timestamp
  - Last operation type
Performance: Must complete within 500ms
```

**FR-006: Migration Execution**
```
Requirement: Application must be able to apply migration scripts
Inputs: Database connection string, migration file path, version number
Outputs: Migration applied
Behavior:
  1. Validate migration file exists
  2. Check if migration already applied (from history)
  3. Execute migration script
  4. Record migration in history table
  5. Log execution details
Performance: Depends on script complexity
```

### Non-Functional Requirements

**NFR-001: Environment Validation**
```
Must not allow database deletion in non-Development environments
Must throw InvalidOperationException with clear message
Must log violation attempt
Must not proceed with any operations
```

**NFR-002: Security**
```
API endpoints require authentication
API endpoints limited to Development environment
Sensitive operations require explicit confirmation
Database credentials never logged
All operations logged with timestamp and user
```

**NFR-003: Reliability**
```
Operations must be atomic (all or nothing)
Failures must be recoverable
Must handle SQL connection failures gracefully
Must handle missing migration files gracefully
Must handle corrupted data gracefully
```

**NFR-004: Performance**
```
Database creation: < 5 seconds
Database deletion: < 2 seconds
Status check: < 500ms
API response time: < 1 second (excluding operation time)
Seed data insertion: < 3 seconds
```

**NFR-005: Logging & Auditing**
```
All operations logged with:
  - Timestamp (UTC)
  - Operation type
  - User/requestor
  - Environment
  - Success/failure
  - Duration
  - Result details
Audit trail immutable (append-only)
```

---

## 🏗️ ARCHITECTURE SPECIFICATION

### Service Architecture

```
┌─────────────────────────────────────┐
│   API Layer           │
│  ┌──────────────────────────────┐   │
│  │  DatabaseController   │   │
│  │  - POST /api/admin/db/init   │   │
│  │  - DELETE /api/admin/db      │   │
│  │  - POST /api/admin/db/recr   │   │
│  │  - GET /api/admin/db/status  │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
       ↓
┌─────────────────────────────────────┐
│   Service Layer │
│  ┌──────────────────────────────┐   │
│  │  IDatabaseManager            │   │
│  │  - CreateDatabaseAsync()  │   │
│  │  - DeleteDatabaseAsync()     │   │
││  - RecreateDatabaseAsync()   │   │
│  │  - SeedDataAsync()  │   │
│  │  - IsInitializedAsync()      │   │
│  │  - ApplyMigrationsAsync()    │   │
│  └──────────────────────────────┘   │
│ ↓             │
│  ┌──────────────────────────────┐   │
│  │  Helper Services             ││
│  │  - EnvironmentValidator      │   │
│  │  - MigrationExecutor     │   │
│  │  - SeedDataExecutor          │   │
│  │  - RateLimiter       │   │
│  │  - AuditLogger   │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
     ↓
┌─────────────────────────────────────┐
│   Infrastructure Layer            │
│  ┌──────────────────────────────┐   │
│  │  SQL Server        │   │
│  │  - Connection Pool     │   │
│  │  - Migration Files           │   │
│  │  - Audit Log Table           │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
```

### Interface Definitions

**IDatabaseManager.cs**
```csharp
public interface IDatabaseManager
{
    /// <summary>
    /// Creates the DataQuest database with initial schema
    /// </summary>
    Task<DatabaseOperationResult> CreateDatabaseAsync();
    
    /// <summary>
    /// Deletes the DataQuest database (Development only)
 /// Requires explicit confirmation
    /// </summary>
    Task<DatabaseOperationResult> DeleteDatabaseAsync(
        string confirmationToken);
    
    /// <summary>
    /// Recreates database (Delete + Create + Seed)
    /// Requires explicit confirmation
    /// </summary>
    Task<DatabaseOperationResult> RecreateDatabaseAsync(
        string confirmationToken);
    
    /// <summary>
    /// Populates database with seed data
    /// </summary>
    Task<DatabaseOperationResult> SeedDataAsync();
 
    /// <summary>
    /// Checks if database is initialized
    /// </summary>
Task<bool> IsInitializedAsync();
    
    /// <summary>
/// Gets current database status
    /// </summary>
    Task<DatabaseStatus> GetStatusAsync();
    
    /// <summary>
    /// Applies migration scripts
    /// </summary>
    Task<DatabaseOperationResult> ApplyMigrationsAsync(
   string migrationPath, 
        int versionNumber);
}

public class DatabaseOperationResult
{
    public bool Success { get; set; }
    public string Message { get; set; }
    public TimeSpan Duration { get; set; }
    public Dictionary<string, int> RecordCounts { get; set; }
    public string Error { get; set; }
}

public class DatabaseStatus
{
    public bool IsInitialized { get; set; }
    public int TableCount { get; set; }
    public Dictionary<string, int> RecordCounts { get; set; }
    public DateTime LastOperation { get; set; }
  public string LastOperationType { get; set; }
    public int? Tier1CaseRecords { get; set; }
}
```

---

## 🔐 SECURITY SPECIFICATION

### Authentication & Authorization

```
All database management endpoints:
✅ Require [Authorize] attribute
✅ Require [Development] environment attribute
✅ Log all access attempts
✅ Return 403 Forbidden in non-Development
✅ Never expose error details to unauthorized users
```

### Confirmation Token Generation

```
For destructive operations (Delete/Recreate):
1. Generate unique confirmation token
2. Send to client with warning message
3. Client must send same token to confirm
4. Prevents accidental clicks
5. Token expires after 5 minutes
6. Only valid once
```

### Rate Limiting Implementation

```
Delete Operation Protection:
├─ Last delete timestamp stored in-memory or cache
├─ New delete request blocked if < 5 minutes since last delete
├─ Exception: First run in new application instance
├─ Warning message shows time until delete allowed
├─ Prevents accidental repeated deletes
└─ Rate limit can be overridden with admin key in Development only
```

### Audit Logging

```
Create DatabaseAuditLog table:
├─ OperationId (GUID)
├─ OperationType (Create, Delete, Recreate, Seed, Migrate)
├─ Timestamp (UTC)
├─ User (from HttpContext)
├─ Environment
├─ Success (1/0)
├─ Duration (milliseconds)
├─ RecordsAffected
├─ ErrorMessage (if failed)
└─ IpAddress

Indexes:
├─ On Timestamp (for chronological queries)
├─ On OperationType (for analytics)
└─ On User (for user-specific audit)
```

---

## 📊 DATA FLOW SPECIFICATION

### Database Creation Flow

```
Client Request
    ↓
POST /api/admin/database/initialize
    ↓
DatabaseController.Initialize()
    ↓
[Authorize] ✓
[Development] ✓
    ↓
DatabaseManager.CreateDatabaseAsync()
    ↓
├─ EnvironmentValidator.ValidateAsync()  ✓ Development
├─ Connect to SQL Server    ✓ Connected
├─ ExecuteMigrationScript(V001_InitialSchema.sql)
│  ├─ Read script file
│  ├─ Execute batched commands
│  └─ Verify execution
├─ VerifyTablesCreated()        ✓ 14 tables
├─ AuditLogger.LogAsync()            ✓ Logged
└─ Return success
    ↓
Response: 200 OK
{
  "success": true,
  "message": "Database created successfully",
  "duration": "4.2 seconds",
  "tableCount": 14
}
```

### Database Deletion Flow

```
Client Request
    ↓
DELETE /api/admin/database
With: { confirmationToken: "abc123xyz" }
    ↓
DatabaseController.Delete()
 ↓
[Authorize] ✓
[Development] ✓
    ↓
DatabaseManager.DeleteDatabaseAsync(confirmationToken)
    ↓
├─ EnvironmentValidator.ValidateAsync()        ✓ Development
├─ ConfirmationValidator.ValidateAsync()  ✓ Token valid
├─ RateLimiter.CheckAsync() ✓ Not rate limited
├─ Connect to SQL Server       ✓ Connected
├─ DropAllTables()
│  ├─ Drop foreign key constraints
│  ├─ Drop all DataQuest tables
│  └─ Verify deletion
├─ AuditLogger.LogAsync()  ✓ Logged
└─ Return success
    ↓
Response: 200 OK
{
  "success": true,
  "message": "Database deleted successfully",
  "duration": "1.8 seconds"
}
```

### Database Recreation Flow

```
Client Request
    ↓
POST /api/admin/database/recreate
With: { confirmationToken: "abc123xyz" }
    ↓
DatabaseManager.RecreateDatabaseAsync()
    ↓
├─ Call DeleteDatabaseAsync()
│  ├─ [Validation & safeguards]
│  └─ ✓ Deleted
│
├─ Call CreateDatabaseAsync()
│  ├─ [Schema creation]
│  └─ ✓ Created
│
├─ Call SeedDataAsync()
│  ├─ Execute V001_SeedData_Tier1.sql
│  ├─ Verify data inserted
│  └─ ✓ Seeded
│
├─ AuditLogger.LogAsync()
│  └─ ✓ Single audit entry for entire operation
│
└─ Return success
    ↓
Response: 200 OK
{
  "success": true,
  "message": "Database recreated successfully",
  "duration": "8.5 seconds",
  "recordsInserted": {
    "Cases": 2,
    "Persons": 10,
    "Locations": 6,
    "BadgeAccess": 52,
    "ParkingLotAccess": 28,
    "StorySteps": 4,
    "AnswerKeys": 4
  }
}
```

---

## 🧪 TEST SPECIFICATION

### Unit Tests

**EnvironmentValidator Tests**
```
✓ AllowDevelopment - Returns true for Development environment
✓ BlockStaging - Returns false for Staging environment
✓ BlockProduction - Returns false for Production environment
✓ LogsViolation - Logs attempt to use outside Development
```

**MigrationExecutor Tests**
```
✓ ExecutesMigrationScript - Executes SQL script successfully
✓ HandlesScriptNotFound - Returns error if script missing
✓ HandlesSqlError - Catches SQL exceptions gracefully
✓ LogsExecution - Logs start, completion, duration
```

**RateLimiter Tests**
```
✓ AllowsFirstDelete - Allows first delete operation
✓ BlocksSecondDelete - Blocks delete within 5 minutes
✓ AllowsAfterWait - Allows delete after 5 minutes
✓ MaintainsState - Correctly tracks last operation time
```

### Integration Tests

**Full Database Lifecycle**
```
✓ CreateDatabase - Creates schema successfully
✓ VerifyTablesExist - All 14 tables present
✓ SeedData - Data inserted successfully
✓ VerifyDataExists - All seed data present
✓ DeleteDatabase - Database deleted successfully
✓ VerifyDeletion - No tables remain
✓ RecreateFull - Recreate works end-to-end
```

### AI Agent Integration Tests

```
✓ InitializeForAgent - Database ready for agent testing
✓ RunAgentScenario1 - Agent runs on clean Case 1.1 data
✓ RunAgentScenario2 - Agent runs on clean Case 1.2 data
✓ ResetBetweenScenarios - Clean state between tests
✓ MultipleAgentSequence - Multiple agents in sequence
```

---

## 📦 DEPENDENCIES

### .NET Framework
- .NET 9.0
- System.Data.SqlClient or Microsoft.Data.SqlClient
- Microsoft.Extensions.DependencyInjection
- Microsoft.Extensions.Logging

### External Dependencies
- SQL Server 2019+ (existing)
- Migration script files (existing)

### Internal Dependencies
- Database schema (V001_InitialSchema.sql)
- Seed data (V001_SeedData_Tier1.sql)

---

## 🚀 DEPLOYMENT SPECIFICATION

### File Structure
```
src/
├── DataQuest/
│   ├── Services/
│   │   ├── Database/
│   │   │   ├── IDatabaseManager.cs
││   │   ├── DatabaseManager.cs
│   │   │   ├─ IEnvironmentValidator.cs
│   │   │   ├─ EnvironmentValidator.cs
│   │   │   ├─ IMigrationExecutor.cs
│   │   │   ├─ MigrationExecutor.cs
│   │   │   ├─ IRateLimiter.cs
│   │   │   ├─ RateLimiter.cs
│   │   │   ├─ IAuditLogger.cs
│   │   │   └─ AuditLogger.cs
│   │
│   ├── Controllers/
│   │   └── Admin/
│   │       └── DatabaseController.cs
│   │
│   └── Program.cs
│       └── services.AddScoped<IDatabaseManager, DatabaseManager>();
│
└── sql/
    └── migrations/
        ├── V001_InitialSchema.sql
        └── V001_SeedData_Tier1.sql
```

### Configuration
```
appsettings.Development.json:
{
  "DatabaseManagement": {
    "Enabled": true,
    "RateLimitSeconds": 300,
    "AllowedEnvironments": ["Development"],
    "MigrationPath": "sql/migrations"
  }
}

appsettings.Production.json:
{
  "DatabaseManagement": {
    "Enabled": false,
    "AllowedEnvironments": []
  }
}
```

---

## 📋 COMPLIANCE MATRIX

| Requirement | Specification Section | Implemented In |
|---|---|---|
| Development-only | NFR-001, Security | EnvironmentValidator |
| Confirmation | FR-002, FR-003, Security | ConfirmationValidator |
| Rate limiting | NFR-003, Security | RateLimiter |
| Logging | NFR-005, Security | AuditLogger |
| Error handling | FR-* | DatabaseManager |
| Performance | NFR-004 | Async operations |

---

**Technical Specification:** CHG-002  
**Status:** PROPOSED  
**Next:** Development and testing

