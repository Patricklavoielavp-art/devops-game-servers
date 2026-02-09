# Contributing

We use **Conventional Commits** for commit messages to enable automatic versioning and chengelog generation.

## Commit Message Format 
<type>(<scope>): <subject>

<body> <footer> ```

Types
feat: A new feature (results in a MINOR version bump)
fix: A bug fix (results in a PATCH version bump)
perf: A performance improvement (results in a PATCH version bump)
docs: Documentation changes (no version bump)
style: Code style changes (no version bump)
refactor: Code refactoring (no version bump)
test: Test additions/modifications (no version bump)
ci: CI/CD configuration changes (no version bump)
Scope (optional)
Component or module affected: terraform, docker, scripts, gameserver, etc.

Subject
Imperative mood ("add feature", not "added feature")
No capital letter at the start
No period at the end
Limit to 50 characters
Body (optional)
Explain what and why, not how.
Wrap at 72 characters.

Footer (optional)
Reference issues: Closes #123 or Fixes #456

## Exemples
feat(docker): add health check to game-server container

Add HEALTHCHECK instruction to Dockerfile to monitor container health.
Prometheus can now scrape /health endpoint.

Closes #45
fix(terraform): prevent unintended VM recreation

Add lifecycle ignore_changes to prevent unnecessary VM recreation when
cloud-init data changes.
docs: update readme with release notes instructions
**File 5: package.json (Node.js runtime for semantic-release)**