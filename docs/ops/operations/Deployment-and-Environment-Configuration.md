# Deployment & Environment Configuration Strategy

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - DEPLOYMENT & OPERATIONS  
**Version:** 1.0  
**Classification:** Critical - Required Before Phase 1 Launch

---

## 📋 Document Purpose

This specification defines the complete deployment strategy, environment configurations, and operational procedures for DataQuest across all environments (development, testing, staging, production). It ensures consistent, reliable deployments with minimal manual intervention and clear rollback procedures.

**This document enables:**
- ✅ DevOps to deploy to any environment reliably
- ✅ Development teams to set up local environments
- ✅ QA to provision test environments quickly
- ✅ Operations to manage production deployments
- ✅ Clear disaster recovery procedures

---

## 🎯 Scope

### What This Document Covers

```
✅ Environment configurations (dev/test/staging/prod)
✅ Docker containerization strategy
✅ Configuration management approach
✅ Secrets and credentials handling
✅ Database initialization and migrations
✅ Deployment procedures (step-by-step)
✅ Rollback procedures
✅ Environment variables specification
✅ Infrastructure requirements
✅ Health checks and monitoring
✅ Startup sequences
```

### What This Document Does NOT Cover

```
❌ Cloud provider selection (AWS/Azure/GCP)
❌ Kubernetes orchestration (Phase 2+)
❌ Advanced infrastructure automation
❌ Cost optimization strategies
```

---

## 🏗️ Environment Strategy

### Four Environments

```
┌──────────────────────────────────┐
│        DEVELOPMENT        │
├──────────────────────────────────┤
│ Local workstations          │
│ Mock databases    │
│ No external dependencies     │
│ Hot reload enabled         │
│ Verbose logging                  │
└──────────────────────────────────┘
           ↓
┌──────────────────────────────────┐
│        TESTING (QA)     │
├──────────────────────────────────┤
│ Automated testing             │
│ Test database (separate)         │
│ Scheduled test runs           │
│ Integration testing       │
│ Performance testing    │
└──────────────────────────────────┘
        ↓
┌──────────────────────────────────┐
│        STAGING       │
├──────────────────────────────────┤
│ Production-like environment      │
│ Production copy of data (masked) │
│ UAT testing   │
│ Performance testing   │
│ Production monitoring stack      │
└──────────────────────────────────┘
           ↓
┌──────────────────────────────────┐
│        PRODUCTION   │
├──────────────────────────────────┤
│ Live student environment         │
│ High availability           │
│ Load balanced         │
│ Full monitoring & alerting       │
│ Automated backups      │
│ Disaster recovery ready  │
└──────────────────────────────────┘
```

### Environment Specifications

#### Development Environment

```
Location: Developer local workstations
Database: Local SQL Server (or SQLite for testing)
Containers: Docker Desktop / Docker Compose
Configuration: Local appsettings.Development.json
Logging Level: DEBUG
Features: Hot reload, detailed error pages
Debugging: Full stack traces, breakpoints enabled
External APIs: Mocked/stubbed responses
Performance: Not optimized
Data: Sample/test data only
```

#### Testing Environment

```
Location: CI/CD pipeline or dedicated server
Database: Test SQL Server instance
Containers: Docker (ephemeral per test run)
Configuration: appsettings.Testing.json
Logging Level: INFO
Features: Test-specific configuration
Debugging: Detailed logs for failed tests
External APIs: Mocked or sandbox accounts
Performance: Adequate for test execution
Data: Test fixtures and seed data
Retention: Cleaned up after tests
```

#### Staging Environment

```
Location: Cloud/dedicated server (production-like)
Database: Production replica (with masked data)
Containers: Docker in production mode
Configuration: appsettings.Staging.json
Logging Level: INFO (with ERROR escalation)
Features: Production monitoring stack active
Debugging: Production error tracking
External APIs: Sandbox/staging accounts (if applicable)
Performance: Production-grade optimization
Data: Representative production data (masked)
Monitoring: Same stack as production
Health Checks: Active
Backups: Daily
SSL/TLS: Production certificates
```

#### Production Environment

```
Location: Cloud/dedicated infrastructure
Database: Production SQL Server (HA setup if possible)
Containers: Docker (orchestrated, load balanced)
Configuration: appsettings.Production.json
Logging Level: WARN/ERROR (with sampling)
Features: Production optimization
Debugging: Minimal stack traces (security)
External APIs: Live accounts
Performance: Fully optimized
Data: Real student data
Monitoring: Full observability stack
Health Checks: Continuous monitoring
Backups: Hourly (or as per RPO)
SSL/TLS: Current production certificates
Failover: Active-passive or load-balanced
```

---

## 🐳 Docker Containerization Strategy

### Dockerfile

**File:** `Dockerfile` (in solution root)

```dockerfile
# Multi-stage build for optimization

# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy and restore
COPY ["DataQuest_v2.sln", "."]
COPY ["src/DataQuest.Backend/*.csproj", "src/DataQuest.Backend/"]
COPY ["src/DataQuest.Agents/*.csproj", "src/DataQuest.Agents/"]
COPY ["src/DataQuest.MCP/*.csproj", "src/DataQuest.MCP/"]

RUN dotnet restore "DataQuest_v2.sln"

# Copy source and build
COPY . .
RUN dotnet build "DataQuest_v2.sln" -c Release -o /app/build

# Publish
FROM build AS publish
RUN dotnet publish "src/DataQuest.Backend/DataQuest.Backend.csproj" \
    -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copy published app
COPY --from=publish /app/publish .

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Labels
LABEL maintainer="DataQuest Team"
LABEL version="1.0.0"

# Run app
ENTRYPOINT ["dotnet", "DataQuest.Backend.dll"]
```

### Docker Compose

**File:** `docker-compose.yml` (for local development)

```yaml
version: '3.8'

services:
  # SQL Server Database
  sqlserver:
    image: mcr.microsoft.com/mssql/server:2022-latest
  environment:
   SA_PASSWORD: "LocalDev@Password123"
      ACCEPT_EULA: "Y"
    ports:
      - "1433:1433"
    volumes:
      - sqlserver_data:/var/opt/mssql
    healthcheck:
      test: /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "LocalDev@Password123" -Q "SELECT 1"
      interval: 10s
      timeout: 5s
      retries: 5

  # DataQuest Backend API
  api:
    build:
      context: .
      dockerfile: Dockerfile
 environment:
 ASPNETCORE_ENVIRONMENT: Development
      ASPNETCORE_URLS: "http://+:5000"
   ConnectionStrings__DataQuest: "Server=sqlserver,1433;Database=DataQuest;User Id=sa;Password=LocalDev@Password123;TrustServerCertificate=true"
      Logging__LogLevel__Default: "Information"
    ports:
      - "5000:5000"
    depends_on:
      sqlserver:
        condition: service_healthy
    volumes:
      - .:/src

volumes:
  sqlserver_data:
```

### Docker Production Configuration

For production, use orchestration (Docker Swarm or Kubernetes) with:
- Resource limits (CPU, memory)
- Restart policies
- Health checks
- Logging drivers
- Network policies
- Secret management

---

## 🔐 Secrets and Credentials Management

### Environment Variables (Non-Secret)

```
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://+:5000
LOG_LEVEL=WARN
DATABASE_POOL_SIZE=20
CACHE_TTL_SECONDS=3600
API_RATE_LIMIT_QUERIES_PER_HOUR=100
```

### Secrets Management Strategy

**Development:**
```
File: appsettings.Development.json (local, not in git)
Location: User's local machine
Rotation: Manual (if needed)
Storage: Plain text (local only)
```

**Testing:**
```
File: appsettings.Testing.json
Location: CI/CD environment variables
Rotation: Per CI/CD run or as needed
Storage: CI/CD secrets manager
```

**Staging & Production:**
```
Strategy: Azure Key Vault / AWS Secrets Manager
Rotation: Every 90 days (recommended)
Access: Role-based (least privilege)
Audit: All access logged
Secrets to manage:
  ├─ Database connection string
  ├─ JWT signing key
  ├─ LLM API keys (for agents)
  ├─ TLS certificate private keys
  └─ Backup encryption keys
```

### appsettings.json Structure

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning"
    }
  },
  "ConnectionStrings": {
    "DataQuest": "Server=localhost;Database=DataQuest;User Id=sa;Password=..."
  },
  "DataQuest": {
    "Api": {
      "RateLimiting": {
        "QueriesPerHour": 100,
        "SchemaQueriesPerHour": 500
   }
    },
    "Cache": {
      "SchemaTTLHours": 1,
      "QueryResultsTTLMinutes": 5
    },
    "Database": {
 "ConnectionPoolSize": 20,
   "CommandTimeoutSeconds": 30
    },
    "Security": {
      "JwtSecretKey": "STORED_IN_KEY_VAULT",
    "JwtExpirationHours": 24
    }
  }
}
```

---

## 🗄️ Database Initialization & Migration Strategy

### Database Setup

#### Initial Setup Script

**File:** `scripts/init-database.sql`

```sql
-- Create database if not exists
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DataQuest')
BEGIN
  CREATE DATABASE DataQuest;
END

-- Create main tables (from technical-design/database-schema)
USE DataQuest;

CREATE TABLE Students (
  StudentID INT PRIMARY KEY IDENTITY(1,1),
  Email NVARCHAR(255) UNIQUE NOT NULL,
  PasswordHash NVARCHAR(255) NOT NULL,
  CurrentTier INT DEFAULT 1,
  CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

CREATE TABLE Cases (
  CaseID VARCHAR(50) PRIMARY KEY,
  Name NVARCHAR(255) NOT NULL,
  TierNumber INT NOT NULL,
  DifficultySortOrder INT,
  CaseJson NVARCHAR(MAX) NOT NULL,
  CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

CREATE TABLE StudentSessions (
  SessionID VARCHAR(50) PRIMARY KEY,
  StudentID INT NOT NULL FOREIGN KEY REFERENCES Students(StudentID),
  CaseID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES Cases(CaseID),
  StartedAt DATETIME2 DEFAULT GETUTCDATE(),
  ExpiresAt DATETIME2 NOT NULL,
  State NVARCHAR(50) DEFAULT 'ACTIVE',
  CurrentQuestion INT DEFAULT 0
);

CREATE TABLE QueryExecutions (
  ExecutionID VARCHAR(50) PRIMARY KEY,
  SessionID VARCHAR(50) NOT NULL FOREIGN KEY REFERENCES StudentSessions(SessionID),
  QuestionIndex INT NOT NULL,
  QuerySubmitted NVARCHAR(MAX) NOT NULL,
  Status NVARCHAR(50) NOT NULL,
  ResultRowCount INT,
  ExecutionTimeMs INT,
  CreatedAt DATETIME2 DEFAULT GETUTCDATE()
);

-- Create indexes
CREATE INDEX IX_Students_Email ON Students(Email);
CREATE INDEX IX_StudentSessions_StudentID ON StudentSessions(StudentID);
CREATE INDEX IX_StudentSessions_ExpiresAt ON StudentSessions(ExpiresAt);
CREATE INDEX IX_QueryExecutions_SessionID ON QueryExecutions(SessionID);
CREATE INDEX IX_QueryExecutions_CreatedAt ON QueryExecutions(CreatedAt);
```

#### Entity Framework Migrations

**Migration Strategy:**

```
1. Development:
   - Use EF Core migrations for schema changes
   - Apply migrations automatically on startup (development only)
   - Command: dotnet ef database update

2. Testing:
   - Apply migrations as part of test setup
   - Use separate test database
   - Migrations run before each test run

3. Staging:
   - Manual migration approval required
- Dry-run before production
   - Scheduled during maintenance windows

4. Production:
   - Require separate approval/change request
   - Maintain migration history
   - Backup before applying
   - Rollback procedure ready
```

**Migration Commands:**

```bash
# Create new migration
dotnet ef migrations add AddNewFeature

# Review migration
dotnet ef migrations script

# Apply migration
dotnet ef database update

# Rollback
dotnet ef database update PreviousMigration

# Generate SQL script for production
dotnet ef migrations script --idempotent > migration.sql
```

---

## 📋 Configuration Management

### Configuration Files

```
appsettings.json (defaults)
├─ appsettings.Development.json (dev overrides)
├─ appsettings.Testing.json (test overrides)
├─ appsettings.Staging.json (staging overrides)
└─ appsettings.Production.json (production overrides)

Environment Variables (override all above)
```

### Load Order (highest priority last):

1. `appsettings.json` (base)
2. `appsettings.{ASPNETCORE_ENVIRONMENT}.json` (environment-specific)
3. Environment variables

### Configuration Validation

**Startup:** Validate all required configurations on application start

```csharp
// Program.cs
public void ValidateConfiguration(IConfiguration config)
{
  var requiredSettings = new[] {
    "ConnectionStrings:DataQuest",
    "DataQuest:Security:JwtSecretKey",
    "DataQuest:Database:CommandTimeoutSeconds"
  };

  foreach (var setting in requiredSettings)
  {
    if (string.IsNullOrEmpty(config[setting]))
      throw new InvalidOperationException($"Missing required setting: {setting}");
  }
}
```

---

## 🚀 Deployment Procedures

### Pre-Deployment Checklist

```
Environment Specific:
□ All configuration values set
□ Secrets loaded from vault
□ Database migrations prepared
□ SSL/TLS certificates current
□ DNS/networking configured
□ Firewall rules set

Testing:
□ All unit tests passing
□ Integration tests passing
□ Performance tests within targets
□ Security scan passed
□ Code review approved

Documentation:
□ Deployment notes updated
□ Rollback procedure reviewed
□ Team notified of deployment
□ Maintenance window scheduled (if needed)
```

### Development Environment Deployment

**Step 1: Local Setup**
```bash
# Clone repository
git clone https://github.com/user/DataQuest_v2.git
cd DataQuest_v2

# Start services with Docker Compose
docker-compose up -d

# Wait for database to be ready
# (docker-compose healthcheck handles this)

# Apply migrations
dotnet ef database update
```

**Step 2: Verify**
```bash
# Run application
dotnet run --project src/DataQuest.Backend

# Open browser
http://localhost:5000/swagger

# Verify endpoints responding
curl http://localhost:5000/health
```

### Testing Environment Deployment

**Automated in CI/CD Pipeline**

```yaml
# .github/workflows/deploy-testing.yml
name: Deploy to Testing

on:
  push:
    branches: [ develop ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
 
      - name: Build Docker image
        run: docker build -t dataquest:latest .
      
      - name: Push to registry
        run: docker push registry.example.com/dataquest:latest
  
      - name: Deploy to testing
  run: |
        kubectl set image deployment/dataquest-test \
    dataquest=registry.example.com/dataquest:latest
      
      - name: Run tests
        run: dotnet test --configuration Release
      
      - name: Performance tests
        run: ./scripts/performance-tests.sh
```

### Staging Deployment

**Manual with Automated Testing**

```bash
#!/bin/bash
# scripts/deploy-staging.sh

set -e  # Exit on error

echo "Starting staging deployment..."

# 1. Build
echo "Building Docker image..."
docker build -t dataquest:staging-v$(date +%s) .

# 2. Pull latest database
echo "Backing up production database..."
./scripts/backup-database.sh

echo "Restoring to staging..."
./scripts/restore-database-staging.sh

# 3. Apply migrations
echo "Running database migrations..."
dotnet ef database update --connection "Staging"

# 4. Deploy
echo "Deploying to staging..."
kubectl apply -f k8s/staging-deployment.yaml

# 5. Verify
echo "Waiting for deployment..."
kubectl rollout status deployment/dataquest-staging

echo "Running smoke tests..."
./scripts/smoke-tests.sh staging

echo "Deployment complete!"
```

### Production Deployment

**High Ceremony Process**

```bash
#!/bin/bash
# scripts/deploy-production.sh

set -e

echo "PRODUCTION DEPLOYMENT - PROCEED WITH CAUTION"
echo "============================================"

# 1. Pre-flight checks
echo "1. Running pre-flight checks..."
./scripts/preflight-checks.sh

# 2. Backup
echo "2. Creating backup..."
./scripts/backup-database.sh
./scripts/backup-config.sh

# 3. Deploy (blue-green strategy)
echo "3. Deploying (blue-green)..."
CURRENT_COLOR=$(kubectl get service dataquest-prod -o jsonpath='{.spec.selector.color}')
NEW_COLOR=$([ "$CURRENT_COLOR" = "blue" ] && echo "green" || echo "blue")

echo "   Deploying to $NEW_COLOR environment..."
kubectl apply -f k8s/prod-deployment-${NEW_COLOR}.yaml

# 4. Health checks
echo "4. Running health checks..."
kubectl rollout status deployment/dataquest-prod-${NEW_COLOR}
./scripts/health-checks.sh prod-${NEW_COLOR}

# 5. Smoke tests
echo "5. Running smoke tests..."
./scripts/smoke-tests.sh prod-${NEW_COLOR}

# 6. Traffic switch
echo "6. Switching traffic to $NEW_COLOR..."
kubectl patch service dataquest-prod -p '{"spec":{"selector":{"color":"'${NEW_COLOR}'"}}}'

echo "7. Monitoring..."
./scripts/monitor-deployment.sh 300  # Monitor for 5 minutes

echo "Production deployment complete!"
```

---

## 🔄 Rollback Procedures

### Immediate Rollback (if critical issue)

```bash
#!/bin/bash
# scripts/rollback-production.sh

echo "INITIATING PRODUCTION ROLLBACK"

# Switch back to previous color
CURRENT_COLOR=$(kubectl get service dataquest-prod -o jsonpath='{.spec.selector.color}')
PREVIOUS_COLOR=$([ "$CURRENT_COLOR" = "blue" ] && echo "green" || echo "blue")

echo "Switching traffic back to $PREVIOUS_COLOR..."
kubectl patch service dataquest-prod -p '{"spec":{"selector":{"color":"'${PREVIOUS_COLOR}'"}}}'

# Monitor
./scripts/monitor-deployment.sh 300

echo "Rollback complete!"
echo "Incident report required: ./scripts/create-incident-report.sh"
```

### Database Rollback

```bash
# For schema changes
dotnet ef database update <PreviousMigration>

# For data issues (use backup)
./scripts/restore-database.sh <BackupTimestamp>
```

---

## 🏥 Health Checks & Monitoring

### Health Check Endpoint

**Endpoint:** `GET /health`

```json
{
  "status": "Healthy",
  "timestamp": "2025-12-03T10:30:00Z",
  "services": {
    "database": {
      "status": "Healthy",
      "response_time_ms": 45
    },
    "mcp": {
      "status": "Healthy",
      "response_time_ms": 120
    },
    "cache": {
      "status": "Healthy",
      "response_time_ms": 5
  }
  },
  "version": "1.0.0"
}
```

### Startup Sequence

1. **Application Start**
   - Load configuration
   - Validate configuration
   - Initialize logging

2. **Services Initialization**
   - Connect to database
   - Verify schema (run pending migrations)
   - Initialize cache
   - Connect to MCP

3. **Ready State**
   - Health checks pass
   - Accept traffic
   - Begin monitoring

```csharp
public class StartupHealthCheck : IHostedService
{
  public async Task StartAsync(CancellationToken ct)
  {
    // Database connectivity
    if (!await _db.CanConnectAsync(ct))
   throw new InvalidOperationException("Cannot connect to database");
    
    // MCP connectivity
    if (!await _mcp.IsHealthyAsync(ct))
      throw new InvalidOperationException("MCP not responding");
    
    // Cache connectivity
    if (!await _cache.IsHealthyAsync(ct))
      throw new InvalidOperationException("Cache not responding");
  }
}
```

---

## 📊 Deployment Checklist

### Pre-Deployment

```
□ Code changes reviewed and merged
□ All tests passing (unit, integration, performance)
□ Security scan passed
□ Performance targets met
□ Configuration reviewed
□ Secrets configured
□ Migrations prepared
□ Rollback plan documented
□ Team notified
□ Maintenance window scheduled
```

### Deployment Execution

```
□ Pre-flight checks pass
□ Backup created
□ Database migrations applied
□ Container image deployed
□ Health checks pass
□ Smoke tests pass
□ Performance acceptable
□ Monitoring active
```

### Post-Deployment

```
□ Verify all endpoints responding
□ Check logs for errors
□ Monitor performance metrics
□ Verify database connectivity
□ Confirm students can login
□ Check case execution working
□ Verify agent responses
□ Monitor error rates
□ Document any issues
□ Celebrate success!
```

---

## ✅ Implementation Checklist

### Environment Setup

```
□ Development environment configured
□ Testing environment created
□ Staging environment created
□ Production environment created
□ All environments have separate databases
□ Configuration management system in place
□ Secrets vault configured
□ SSL/TLS certificates installed
```

### Deployment Automation

```
□ Docker containerization complete
□ Docker Compose for local development
□ CI/CD pipeline configured
□ Automated testing in pipeline
□ Automated deployment to testing
□ Manual approval for staging/production
□ Deployment scripts created and tested
□ Rollback procedures documented and tested
```

### Monitoring & Health

```
□ Health check endpoint implemented
□ Logging configured per environment
□ Monitoring stack deployed
□ Alerting rules configured
□ Performance baseline established
□ Incident response procedures documented
```

---

## 🔗 Related Documents

**Core Specifications:**
- `API-Specification.md` (Gap #1 - Just completed)

**Infrastructure Documentation (To Be Created):**
- Logging & Observability Strategy (Gap #2)
- Security & Authentication Strategy (Gap #3)
- CI/CD Pipeline Configuration (Gap #4)

---

**DEPLOYMENT & ENVIRONMENT CONFIGURATION COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR IMPLEMENTATION**

