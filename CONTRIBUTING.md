# Contributing to DataQuest

Thank you for considering contributing to DataQuest! This document provides guidelines to help you contribute effectively.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
3. **Create a branch** following the naming convention (see below)
4. **Make your changes** following the coding standards
5. **Submit a pull request** with a clear description

## Naming Conventions

Please follow our [Naming Conventions Guide](docs/design-and-planning/Naming%20Conventions%20Guide%20-%20DataQuest.md) for all contributions.

### Branch Names
- Format: `type/description` (e.g., `feature/case-loading-pipeline`)
- Types: `feature`, `bugfix`, `hotfix`, `refactor`, `docs`, `test`, `chore`
- Use lowercase with hyphens

### Commit Messages
- Format: `type: description` (e.g., `feat: add case loading pipeline`)
- Use imperative mood (add, fix, update, not added, fixed, updated)
- Keep messages clear and descriptive

## Code Standards

### C# Code
- Use PascalCase for class names, methods, and properties
- Use _camelCase for private fields (with leading underscore)
- Use UPPER_CASE for constants
- Follow the naming guide for interfaces (I prefix)
- Write clear, descriptive variable names

### Documentation
- Use Markdown for all documentation
- Place documentation in appropriate `docs/` subdirectory
- Include examples where helpful
- Keep documentation up-to-date with code changes

### Directory Structure
- Follow the established directory structure
- Use lowercase-with-hyphens for multi-word directory names
- Don't introduce new top-level directories without discussion

## Pull Request Process

1. **Update documentation** - Ensure your changes are documented
2. **Add tests** - Include unit tests for new features
3. **Run tests locally** - Verify all tests pass
4. **Keep it focused** - One feature or fix per PR
5. **Write a clear description** - Explain what and why

## Code Review

All contributions require code review before merging. A maintainer will review your PR and may request changes. Be responsive to feedback and make requested modifications.

## Questions or Suggestions?

- Create an issue for discussion
- Ask in the PR if you have questions
- Check existing issues/discussions first

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

Thank you for contributing to DataQuest!
