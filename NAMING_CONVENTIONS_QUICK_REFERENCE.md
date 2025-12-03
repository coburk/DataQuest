# Naming Conventions Summary - Quick Reference

## The Core Rule

```
? USE HYPHENS for:  Directory names, config files, scripts, branch names
? DON'T CHANGE:    C# code, projects, namespaces (they use PascalCase)
```

---

## Quick Visual Guide

### ? DO Use Hyphens Here

```
docs/
??? design-and-planning/       ? (rename from "design and planning")
??? ui-mockups/  ? (already correct)
??? ai-agent-icons/? (already correct)

config/
??? agent-endpoints.json      ? (use hyphens)
??? user-preferences.json     ? (use hyphens)

tools/
??? setup-environment.ps1     ? (use hyphens)
??? run-tests.sh    ? (use hyphens)

.github/workflows/
??? build-and-test.yml        ? (use hyphens)
??? code-analysis.yml         ? (use hyphens)

tests/DataQuest.Tests.Data/
??? case-plans/      ? (use hyphens)
??? llm-prompts/              ? (use hyphens)
??? sql-examples/             ? (use hyphens)

Git Branches:
??? feature/case-loading-pipeline    ? (use hyphens)
??? feature/query-validator     ? (use hyphens)
```

### ? DO NOT Change (Keep PascalCase)

```
C# Code - NEVER use hyphens:
? public class CasePlan { }         ? Correct
? public class Case-Plan { }        ? Invalid syntax

? namespace DataQuest.Services { }  ? Correct
? namespace DataQuest-Services { }  ? Invalid syntax

? public void LoadCaseAsync() { }   ? Correct
? public void Load-Case-Async() { } ? Invalid syntax

Project Files - Keep as is:
? DataQuest.Models.csproj
? DataQuest.Database.csproj
? DataQuest.Orchestration.csproj
```

---

## Existing Inconsistencies to Fix

| Item | Current | Should Be |
|------|---------|-----------|
| `docs/design and planning/` | ? Spaces | ? `docs/design-and-planning/` |
| Everything else in `docs/` | ? Correct | Keep as is |
| C# Projects | ? All PascalCase | Keep as is |
| C# Namespaces | ? All PascalCase | Keep as is |

---

## Why This Matters

### ? Problems with spaces:
```powershell
cd docs\design and planning\   # ? BREAKS - spaces cause issues
cd "docs\design and planning\"      # ?? Requires escaping/quotes

# In URLs:
/docs/design%20and%20planning/      # ?? Gets encoded as %20
```

### ? Benefits of hyphens:
```powershell
cd docs\design-and-planning\        # ? WORKS - no escaping needed

# In URLs:
/docs/design-and-planning/          # ? Clean, readable
```

---

## Single Decision Rule

When deciding on naming:

```
    Is it C# code?
       /          \
    YES             NO
          /    \
   Use       Is it a directory
       PascalCase   or config/script?
  /               \
            YES            NO
        /            \
          Use hyphens    Use whatever
   for multi-word       is appropriate
          names              (usually PascalCase
  for document titles)
```

---

## Action Items Summary

### Immediate (Before Directory Restructuring)
- [ ] Document the naming convention decision
- [ ] Create `NAMING_CONVENTIONS.md` at root
- [ ] Add naming rules to `CONTRIBUTING.md`

### During Directory Restructuring
- [ ] Rename `docs/design and planning/` ? `docs/design-and-planning/`
- [ ] Use hyphens for all new multi-word directory names

### When Creating New Files
- [ ] Config files: `agent-endpoints.json`, `user-preferences.json`
- [ ] Scripts: `setup-environment.ps1`, `run-tests.sh`
- [ ] Test data dirs: `case-plans/`, `llm-prompts/`, `sql-examples/`
- [ ] GitHub workflows: `build-and-test.yml`
- [ ] Git branches: `feature/case-loading-pipeline`

### Never Change
- ? All existing C# projects (PascalCase)
- ? All existing C# namespaces (PascalCase)
- ? All existing C# code (PascalCase)

---

## Example Applied to DataQuest Structure

```
DataQuest/  (root - single word, no change needed)
??? .github/
?   ??? workflows/
?     ??? build-and-test.yml           ? Hyphens
?       ??? code-analysis.yml            ? Hyphens
?
??? config/
?   ??? appsettings.json          ? Correct
?   ??? agent-endpoints.json       ? Hyphens
?   ??? user-preferences.json ? Hyphens
?
??? docs/
?   ??? design-and-planning/     ? Rename from spaces
?   ??? ui-mockups/             ? Already correct
?   ??? ai-agent-icons/? Already correct
?   ??? README.md
?
??? sql/
?   ??? migrations/        ? Single word
?   ??? seeds/ (or data-seeds/)          ? Hyphen if needed
?
??? src/
?   ??? DataQuest.Models/      ? PascalCase (C#)
?   ??? DataQuest.Database/          ? PascalCase (C#)
?   ??? DataQuest.Services/       ? PascalCase (C#)
?   ??? DataQuest.Orchestration/         ? PascalCase (C#)
?   ??? DataQuest.Mcp/      ? PascalCase (C#)
?   ??? DataQuest.Agents/   ? PascalCase (C#)
?   ??? DataQuest.App/   ? PascalCase (C#)
?
??? tests/
?   ??? DataQuest.Tests.Unit/            ? PascalCase (C#)
?   ??? DataQuest.Tests.Integration/     ? PascalCase (C#)
?   ??? DataQuest.Tests.Data/            ? PascalCase (C#)
? ??? case-plans/        ? Hyphens
?     ??? llm-prompts/                 ? Hyphens
?       ??? data-seed/                ? Hyphens
?     ??? sql-examples/                ? Hyphens
?
??? tools/
?   ??? setup-environment.ps1  ? Hyphens
?   ??? run-tests.sh         ? Hyphens
?   ??? build-solution.ps1        ? Hyphens
?
??? DataQuest.sln    ? PascalCase (C#)
```

---

## Recommendation

? **YES - Apply this naming convention standardization**

1. **Establishes clear rules** - No ambiguity about what to name new files
2. **Looks professional** - Consistent with industry standards
3. **Improves usability** - Command-line friendly, no escaping needed
4. **Easy to implement** - Just rename one folder and create docs
5. **Non-breaking** - Doesn't affect any C# code, only directory/file names

**Should I include this in the complete directory restructuring plan?**
