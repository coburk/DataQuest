# Logging & Observability Strategy

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - LOGGING & OBSERVABILITY  
**Version:** 1.0  
**Classification:** Critical - Required Before Phase 1 Launch

---

## 📋 Document Purpose

This specification defines the complete logging and observability strategy for DataQuest, enabling comprehensive monitoring, performance analysis, and troubleshooting across all environments. It ensures that production issues can be rapidly diagnosed, performance can be optimized, and security events can be detected and investigated.

**This document enables:**
- ✅ Real-time monitoring of system health
- ✅ Rapid diagnosis of production issues
- ✅ Performance optimization and tracking
- ✅ Security incident detection
- ✅ Student experience visibility
- ✅ Compliance audit trails

---

## 🎯 Scope

### What This Document Covers

```
✅ Centralized logging architecture
✅ Log levels and verbosity per component
✅ Structured logging format (JSON)
✅ Correlation IDs for distributed tracing
✅ Application Performance Monitoring (APM)
✅ Error tracking and alerting
✅ Dashboard specifications
✅ Alert rules and thresholds
✅ SLA targets for incident response
✅ Log retention and archival
✅ Troubleshooting procedures
✅ Cost optimization
```

### What This Document Does NOT Cover

```
❌ Detailed monitoring tool setup (tool-specific)
❌ Advanced machine learning/anomaly detection
❌ Custom visualization design
❌ GDPR log compliance (beyond retention)
```

---

## 🏗️ Logging Architecture

### Three-Tier Logging Strategy

```
┌─────────────────────────────────────────────┐
│     APPLICATION LOGGING (Tier 1)      │
│  ├─ Local console output              │
│  ├─ Structured JSON logs              │
│  └─ Real-time to log aggregator    │
└─────────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────────┐
│  AGGREGATION & PARSING (Tier 2)   │
│  ├─ Collect from all services         │
│  ├─ Parse and enrich logs      │
│  ├─ Add correlation IDs      │
│  └─ Index for searching          │
└─────────────────────────────────────────────┘
      ↓
┌─────────────────────────────────────────────┐
│  ANALYSIS & VISUALIZATION (Tier 3)     │
│  ├─ Real-time dashboards     │
│  ├─ Historical analysis               │
│  ├─ Alerting rules       │
│  └─ Reporting  │
└─────────────────────────────────────────────┘
```

---

## 📋 Log Levels

### Level Definitions

```
DEBUG (Level 0):
├─ Verbose diagnostic information
├─ When: Development and troubleshooting
├─ Never in production
└─ Example: "Query parameter validation passed: tier=Junior"

INFO (Level 1):
├─ High-level application events
├─ When: Production (sampling)
├─ Normal operation milestones
└─ Examples:
   - "Student logged in successfully"
   - "Case started by student_123"
   - "Query executed successfully (142ms, 23 rows)"

WARN (Level 2):
├─ Potential problems that don't stop operation
├─ When: All environments
├─ Requires investigation but not urgent
└─ Examples:
   - "Query response time exceeds target (4.2s vs 3s)"
   - "Database connection pool utilization high (85%)"
   - "Token refresh rate unusually high"

ERROR (Level 3):
├─ Serious issues that degrade functionality
├─ When: All environments (immediately alerting)
├─ Requires immediate investigation
└─ Examples:
   - "Query execution failed: database connection timeout"
   - "Authentication token validation failed"
   - "Rate limit exceeded for student_123"

CRITICAL (Level 4):
├─ System-threatening issues
├─ When: All environments (immediate escalation)
├─ Requires immediate action
└─ Examples:
   - "Database connection pool exhausted"
   - "Authentication service unavailable"
   - "Backup failure - no current backup exists"
```

### Per-Component Log Levels

```
DEVELOPMENT (ASPNETCORE_ENVIRONMENT=Development):
├─ DataQuest.Backend: DEBUG
├─ DataQuest.Agents: DEBUG
├─ DataQuest.MCP: DEBUG
├─ Microsoft.*: DEBUG
├─ System.*: WARNING
└─ Result: Verbose, detailed output

TESTING (ASPNETCORE_ENVIRONMENT=Testing):
├─ DataQuest.Backend: INFO
├─ DataQuest.Agents: INFO
├─ DataQuest.MCP: INFO
├─ Microsoft.*: WARNING
├─ System.*: ERROR
└─ Result: Important events only

STAGING (ASPNETCORE_ENVIRONMENT=Staging):
├─ DataQuest.Backend: INFO
├─ DataQuest.Agents: INFO
├─ DataQuest.MCP: INFO (DEBUG for MCP troubleshooting)
├─ Microsoft.*: WARNING
├─ System.*: ERROR
└─ Result: Monitor for issues pre-production

PRODUCTION (ASPNETCORE_ENVIRONMENT=Production):
├─ DataQuest.Backend: WARNING (INFO with sampling)
├─ DataQuest.Agents: WARNING (INFO with sampling)
├─ DataQuest.MCP: WARNING
├─ Microsoft.*: ERROR
├─ System.*: ERROR
└─ Result: Minimal noise, critical issues only
```

### Configuration (.NET 9)

```csharp
// appsettings.json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
    "Microsoft": "Warning",
      "Microsoft.EntityFrameworkCore": "Warning",
      "DataQuest.Backend": "Information",
      "DataQuest.Agents": "Information",
      "DataQuest.MCP": "Information"
    }
  }
}

// appsettings.Production.json
{
  "Logging": {
    "LogLevel": {
      "Default": "Warning",
      "Microsoft": "Error",
"Microsoft.EntityFrameworkCore": "Error",
   "DataQuest.Backend": "Warning",
      "DataQuest.Agents": "Warning",
      "DataQuest.MCP": "Warning"
    }
  }
}

// Program.cs
builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Logging.AddDebug();

// In production, add structured logging
if (app.Environment.IsProduction())
{
    builder.Services.AddSerilog(new LoggerConfiguration()
        .MinimumLevel.Warning()
        .WriteTo.Console(new JsonFormatter())
 .CreateLogger());
}
```

---

## 📝 Structured Logging Format

### JSON Log Structure

All logs must be JSON for parsing and analysis:

```json
{
  "timestamp": "2025-12-03T10:30:45.123Z",
  "level": "INFO",
"logger": "DataQuest.Backend.Services.QueryService",
  "message": "Query executed successfully",
  "correlation_id": "req_abc123def456",
  "trace_id": "trace_xyz789",
  "span_id": "span_001",
  "student_id": "student_123",
  "session_id": "session_abc",
  "request_id": "req_abc123def456",
  "execution_id": "exec_xyz789",
  
  "context": {
    "environment": "production",
    "service": "QueryService",
    "version": "1.0.0",
    "host": "api-pod-001",
    "deployment": "prod-us-east-1"
  },
  
  "event": {
    "type": "QUERY_EXECUTED",
    "query_hash": "abc123def",
    "query_type": "SELECT",
    "table_count": 2,
    "rows_returned": 23,
    "execution_time_ms": 142,
    "status": "SUCCESS"
  },
  
  "performance": {
    "duration_ms": 142,
    "cpu_ms": 45,
    "db_time_ms": 87,
 "network_ms": 10
  },
  
  "user_context": {
    "student_id": "student_123",
    "tier": "Junior Data Analyst",
    "case_id": "case_tier1_001"
  },
  
  "error": null,
  
  "tags": ["query_execution", "performance_tracked"],
  "metadata": {}
}
```

### Implementation (.NET 9 with Serilog)

```csharp
using Serilog;

// Program.cs
Log.Logger = new LoggerConfiguration()
  .MinimumLevel.Information()
    .Enrich.FromLogContext()
    .Enrich.WithProperty("Application", "DataQuest")
    .Enrich.WithProperty("Environment", app.Environment.EnvironmentName)
    .WriteTo.Console(new JsonFormatter())
    .WriteTo.Seq("http://seq-server:5341")  // or Application Insights, ELK, etc.
    .CreateLogger();

builder.Host.UseSerilog();

// In service/controller
public class QueryService
{
    private readonly ILogger<QueryService> _logger;

    public async Task<QueryResult> ExecuteQueryAsync(string query)
    {
        var executionId = Guid.NewGuid().ToString();
        var sw = Stopwatch.StartNew();

  try
        {
      _logger.LogInformation(
                "Executing query {QueryHash} with {TableCount} tables",
        GetQueryHash(query),
      GetTableCount(query));

            var results = await _mcp.ExecuteQuery(query);
  sw.Stop();

            _logger.LogInformation(
         "Query executed successfully: {ExecutionId} returned {RowCount} rows in {Duration}ms",
                executionId,
          results.RowCount,
    sw.ElapsedMilliseconds);

 return results;
        }
        catch (Exception ex)
        {
            sw.Stop();
            _logger.LogError(ex,
                "Query execution failed: {ExecutionId} after {Duration}ms",
       executionId,
       sw.ElapsedMilliseconds);
    throw;
        }
    }
}
```

---

## 🔗 Correlation IDs for Distributed Tracing

### Request Flow with Correlation IDs

```
Request arrives:
1. Generate Request ID: req_abc123def456
2. Generate Trace ID: trace_xyz789 (for entire request lifecycle)
3. Add to HTTP headers:
   X-Request-ID: req_abc123def456
   X-Trace-ID: trace_xyz789

Request flows through services:
1. API Controller (span_001)
   └─ Log: "Request received" [trace_xyz789, span_001]

2. QueryService (span_002)
   └─ Log: "Processing query" [trace_xyz789, span_002]

3. MCP Service (span_003)
   └─ Log: "Executing query" [trace_xyz789, span_003]

4. Database (span_004)
   └─ Log: "Query completed" [trace_xyz789, span_004]

5. Response returned
   └─ Log: "Response sent" [trace_xyz789, span_001]

ALL LOGS LINKED by trace_xyz789 → Can see complete flow
```

### Implementation

```csharp
// Middleware to inject correlation IDs
public class CorrelationIdMiddleware
{
  private readonly RequestDelegate _next;

    public async Task InvokeAsync(HttpContext context)
    {
        var requestId = context.Request.Headers.ContainsKey("X-Request-ID")
            ? context.Request.Headers["X-Request-ID"].ToString()
            : Guid.NewGuid().ToString();

        var traceId = context.Request.Headers.ContainsKey("X-Trace-ID")
         ? context.Request.Headers["X-Trace-ID"].ToString()
            : Guid.NewGuid().ToString();

        // Add to log context
        using (LogContext.PushProperty("RequestId", requestId))
   using (LogContext.PushProperty("TraceId", traceId))
        {
    context.Response.Headers.Add("X-Request-ID", requestId);
            context.Response.Headers.Add("X-Trace-ID", traceId);

            await _next(context);
 }
    }
}

// Register middleware
app.UseMiddleware<CorrelationIdMiddleware>();
```

---

## 📊 Application Performance Monitoring (APM)

### Metrics to Track

```
Request Metrics:
├─ Request count (per endpoint)
├─ Request latency (p50, p95, p99)
├─ Request error rate
├─ Request throughput (requests/sec)
└─ Request size (bytes)

Database Metrics:
├─ Query execution time (p50, p95, p99)
├─ Query count (per minute)
├─ Slow queries (> 3 seconds)
├─ Connection pool utilization
├─ Query errors
└─ Deadlock count

Service Metrics:
├─ MCP response time
├─ MCP error rate
├─ Agent response latency
├─ Cache hit rate
└─ Cache size

Business Metrics:
├─ Students logged in (DAU)
├─ Cases started (per hour)
├─ Queries submitted (per hour)
├─ Tier progressions
└─ Completion rate

System Metrics:
├─ CPU utilization
├─ Memory usage
├─ Disk usage
├─ Network I/O
└─ Container restarts
```

### Implementation with Application Insights / ELK

```csharp
// Option 1: Application Insights (Azure)
builder.Services.AddApplicationInsightsTelemetry();

var telemetryClient = new TelemetryClient();

// Track custom metric
telemetryClient.TrackEvent("QueryExecuted", new Dictionary<string, string>
{
    { "QueryHash", GetQueryHash(query) },
    { "RowCount", results.RowCount.ToString() }
}, new Dictionary<string, double>
{
    { "Duration", sw.ElapsedMilliseconds },
  { "RowsPerSecond", results.RowCount / (sw.ElapsedMilliseconds / 1000.0) }
});

// Option 2: Prometheus (for Grafana)
private static readonly Counter QueryCounter = Counter
 .Create("queries_total", "Total queries executed");

private static readonly Histogram QueryDuration = Histogram
    .Create("query_duration_ms", "Query execution duration");

// In service
QueryCounter.Inc();
using (QueryDuration.Observe(sw.ElapsedMilliseconds))
{
    // Query execution
}
```

---

## 🚨 Error Tracking

### Error Categories

```
Application Errors:
├─ Syntax errors in query
├─ Context errors (table not found)
├─ Query timeouts
├─ Rate limit exceeded
└─ Invalid input

Infrastructure Errors:
├─ Database connection failures
├─ Service timeouts
├─ Out of memory
├─ Disk space issues
└─ Network errors

Security Errors:
├─ Authentication failures
├─ Authorization failures
├─ SQL injection attempts
├─ Rate limit violations
└─ CSRF token failures
```

### Error Tracking Implementation

```csharp
try
{
    var result = await _mcp.ExecuteQuery(query);
}
catch (QueryTimeoutException ex)
{
    _logger.LogError(ex, "Query timeout: {Query}", query);
    sentryClient.CaptureException(ex, scope =>
    {
    scope.SetTag("error_type", "QUERY_TIMEOUT");
        scope.SetExtra("query_hash", GetQueryHash(query));
    });
}
catch (DatabaseConnectionException ex)
{
    _logger.LogError(ex, "Database connection failed");
    sentryClient.CaptureException(ex, scope =>
    {
        scope.SetTag("error_type", "DB_CONNECTION");
        scope.SetLevel(SentryLevel.Fatal);  // Critical alert
    });
}
```

---

## 📊 Dashboards

### Dashboard 1: System Health

```
Real-time indicators:
├─ API Response Time (p95)
├─ Error Rate (%)
├─ Database Connection Pool (%)
├─ Cache Hit Rate (%)
├─ Active Sessions
├─ Queries/Second
└─ System CPU / Memory

Color coding:
├─ Green: Normal (< warning threshold)
├─ Yellow: Warning (approaching limit)
├─ Red: Critical (threshold exceeded)
```

### Dashboard 2: Query Performance

```
Charts:
├─ Query execution time distribution (histogram)
├─ Top 10 slowest queries
├─ Query count by type (SELECT, aggregate, JOIN)
├─ Error rate by query type
├─ Query performance over time (trend)
└─ Queries by tier (tier 1 vs tier 5)

Filters:
├─ Time range (last hour, day, week)
├─ Query type
├─ Tier level
└─ Status (success/error)
```

### Dashboard 3: Student Experience

```
Metrics:
├─ Students active (real-time)
├─ Cases started (per hour)
├─ Queries submitted (per hour)
├─ Query success rate
├─ Tier progression rate
├─ Session duration average
└─ Common errors

Trends:
├─ Daily active users
├─ Week-over-week growth
├─ Case popularity
└─ Tier completion rate
```

### Dashboard 4: Security Events

```
Monitored:
├─ Failed login attempts
├─ Account lockouts
├─ Rate limit violations
├─ SQL injection attempts
├─ CSRF failures
├─ Unauthorized access attempts
└─ Token validation failures

Alerts:
├─ Multiple failed logins from same IP
├─ Spike in rate limit violations
├─ SQL injection attempt detected
├─ Unusual query patterns
└─ Security header violations
```

---

## 🚨 Alerting Rules

### Alert Severity Levels

```
CRITICAL (Immediate escalation):
├─ Database unavailable
├─ API service down
├─ Authentication service down
├─ Error rate > 5%
├─ Query timeout rate > 10%
├─ SQL injection attempt detected
└─ SLA: Page on-call engineer immediately

HIGH (Urgent):
├─ API response time p95 > 5 seconds
├─ Database connection pool > 90%
├─ Cache hit rate < 50%
├─ Rate limit violations > 10/min
├─ Failed login rate > 20/min
└─ SLA: Notify team within 5 minutes

MEDIUM (Investigation):
├─ Query execution time p95 > 3 seconds
├─ Database queries > 10/sec
├─ Memory usage > 85%
├─ Warning logs > 100/min
└─ SLA: Investigate within 1 hour

LOW (Monitoring):
├─ Unusual but not critical metric changes
├─ Debug logs spike
├─ Cache evictions increasing
└─ SLA: Review in daily standup
```

### Example Alert Rules

```yaml
# Prometheus alert rules (prometheus.rules.yml)
groups:
  - name: dataquest_alerts
    rules:
      # Critical: Error rate too high
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.05
    for: 2m
        labels:
      severity: critical
    annotations:
       summary: "High error rate detected"
          description: "Error rate is {{ $value | humanizePercentage }}"

      # High: Response time degradation
      - alert: SlowResponseTime
        expr: histogram_quantile(0.95, http_request_duration_ms) > 5000
        for: 5m
      labels:
   severity: high
        annotations:
  summary: "API response time degraded"
  description: "p95 latency is {{ $value }}ms"

      # Medium: Database connection pool pressure
      - alert: DBConnectionPoolPressure
        expr: db_connection_pool_utilization > 0.90
        for: 5m
    labels:
          severity: medium
    annotations:
          summary: "Database connection pool pressure"
  description: "Pool utilization is {{ $value | humanizePercentage }}"
```

---

## 📋 Log Retention & Archival

### Retention Policy

```
Real-time Logs (Hot Storage):
├─ Duration: 7 days
├─ Storage: Fast (SSD)
├─ Retention: Real-time queries
└─ Cost: Higher

Recent Logs (Warm Storage):
├─ Duration: 8-30 days
├─ Storage: Medium (HDD)
├─ Retention: Recent analysis
└─ Cost: Medium

Archive Logs (Cold Storage):
├─ Duration: 31-365 days
├─ Storage: Slow (Archive)
├─ Retention: Compliance, audit
└─ Cost: Low

Deletion:
├─ After 1 year: Archive deletion
├─ Exception: Critical security incidents (3 years minimum)
└─ Policy: Automatic, no manual intervention
```

### Implementation

```csharp
// Application Insights
new TelemetryConfiguration()
{
    DataCollectionLevel = DataCollectionLevel.Basic
};

// Serilog with tiered sinks
new LoggerConfiguration()
    .WriteTo.Console()          // Real-time
    .WriteTo.File("logs/log-.txt",
     rollingInterval: RollingInterval.Day,    // 7 days rolling
 retainedFileCountLimit: 7)
    .WriteTo.AzureTableStorage(         // Warm storage
        "connection-string",
        "DataQuestLogs",
        retentionDays: 30)
    .WriteTo.AzureBlobStorage(     // Cold storage
 "connection-string",
        "dataquest-logs-archive",
      retentionDays: 365)
    .CreateLogger();
```

---

## 🔧 Troubleshooting Guide

### Common Issues and Diagnostics

#### Issue: High Query Latency

```
Step 1: Check query logs
Query: logs | where event.type == "QUERY_EXECUTED" 
       | summarize AvgDuration = avg(performance.duration_ms) by query_type
       | where AvgDuration > 3000

Step 2: Identify slow queries
Query: logs | where performance.duration_ms > 3000
       | top 10 by performance.duration_ms

Step 3: Check database metrics
- Is connection pool exhausted?
- Are there blocking queries?
- Is disk I/O bottlenecked?

Step 4: Review execution plans
- Analyze slow query execution plans
- Check for missing indexes
- Review for suboptimal joins

Action:
- Add index if needed
- Rewrite query if inefficient
- Increase query timeout if acceptable
```

#### Issue: High Error Rate

```
Step 1: Identify error type
Query: logs | where level == "ERROR"
       | summarize Count = count() by error_type
       | sort by Count

Step 2: Drill into specific error
Query: logs | where error_type == "QUERY_TIMEOUT"
       | project timestamp, student_id, query_hash, duration_ms

Step 3: Check patterns
- Is it specific student or general?
- Is it specific query type or general?
- Is it specific time of day?

Step 4: Correlate with infrastructure
- Check database load
- Check network latency
- Check service resource usage

Action:
- If student-specific: throttle or educate
- If query-specific: optimize or alert user
- If infrastructure: scale or investigate
```

#### Issue: Memory Leak

```
Step 1: Check memory trend
Chart: memory_usage_bytes over time (24 hours)

Step 2: Correlate with activity
- Does memory increase with activity?
- Does memory increase monotonically?
- Does garbage collection happen?

Step 3: Identify problematic component
Query: logs | summarize MemoryByService = memory_bytes by service

Step 4: Get heap dumps
- Take heap dump at baseline
- Wait for memory growth
- Take another heap dump
- Diff to find leak

Action:
- Fix memory leak in identified service
- Deploy hotfix or rolling update
- Monitor memory usage post-fix
```

---

## 📊 Observability Checklist

### Pre-Production

```
Logging:
□ Structured JSON logging configured
□ Log levels correct per environment
□ Correlation IDs injected
□ Sensitive data masked (passwords, tokens)
□ Log retention policy configured
□ Log archival working

APM:
□ Application Insights / APM agent installed
□ Key metrics defined and tracked
□ Baseline metrics established
□ Performance targets documented

Error Tracking:
□ Error tracking service configured
□ All exceptions captured
□ Error grouping working
□ Severity levels assigned

Dashboards:
□ System health dashboard created
□ Query performance dashboard created
□ Student experience dashboard created
□ Security events dashboard created
□ All dashboards accessible to team

Alerts:
□ Alert rules configured
□ Severity levels defined
□ Notification channels set up
□ On-call escalation defined
□ Alert testing completed
```

### Post-Production

```
Monitoring:
□ All dashboards accessible
□ Alert notifications working
□ Alerts not noisy (tuned appropriately)
□ On-call team receives pages
□ Log searches fast and responsive

Maintenance:
□ Weekly review of alerts
□ Monthly review of metrics
□ Quarterly review of retention policies
□ Optimize dashboard queries
□ Train team on investigation procedures
```

---

## 🔗 Related Documents

**Core Specifications (Continuity Check):**
- ✅ Spec #5: API and Service Layer Architecture (service boundaries clear)
- ✅ Spec #7: Testing and QA Implementation Guide (performance benchmarks aligned)

**Infrastructure Documentation (Gap Fixes):**
- ✅ Gap #1: API Specification (performance targets documented)
- ✅ Gap #2: Deployment & Environment Configuration (logging in each environment)
- ✅ Gap #3: Security & Authentication Strategy (security event logging)
- ⏳ Gap #5: CI/CD Pipeline Configuration (CI/CD observability)

---

## ✅ Implementation Checklist

### Phase 1: Foundation

```
□ Serilog or similar structured logging library integrated
□ JSON formatting configured
□ Correlation IDs implemented
□ Log levels configured per environment
□ Application Insights or ELK stack deployed
□ Basic dashboards created
□ Alert rules configured
□ Error tracking service integrated (Sentry/etc.)
□ Log retention policy implemented
```

### Phase 1+: Hardening

```
□ APM agent installed and metrics flowing
□ Key metrics dashboards created
□ Alert tuning completed (minimal false positives)
□ Runbooks created for common incidents
□ Team trained on dashboards
□ Troubleshooting guide distributed
□ On-call procedures documented
```

### Ongoing: Operations

```
□ Logs monitored for anomalies
□ Dashboards reviewed daily
□ Alerts responded to within SLA
□ Performance trends tracked
□ Bottlenecks identified and addressed
□ Log storage costs optimized
□ Retention policies reviewed quarterly
```

---

## 🎓 Conclusion

This specification provides comprehensive observability coverage for DataQuest Phase 1 through:

1. **Structured Logging**: JSON format for machine parsing and analysis
2. **Correlation IDs**: Complete request tracing across services
3. **Performance Monitoring**: Real-time APM for optimization
4. **Error Tracking**: Comprehensive error capture and grouping
5. **Dashboards**: Operational visibility across dimensions
6. **Alerting**: Timely notification of issues
7. **Retention**: Compliance-grade log preservation

All aligned with existing specifications and supporting production monitoring readiness.

---

**LOGGING & OBSERVABILITY STRATEGY COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR IMPLEMENTATION**

