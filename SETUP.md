# Setup Instructions for DataQuest Development

This document provides step-by-step instructions to set up a local development environment for DataQuest.

## Prerequisites

### Required Software

- **Windows 10/11** or **macOS/Linux** with WSL2
- **.NET 9 SDK** (download from [dotnet.microsoft.com](https://dotnet.microsoft.com/download))
- **Visual Studio 2022** (Community Edition minimum) OR **Visual Studio Code**
- **SQL Server** (LocalDB or full installation)
- **Ollama** (for local LLM support) - download from [ollama.ai](https://ollama.ai)
- **Git** (for version control)

### Verify Installations

```bash
# Check .NET installation
dotnet --version

# Check Git installation
git --version

# Check SQL Server (if installed)
sqlcmd -?

# Check Ollama (after installation)
ollama --version
```

## Installation Steps

### Step 1: Clone the Repository

```bash
git clone https://github.com/coburk/DataQuest.git
cd DataQuest
```

### Step 2: Restore NuGet Packages

```bash
dotnet restore
```

### Step 3: Build the Solution

```bash
dotnet build DataQuest.sln
```

### Step 4: Configure Database

#### Option A: Use LocalDB (Recommended for Development)

1. Create the database:
   ```bash
   sqlcmd -S (localdb)\mssqllocaldb -i sql/create_dataquest_db.sql
   ```

2. Seed sample data:
   ```bash
   sqlcmd -S (localdb)\mssqllocaldb -i sql/seed_data.sql
   ```

#### Option B: Use Full SQL Server Installation

Edit `config/appsettings.json` and update the connection string:
```json
"ConnectionStrings": {
  "DataQuestDB": "Server=YOUR_SERVER;Database=DataQuestDB;Integrated Security=True;"
}
```

### Step 5: Configure Application

1. Copy configuration templates (if needed):
   ```bash
   cp config/appsettings.json config/appsettings.Development.json
   ```

2. Edit `config/appsettings.json` with your settings:
   - Database connection string
   - Case storage directory
   - Logging preferences

3. Edit `config/agent-endpoints.json` with your settings:
   - Ollama endpoint URL (usually `http://localhost:11434`)
   - LLM model name (e.g., `llama3:8b-instruct`)

### Step 6: Set Up Ollama (Optional, for AI Features)

1. Install Ollama from [ollama.ai](https://ollama.ai)
2. Start Ollama:
   ```bash
   ollama serve
   ```
3. In another terminal, pull a model:
   ```bash
   ollama pull llama3:8b-instruct
   ```

### Step 7: Run the Application

#### Using Visual Studio
1. Open `DataQuest.sln` in Visual Studio
2. Set `DataQuest.App` as the startup project
3. Press F5 to run

#### Using Command Line
```bash
cd src/DataQuest.App
dotnet run
```

#### Using dotnet CLI
```bash
dotnet run --project src/DataQuest.App
```

### Step 8: Run Tests

```bash
# Run all tests
dotnet test

# Run specific test project
dotnet test tests/DataQuest.Tests.Unit

# Run with verbose output
dotnet test --verbosity detailed
```

## Troubleshooting

### SQL Server Connection Issues

**Problem:** "Cannot connect to database"

**Solution:**
1. Verify SQL Server is running:
   ```bash
   # For LocalDB
   sqllocaldb info mssqllocaldb
   ```
2. Check connection string in `config/appsettings.json`
3. Ensure database exists: `sqlcmd -S (localdb)\mssqllocaldb -Q "SELECT name FROM sys.databases"`

### Ollama Not Responding

**Problem:** "Cannot reach Ollama at http://localhost:11434"

**Solution:**
1. Verify Ollama is running: `ollama serve`
2. Check Ollama endpoint in `config/agent-endpoints.json`
3. Try accessing Ollama directly: `curl http://localhost:11434/api/tags`

### NuGet Package Restore Fails

**Problem:** "Error restoring NuGet packages"

**Solution:**
1. Clear NuGet cache:
   ```bash
   dotnet nuget locals all --clear
   ```
2. Try restoring again:
   ```bash
   dotnet restore --force
   ```

### Build Fails with "Framework not found"

**Problem:** ".NET 9 not found"

**Solution:**
1. Install .NET 9 SDK from [dotnet.microsoft.com](https://dotnet.microsoft.com/download)
2. Verify installation: `dotnet --list-sdks`
3. Verify `global.json` points to .NET 9

## Development Workflow

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes** following coding standards

3. **Run tests locally:**
 ```bash
   dotnet test
   ```

4. **Commit with descriptive messages:**
   ```bash
   git commit -m "feat: add new feature description"
   ```

5. **Push to your fork:**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a pull request** on GitHub

## IDE Setup Recommendations

### Visual Studio 2022

Recommended extensions:
- EditorConfig Language Support
- GitHub Copilot (optional)
- Markdown Editor

### Visual Studio Code

Recommended extensions:
- C# (powered by OmniSharp)
- .NET Install Tool
- Thunder Client or REST Client (for API testing)
- GitLens
- Markdown All in One

## Environment Variables (Optional)

For advanced configuration, you can set environment variables:

```bash
# Windows
set DATAQUEST_ENVIRONMENT=Development
set DATAQUEST_LOG_LEVEL=Debug

# Unix/macOS/Linux
export DATAQUEST_ENVIRONMENT=Development
export DATAQUEST_LOG_LEVEL=Debug
```

## Next Steps

1. Read the [Architecture Guide](ARCHITECTURE.md)
2. Review [Naming Conventions](docs/design-and-planning/Naming%20Conventions%20Guide%20-%20DataQuest.md)
3. Start with Phase 1 development tasks
4. Refer to design documents in `docs/design-and-planning/`

## Getting Help

- Check [existing issues](https://github.com/coburk/DataQuest/issues)
- Read design documents in `docs/`
- Ask in GitHub Discussions
- See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines

## Resources

- [.NET 9 Documentation](https://learn.microsoft.com/en-us/dotnet/)
- [Entity Framework Core](https://learn.microsoft.com/en-us/ef/core/)
- [WinForms Development](https://learn.microsoft.com/en-us/dotnet/desktop/winforms/)
- [Ollama Documentation](https://github.com/ollama/ollama)
- [Model Context Protocol](https://modelcontextprotocol.io/)
