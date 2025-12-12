# 🏗️ INFRASTRUCTURE & DEVOPS IMPLEMENTATION GUIDE

**Date:** December 3, 2025  
**Status:** OPERATIONAL SPECIFICATION  
**Version:** 1.0  
**Classification:** Implementation Guidance

---

## 📋 Document Purpose

This specification defines the infrastructure and DevOps strategy for DataQuest: SQL Detective. It operationalizes deployment, scaling, and operations into concrete procedures that ensure the application can be reliably deployed, monitored, and scaled.

**This document enables:**
- ✅ DevOps team to set up infrastructure
- ✅ Development team to understand deployment process
- ✅ Release manager to execute releases confidently
- ✅ Operations team to manage production environment
- ✅ Leadership to understand deployment strategy

---

## 🎯 Scope

### What This Document Covers

```
✅ Infrastructure architecture (cloud / on-premises)
✅ Environment configuration (dev/staging/production)
✅ CI/CD pipeline specification
✅ Database migration procedures
✅ Backup and restore procedures
✅ Disaster recovery planning
✅ Scaling strategy
✅ Deployment procedures
✅ Infrastructure-as-Code approach
✅ Performance optimization
```

---

## 🏗️ Infrastructure Architecture

### Target Architecture (Azure)

```
┌─────────────────────────────────────────────────────┐
│  INTERNET       │
└────────────────────┬────────────────────────────────┘
       │
 ↓
┌─────────────────────────────────────────────────────┐
│       Azure Front Door (CDN)         │
│        (SSL/TLS, DDoS protection)         │
└────────────────┬────────────────────────────────────┘
       │
       ↓
┌─────────────────────────────────────────────────────┐
│  App Service Environment  │
│  ┌──────────────────────────────────┐   │
│  │   App Service (Web API)    │   │
││   ├─ .NET 9 Runtime     │   │
│  │   ├─ Query Tutor Agent           │   │
│  │   ├─ Database Agent  │   │
│  │   └─ Case Service    │   │
│  │  │   │
│  │   Instances: 2-4 (auto-scale)│   │
│  └──────────────┬───────────────────┘   │
│           │    │
│  ┌──────────────┴───────────────────┐   │
│  │ ↓   │
│  │  ┌──────────────────────────────┐   │
│  │  │ App Service (MCP Server)  │   │
│  │  │ Query execution             │   │
│  │  └──────────────┬───────────────┘   │
│  │                 │   │
│  └─────────────────┼───────────────────┘
│    │
├───────────────────┼────────────────────┤
│      │      │
│     ┌─────────────┴──────────────┐     │
│     ↓ ↓     │
│  ┌────────────┐          ┌────────────┐│
│  │  App Config│    │ Key Vault  ││
│  │  Service   │          │(Secrets)   ││
│  └────────────┘  └────────────┘│
│            │
│     ┌────────────────────────────┐     │
│     ↓       ↓     │
│  ┌────────────────────────────────┐    │
│  │   SQL Server Database          │    │
│  │   ├─ CodeLog       │    │
│  │   ├─ Customers │    │
│  │   ├─ Cases         │    │
│  │   └─ Student Progress │    │
│  │     │    │
│  │   HA Setup: Availability Group │    │
│  └────────────────────────────────┘    │
│    │
│     ┌────────────────────────────┐     │
│     ↓             ↓   │
│  ┌──────────────┐┌──────────┐│
│  │ Redis Cache  │         │ Storage  ││
│  │ (Sessions, │         │ (Blobs,  ││
│  │  schema)     │         │  Logs)   ││
│  └──────────────┘      └──────────┘│
│   │
└────────────────────────────────────────┘
```

### Environment Tiers

```
DEVELOPMENT (Dev)
├─ Location: Local machine or dev Azure subscription
├─ Instances: 1 (Single instance)
├─ Database: Shared test database
├─ Backups: Daily snapshots (7-day retention)
├─ Purpose: Developer testing
└─ Cost: Minimal

STAGING (Pre-Production)
├─ Location: Azure East US
├─ Instances: 2 (for testing load balancing)
├─ Database: Production-like copy (anonymized data)
├─ Backups: Daily backups (14-day retention)
├─ Purpose: Final testing before production
└─ Cost: Medium

PRODUCTION
├─ Location: Azure (Multi-region: East US + West US)
├─ Instances: 2-4 (auto-scaling enabled)
├─ Database: HA/DR setup (Availability Group)
├─ Backups: Hourly backups (30-day retention)
├─ Purpose: Live student usage
└─ Cost: High (performance + redundancy)
```

---

## 🚀 CI/CD Pipeline Specification

### Pipeline Architecture

```
Developer
    ↓
    ├─ Push code to GitHub
    │  (or PR to main branch)
    ↓
Trigger CI Pipeline
    ├─ Step 1: Checkout code
    ├─ Step 2: Build (.NET 9)
    ├─ Step 3: Run unit tests
    ├─ Step 4: Run integration tests
    ├─ Step 5: Code quality scan (SonarQube)
    ├─ Step 6: Build Docker image
    ├─ Step 7: Push to container registry
    └─ Step 8: Publish test results

    ↓ If all pass, trigger CD pipeline

Deploy to STAGING
    ├─ Deploy to staging environment
    ├─ Run smoke tests
    ├─ Run performance tests
    ├─ Run security scan
    └─ Wait for approval

    ↓ With approval, deploy to PRODUCTION

Deploy to PRODUCTION
    ├─ Create backup of current version
    ├─ Deploy new version (blue-green)
    ├─ Run health checks
    ├─ Monitor error rate for 15 minutes
    ├─ If all good: Complete switch
    ├─ If issues: Automatic rollback
    └─ Notify team of deployment

Post-Deployment
    ├─ Run full test suite
    ├─ Monitor application metrics
  ├─ Collect user feedback
    └─ Create incident ticket if needed
```

### GitHub Actions Workflow

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
 - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: '9.0.x'
    
    - name: Restore dependencies
      run: dotnet restore
    
    - name: Build
      run: dotnet build --configuration Release --no-restore
    
    - name: Run unit tests
      run: dotnet test --filter Category=Unit --no-build
    
    - name: Run integration tests
      run: dotnet test --filter Category=Integration --no-build
    
    - name: SonarQube scan
  uses: SonarSource/sonarcloud-github-action@master
      env:
   GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
    
    - name: Build Docker image
      run: docker build -t dataquest:${{ github.sha }} .
    
    - name: Push to Azure Container Registry
      run: |
        docker tag dataquest:${{ github.sha }} myacr.azurecr.io/dataquest:${{ github.sha }}
     docker push myacr.azurecr.io/dataquest:${{ github.sha }}

  deploy-staging:
    needs: build-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - name: Deploy to staging
      run: |
        az webapp deployment slot create \
    --resource-group ${{ secrets.AZURE_RG }} \
          --name ${{ secrets.AZURE_APP_NAME }} \
  --slot staging \
          --configuration-source-name production
    
    - name: Run smoke tests
      run: pytest tests/smoke_tests.py --staging

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - name: Create backup
      run: |
     az sql db copy \
     --resource-group ${{ secrets.AZURE_RG }} \
          --server ${{ secrets.AZURE_SQL_SERVER }} \
          --name dataquest \
        --dest-name dataquest-backup-${{ github.sha }}
    
    - name: Deploy to production (blue-green)
      run: |
        az webapp deployment slot swap \
    --resource-group ${{ secrets.AZURE_RG }} \
          --name ${{ secrets.AZURE_APP_NAME }} \
        --slot staging
    
    - name: Health check
      run: curl -f https://api.dataquest.edu/health || exit 1
    
    - name: Monitor error rate
      run: python scripts/monitor_deployment.py --duration 15
```

---

## 💾 Database Management

### Database Schema Versioning

```
Versioning Strategy: Semantic versioning (1.0.0)

Schema Version: 1.0.0
├─ CodeLog table
├─ Customers table
├─ Cases table (metadata)
├─ StudentProgress table
├─ AgentResponses table
└─ Indexes on frequently queried columns

Migration Path:
├─ V1.0.0 (initial)
├─ V1.1.0 (add audit logging tables)
├─ V1.2.0 (add analytics tables)
├─ V2.0.0 (add authentication/authorization tables)
└─ Future versions as needed
```

### Database Backup Strategy

```
Production Backups:
├─ Automated hourly backups (30-day retention)
├─ Point-in-time recovery: up to 30 days
├─ Geographic redundancy: Paired region
├─ Full backup: Weekly
├─ Differential backup: Daily
├─ Transaction log backup: Hourly

Backup Testing:
├─ Monthly restore test to staging
├─ Verify data integrity
├─ Measure restore time
├─ Document recovery procedures

Disaster Recovery:
├─ RTO (Recovery Time Objective): 15 minutes
├─ RPO (Recovery Point Objective): 1 hour
├─ Failover to paired region: Automatic if primary down > 5 min
└─ Manual failover: If needed
```

### Migration Procedures

```
Process: Zero-downtime migration strategy

Pre-Migration:
1. Create migration script
2. Test on staging environment
3. Verify: No data loss, performance acceptable
4. Get approval from tech lead
5. Schedule during low-traffic window

During Migration:
1. Create backup of current database
2. Execute migration script (read-only mode)
3. Verify data consistency
4. Run test suite on migrated data
5. If all good: Switch to read-write mode
6. Monitor error rate for 30 minutes

Post-Migration:
1. Verify application functioning
2. Check query performance
3. Confirm no data loss
4. Document any changes
5. Archive previous backup
6. Notify stakeholders
```

---

## 🔄 Scaling Strategy

### Horizontal Scaling

```
Auto-Scaling Rules:
├─ CPU > 70% for 5 min: Scale up 1 instance
├─ Memory > 80% for 5 min: Alert (may need code optimization)
├─ CPU < 30% for 15 min: Scale down 1 instance
├─ Min instances: 2 (High Availability)
├─ Max instances: 4 (Cost control)

Trigger Conditions:
├─ Concurrent users > 100: Scale up
├─ Query timeout rate > 2%: Scale up
├─ Database connections > 80%: Scale database
└─ Agent response time p95 > 3s: Scale up

Load Balancing:
├─ Algorithm: Round-robin
├─ Health check: Every 10 seconds
├─ Sticky sessions: No (stateless design)
└─ Session state: Stored in Redis (not app memory)
```

### Vertical Scaling

```
Database Scaling:
├─ Current: Standard (2 vCores, 5GB)
├─ Trigger: Database CPU > 80% for 10 min
├─ Scale to: Premium (4 vCores, 20GB)
├─ Trigger: Premium CPU > 80%
├─ Scale to: Maximum (8 vCores, 50GB)

Cache Scaling:
├─ Current: Redis Basic (250MB)
├─ Trigger: Cache hits > 80% (good, no scaling needed)
├─ Trigger: Cache eviction rate > 1000 evictions/min
├─ Scale to: Redis Standard (2.5GB)
└─ Scale to: Redis Premium (50GB, if needed)
```

---

## 🔐 Security Procedures

### Secrets Management

```
Secrets Storage: Azure Key Vault

Secrets to Store:
├─ Database connection string
├─ API keys (external services)
├─ LLM API keys (OpenAI, Azure)
├─ Session encryption keys
├─ CORS allowed domains
└─ SSL certificates

Access Control:
├─ Only services that need access have access
├─ Role-based access control (RBAC)
├─ Audit logging of all access
├─ Secrets rotated quarterly
└─ Emergency rotation procedures

Code Implementation:
```csharp
var client = new SecretClient(
    vaultUri: new Uri(keyVaultUrl),
    credential: new DefaultAzureCredential());

var connectionString = client.GetSecret("db-connection-string").Value.Value;
```

### Network Security

```
Firewall Rules:
├─ Azure SQL: Allow only App Service connections
├─ App Service: Require HTTPS
├─ API endpoints: CORS restricted to known domains
└─ Database: No public internet access (Private Endpoint)

SSL/TLS Configuration:
├─ Minimum version: TLS 1.2
├─ Ciphers: Modern ciphers only
├─ Certificate: Auto-renewed (Let's Encrypt or Azure-managed)
└─ HTTP redirect: All traffic redirects to HTTPS
```

---

## 📋 Deployment Checklist

### Pre-Deployment

```
□ All tests passing
□ Code review completed
□ Merge to main branch
□ Release notes prepared
□ Database migrations tested on staging
□ Secrets configured in production
□ Monitoring alerts configured
□ On-call engineer assigned
□ Rollback plan documented
□ Customer communication prepared
```

### Deployment Day

```
□ Create production database backup
□ Deploy to staging environment
□ Run smoke tests on staging
□ Get final approval for production
□ Schedule deployment window
□ Notify stakeholders
□ Deploy to production (blue-green)
□ Verify: All instances healthy
□ Run health check endpoint
□ Monitor error rate
□ Check logs for exceptions
□ Verify functionality
□ Monitor for 30 minutes
```

### Post-Deployment

```
□ All instances responding
□ Error rate normal
□ Query performance acceptable
□ Agent services responding
□ Database queries performing
□ No unusual memory usage
□ Cache hit rates normal
□ Analytics showing traffic increase
□ Security scan passed
□ Create incident ticket if issues
□ Document any observations
```

---

## 🆘 Disaster Recovery Plan

### Recovery Procedures

```
Scenario: Database unavailable
├─ Detection: Health check fails
├─ Response time: < 5 minutes
├─ Action 1: Verify connectivity (check firewall)
├─ Action 2: Check database resource usage
├─ Action 3: If primary region down: Failover to paired region
├─ Action 4: If data corruption: Restore from backup
├─ Recovery time: 15 minutes
└─ Communication: Notify users, provide ETA

Scenario: Application crash
├─ Detection: Health check fails
├─ Response time: < 1 minute
├─ Action 1: Auto-restart container (if healthy)
├─ Action 2: Check error logs for root cause
├─ Action 3: If deployment issue: Automatic rollback
├─ Action 4: If resource issue: Scale up
├─ Recovery time: 5-10 minutes
└─ Communication: Notify users if > 2 minutes outage

Scenario: DDoS attack
├─ Detection: Traffic spike, high error rate
├─ Response time: < 2 minutes (automatic)
├─ Action 1: Azure DDoS protection engages
├─ Action 2: Rate limiting applied
├─ Action 3: Requests routed through WAF
├─ Recovery time: Automatic
└─ Communication: Automatic, no customer notification needed
```

---

## 📊 Performance Optimization

### Database Optimization

```
Indexes:
├─ Index on CodeLog(Status) - Filter queries
├─ Index on Cases(Tier) - Tier progression queries
├─ Index on StudentProgress(StudentID, CaseID) - Progress lookup
├─ Index on AgentResponses(SessionID) - Recent responses
└─ Review quarterly for unused indexes

Query Optimization:
├─ Query plan analysis for slow queries
├─ Consider materialized views for complex queries
├─ Archive old data (older than 1 year) to separate tables
├─ Monitor query execution time
└─ Set up query performance baseline
```

### Application Caching

```
Redis Cache Strategy:
├─ Schema cache: 24-hour TTL
├─ Student progress: 1-hour TTL
├─ Case metadata: 24-hour TTL
├─ Agent responses: 5-minute TTL
└─ Session data: User session duration

Cache Invalidation:
├─ On case update: Invalidate related cache
├─ On student progress: Invalidate progress cache
├─ On schema change: Invalidate schema cache
└─ Manual: Clear all cache command (emergency)
```

---

## ✅ Infrastructure Checklist

### Initial Setup

```
[ ] Create Azure subscription
[ ] Set up resource groups
[ ] Configure networking (VNet, subnets)
[ ] Set up Key Vault
[ ] Create SQL Database
[ ] Create App Service Plan
[ ] Deploy App Services
[ ] Configure DNS
[ ] Set up SSL certificates
[ ] Configure CDN
```

### CI/CD Setup

```
[ ] GitHub Actions configured
[ ] Container registry created
[ ] Build pipeline tested
[ ] Deploy to staging automated
[ ] Deploy to production (manual approval)
[ ] Rollback procedure tested
[ ] Notifications configured
[ ] Test pipeline execution
```

### Monitoring & Operations

```
[ ] Logging configured
[ ] Monitoring dashboards created
[ ] Alert rules configured
[ ] Health check endpoints verified
[ ] Backup automated
[ ] Disaster recovery tested
[ ] On-call rotation established
[ ] Runbooks documented
```

---

## 🎓 Conclusion

Comprehensive infrastructure and DevOps procedures ensure DataQuest can be **reliably deployed, scaled, and maintained** in production. With clear procedures, automated processes, and disaster recovery plans, operations can focus on ensuring high availability and performance.

**Key Success Factors:**

1. **Infrastructure as Code** - Reproducible, versioned setup
2. **Automated CI/CD** - Fast, reliable deployments
3. **Monitoring** - Know when problems occur
4. **Backup & Recovery** - Data always protected
5. **Scaling** - Handle growth automatically
6. **Security** - Secrets protected, traffic secure
7. **Procedures** - Team knows what to do

---

**INFRASTRUCTURE & DEVOPS GUIDE COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR IMPLEMENTATION**

