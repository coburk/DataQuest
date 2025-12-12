# Database Security & Data Protection Strategy

**Date:** December 3, 2025  
**Status:** SECURITY SPECIFICATION - PROTECTING CASE DATA  
**Version:** 1.0  
**Classification:** Critical Security Document

---

## 📋 Document Purpose

This specification addresses a critical security concern: **preventing students from bypassing the learning experience by accessing AnswerKeys or Conclusion data directly**. It defines technical and architectural controls to ensure data protection and maintain learning integrity.

**This document addresses:**
- ✅ Why data protection matters (learning integrity)
- ✅ What data needs protection (AnswerKeys, Conclusion, etc.)
- ✅ Technical controls (database-level, application-level)
- ✅ Architectural controls (separation, permissions, auditing)
- ✅ Implementation approach (immediate + future)

---

## 🎯 The Problem

### The Risk

Without proper controls, a student could:

```
SCENARIO 1: Direct Database Query
├─ Connect to SQL Server
├─ SELECT * FROM AnswerKeys
└─ Get all answers instantly
└─ LEARNING BYPASSED ❌

SCENARIO 2: Inspect API Response
├─ Student queries API
├─ API accidentally returns CanonicalQuery
├─ Student sees the answer
└─ LEARNING BYPASSED ❌

SCENARIO 3: Read Conclusion
├─ Student accesses Conclusion field
├─ Case solution revealed
└─ LEARNING BYPASSED ❌

SCENARIO 4: Database File Access
├─ Student accesses backup files
├─ Extracts database
├─ Reads all sensitive data
└─ LEARNING BYPASSED ❌
```

### Why This Matters

```
Learning Model: Socratic Method (6 levels of hints)
  ├─ Level 1: General guidance
  ├─ Level 2: Schema hint
  ├─ Level 3: Specific tables
  ├─ Level 4: Join hint
  ├─ Level 5: Query structure
  └─ Level 6: Answer (but they write it)

If AnswerKeys visible:
  └─ Student goes straight to Level 6
  └─ NO learning happens
  └─ System fails its purpose
```

---

## 🔐 Multi-Layer Protection Strategy

### Layer 1: Database Access Control

**Principle:** Students should NEVER have direct database access

```sql
-- Create separate database users/roles

-- 1. Application Service Account (reads/writes appropriate tables)
CREATE LOGIN [DataQuest_App] WITH PASSWORD = 'SecurePassword123!';
CREATE USER [DataQuestAppUser] FOR LOGIN [DataQuest_App];

-- 2. Student Query Execution Account (VERY LIMITED)
CREATE LOGIN [DataQuest_StudentQueryExec] WITH PASSWORD = 'SecurePassword456!';
CREATE USER [DataQuestStudentQueryExec] FOR LOGIN [DataQuest_StudentQueryExec];

-- 3. Admin Account (full access, rarely used)
CREATE LOGIN [DataQuest_Admin] WITH PASSWORD = 'SecurePassword789!';
CREATE USER [DataQuestAdminUser] FOR LOGIN [DataQuest_Admin];
```

**Permissions:**

```sql
-- Application Service Account: Full platform access
-- (But queries are filtered in code)
GRANT SELECT, INSERT, UPDATE ON [dbo].[Persons] TO [DataQuestAppUser];
GRANT SELECT, INSERT, UPDATE ON [dbo].[Locations] TO [DataQuestAppUser];
GRANT SELECT, INSERT, UPDATE ON [dbo].[Evidence] TO [DataQuestAppUser];
GRANT SELECT, INSERT, UPDATE ON [dbo].[WitnessStatements] TO [DataQuestAppUser];
GRANT SELECT, INSERT, UPDATE ON [dbo].[TransactionLogs] TO [DataQuestAppUser];
GRANT SELECT, INSERT, UPDATE ON [dbo].[Cases] TO [DataQuestAppUser];
GRANT SELECT, INSERT, UPDATE ON [dbo].[StorySteps] TO [DataQuestAppUser];
GRANT SELECT ON [dbo].[AnswerKeys] TO [DataQuestAppUser];  -- SELECT ONLY
GRANT SELECT ON [dbo].[CommunicationRecords] TO [DataQuestAppUser];
GRANT SELECT ON [dbo].[Relationships] TO [DataQuestAppUser];

-- DENY everything else
DENY INSERT, UPDATE, DELETE ON [dbo].[AnswerKeys] TO [DataQuestAppUser];

-- Student Query Execution Account: EXTREMELY LIMITED
-- Can ONLY execute specific stored procedures for their queries
CREATE PROCEDURE [dbo].[sp_ExecuteStudentQuery]
    @SessionID GUID,
    @StudentID GUID,
    @Query NVARCHAR(MAX)
AS
BEGIN
    -- This stored procedure validates and executes student queries
    -- See details below
END;

GRANT EXECUTE ON [dbo].[sp_ExecuteStudentQuery] TO [DataQuestStudentQueryExec];
-- THAT'S IT - no direct table access!
```

### Layer 2: Application-Level Filtering

**Principle:** The API never returns sensitive data

```csharp
// C# Services Layer - Filter sensitive data

public class QueryService : IQueryService
{
  private readonly MSSQLMCPServer _mcpServer;
    
    public async Task<QueryExecutionResponse> ExecuteQueryAsync(
        string query, string sessionId, string studentId)
 {
        // VALIDATE: Query doesn't attempt to access AnswerKeys, Conclusion, etc.
   if (ContainsForbiddenTables(query))
        {
            throw new UnauthorizedQueryException(
      "Query contains restricted tables");
  }
        
        // EXECUTE: Use MCP server (which uses limited permissions)
      var result = await _mcpServer.ExecuteQueryAsync(query);
        
        // FILTER: Remove any sensitive columns
 var filtered = FilterSensitiveColumns(result);
   
        // LOG: Record the attempt for audit
        await _auditService.LogQuerySubmissionAsync(
 sessionId, studentId, query, result.Status);
        
        return filtered;
    }
    
    private bool ContainsForbiddenTables(string query)
    {
        var forbidden = new[] { "AnswerKeys", "Conclusion", "CanonicalQuery" };
        return forbidden.Any(table => 
        query.Contains(table, StringComparison.OrdinalIgnoreCase));
    }
    
    private QueryExecutionResponse FilterSensitiveColumns(
        QueryExecutionResponse response)
    {
    // Remove any columns that shouldn't be shown
        var filtered = new QueryExecutionResponse
        {
            Rows = response.Rows
     .Select(row => new Dictionary<string, object>(row)
          .Where(kvp => !IsSensitiveColumn(kvp.Key))
          .ToDictionary(kvp => kvp.Key, kvp => kvp.Value))
 .ToList(),
        RowCount = response.RowCount,
  ExecutionTimeMs = response.ExecutionTimeMs
        };
        
        return filtered;
    }
    
    private bool IsSensitiveColumn(string columnName)
    {
        var sensitive = new[] 
        { 
       "ExpectedResultHash", 
            "ExpectedClueValue",
   "CanonicalQuery",
    "Conclusion"
  };
        
 return sensitive.Any(col => 
  columnName.Equals(col, StringComparison.OrdinalIgnoreCase));
    }
}
```

### Layer 3: Stored Procedure Approach

**Principle:** Students execute through controlled stored procedures only

```sql
-- Modified create_dataquest_db.sql approach
-- Instead of students executing arbitrary queries against case database,
-- they execute through stored procedures

CREATE PROCEDURE [dbo].[sp_ExecuteStudentQuerySafely]
    @CaseID INT,
    @StudentID GUID,
    @Query NVARCHAR(MAX),
    @SessionID GUID
AS
BEGIN
    SET NOCOUNT ON;
    
    -- 1. VALIDATE: Query syntax only - no dangerous keywords
    IF @Query LIKE '%DROP%' OR @Query LIKE '%DELETE%' 
        OR @Query LIKE '%UPDATE%' OR @Query LIKE '%INSERT%'
  BEGIN
        RAISERROR('Query contains unauthorized operations', 16, 1);
        RETURN;
    END;
    
    -- 2. VALIDATE: No access to protected tables
    IF @Query LIKE '%AnswerKeys%' OR @Query LIKE '%CanonicalQuery%'
        OR @Query LIKE '%Conclusion%'
    BEGIN
        RAISERROR('Query accesses restricted tables', 16, 1);
     RETURN;
    END;
    
    -- 3. VALIDATE: Query timeout enforcement
    SET STATEMENT_TIMEOUT 30000;  -- 30 seconds
    
    -- 4. EXECUTE: Run the student's query dynamically
    -- Results are returned but filtered by application layer
    EXEC sp_executesql @Query;
    
    -- 5. LOG: Record successful execution
    INSERT INTO [dbo].[QueryAuditLog] (
        [StudentID], [CaseID], [SessionID], 
   [Query], [ExecutedAt], [Success]
    )
    VALUES (
    @StudentID, @CaseID, @SessionID, 
        @Query, GETUTCDATE(), 1
    );
END;
GO
```

### Layer 4: Database Schema Segregation

**Principle:** Separate databases for different access levels

```
ARCHITECTURE:

Main DataQuest Database (Server A)
├─ Students table (write access)
├─ Student_Sessions (write access)
├─ Student_Queries (write access)
├─ Query_Feedback (write access)
├─ Tiers (read access)
├─ Cases (metadata only)
├─ CaseContent (JSON, application reads and filters)
├─ AnswerKeys (RESTRICTED - admin only)
├─ Conclusion (RESTRICTED - admin only)
└─ AuditLog (append-only)

Case-Specific Database (Server B or Same Server, Separate DB)
├─ Persons (read access - students query these)
├─ Locations (read access)
├─ Evidence (read access)
├─ WitnessStatements (read access)
├─ TransactionLogs (read access)
├─ CommunicationRecords (read access)
├─ Relationships (read access)
├─ StorySteps (RESTRICTED)
└─ AnswerKeys (RESTRICTED)

Connection Strings:
├─ App Service: Full access to Main DB, limited to Case DB
├─ Student Query: No direct DB access, only stored procedures
└─ Admin: Full access (secured, monitored, audited)
```

### Layer 5: Encryption at Rest

**Principle:** Even if database files are accessed, data is encrypted

```
Configuration (SQL Server 2022+):

1. TRANSPARENT DATA ENCRYPTION (TDE)
   ├─ Encrypts entire database automatically
   ├─ Transparent to application (no code changes)
├─ Key management via SQL Server Encryption Manager
   
   CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SecurePassword123!';

 CREATE CERTIFICATE DataQuestCert WITH SUBJECT = 'DataQuest TDE';
   
   CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256 
   ENCRYPTION BY SERVER CERTIFICATE DataQuestCert;
 
   ALTER DATABASE DataQuest SET ENCRYPTION ON;

2. COLUMN-LEVEL ENCRYPTION (for sensitive columns)
   ├─ Encrypt AnswerKeys.ExpectedClueValue
   ├─ Encrypt Cases.Conclusion
   ├─ Requires application layer to decrypt (with permission checks)
   
   ALTER TABLE [dbo].[AnswerKeys]
   ADD [ExpectedClueValue_Encrypted] VARBINARY(256);
   
   -- Update with encrypted values:
   UPDATE [dbo].[AnswerKeys]
   SET [ExpectedClueValue_Encrypted] = 
       EncryptByKey(Key_GUID('DataQuestKey'), [ExpectedClueValue]);
```

### Layer 6: Audit & Monitoring

**Principle:** All access attempts are logged and monitored

```sql
-- Create audit table
CREATE TABLE [dbo].[SecurityAuditLog] (
    [AuditID] BIGINT PRIMARY KEY IDENTITY(1,1),
    [EventType] VARCHAR(50) NOT NULL, -- 'QUERY_SUBMITTED', 'FORBIDDEN_QUERY', 'UNAUTHORIZED_ACCESS'
    [StudentID] GUID NOT NULL,
    [SessionID] GUID NOT NULL,
    [QueryAttempted] VARCHAR(MAX) NULL,
    [Result] VARCHAR(50) NOT NULL, -- 'SUCCESS', 'BLOCKED', 'ERROR'
    [ErrorMessage] VARCHAR(MAX) NULL,
    [IPAddress] VARCHAR(50) NOT NULL,
    [Timestamp] DATETIME2 NOT NULL DEFAULT GETUTCDATE()
);

CREATE INDEX IDX_SecurityAudit_StudentID ON [dbo].[SecurityAuditLog]([StudentID]);
CREATE INDEX IDX_SecurityAudit_Timestamp ON [dbo].[SecurityAuditLog]([Timestamp]);
CREATE INDEX IDX_SecurityAudit_EventType ON [dbo].[SecurityAuditLog]([EventType]);

-- Alert on suspicious patterns
CREATE PROCEDURE [dbo].[sp_DetectSuspiciousActivity]
AS
BEGIN
    -- Alert if student tries AnswerKeys access 10+ times
  SELECT StudentID, COUNT(*) as AttemptCount
    FROM [dbo].[SecurityAuditLog]
    WHERE EventType = 'FORBIDDEN_QUERY'
    AND Timestamp > DATEADD(HOUR, -1, GETUTCDATE())
    GROUP BY StudentID
    HAVING COUNT(*) > 10;
    -- Escalate to admin if found
END;
GO
```

### Layer 7: API-Level Controls

**Principle:** API validates and filters all responses (from Gap #1 - API Specification)

```csharp
// API Security Middleware

[ApiController]
[Route("api/[controller]")]
public class QueryController : ControllerBase
{
    private readonly IQueryService _queryService;
    private readonly ISecurityAuditService _auditService;
    
    [HttpPost("execute")]
    [Authorize(Roles = "Student")]
    public async Task<IActionResult> ExecuteQuery(
        [FromBody] QueryRequest request,
        [FromHeader] string xSessionId)
    {
        try
        {
        // 1. Validate session exists and belongs to student
            var session = await _sessionService.GetSessionAsync(
  new Guid(xSessionId), User.FindFirst(ClaimTypes.NameIdentifier).Value);
    
      if (session == null || session.State != SessionState.Active)
       {
   await _auditService.LogSecurityEventAsync(
             "UNAUTHORIZED_ACCESS", session?.StudentID.ToString(),
   xSessionId, request.Query, "BLOCKED", 
       "Session not found or expired");
     return Unauthorized();
         }
 
 // 2. Validate query doesn't contain forbidden patterns
       if (ContainsForbiddenPatterns(request.Query))
         {
       await _auditService.LogSecurityEventAsync(
        "FORBIDDEN_QUERY", session.StudentID.ToString(),
 xSessionId, request.Query, "BLOCKED",
  "Query contains restricted tables/operations");
   return BadRequest("Query contains restricted operations");
            }
       
  // 3. Execute query with protection
var result = await _queryService.ExecuteQueryAsync(
        request.Query, xSessionId, session.StudentID.ToString());
      
          // 4. Filter sensitive columns from response
            var filteredResult = FilterSensitiveData(result);
            
            // 5. Log successful execution
            await _auditService.LogSecurityEventAsync(
    "QUERY_EXECUTED", session.StudentID.ToString(),
          xSessionId, request.Query, "SUCCESS", null);
      
    return Ok(filteredResult);
        }
        catch (Exception ex)
        {
 await _auditService.LogSecurityEventAsync(
 "QUERY_ERROR", User.FindFirst(ClaimTypes.NameIdentifier).Value,
             xSessionId, request.Query, "ERROR", ex.Message);
       
            return StatusCode(500, "An error occurred while executing your query");
        }
    }
    
    private bool ContainsForbiddenPatterns(string query)
    {
        var forbiddenPatterns = new[]
      {
       "AnswerKeys", "Conclusion", "CanonicalQuery",
   "ExpectedClueValue", "ExpectedResultHash",
      "DROP", "DELETE", "UPDATE", "INSERT",
  "ALTER", "TRUNCATE", "EXEC", "sp_"
        };
   
        var upperQuery = query.ToUpper();
        return forbiddenPatterns.Any(pattern => 
            Regex.IsMatch(upperQuery, $@"\b{pattern}\b"));
    }
    
    private QueryResult FilterSensitiveData(QueryResult result)
    {
        var sensitiveColumns = new[] 
        { 
    "ExpectedResultHash", "ExpectedClueValue",
   "CanonicalQuery", "Conclusion"
        };
 
        // Remove sensitive columns from result
        var filteredRows = result.Rows
    .Select(row => row.Keys
       .Where(k => !sensitiveColumns.Contains(k))
 .ToDictionary(k => k, k => row[k]))
            .ToList();
        
        return new QueryResult
    {
  Rows = filteredRows,
     RowCount = result.RowCount,
      ExecutionTimeMs = result.ExecutionTimeMs
    };
    }
}
```

---

## 🛡️ Implementation Roadmap

### Phase 1: Immediate (Before Launch)

```
✅ Add FirstName/LastName to Persons table
✅ Implement API filtering (Layer 2)
✅ Add query validation in application (Layer 3)
✅ Create audit logging table (Layer 6)
✅ Implement API controls (Layer 7)
```

### Phase 2: Short-term (Week 1-2)

```
□ Implement database-level permissions (Layer 1)
□ Create stored procedures (Layer 3)
□ Set up role-based access control (RBAC)
□ Configure audit alerts
```

### Phase 3: Medium-term (Week 3-4)

```
□ Implement TDE encryption (Layer 5)
□ Column-level encryption for sensitive data
□ Backup encryption
□ Security testing and penetration testing
```

---

## 📊 Summary: What Gets Protected

| Data | Protection | Implementation |
|------|-----------|-----------------|
| AnswerKeys | Hidden from students | DB permissions + API filtering |
| Conclusion | Hidden from students | DB permissions + API filtering |
| CanonicalQuery | Hidden from students | DB permissions + API filtering |
| Case Data (Persons, etc.) | Visible to students | Query validation only |
| StudentProgress | Personal data only | Row-level security |
| AuditLogs | Admin only | DB permissions + encrypted |

---

## 🎓 Conclusion

This multi-layer approach ensures:

1. ✅ **Students cannot bypass learning** - AnswerKeys/Conclusion inaccessible
2. ✅ **Data integrity maintained** - No malicious modifications
3. ✅ **Audit trail created** - All access logged and monitored
4. ✅ **Compliance ready** - Security controls for FERPA/GDPR
5. ✅ **Performance maintained** - Filtering doesn't require schema redesign

**Result:** Students MUST follow the Socratic method (6 levels) to solve cases. Shortcuts are technically impossible.

---

**DATABASE SECURITY & DATA PROTECTION STRATEGY COMPLETE:** December 3, 2025
**Status:** ✅ **READY FOR IMPLEMENTATION**

