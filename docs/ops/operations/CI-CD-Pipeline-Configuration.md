# CI/CD Pipeline Configuration

**Date:** December 3, 2025  
**Status:** IMPLEMENTATION SPECIFICATION - CI/CD PIPELINE  
**Version:** 1.0  
**Classification:** Critical - Required Before Phase 1 Launch

---

## 📋 Document Purpose

This specification defines the complete continuous integration and continuous deployment (CI/CD) pipeline for DataQuest, automating the build, test, analysis, and deployment processes across all environments. It ensures rapid, reliable, and quality-controlled releases while maintaining security and compliance.

**This document enables:**
- ✅ Automated testing on every code change
- ✅ Rapid feedback to developers
- ✅ Code quality gates enforcement
- ✅ Security scanning automation
- ✅ Reliable deployments to any environment
- ✅ Automated rollback on failures

---

## 🎯 Scope

### What This Document Covers

```
✅ CI/CD platform selection (GitHub Actions recommended)
✅ Pipeline stages and workflow
✅ Build process and automation
✅ Automated testing execution
✅ Code quality gates
✅ Security scanning (SAST, dependencies)
✅ Artifact versioning and storage
✅ Deployment automation
✅ Rollback procedures
✅ Monitoring and notifications
✅ Performance tracking
✅ Secret management in CI/CD
```

### What This Document Does NOT Cover

```
❌ Advanced deployment strategies (Canary, A/B testing Phase 2+)
❌ Kubernetes-specific orchestration
❌ Advanced GitOps strategies
❌ Custom workflow development
```

---

## 🏗️ CI/CD Architecture

### Pipeline Overview

```
Developer
    ↓ (git push)
GitHub Repository
 ↓
Webhook triggers
    ↓
┌─────────────────────────────────────────┐
│ PULL REQUEST PIPELINE       │
├─────────────────────────────────────────┤
│ 1. Build              │
│ 2. Unit Tests         │
│ 3. Code Quality Gate  │
│ 4. Security Scan │
│ 5. Code Review (manual)  │
│ ✓ Approve & Merge     │
└─────────────────────────────────────────┘
    ↓ (Merged to main)
┌─────────────────────────────────────────┐
│   MAIN BRANCH PIPELINE    │
├─────────────────────────────────────────┤
│ 1. Build      │
│ 2. Unit Tests     │
│ 3. Integration Tests  │
│ 4. Code Quality  │
│ 5. Security Scan      │
│ 6. Build artifacts    │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│   DEPLOYMENT PIPELINE   │
├─────────────────────────────────────────┤
│ 1. Deploy to Testing      │
│ 2. Run test suite    │
│ 3. Approve promotion      │
│ 4. Deploy to Staging    │
│ 5. Run smoke tests    │
│ 6. Approve production     │
│ 7. Deploy to Production   │
│ 8. Monitor (30min)    │
└─────────────────────────────────────────┘
```

---

## 🛠️ Platform: GitHub Actions

### Why GitHub Actions?

```
✅ Native integration with GitHub
✅ No additional infrastructure
✅ Generous free tier (2000 min/month)
✅ Extensive marketplace (pre-built actions)
✅ Good documentation
✅ Works across platforms (Linux, Windows, macOS)
✅ Secrets management built-in
```

### Alternative Platforms

```
✅ Azure Pipelines (already have Azure resources)
✅ Jenkins (self-hosted, maximum control)
✅ GitLab CI (if using GitLab)
⚠️ CircleCI (separate account, cost)
```

---

## 📋 Pipeline Stages

### Stage 1: Pull Request Pipeline

**Trigger:** On PR creation/update to `main` or `develop` branches

**File:** `.github/workflows/pr-checks.yml`

```yaml
name: PR Checks

on:
  pull_request:
  branches: [main, develop]
    paths:
      - 'src/**'
      - '.github/workflows/**'
      - 'tests/**'

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
      with:
          fetch-depth: 0  # Full history for analysis
      
      - name: Setup .NET 9
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '9.0.0'
      
      - name: Restore dependencies
    run: dotnet restore
      
      - name: Build
        run: dotnet build --configuration Release --no-restore
        
      - name: Upload build artifacts
      uses: actions/upload-artifact@v3
        with:
          name: build-artifacts
          path: |
            src/DataQuest.Backend/bin/Release/
  src/DataQuest.Agents/bin/Release/

  test:
    name: Unit Tests
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/checkout@v3
    
      - name: Setup .NET 9
        uses: actions/setup-dotnet@v3
        with:
   dotnet-version: '9.0.0'
      
      - name: Run unit tests
        run: dotnet test --configuration Release --no-build --logger:"trx" \
             --collect:"XPlat Code Coverage" \
    /p:CoverageDirectory=./coverage

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
      with:
          files: ./coverage/*
          flags: unittests
          fail_ci_if_error: false

      - name: Comment PR with test results
        if: always()
   uses: actions/github-script@v6
        with:
      script: |
  const fs = require('fs');
      const results = fs.readFileSync('test-results.txt', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
     owner: context.repo.owner,
repo: context.repo.repo,
     body: results
            });

  quality-gate:
    name: Code Quality
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/checkout@v3
      
    - name: Setup .NET 9
     uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '9.0.0'
      
  - name: Install SonarCloud scanner
  run: |
          dotnet tool install --global dotnet-sonarscanner
      
      - name: Analyze with SonarCloud
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
     SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        run: |
   dotnet sonarscanner begin \
            /k:"DataQuest_v2" \
            /o:"your-org" \
    /d:sonar.login=${{ secrets.SONAR_TOKEN }} \
            /d:sonar.host.url=https://sonarcloud.io \
         /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml"
       
 dotnet build
          
      dotnet sonarscanner end /d:sonar.login=${{ secrets.SONAR_TOKEN }}

  security:
    name: Security Scan
    runs-on: ubuntu-latest
    needs: build
steps:
      - uses: actions/checkout@v3
      
      - name: Setup .NET 9
        uses: actions/setup-dotnet@v3
        with:
    dotnet-version: '9.0.0'
   
      - name: Restore dependencies
        run: dotnet restore
    
      - name: Check for vulnerable dependencies
        run: dotnet list package --vulnerable --include-transitive
        continue-on-error: true
      
      - name: Run SAST analysis (Semgrep)
        uses: returntocorp/semgrep-action@v1
        with:
          generateSarif: true
      
      - name: Upload SARIF to GitHub
        uses: github/codeql-action/upload-sarif@v2
   with:
          sarif_file: semgrep.sarif

  decision:
    name: PR Status Decision
    runs-on: ubuntu-latest
    needs: [build, test, quality-gate, security]
    if: always()
    steps:
      - name: Check if all checks passed
    run: |
   if [ "${{ needs.build.result }}" != "success" ] || \
  [ "${{ needs.test.result }}" != "success" ] || \
     [ "${{ needs.quality-gate.result }}" != "success" ] || \
       [ "${{ needs.security.result }}" != "success" ]; then
            echo "Some checks failed"
   exit 1
          fi
          echo "All checks passed ✓"
```

---

### Stage 2: Main Branch Pipeline

**Trigger:** On merge to `main` branch

**File:** `.github/workflows/main-branch.yml`

```yaml
name: Main Branch Pipeline

on:
  push:
    branches: [main]
    paths:
      - 'src/**'
      - '.github/workflows/**'
      - 'tests/**'

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-test:
    name: Build & Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup .NET 9
    uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '9.0.0'
    
      - name: Restore & Build
        run: |
          dotnet restore
       dotnet build --configuration Release
      
   - name: Run all tests
        run: |
          dotnet test --configuration Release \
            --logger:"trx" \
            --collect:"XPlat Code Coverage"
      
      - name: Upload coverage
    uses: codecov/codecov-action@v3

  performance:
 name: Performance Tests
    runs-on: ubuntu-latest
    needs: build-and-test
    steps:
   - uses: actions/checkout@v3
      
      - name: Setup .NET 9
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '9.0.0'
      
      - name: Run performance tests
     run: dotnet test --configuration Release \
  --filter Category=Performance
      
      - name: Compare against baseline
   run: ./scripts/compare-performance.sh
   continue-on-error: true

  build-docker:
    name: Build Docker Image
    runs-on: ubuntu-latest
    needs: [build-and-test, performance]
    permissions:
      contents: read
      packages: write
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
  steps:
      - uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
 uses: docker/setup-buildx-action@v2
      
      - name: Log in to Container Registry
        uses: docker/login-action@v2
        with:
  registry: ${{ env.REGISTRY }}
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
  id: meta
        uses: docker/metadata-action@v4
        with:
     images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=semver,pattern={{version}}
     type=semver,pattern={{major}}.{{minor}}
            type=ref,event=branch
            type=sha,prefix=v{{branch}}-
 
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
        context: .
          push: true
   tags: ${{ steps.meta.outputs.tags }}
 labels: ${{ steps.meta.outputs.labels }}
       cache-from: type=gha
          cache-to: type=gha,mode=max

  tag-release:
    name: Create Release Tag
    runs-on: ubuntu-latest
    needs: build-docker
  steps:
      - uses: actions/checkout@v3
      
      - name: Generate version
        id: version
     run: |
          VERSION=$(git describe --tags --always --dirty)
      echo "version=$VERSION" >> $GITHUB_OUTPUT
      
   - name: Create tag
        run: |
        git tag -a v${{ steps.version.outputs.version }} \
            -m "Release ${{ steps.version.outputs.version }}"
        git push origin v${{ steps.version.outputs.version }}

  notify:
    name: Notify Team
    runs-on: ubuntu-latest
    needs: [tag-release]
if: always()
    steps:
      - name: Send Slack notification
        uses: slackapi/slack-github-action@v1
      with:
   payload: |
            {
       "text": "Main branch pipeline completed",
         "blocks": [
                {
               "type": "section",
       "text": {
        "type": "mrkdwn",
  "text": "Pipeline Status: ${{ job.status }}\nVersion: ${{ needs.tag-release.outputs.version }}"
           }
   }
              ]
     }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

---

### Stage 3: Deployment Pipeline

**Trigger:** Manual approval on main branch (or automatically based on tag)

**File:** `.github/workflows/deploy.yml`

```yaml
name: Deployment Pipeline

on:
  workflow_dispatch:
    inputs:
      environment:
   description: 'Deployment environment'
        required: true
        type: choice
    options:
          - testing
          - staging
      - production
      image-tag:
    description: 'Docker image tag to deploy'
    required: true
        default: 'latest'

jobs:
  deploy:
    name: Deploy to ${{ github.event.inputs.environment }}
    runs-on: ubuntu-latest
    environment:
      name: ${{ github.event.inputs.environment }}
      url: https://${{ github.event.inputs.environment }}-api.dataquest.dev
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure deployment
        run: |
          # Load environment-specific config
          . scripts/env/${{ github.event.inputs.environment }}.sh
   
   echo "DEPLOY_ENV=$DEPLOY_ENV" >> $GITHUB_ENV
      echo "API_URL=$API_URL" >> $GITHUB_ENV
        echo "DB_HOST=$DB_HOST" >> $GITHUB_ENV
      
      - name: Pre-deployment checks
        run: |
          ./scripts/preflight-checks.sh ${{ github.event.inputs.environment }}
    
    - name: Backup database
      if: github.event.inputs.environment == 'production'
   env:
   DB_CONNECTION_STRING: ${{ secrets[format('{0}_DB_CONNECTION', 
     github.event.inputs.environment)] }}
 run: ./scripts/backup-database.sh
      
      - name: Deploy using kubectl
        env:
          KUBE_CONFIG: ${{ secrets[format('{0}_KUBE_CONFIG', 
    github.event.inputs.environment)] }}
          DOCKER_IMAGE: ghcr.io/${{ github.repository }}:${{ github.event.inputs.image-tag }}
        run: |
   mkdir -p $HOME/.kube
       echo "$KUBE_CONFIG" | base64 -d > $HOME/.kube/config
          
          # Deploy using Helm or kubectl
          kubectl set image deployment/dataquest \
         api=${{ env.DOCKER_IMAGE }} \
          -n dataquest-${{ github.event.inputs.environment }}
        
          # Wait for rollout
 kubectl rollout status deployment/dataquest \
      -n dataquest-${{ github.event.inputs.environment }} \
            --timeout=5m
      
      - name: Run smoke tests
        run: ./scripts/smoke-tests.sh ${{ github.event.inputs.environment }}
   
      - name: Verify deployment
   run: ./scripts/health-checks.sh ${{ github.event.inputs.environment }}
      
      - name: Create deployment record
   run: |
          curl -X POST https://api.dataquest.dev/admin/deployments \
  -H "Authorization: Bearer ${{ secrets.ADMIN_TOKEN }}" \
 -H "Content-Type: application/json" \
       -d '{
     "environment": "${{ github.event.inputs.environment }}",
           "version": "${{ github.event.inputs.image-tag }}",
       "deployed_by": "${{ github.actor }}",
          "timestamp": "'$(date -u +'%Y-%m-%dT%H:%M:%SZ')'",
              "commit_sha": "${{ github.sha }}"
            }'
      
      - name: Notify deployment success
    if: success()
        uses: slackapi/slack-github-action@v1
        with:
      payload: |
            {
          "text": "✅ Deployment successful to ${{ github.event.inputs.environment }}",
          "blocks": [
                {
 "type": "section",
         "text": {
           "type": "mrkdwn",
          "text": "*Deployment Successful*\nEnvironment: ${{ github.event.inputs.environment }}\nVersion: ${{ github.event.inputs.image-tag }}\nDeployed by: @${{ github.actor }}"
          }
  }
          ]
         }
      env:
   SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
 
      - name: Rollback on failure
        if: failure() && github.event.inputs.environment == 'production'
        run: ./scripts/rollback-production.sh

  monitor:
    name: Monitor Deployment (30min)
    runs-on: ubuntu-latest
    needs: deploy
    if: always()
  steps:
      - uses: actions/checkout@v3
 
      - name: Monitor application
        run: ./scripts/monitor-deployment.sh ${{ github.event.inputs.environment }} 1800
```

---

## 🔑 Secrets Management

### GitHub Secrets Required

```
Credentials:
├─ GITHUB_TOKEN (auto-generated)
├─ SONAR_TOKEN (SonarCloud)
├─ SLACK_WEBHOOK (Slack notifications)
├─ ADMIN_TOKEN (DataQuest API)
└─ DOCKER_USERNAME / DOCKER_PASSWORD (optional)

Environment-Specific Secrets:
├─ TESTING_DB_CONNECTION
├─ STAGING_DB_CONNECTION
├─ PRODUCTION_DB_CONNECTION
├─ TESTING_KUBE_CONFIG
├─ STAGING_KUBE_CONFIG
├─ PRODUCTION_KUBE_CONFIG
└─ PRODUCTION_JWT_SECRET

Store in GitHub Settings > Secrets and variables
Access in workflows using: ${{ secrets.SECRET_NAME }}
```

---

## 📊 Pipeline Metrics

### Track These Metrics

```
Build Metrics:
├─ Build success rate
├─ Build duration (trend over time)
├─ Compilation warnings count
└─ Artifact size

Test Metrics:
├─ Test success rate
├─ Test execution time
├─ Code coverage % (target: > 80%)
├─ Tests per minute
└─ Failed test trend

Quality Metrics:
├─ SonarQube issues (blocker/critical/major)
├─ Code duplications %
├─ Code smells count
├─ Security hotspots
└─ Technical debt ratio

Deployment Metrics:
├─ Deployment frequency (per day)
├─ Deployment success rate
├─ Mean time to recovery (MTTR)
├─ Change failure rate
└─ Rollback frequency
```

---

## 🚨 Failure Handling

### Automatic Rollback

```yaml
# In deploy.yml
- name: Monitor for errors
  run: |
    for i in {1..30}; do
      HEALTH=$(curl -s https://api.dataquest.dev/health | jq .status)
    ERROR_RATE=$(curl -s https://api.dataquest.dev/metrics | jq .error_rate)
      
      if [ "$HEALTH" != "Healthy" ] || [ "$ERROR_RATE" > "0.05" ]; then
        echo "Deployment unhealthy, rolling back..."
        ./scripts/rollback-production.sh
        exit 1
      fi
      
      sleep 60
    done
```

### Deployment Strategies

#### Blue-Green Deployment

```bash
# 1. Deploy to GREEN (inactive)
kubectl apply -f k8s/deployment-green.yaml

# 2. Run tests against GREEN
./scripts/smoke-tests.sh green

# 3. Switch traffic to GREEN
kubectl patch service dataquest \
  -p '{"spec":{"selector":{"color":"green"}}}'

# 4. Keep BLUE as rollback target
# If issues detected, switch back to BLUE immediately
```

#### Canary Deployment

```bash
# Deploy new version to 5% of traffic
kubectl set image deployment/dataquest \
  api=new-image:tag \
  --replicas=20 \
  --selector=version=canary,weight=5%

# Monitor error rate for 10 minutes
# If error rate > threshold, rollback
# Otherwise, gradually increase to 100%
```

---

## 📋 Pipeline Checklist

### Pre-Production

```
Code Quality:
□ SonarQube configured
□ Quality gates enforced
□ Coverage thresholds set (> 80%)
□ Code review required

Security:
□ SAST scanning enabled
□ Dependency scanning enabled
□ Secret scanning enabled
□ License compliance check

Testing:
□ Unit tests automated
□ Integration tests automated
□ Performance tests automated
□ E2E tests automated (if applicable)

Build:
□ Docker build automated
□ Image pushed to registry
□ Artifacts stored
□ Versioning correct

Deployment:
□ Testing deployment automated
□ Staging deployment requires approval
□ Production deployment requires approval
□ Rollback procedures tested
```

### Post-Production

```
Monitoring:
□ Pipeline metrics visible
□ Success rate tracked
□ Deployment frequency monitored
□ MTTR tracked

Optimization:
□ Pipeline duration optimized
□ Parallel jobs where possible
□ Cache configured for builds
□ Artifacts cleaned up

Team:
□ Developers understand pipeline
□ On-call team knows procedures
□ Runbooks updated
□ Regular drills of failure scenarios
```

---

## 🔗 Related Documents

**Core Specifications (Continuity Check):**
- ✅ Spec #5: API and Service Layer Architecture (build artifacts contain all services)
- ✅ Spec #7: Testing and QA Implementation Guide (automated tests executed)

**Infrastructure Documentation (Gap Fixes):**
- ✅ Gap #1: API Specification (performance tracked in pipeline)
- ✅ Gap #2: Deployment & Environment Configuration (deployment integrated)
- ✅ Gap #3: Security & Authentication Strategy (security scanning included)
- ✅ Gap #4: Logging & Observability Strategy (logging configured per environment)

---

## ✅ Implementation Checklist

### Phase 1: Foundation

```
□ GitHub Actions workflows created
□ Build pipeline working
□ Unit tests automated
□ Docker image building
□ Deploy to testing automated
□ Smoke tests running
□ Notifications configured
```

### Phase 1+: Hardening

```
□ SonarQube integration complete
□ Code coverage > 80%
□ SAST scanning working
□ Dependency scanning working
□ Performance tests automated
□ Quality gates enforcing
□ Deploy to staging requires approval
□ Deploy to production requires approval
```

### Ongoing: Operations

```
□ Pipeline metrics tracked
□ Build success rate > 95%
□ Deployment success rate > 99%
□ Mean time to recovery < 15 minutes
□ No rollbacks due to test failures
□ Deployment frequency ≥ 1 per day
□ Team trained on procedures
```

---

## 🎓 Conclusion

This specification provides comprehensive CI/CD automation for DataQuest Phase 1 through:

1. **Automated Building**: Consistent, reproducible builds
2. **Comprehensive Testing**: Unit, integration, performance, and E2E
3. **Quality Enforcement**: Code quality gates with SonarQube
4. **Security Scanning**: SAST and dependency vulnerability detection
5. **Automated Deployment**: Safe, repeatable deployments to all environments
6. **Monitoring & Rollback**: Automatic detection and recovery from failures
7. **Team Visibility**: Dashboards, notifications, and audit trails

All aligned with existing specifications and supporting rapid, reliable development and deployment.

---

**CI/CD PIPELINE CONFIGURATION COMPLETE:** December 3, 2025  
**Status:** ✅ **READY FOR IMPLEMENTATION**

