# Naming Conventions Analysis & Standardization Recommendations

## Current State of Naming Conventions

### Directory Naming Patterns in Current Codebase

```
docs/
??? ai-agent-icons/         ? Uses hyphens (GOOD)
??? artifacts/  ? Single word (GOOD)
??? design and planning/    ? Uses spaces (INCONSISTENT)
??? diagrams/  ? Single word (GOOD)
??? proposal/               ? Single word (GOOD)
??? research/               ? Single word (GOOD)
??? ui-mockups/             ? Uses hyphens (GOOD)
```

### Project/File Naming Patterns

```
C# Projects:
- DataQuest.Models    ? PascalCase (Standard for .NET projects)
- DataQuest.Database   ? PascalCase
- DataQuest.Services              ? PascalCase
- DataQuest.Tests.Unit     ? PascalCase
- DataQuest.Tests.Integration     ? PascalCase

Files:
- Project Goals and Scope - DataQuest SQL Detective.md    ?? Spaces (acceptable for documents)
- Core Domain Models.md      ?? Spaces (acceptable for documents)
- Draft JSON case schema.md      ?? Spaces (acceptable for documents)
```

---

## Analysis: Where to Apply Hyphen Naming Convention

### ? YES - Use Hyphens For These:

| Context | Examples | Why |
|---------|----------|-----|
| **Directory names** | `design-and-planning/`, `ui-mockups/` | Easier for command-line, cleaner in paths, standard convention |
| **URLs/Web content** | Future web UI routes | URLs shouldn't use spaces (they get encoded as %20) |
| **Configuration files** | `agent-endpoints.json`, `user-preferences.json` | Consistency with directory naming |
| **Hyphenated project names** (if any) | e.g., `DataQuest.Mcp-Integration` | Could use hyphens for multi-word descriptors |
| **GitHub branch names** | `feature/case-loading-pipeline` | Standard GitHub convention |
| **Script names** | `setup-environment.ps1`, `run-tests.sh` | Industry standard for scripts |

### ?? MAYBE - Context Dependent:

| Context | Current | Recommendation |
|---------|---------|-----------------|
| **C# Project names** | `DataQuest.Agents` | Keep PascalCase (C# standard) - DO NOT change |
| **C# Namespaces** | `DataQuest.Services` | Keep PascalCase (C# standard) - DO NOT change |
| **C# File names** | `CaseDefinition.cs` | Keep PascalCase (C# standard) - DO NOT change |
| **Markdown document titles** | `Core Domain Models.md` | Can keep spaces (acceptable for document names) |
| **Markdown anchor links** | `#design-and-planning` | Use hyphens when creating headers/anchors |

### ? NO - Do NOT use hyphens for:

| Context | Reason |
|---------|--------|
| **C# Classes** | `public class Case-Definition` - Invalid C# syntax |
| **C# Namespaces** | `namespace DataQuest.Design-And-Planning` - Invalid C# syntax |
| **C# Method names** | `public void Load-Case()` - Invalid C# syntax |
| **Package/NuGet names** | Already standardized (use dots and PascalCase) |
| **Database names** | Already standardized (usually PascalCase or snake_case) |

---

## Recommended Standardization Strategy

### Tier 1: Apply Immediately (High Priority)

```
docs/
??? design-and-planning/      ? Rename from "design and planning"
??? ai-agent-icons/       ? Already correct
??? diagrams/ ? Already correct
??? proposal/               ? Already correct
??? research/ ? Already correct
??? ui-mockups/   ? Already correct
```

### Tier 2: Apply When Creating New Items (Medium Priority)

**When creating new configuration files:**
- `appsettings.json` ? (already lowercase, correct)
- `agentendpoints.json` ? Consider `agent-endpoints.json` 
- `userpreferences.json` ? Consider `user-preferences.json`

**When creating new directories:**
- Use hyphens for multi-word names: `llm-prompts/`, `test-data/`, `case-plans/`
- Single words: `artifacts/`, `diagrams/`, `research/` (no change needed)

**When creating GitHub branches:**
- `feature/case-loading-pipeline` ?
- `feature/query-validator` ?
- `fix/mcp-server-timeout` ?

**When creating script files:**
- `setup-environment.ps1` ?
- `run-tests.sh` ?
- `build-solution.ps1` ?

### Tier 3: Do NOT Change (Preserve C# Standards)

- All C# class names (PascalCase)
- All C# namespace names (PascalCase)
- All C# method/property names (PascalCase)
- Project file names (PascalCase)
- NuGet package names

---

## Complete Naming Convention Guide

### For This Project: "DataQuest"

| Item Type | Format | Example | Notes |
|-----------|--------|---------|-------|
| **Directories** | lowercase-with-hyphens | `design-and-planning/`, `llm-prompts/` | Multi-word dirs use hyphens |
| **C# Projects** | PascalCase.WithDots | `DataQuest.Models`, `DataQuest.Mcp` | Standard .NET convention |
| **C# Namespaces** | PascalCase.WithDots | `DataQuest.Services`, `DataQuest.Orchestration` | Standard .NET convention |
| **C# Classes** | PascalCase | `CasePlan`, `QueryValidator`, `MCPServer` | Standard .NET convention |
| **C# Methods** | PascalCase | `LoadCaseAsync()`, `ExecuteQueryAsync()` | Standard .NET convention |
| **Config Files** | lowercase-with-hyphens | `agent-endpoints.json`, `user-preferences.json` | Consistency with directories |
| **Script Files** | lowercase-with-hyphens | `setup-environment.ps1`, `run-tests.sh` | Standard convention |
| **Git Branches** | lowercase-with-hyphens | `feature/case-loading-pipeline` | GitHub standard |
| **Document Files** | Title Case (spaces ok) | `Core Domain Models.md` | Readable, acceptable for docs |

---

## Implementation Plan

### Phase 1: Documentation Structure (DO IMMEDIATELY)

1. Rename `docs/docs/design and planning/` ? `docs/design-and-planning/`
2. Verify all other doc folder names use consistent convention (hyphens for multi-word)

### Phase 2: Configuration Files (DO BEFORE CODE DEVELOPMENT)

When creating configuration files in `config/`:
- ? `appsettings.json` (already correct)
- ? `appsettings.Development.json` (already correct)
- ?? `agent-endpoints.json` (use hyphens)
- ?? `user-preferences.json` (use hyphens)

### Phase 3: New Directories in Tests (DO BEFORE CODE DEVELOPMENT)

When creating test data directories:
- `tests/DataQuest.Tests.Data/case-plans/` ? Hyphenated
- `tests/DataQuest.Tests.Data/llm-prompts/` ? Hyphenated
- `tests/DataQuest.Tests.Data/sql-examples/` ? Hyphenated

### Phase 4: Scripts and Tools (DO BEFORE CODE DEVELOPMENT)

When creating scripts in `tools/`:
- `tools/setup-environment.ps1`
- `tools/run-tests.sh`
- `tools/build-solution.ps1`

### Phase 5: GitHub Workflows (DO DURING CI/CD SETUP)

- `.github/workflows/build-and-test.yml`
- `.github/workflows/code-analysis.yml`
- Branch naming convention docs

---

## Benefits of This Standardization

| Benefit | Impact |
|---------|--------|
| **Command-line friendly** | `cd design-and-planning/` works without escaping; `cd design\ and\ planning/` requires escaping |
| **URL safe** | If web UI is added later, paths don't need encoding |
| **Professional** | Looks modern and follows current industry standards |
| **Searchable** | Easier to find in documentation and logs |
| **Consistent** | Clear rule: "multi-word directory names use hyphens" |
| **No conflicts** | Hyphens vs. dots have different purposes (hyphens for directory names, dots for namespaces) |

---

## Summary & Recommendation

### ? **YES - Standardize on hyphens for:**
- Directory/folder names (especially multi-word)
- Configuration file names
- Script file names
- GitHub branch names
- New file/folder names going forward

### ? **NO - Do NOT change:**
- C# project names (PascalCase is standard)
- C# namespaces (PascalCase is standard)
- C# code (PascalCase is standard)
- Existing document file names (acceptable with spaces)

### ?? **Action Items:**

1. **Rename immediately:** `docs/docs/design and planning/` ? `docs/design-and-planning/`
2. **Create standard:** When creating new dirs, use `lowercase-with-hyphens` for multi-word names
3. **Document this:** Add to `.editorconfig` or `CONTRIBUTING.md` as a guideline
4. **Apply consistently:** Use this convention when creating `config/`, `tools/`, and test data directories

**Should I proceed with creating a formal NAMING_CONVENTIONS.md document and implementing these changes?**
