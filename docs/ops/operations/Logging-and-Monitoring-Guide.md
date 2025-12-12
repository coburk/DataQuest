# 📊 LOGGING & MONITORING IMPLEMENTATION GUIDE

**Date:** December 3, 2025  
**Status:** OPERATIONAL SPECIFICATION  
**Version:** 1.0  
**Classification:** Implementation Guidance

---

## 📋 Document Purpose

This specification defines the logging and monitoring strategy for DataQuest: SQL Detective. It operationalizes observability into concrete, implementable procedures that ensure the application's health, performance, and reliability can be tracked and issues identified quickly.

**This document enables:**
- ✅ DevOps team to set up centralized logging
- ✅ Development team to add appropriate logging
- ✅ Operations team to monitor application health
- ✅ Support team to troubleshoot issues
- ✅ Leadership to understand application performance

---

## 🎯 Scope

### What This Document Covers

```
✅ Logging architecture and strategy
✅ Log levels and severity classification
✅ Structured logging patterns
✅ Performance metrics to track
✅ Alert thresholds and conditions
✅ Dashboard configuration
✅ Log retention and archival
✅ Monitoring tools and setup
✅ Incident response procedures
✅ Health check endpoints
```

### What This Document Does NOT Cover

```
❌ Specific monitoring tool selection (Azure Monitor, Datadog, etc.)
❌ Machine learning-based anomaly detection
❌ Custom dashboard visualization code
❌ Advanced alerting automation
```

---

## 🏗️ Logging Architecture

### Centralized Logging Strategy

```
┌──────────────────────────────────────────────┐
│   DataQuest Application Services│
│   ├─ Query Service            │
│   ├─ Case Service     │
│   ├─ Schema Service   │
│   ├─ Hint Service                │
│   └─ Agent Communication Service            │
└──────────────────┬───────────────────────────┘
      │
          ↓ Structured Logs
        ┌──────────────────────┐
  │  Logging Framework │
        │  (Serilog/.NET)      │
     └──────────┬───────────┘
     │
     ┌─────────────┼─────────────┐
     ↓             ↓    ↓
┌─────────┐  ┌─────────┐  ┌──────────────┐
│  Console│  │   File  │  │ Aggregator   │
│  (Dev)  │  │ (Local) │  │ (Production) │
└─────────┘  └─────────┘  └──────┬───────┘
          │
      ┌─────────────┴──────────────┐
        ↓↓
          ┌────────────────┐         ┌──────────────────┐
     │ Log Storage  │         │ Analytics Engine │
        │ (Azure Storage)│         │ (Query Analysis) │
            └────────────────┘         └──────────────────┘
            │  │
    └────────────────┬───────────┘
        ↓
      ┌─────────────────┐
 │ Dashboards &    │
     │ Alerting        │
        └─────────────────┘
```

### Log Levels Hierarchy

```
FATAL (Level 0):
├─ Application crash
├─ Unrecoverable error
├─ Database connection lost
└─ Action: Immediate alert + page on-call

ERROR (Level 1):
├─ Query execution failure
├─ Service dependency down
├─ Invalid configuration
└─ Action: Alert + investigation queue

WARN (Level 2):
├─ Query timeout (but recovered)
├─ Agent response delayed
├─ High memory usage
├─ Slow query detected
└─ Action: Log + monitor + investigate

INFO (Level 3):
├─ Case completed successfully
├─ Tier advancement
├─ Query executed (summary)
├─ Agent response received
└─ Action: Logged for analytics

DEBUG (Level 4):
├─ Query details (PII redacted)
├─ Service method entry/exit
├─ Cache hit/miss
├─ Database query timing
└─ Action: Logged locally, not production

TRACE (Level 5):
├─ Detailed variable values
├─ Loop iterations
├─ Complex logic paths
└─ Action: Dev environment only
```

---

## 📝 Structured Logging Patterns

### Standard Log Entry Format

```json
{
  "timestamp": "2025-12-03T14:30:45.123Z",
  "level": "INFO",
  "logger": "DataQuest.Services.QueryService",
  "correlationId": "req-12345-abcde",
  "userId": "student-789",
  "caseId": "case_001",
  "eventType": "QueryExecuted",
  "message": "Query executed successfully",
  "properties": {
    "queryDurationMs": 156,
    "rowsReturned": 23,
  "isCorrect": true,
    "attemptNumber": 1
  },
  "exception": null,
  "environment": "production"
}
```

### C# Logging Implementation

```csharp
// Structured logging with Serilog

using Serilog;
using Serilog.Context;

public class QueryService : IQueryService
{
    private readonly ILogger<QueryService> _logger;
    
    public async Task<QueryExecutionResponse> ExecuteQueryAsync(
    string sessionId, string query, int questionIndex)
    {
 // Add correlation context
   using (LogContext.PushProperty("CorrelationId", sessionId))
    using (LogContext.PushProperty("CaseId", caseId))
        using (LogContext.PushProperty("QueryHash", GetQueryHash(query)))
        {
 var stopwatch = Stopwatch.StartNew();
  
    try
        {
      _logger.Information(
        "Query execution started. " +
      "Question: {QuestionIndex}, " +
   "QueryLength: {QueryLength}",
  questionIndex,
       query.Length);
    
      var result = await _mcp.ExecuteTool("execute_sql", new { query });

                stopwatch.Stop();
      
  _logger.Information(
     "Query executed successfully. " +
           "Duration: {DurationMs}ms, " +
   "RowsReturned: {RowCount}, " +
       "IsCorrect: {IsCorrect}",
      stopwatch.ElapsedMilliseconds,
     result.RowCount,
     result.IsCorrect);
     
     return MapResult(result);
     }
       catch (TimeoutException ex)
   {
          stopwatch.Stop();
           
       _logger.Warning(ex,
    "Query execution timeout. " +
         "Duration: {DurationMs}ms, " +
     "Question: {QuestionIndex}",
        stopwatch.ElapsedMilliseconds,
 questionIndex);
              
   throw;
     }
            catch (Exception ex)
        {
                stopwatch.Stop();
           
    _logger.Error(ex,
 "Query execution failed. " +
     "Duration: {DurationMs}ms, " +
        "Question: {QuestionIndex}",
     stopwatch.ElapsedMilliseconds,
  questionIndex);
      
     throw;
   }
        }
    }
}
```

---

## 📊 Performance Metrics to Track

### Query Execution Metrics

```
Metric Name: query_execution_duration_ms
├─ Description: Time to execute query (in milliseconds)
├─ Threshold: 
│  ├─ Good: < 200ms
│  ├─ Acceptable: 200-3000ms
│  ├─ Warning: 3000-10000ms
│  └─ Alert: > 10000ms
├─ Tracked by: QueryService
└─ Alerting: Yes

Metric Name: query_timeout_rate
├─ Description: Percentage of queries that timeout
├─ Threshold:
│  ├─ Good: < 0.5%
│  ├─ Warning: 0.5-2%
│  └─ Alert: > 2%
├─ Tracked by: QueryService
└─ Alerting: Yes

Metric Name: query_success_rate
├─ Description: Percentage of students solving queries correctly
├─ Threshold:
│  ├─ Good: > 85%
│  ├─ Warning: 70-85%
│  └─ Alert: < 70%
├─ Tracked by: CaseService
└─ Alerting: Educational metric
```

### Service Health Metrics

```
Metric Name: service_response_time_p95
├─ Description: 95th percentile response time
├─ Threshold:
│  ├─ Good: < 500ms
│  ├─ Warning: 500-2000ms
│  └─ Alert: > 2000ms
├─ Services: All
└─ Alerting: Yes

Metric Name: service_error_rate
├─ Description: Percentage of requests resulting in error
├─ Threshold:
│  ├─ Good: < 0.1%
│  ├─ Warning: 0.1-1%
│  └─ Alert: > 1%
├─ Services: All
└─ Alerting: Yes

Metric Name: database_connection_pool_utilization
├─ Description: Percentage of connection pool in use
├─ Threshold:
│  ├─ Good: < 70%
│  ├─ Warning: 70-85%
│  └─ Alert: > 85%
├─ Tracked by: MCP Server
└─ Alerting: Yes
```

### Application Health Metrics

```
Metric Name: active_sessions
├─ Description: Number of concurrent student sessions
├─ Threshold: Informational (track trends)
├─ Tracked by: CaseService
└─ Alerting: No

Metric Name: cases_completed_per_hour
├─ Description: Case completion rate
├─ Threshold: Informational (measure engagement)
├─ Tracked by: CaseService
└─ Alerting: No

Metric Name: agent_availability
├─ Description: Percentage of time agents responding
├─ Threshold:
│  ├─ Good: > 99%
│  ├─ Warning: 95-99%
│  └─ Alert: < 95%
├─ Tracked by: Agent Communication Service
└─ Alerting: Yes
```

---

## 🚨 Alert Thresholds & Escalation

### Alert Matrix

| Condition | Severity | Action | Escalation |
|-----------|----------|--------|------------|
| Query timeout rate > 2% | HIGH | Page on-call | Immediate |
| Query success rate < 70% | MEDIUM | Create ticket | 30 min |
| Database connection pool > 85% | MEDIUM | Create ticket | 1 hour |
| Service error rate > 1% | HIGH | Page on-call | Immediate |
| Agent availability < 95% | HIGH | Page on-call | Immediate |
| Memory usage > 90% | MEDIUM | Alert | 30 min |
| API response time p95 > 2s | LOW | Track trend | 4 hours |

### Alert Examples

```
ALERT: Query Timeout Rate Exceeds Threshold
├─ Current: 3.2% (last 5 minutes)
├─ Threshold: 2%
├─ Severity: HIGH
├─ Action: Page on-call immediately
├─ Details:
│  ├─ 5 timeouts out of 156 queries
│  ├─ Affected tier: Data Inspector (Tier 3)
│  └─ Recommendation: Check database performance
└─ Link to logs: [correlation ID link]

ALERT: Service Error Rate Elevated
├─ Current: 2.1% (last 15 minutes)
├─ Threshold: 1%
├─ Severity: HIGH
├─ Service: QueryService
├─ Error Type: Database connection timeout
├─ Action: Investigate DB connection pool
└─ Recommended: Restart service or scale up
```

---

## 📈 Dashboard Configuration

### Production Dashboard Layout

```
┌─────────────────────────────────────────────────────────┐
│           DataQuest Health Dashboard     │
├─────────────────────────────────────────────────────────┤
│        │
│ SYSTEM STATUS      │
│ ├─ Overall Status: 🟢 HEALTHY        │
│ ├─ Uptime: 99.97% (last 7 days)        │
│ └─ Last Incident: 2 days ago (resolved)      │
│         │
├─────────────────────────────────────────────────────────┤
│     │
│ KEY METRICS (Last 1 Hour)     │
│ ├─ Query Timeout Rate: 0.8% 🟢 (threshold: 2%)       │
│ ├─ Service Error Rate: 0.04% 🟢 (threshold: 1%)      │
│ ├─ API Response p95: 342ms 🟢 (threshold: 2000ms)    │
│ ├─ Agent Availability: 99.8% 🟢 (threshold: 95%)     │
│ └─ DB Connection Pool: 64% 🟢 (threshold: 85%)       │
│     │
├─────────────────────────────────────────────────────────┤
│  │
│ QUERY EXECUTION PERFORMANCE   │
│ ├─ [Graph] Query Duration Distribution                │
│ ├─ [Graph] Queries/Second       │
│ └─ [Graph] Success Rate Trend      │
│  │
├─────────────────────────────────────────────────────────┤
│       │
│ RECENT EVENTS   │
│ ├─ 14:30 - Case "Missing Code" completed (Tier 1)    │
│ ├─ 14:25 - Student advanced to Senior Analyst         │
│ ├─ 14:20 - Query Tutor response time: 1.2s           │
│ └─ 14:15 - Database schema cache refreshed            │
│      │
│ ACTIVE SESSIONS: 47         │
│ CASES IN PROGRESS: 23     │
│ COMPLETED TODAY: 156                │
│      │
└─────────────────────────────────────────────────────────┘
```

### Developer Dashboard

```
┌─────────────────────────────────────────────────────────┐
│      DataQuest Development Troubleshooting  │
├─────────────────────────────────────────────────────────┤
│           │
│ ERROR RATE BY SERVICE (Last 24 Hours)        │
│ ├─ QueryService: 0.03% (2 errors)           │
│ ├─ CaseService: 0.01% (1 error)            │
│ ├─ SchemaService: 0.02% (1 error)   │
│ └─ AgentService: 0.05% (3 errors)      │
│          │
│ SLOW QUERY ANALYSIS (Last Hour)        │
│ ├─ Slowest: 8,234ms (case_001, Tier 5)              │
│ ├─ Average slow: 1,456ms          │
│ ├─ Count: 3 slow queries  │
│ └─ Recommendation: Add database index on Status column│
│        │
│ AGENT PERFORMANCE      │
│ ├─ Query Tutor response time p95: 2.1s        │
│ ├─ Database Agent response time p95: 1.8s │
│ └─ Availability: 99.8% │
│   │
│ LOGS SEARCH              │
│ ├─ Error level (last 4 hours): [Search Box]│
│ ├─ Results: 5 errors found│
│ └─ [View Details] [Export]     │
│              │
└─────────────────────────────────────────────────────────┘
```

---

## 🔍 Health Check Endpoints

### Endpoint: GET /health

**Purpose:** Basic application health check

```http
GET /health HTTP/1.1
Host: api.dataquest.edu

Response (200 OK):
{
  "status": "healthy",
  "timestamp": "2025-12-03T14:30:45Z",
  "version": "1.0.0",
  "uptime_seconds": 86400
}
```

### Endpoint: GET /health/detailed

**Purpose:** Detailed health check with dependency status

```http
GET /health/detailed HTTP/1.1
Host: api.dataquest.edu

Response (200 OK):
{
  "status": "healthy",
  "timestamp": "2025-12-03T14:30:45Z",
  "components": {
    "database": {
      "status": "healthy",
  "response_time_ms": 12,
  "connection_pool_utilization": 0.64
    },
  "agents": {
    "status": "healthy",
      "query_tutor": { "status": "available", "response_time_ms": 1200 },
      "database_agent": { "status": "available", "response_time_ms": 950 }
    },
  "cache": {
      "status": "healthy",
      "hit_rate": 0.87
    }
  }
}

Response (503 Service Unavailable):
{
  "status": "degraded",
  "timestamp": "2025-12-03T14:30:45Z",
  "components": {
    "database": {
      "status": "unhealthy",
      "error": "Connection timeout",
      "response_time_ms": null
    },
    "agents": {
      "status": "degraded",
      "query_tutor": { "status": "timeout", "response_time_ms": null }
    }
  }
}
```

---

## 📋 Log Retention & Archival Policy

### Retention Schedule

```
Log Level    | Storage Duration | Archival Strategy
─────────────┼──────────────────┼─────────────────────
FATAL/ERROR  | 90 days (prod)   | Archive to cold storage after 30 days
 | 30 days (dev)    |
   |            |
WARN         | 30 days (prod)   | Archive to cold storage after 14 days
             | 7 days (dev)     |
         |       |
INFO     | 7 days (prod)    | Archive to cold storage after 3 days
         | 24 hours (dev)   |
   |      |
DEBUG        | 24 hours (prod)  | Don't archive (delete after retention)
        | Local only (dev) |
```

### Archival Locations

```
Production Logs:
├─ Hot Storage (7 days): Azure Table Storage
│  └─ Fast query access, full resolution
├─ Warm Storage (14-30 days): Azure Blob Storage
│  └─ Lower cost, slightly slower access
└─ Cold Storage (30-90 days): Archive tier
   └─ Minimal cost, 12-hour retrieval time

Development Logs:
├─ Console output
├─ Local file system (7 days)
└─ Never archived
```

---

## 📋 Incident Response Procedures

### P1 Incident (Critical - Service Down)

```
Detection:
├─ Alert: Error rate > 5% OR availability < 99%
└─ Immediate page on-call engineer

Response Timeline:
├─ 0-5 min: Acknowledge alert, assess impact
├─ 5-15 min: Identify root cause (logs, metrics)
├─ 15-30 min: Implement immediate fix or rollback
├─ 30-60 min: Verify resolution, monitor closely
└─ 60+ min: Post-incident review

Investigation Tools:
├─ Dashboard: Check error rate by service
├─ Logs: Correlation ID from alert
├─ Metrics: Recent performance changes
└─ Database: Check connection pool status

Common Causes & Fixes:
├─ Database connection pool exhausted → Restart service or scale
├─ Agent service down → Check agent service health, restart
├─ Query timeout cascade → Scale database or optimize query validation
└─ Memory leak → Check memory metrics, consider restart
```

### P2 Incident (High - Degraded Performance)

```
Detection:
├─ Alert: Error rate > 1% OR p95 response time > 2s
└─ Create ticket (no page on-call unless P1 also triggered)

Response Timeline:
├─ 0-30 min: Triage and assign
├─ 30-60 min: Root cause analysis
├─ 60-120 min: Implement fix
├─ 120+ min: Monitor and verify

Investigation Focus:
├─ Query performance metrics
├─ Agent response times
├─ Database connection status
└─ Recent deployments or changes
```

---

## 🛠️ Implementation Checklist

### Setup Phase

```
[ ] Select monitoring tool (Azure Monitor or Datadog)
[ ] Configure centralized log aggregation
[ ] Set up Serilog in all services
[ ] Configure log levels for each service
[ ] Create structured logging templates
[ ] Set up log retention policies
[ ] Configure database for log storage
```

### Development Phase

```
[ ] Add logging to QueryService
[ ] Add logging to CaseService
[ ] Add logging to SchemaService
[ ] Add logging to Agent services
[ ] Add logging to MCP integration
[ ] Implement correlation IDs
[ ] Add performance metrics collection
[ ] Set up health check endpoints
```

### Monitoring Phase

```
[ ] Create production dashboard
[ ] Create development dashboard
[ ] Set up alert thresholds
[ ] Test alert notifications
[ ] Create incident response runbooks
[ ] Train team on alert response
[ ] Set up on-call rotation
```

---

## 📞 Monitoring Runbooks

### Runbook: High Query Timeout Rate

```
Symptom: Alert triggered - Query timeout rate > 2%

Step 1: Verify Alert
├─ Check dashboard for current rate
├─ Confirm: Is it still ongoing?
└─ If resolved: Close alert, investigate cause

Step 2: Identify Affected Tier
├─ Check logs for timeout patterns
├─ Correlation: Which tier level?
└─ Query complexity involved?

Step 3: Investigate Root Cause
├─ Database performance: Check CPU, memory, connections
├─ Network latency: Check response times
├─ Query complexity: Complex queries timing out?
└─ Recent changes: Any recent deployments?

Step 4: Immediate Action
├─ Option A: Scale database resources
├─ Option B: Increase query timeout limit temporarily
├─ Option C: Optimize query validation
└─ Option D: Restrict complex queries temporarily

Step 5: Long-term Fix
├─ Add database indexes
├─ Optimize MCP query execution
├─ Profile slow queries
└─ Update case complexity limits if needed
```

### Runbook: High Service Error Rate

```
Symptom: Alert triggered - Service error rate > 1%

Step 1: Identify Failing Service
├─ Dashboard shows which service(s)
├─ Check logs for error type
└─ Correlation with recent changes?

Step 2: Common Causes
├─ Database connection: Check connection pool
├─ Configuration: Check if config is correct
├─ Dependencies: Agent service down?
├─ Recent deployment: Any recent changes?

Step 3: Resolution
├─ If database: Check connections, restart if needed
├─ If agent: Check agent service, restart if needed
├─ If config: Verify and fix configuration
├─ If recent change: Consider rollback

Step 4: Verification
├─ Monitor error rate for 15 minutes
├─ Verify no new errors appearing
├─ Check dashboard for normalization
└─ Close ticket once stable
```

---

## 🎓 Conclusion

Comprehensive logging and monitoring ensures DataQuest maintains **high reliability and rapid issue identification**. With clear metrics, alert thresholds, and documented procedures, the operations team can proactively manage application health and respond quickly to any issues.

**Key Success Factors:**

1. **Structured Logging** - Consistent format enables easy searching
2. **Clear Metrics** - Know what's important to track
3. **Automated Alerts** - Catch problems before they escalate
4. **Documented Procedures** - Team knows how to respond
5. **Dashboards** - Visibility into application health
6. **Health Checks** - Automated verification of dependencies

---

**LOGGING & MONITORING GUIDE COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR IMPLEMENTATION**

