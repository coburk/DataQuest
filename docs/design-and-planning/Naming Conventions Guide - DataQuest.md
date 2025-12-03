# Naming Conventions Guide for DataQuest

**Version:** 1.0  
**Last Updated:** December 2025
**Scope:** DataQuest: SQL Detective application  
**Purpose:** Establish consistent, professional naming conventions across all project artifacts

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [C# Code Conventions](#c-code-conventions)
3. [Directory and File Conventions](#directory-and-file-conventions)
4. [Configuration and Infrastructure](#configuration-and-infrastructure)
5. [Version Control (Git)](#version-control-git)
6. [Documentation](#documentation)
7. [Quick Reference](#quick-reference)
8. [Common Mistakes](#common-mistakes)

---

## Core Principles

### The Rule

```
? C# Code:        PascalCase (class names, methods, properties)
? Directories:    lowercase-with-hyphens (for multi-word names)
? Config/Scripts: lowercase-with-hyphens (for multi-word names)
? Git Branches:   feature/lowercase-with-hyphens
? Never Mix:      Don't use hyphens in C# code, don't use PascalCase in paths
```

### Why These Rules Matter

| Principle | Benefit |
|-----------|---------|
| **Consistency** | Developers instantly recognize the naming pattern and purpose |
| **Command-line friendly** | `cd design-and-planning/` works directly without escaping |
| **URL safe** | Paths can be used in web URLs without encoding |
| **Standards compliance** | Follows Microsoft .NET and GitHub conventions |
| **Professional appearance** | Looks polished and intentional |
| **Searchability** | Easier to find in logs, documentation, and code |

---

## C# Code Conventions

### Project Names

**Format:** `CompanyOrOrg.ProjectName` or `CompanyOrOrg.ProjectName.Feature`

**Examples:**
```
? DataQuest.Models
? DataQuest.Database
? DataQuest.Services
? DataQuest.Orchestration
? DataQuest.Mcp
? DataQuest.Agents
? DataQuest.App
? DataQuest.Tests.Unit
? DataQuest.Tests.Integration
```

**Rules:**
- Use PascalCase (capitalize each word)
- Use dots (.) to separate logical groupings, not hyphens
- Start with organization name or prefix (DataQuest)
- Multi-part names use dots, not hyphens or underscores
- Test projects use `.Tests.` infix

**Wrong Examples:**
```
? dataquest.models    (lowercase)
? DataQuest-Models     (hyphen instead of dot)
? DataQuest_Models(underscore)
? dataquest_models    (both wrong)
```

### Namespace Names

**Format:** `DataQuest.LayerName.ComponentName`

**Examples:**
```
? namespace DataQuest.Models { }
? namespace DataQuest.Database { }
? namespace DataQuest.Services { }
? namespace DataQuest.Orchestration.Pipelines { }
? namespace DataQuest.Agents.Database { }
? namespace DataQuest.Mcp.Server { }
? namespace DataQuest.Tests.Unit.Models { }
```

**Rules:**
- Use PascalCase
- Use dots (.) to separate logical hierarchies
- Generally mirror folder structure
- Never use hyphens or underscores

**Structure Pattern:**
```
namespace DataQuest.<Layer>.<Feature> { }
  ?         ?      ?
    ?         ?      ?? Feature (optional, if needed)
         ?         ????????? Layer (Services, Database, Agents, etc.)
     ???????????????????? Organization prefix
```

### Class Names

**Format:** `PascalCase`

**Examples:**
```
? public class CasePlan { }
? public class QueryValidator { }
? public class MCPServer { }
? public class StoryStep { }
? public class CaseManager { }
? public class AgentOrchestrator { }
? public class HintGenerator { }
```

**Rules:**
- Capitalize first letter of each word (PascalCase)
- No underscores, hyphens, or spaces
- Use meaningful, descriptive names
- Nouns are preferred (Entity, Service, Manager)
- Avoid abbreviations unless widely understood (MCP, SQL, UI)

**Suffixes by Purpose:**
```
? *Service      - Business logic services (CaseService, QueryService)
? *Repository   - Data access layer (CaseRepository, QueryRepository)
? *Manager      - Orchestration/coordination (CaseManager, AgentOrchestrator)
? *Agent      - AI agents (DatabaseAgent, CasePlannerAgent)
? *Validator    - Validation logic (QueryValidator, SchemaValidator)
? *Generator    - Generation logic (HintGenerator, CasePlanner)
? *Context   - EF Core DbContext (DataQuestContext)
? *Exception    - Custom exceptions (InvalidCaseException)
```

**Prefixes for Interfaces:**
```
? IRepository   - Interface for repositories
? IService  - Interface for services
? IAgent        - Interface for agents
? IValidator    - Interface for validators
```

### Method Names

**Format:** `PascalCase` with clear, descriptive verbs

**Examples:**
```
? public async Task<CasePlan> LoadCaseAsync(string filePath) { }
? public bool ValidateQuery(string query) { }
? public List<TutorFeedback> GetFeedbackBySubmission(string submissionId) { }
? public Task<bool> ExecuteQueryAsync(string query) { }
? public void SetCurrentStep(int stepId) { }
```

**Rules:**
- Use PascalCase (first letter capitalized)
- Start with a verb (Get, Set, Create, Delete, Validate, Execute, Load, etc.)
- Include async suffix (`Async`) if method returns `Task` or `Task<T>`
- Use clear, descriptive names (not single letters)
- Follow the pattern: `Verb + Noun + Modifiers`

**Common Verb Prefixes:**
```
? Get*      - Retrieve data
? Set*      - Assign/modify data
? Create*   - Create/instantiate
? Delete*   - Remove/delete
? Update*   - Modify existing
? Validate* - Check/verify
? Load*     - Load from source
? Save*     - Save to destination
? Execute*  - Run/perform action
? Generate* - Create new output
```

### Property and Field Names

**Public Properties:** `PascalCase`
```csharp
? public string Title { get; set; }
? public int StepId { get; set; }
? public DateTime CreatedAt { get; set; }
? public List<Person> Persons { get; set; }
```

**Private Fields:** `_camelCase` (with leading underscore)
```csharp
? private string _caseTitle;
? private readonly IRepository _repository;
? private int _currentStep;
```

**Rules:**
- Public properties: PascalCase
- Private fields: underscore + camelCase
- Never use UPPER_CASE for fields (reserved for constants)
- Use meaningful, descriptive names

### Constants

**Format:** `UPPER_CASE_WITH_UNDERSCORES`

**Examples:**
```csharp
? public const int MAX_HINT_LEVEL = 3;
? public const string DEFAULT_MODEL_NAME = "llama3:8b-instruct";
? public const int QUERY_TIMEOUT_SECONDS = 15;
? private const string MCP_SCHEMA_DESCRIBE = "schema.describe";
```

**Rules:**
- Use all uppercase letters
- Separate words with underscores
- Use for static, immutable values
- Place at class level

### Enum Names and Values

**Format:** `PascalCase` for both enum name and values

**Examples:**
```csharp
? public enum FeedbackType
   {
       Hint,
       Correction,
       Encouragement,
       Clarification
   }

? public enum AgentStatus
   {
       Idle,
Processing,
    Complete,
       Error
   }
```

**Rules:**
- Enum name: PascalCase (noun)
- Enum values: PascalCase (not UPPER_CASE)
- Use meaningful names
- Consider plural form if it represents a collection

### Generic Type Parameters

**Format:** `T` or `T<Descriptor>`

**Examples:**
```csharp
? public class Repository<T> where T : class { }
? public async Task<T> GetByIdAsync<T>(int id) where T : class { }
? public IEnumerable<TEntity> GetAll<TEntity>() { }
```

**Rules:**
- Single letter: `T` for simple generics
- Prefixed: `T<Descriptor>` for clarity (e.g., `TEntity`, `TModel`)
- Convention: `T` is most common, followed by `U`, `V` if multiple
- Prefer descriptive names in complex scenarios

---

## Directory and File Conventions

### Root-Level Directories

**Format:** `lowercase-with-hyphens` for multi-word, `lowercase` for single-word

**Structure:**
```
DataQuest/
??? .github/    ? Single word (GitHub workflows)
??? config/   ? Single word (configuration files)
??? docs/    ? Single word (documentation)
??? sql/          ? Single word (database scripts)
??? src/   ? Single word (source code)
??? tests/         ? Single word (test projects)
??? tools/    ? Single word (utility scripts)
??? ...
```

**Rules:**
- Single-word directories: lowercase only
- Multi-word directories: lowercase-with-hyphens
- All lowercase (no uppercase letters)
- No spaces
- No underscores or other special characters

### Documentation Directories

**Format:** `lowercase-with-hyphens` for multi-word folders

**Examples:**
```
docs/
??? design-and-planning/    ? Multi-word: hyphens
??? diagrams/    ? Single word
??? research/? Single word
??? proposal/         ? Single word
??? ui-mockups/             ? Multi-word: hyphens
??? artifacts/        ? Single word
??? README.md
```

**Rules:**
- Use hyphens for clarity and consistency
- Prefer hyphens over spaces for file system compatibility
- Avoid abbreviations unless universally understood

### Source Code Directories

**Format:** `PascalCase` (matches C# project/namespace structure)

**Examples:**
```
src/
??? DataQuest.Models/    ? PascalCase
??? DataQuest.Database/        ? PascalCase
??? DataQuest.Services/         ? PascalCase
??? DataQuest.Orchestration/   ? PascalCase
??? DataQuest.Mcp/             ? PascalCase
??? DataQuest.Agents/    ? PascalCase
??? DataQuest.App/   ? PascalCase
```

**Rules:**
- Match the C# project name exactly
- Use PascalCase with dots
- Folder name = Project file name (without .csproj)

### Subdirectories Within Projects

**Format:** `PascalCase` (for C# code), `lowercase-with-hyphens` (for resources)

**Examples - C# Code Structure:**
```
src/DataQuest.Services/
??? Interfaces/    ? PascalCase (C# namespaces)
??? Implementations/  ? PascalCase
??? Models/           ? PascalCase
??? Exceptions/     ? PascalCase
??? Extensions/     ? PascalCase
```

**Examples - Resource Structure:**
```
src/DataQuest.App/
??? Resources/
?   ??? images/? lowercase
?   ??? styles/             ? lowercase
?   ??? templates/        ? lowercase
```

**Rules:**
- C# code structure: Use PascalCase (mirrors namespaces)
- Resource folders: Use lowercase or lowercase-with-hyphens

### Test Directories

**Format:** `PascalCase` for test projects, `lowercase-with-hyphens` for data

**Examples:**
```
tests/
??? DataQuest.Tests.Unit/           ? PascalCase (project name)
??? DataQuest.Tests.Integration/    ? PascalCase (project name)
??? DataQuest.Tests.Data/
    ??? case-plans/? lowercase-with-hyphens
    ??? llm-prompts/     ? lowercase-with-hyphens
    ??? data-seed/       ? lowercase-with-hyphens
 ??? schemas/        ? lowercase
    ??? sql-examples/     ? lowercase-with-hyphens
```

**Rules:**
- Test projects: PascalCase (matches C# convention)
- Test data folders: lowercase-with-hyphens

### C# File Names

**Format:** `PascalCase.cs` (matches class name)

**Examples:**
```
? CasePlan.cs        (contains class CasePlan)
? QueryValidator.cs            (contains class QueryValidator)
? ICaseRepository.cs           (contains interface ICaseRepository)
? CaseLoadingPipeline.cs       (contains class CaseLoadingPipeline)
```

**Rules:**
- File name must match the primary class/interface name
- Use PascalCase
- One public class/interface per file (standard practice)
- Exception: Nested classes can be in the same file

**Special Files:**
```
? Program.cs         (Program entry point)
? Startup.cs           (Startup configuration - if used)
? Constants.cs         (Static constants)
? Extensions.cs  (Extension methods)
```

### Configuration File Names

**Format:** `lowercase-with-hyphens.json` or `lowercase.json`

**Examples:**
```
config/
??? appsettings.json            ? Standard convention
??? appsettings.Development.json        ? Environment-specific
??? agent-endpoints.json        ? Multi-word: hyphens
??? user-preferences.json     ? Multi-word: hyphens
??? README.md
```

**Rules:**
- Use lowercase for all filenames
- Use hyphens for multi-word names
- `.json` extension for JSON files
- Environment suffixes: `.Development`, `.Production`, etc.

### Script File Names

**Format:** `lowercase-with-hyphens.ps1` or `.sh`

**Examples:**
```
tools/
??? setup-environment.ps1      ? PowerShell script
??? run-tests.sh             ? Bash script
??? build-solution.ps1 ? PowerShell script
??? install-dependencies.sh      ? Bash script
```

**Rules:**
- Use lowercase
- Use hyphens for multi-word names
- Include appropriate extension (.ps1, .sh, .bat, etc.)
- Make scripts executable (`chmod +x` on Unix)

### Markdown File Names

**Format:** `Title Case.md` (spaces acceptable for documentation)

**Examples:**
```
docs/design-and-planning/
??? Project Goals and Scope - DataQuest SQL Detective.md   ?
??? Core Domain Models.md  ?
??? Data Dictionary - DataQuest.md  ?
??? Pipeline - Case Loading - From JSON to Ready State.md   ?
??? README.md      ?
```

**Rules:**
- Use Title Case (capitalize key words)
- Spaces are acceptable in document filenames
- Use hyphens as separators for clarity (e.g., "Part A - Part B")
- `README.md` is always the main documentation file
- Use clear, descriptive titles

---

## Configuration and Infrastructure

### Configuration Files Structure

```
config/
??? appsettings.json              # Main config
??? appsettings.Development.json  # Dev overrides
??? appsettings.Production.json # Production overrides
??? agent-endpoints.json   # AI agent configurations
??? user-preferences.json         # User preference template
??? README.md                # Configuration guide
```

**File Naming Rules:**
- Base: `appsettings.json`
- Environment-specific: `appsettings.{Environment}.json`
- Feature-specific: `{feature}-endpoints.json` (lowercase-with-hyphens)

### GitHub Workflow Files

**Format:** `.github/workflows/{workflow-name}.yml`

**Examples:**
```
.github/workflows/
??? build-and-test.yml    ? Descriptive, hyphenated
??? code-analysis.yml     ? Hyphenated
??? publish-release.yml ? Hyphenated
??? deploy-production.yml  ? Hyphenated
```

**Rules:**
- Use lowercase-with-hyphens
- Use `.yml` extension (not `.yaml`)
- Descriptive names that indicate the workflow purpose

### Infrastructure Files at Root

**Format:** `.{filename}` for hidden files, `UPPERCASE` for main docs

**Examples:**
```
DataQuest/
??? .editorconfig     ? Editor configuration
??? .gitignore  ? Git ignore rules
??? global.json       ? .NET SDK version
??? Directory.Build.props        ? Shared MSBuild properties
??? DataQuest.sln           ? Solution file
??? README.md           ? Main documentation
??? CONTRIBUTING.md              ? Contribution guidelines
??? SETUP.md              ? Setup instructions
??? ARCHITECTURE.md          ? Architecture documentation
??? NAMING_CONVENTIONS.md        ? This file
??? LICENSE              ? License file
```

**Rules:**
- Configuration: lowercase with dot prefix (`.editorconfig`, `.gitignore`)
- Main documentation: `UPPERCASE.md`
- Always include `README.md` and `LICENSE`

---

## Version Control (Git)

### Branch Naming Convention

**Format:** `{type}/{description}` where description uses `lowercase-with-hyphens`

**Types:**
```
feature/   - New feature development
bugfix/    - Bug fixes
hotfix/          - Production hotfixes
refactor/        - Code refactoring (no feature changes)
docs/    - Documentation updates
test/  - Test additions or improvements
chore/        - Build, dependencies, tooling
experiment/      - Experimental features (temporary)
```

**Examples:**
```
? feature/case-loading-pipeline
? feature/query-validator-service
? bugfix/mcp-server-timeout
? hotfix/critical-security-patch
? refactor/database-layer
? docs/naming-conventions
? test/hint-generation-tests
? chore/update-dependencies
```

**Rules:**
- Always use lowercase
- Use hyphens to separate words
- Keep branch names short but descriptive
- Maximum 50 characters recommended
- Use forward slash (/) to separate type from description

**Wrong Examples:**
```
? Feature/Case-Loading-Pipeline     (type capitalized)
? feature_case_loading_pipeline(underscore instead of hyphen)
? feature case loading pipeline     (spaces)
? featureCaseLoadingPipeline        (no type prefix, CamelCase)
```

### Commit Messages

**Format:** `{type}: {description}` where description uses lowercase-with-hyphens

**Examples:**
```
? feat: add case loading pipeline service
? fix: resolve mcp server timeout issue
? docs: update naming conventions guide
? refactor: simplify query validator logic
? test: add unit tests for hint generation
? chore: update nuget package dependencies
```

**Rules:**
- Type: lowercase (feat, fix, docs, refactor, test, chore, etc.)
- Description: lowercase-with-hyphens, imperative mood
- Start with a verb (add, fix, update, resolve, etc.)
- Present tense ("add" not "added")
- No period at end

### Tag Names

**Format:** `v{major}.{minor}.{patch}` with optional prerelease

**Examples:**
```
? v1.0.0    (Release)
? v1.0.0-alpha        (Prerelease)
? v1.0.0-beta.1       (Beta with number)
? v1.0.0-rc.1       (Release candidate)
```

**Rules:**
- Use semantic versioning (major.minor.patch)
- Prefix with `v`
- Use lowercase for prerelease labels
- Use hyphen to separate prerelease identifiers

---

## Documentation

### Markdown File Structure

**Front Matter (Optional):**
```markdown
# Title: Descriptive Title

**Version:** 1.0  
**Last Updated:** December 2025  
**Status:** [Draft/Review/Final]  
**Author:** [Name]  
**Audience:** [Target audience]
```

### Markdown Headings

**Format:** Follow hierarchy with hyphens in anchor links

**Examples:**
```markdown
# Main Title (H1)
## Major Section (H2)
### Subsection (H3)
#### Detail (H4)

[Link to section](#major-section)  ? Hyphens in anchors
```

**Rules:**
- H1 (#) for document title
- H2 (##) for major sections
- Don't skip levels
- Markdown automatically converts headings to anchors with lowercase-hyphens

### Code Block Comments

**Format:** Clear, concise comments in camelCase

**Examples:**
```csharp
// ? Good: Clear purpose
private readonly IRepository _repository;

// ? Avoid: Single letters
private IRepository r;

// ? Good: Explains why, not just what
// Cache schema description to avoid repeated MCP calls
private Dictionary<string, string> _schemaCache;
```

### Documentation Examples

**Within docs/design-and-planning/:**
```
? File: Core Domain Models.md
? File: Data Dictionary - DataQuest.md
? File: Pipeline - Case Loading - From JSON to Ready State.md
```

**Rules:**
- Use Title Case for document titles
- Use hyphens/en-dashes for clarity: "Part A - Part B"
- Keep filenames descriptive but not overly long

---

## Quick Reference

### Decision Tree

```
What are you naming?

?? C# Class, Method, Property?
?  ?? Answer: PascalCase
?     Example: public class CaseManager { }
?
?? C# Private Field?
?  ?? Answer: _camelCase (with underscore)
?     Example: private int _currentStep;
?
?? Directory/Folder (multi-word)?
?  ?? Answer: lowercase-with-hyphens
?     Example: design-and-planning/
?
?? Directory/Folder (single word)?
?  ?? Answer: lowercase
?     Example: config/, tools/
?
?? Config File?
?  ?? Answer: lowercase-with-hyphens.json
?     Example: agent-endpoints.json
?
?? Script File?
?  ?? Answer: lowercase-with-hyphens.sh or .ps1
?     Example: setup-environment.ps1
?
?? Git Branch?
?  ?? Answer: type/lowercase-with-hyphens
?   Example: feature/case-loading-pipeline
?
?? Markdown Document?
??? Answer: Title Case.md (spaces ok)
?  Example: Core Domain Models.md
?
?? GitHub Workflow?
   ?? Answer: lowercase-with-hyphens.yml
 Example: build-and-test.yml
```

### Quick Lookup Table

| Item Type | Format | Example | Notes |
|-----------|--------|---------|-------|
| C# Project | PascalCase.WithDots | `DataQuest.Models` | No hyphens in projects |
| C# Namespace | PascalCase.WithDots | `DataQuest.Services.Core` | Use dots only |
| C# Class | PascalCase | `CaseManager` | Descriptive noun |
| C# Interface | IPascalCase | `IRepository` | I prefix |
| C# Method | PascalCase | `LoadCaseAsync()` | Verb + Async suffix |
| C# Property | PascalCase | `Title` | Public PascalCase |
| C# Field | _camelCase | `_currentStep` | Private underscore prefix |
| C# Constant | UPPER_CASE | `MAX_HINT_LEVEL` | All caps with underscores |
| Directory | lowercase-hyphens | `design-and-planning/` | Multi-word: hyphens |
| Config File | lowercase-hyphens | `agent-endpoints.json` | For multi-word |
| Script File | lowercase-hyphens | `setup-environment.ps1` | For multi-word |
| Git Branch | type/lowercase | `feature/case-loader` | type/description format |
| Markdown File | Title Case.md | `Core Domain Models.md` | Spaces ok in docs |
| GitHub Workflow | lowercase-hyphens.yml | `build-and-test.yml` | Multi-word: hyphens |

---

## Common Mistakes

### ? Mistake: Mixing Naming Styles

**Wrong:**
```csharp
public class case_manager { }           // Snake_case - WRONG
public class caseManager { }            // camelCase - WRONG (use PascalCase)
public class CaseManager { }   // ? CORRECT
```

**Fix:** Always use PascalCase for class names.

---

### ? Mistake: Using Hyphens in C# Code

**Wrong:**
```csharp
public void Load-Case() { }       // ? INVALID syntax
public class Case-Manager { }   // ? INVALID syntax
namespace DataQuest.Case-Loading { }    // ? INVALID syntax
```

**Fix:** Use hyphens only in directories, config files, and scripts—never in C# code.

---

### ? Mistake: Spaces in Directory Names

**Wrong:**
```
docs/design and planning/        // ? Spaces cause issues
design and planning/diagrams/    // ? Spaces require escaping
```

**Fix:** Use hyphens instead.
```
docs/design-and-planning/      // ? CORRECT
design-and-planning/diagrams/           // ? CORRECT
```

---

### ? Mistake: Inconsistent Git Branch Names

**Wrong:**
```
feature/CaseLoading             // ? CamelCase
Feature/case_loading    // ? Type capitalized
feature case_loading        // ? Spaces
```

**Fix:** Use type/lowercase-with-hyphens.
```
feature/case-loading     // ? CORRECT
```

---

### ? Mistake: Non-Descriptive Names

**Wrong:**
```csharp
public class CM { }   // ? Too short
public void ProcessData() { }           // ? Too vague
private int x { get; set; }      // ? Single letter
```

**Fix:** Use clear, descriptive names.
```csharp
public class CaseManager { }    // ? CORRECT
public void ValidateQueryAndCompare() { }  // ? CORRECT
private int CurrentStepId { get; set; } // ? CORRECT
```

---

### ? Mistake: Not Following C# Interface Convention

**Wrong:**
```csharp
public interface Repository { }     // ? No I prefix
public interface ICaseRepo { }          // ? Abbreviated "Repo"
```

**Fix:** Use I prefix with full names.
```csharp
public interface IRepository { }        // ? CORRECT
public interface ICaseRepository { }    // ? CORRECT
```

---

### ? Mistake: Inconsistent File Naming

**Wrong:**
```
CaseManager.cs  // ? CORRECT
case_manager.cs      // ? WRONG (snake_case)
caseManager.cs // ? WRONG (camelCase)
CASE-MANAGER.CS      // ? WRONG (uppercase)
```

**Fix:** Match file name to class name exactly.
```
CaseManager.cs   // ? CORRECT
```

---

## Enforcement and Tools

### EditorConfig

Add rules to `.editorconfig` to enforce conventions:

```ini
# C# file conventions
[*.cs]
# Naming conventions
csharp_style_namespace_declarations = file_scoped:silent

# Method naming
csharp_preferred_modifier_order = public,private,protected,internal

# Interface naming
dotnet_naming_style.interface_style.capitalization = pascal_case
dotnet_naming_symbols.interface_symbols.applicable_kinds = interface
```

### Pre-commit Hooks

Consider adding hooks to check:
- Branch naming format
- Commit message format
- File naming conventions

### Code Review Checklist

When reviewing code:
- [ ] Class names are PascalCase
- [ ] Method names start with a verb
- [ ] Private fields start with underscore
- [ ] Interfaces start with I
- [ ] Constants are UPPER_CASE
- [ ] Branch names follow type/description format
- [ ] No hyphens used in C# code

---

## Summary

This guide establishes **clear, professional naming conventions** for DataQuest to ensure:

? **Consistency** across all project artifacts  
? **Clarity** in purpose and function  
? **Compatibility** with .NET standards and tools  
? **Professionalism** in appearance and practice  

**Commit to following these conventions** to maintain a high-quality, maintainable codebase.

For questions or to propose updates, please create an issue or discussion in the repository.

---

**Document Version:** 1.0  
**Effective Date:** December 2025  
**Next Review:** June 2026
