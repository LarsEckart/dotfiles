---
name: github-actions
description: Guide for creating, debugging, and optimizing GitHub Actions workflows. Use when users need to automate CI/CD pipelines, create reusable workflows, debug workflow failures, optimize action performance, or validate workflow syntax. Includes comprehensive guidance on workflow structure, best practices, common patterns, and actionlint integration for workflow validation.
license: MIT
---

# GitHub Actions

## Overview

This skill helps you create, debug, and optimize GitHub Actions workflows for CI/CD automation. It covers workflow syntax, best practices, debugging techniques, performance optimization, and workflow validation using actionlint.

## When to Use This Skill

Use this skill when users:
- Need to create new GitHub Actions workflows for CI/CD
- Want to debug failing or flaky workflows
- Request optimization of existing workflows (faster builds, reduced costs)
- Ask about GitHub Actions best practices or patterns
- Need to validate workflow syntax before committing
- Want to create reusable workflows or custom actions
- Request help with matrix builds, caching, or advanced features
- Need to integrate third-party actions or services

## General Workflow

Follow this process to help users with GitHub Actions:

### Step 1: Understand Requirements

Clarify what the user needs:
- What should the workflow do? (test, build, deploy, release, etc.)
- What events should trigger it? (push, pull_request, schedule, workflow_dispatch)
- What languages/tools are involved?
- Are there dependencies on external services?
- What are the performance/cost constraints?
- Should it run on multiple OS/versions (matrix)?

### Step 2: Create or Modify Workflow

Create workflows in `.github/workflows/` directory with `.yml` or `.yaml` extension.

**Basic workflow structure:**
```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up environment
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test
```

### Step 3: Validate with actionlint

Always validate workflows before committing using [actionlint](https://github.com/rhysd/actionlint/blob/v1.7.7/docs/usage.md):

**Install actionlint:**
```bash
# macOS
brew install actionlint

# Linux
bash <(curl https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash)

# Or use Docker
docker run --rm -v $(pwd):/repo --workdir /repo rhysd/actionlint:latest
```

**Run actionlint:**
```bash
# Validate all workflows
actionlint

# Validate specific workflow
actionlint .github/workflows/ci.yml

# Output in different formats
actionlint -format '{{range $err := .}}{{$err.Message}}{{end}}'

# Ignore specific rules
actionlint -ignore 'SC2086:' -ignore 'SC2016:'

# Use with GitHub Actions (in workflow)
- name: Check workflow files
  uses: docker://rhysd/actionlint:latest
  with:
    args: -color
```

**Common actionlint checks:**
- Syntax errors in YAML
- Invalid action references or versions
- Type mismatches in expressions
- Undefined variables or contexts
- Shell script issues (via shellcheck integration)
- Invalid event triggers
- Deprecated features

See [actionlint usage documentation](https://github.com/rhysd/actionlint/blob/v1.7.7/docs/usage.md) for complete validation options.

### Step 4: Test and Debug

Test workflows using these techniques:

**Local testing with act:**
```bash
# Install act (runs workflows locally with Docker)
brew install act

# Run workflow locally
act

# Run specific job
act -j test

# Run specific event
act pull_request
```

**Debug in GitHub Actions:**
```yaml
# Enable debug logging
- name: Debug info
  run: |
    echo "Event: ${{ github.event_name }}"
    echo "Ref: ${{ github.ref }}"
    echo "SHA: ${{ github.sha }}"

# Enable step debugging with ACTIONS_STEP_DEBUG secret set to true
# Enable runner debugging with ACTIONS_RUNNER_DEBUG secret set to true
```

**Common debugging commands:**
```bash
# View workflow runs
gh run list

# View specific run details
gh run view <run-id>

# View logs
gh run view <run-id> --log

# Re-run failed jobs
gh run rerun <run-id> --failed

# Watch a running workflow
gh run watch
```

### Step 5: Optimize for Performance

Apply these optimizations:

**Use caching:**
```yaml
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

**Parallel jobs:**
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20, 22]
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
```

**Conditional execution:**
```yaml
- name: Deploy
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
  run: npm run deploy
```

**Fail fast:**
```yaml
strategy:
  fail-fast: true  # Stop all jobs if one fails
  matrix:
    os: [ubuntu-latest, macos-latest, windows-latest]
```

## Workflow Syntax Reference

### Event Triggers

```yaml
# Single event
on: push

# Multiple events
on: [push, pull_request]

# Event with filters
on:
  push:
    branches:
      - main
      - 'releases/**'
    paths:
      - '**.js'
      - '!docs/**'
    tags:
      - v*

# Scheduled workflows
on:
  schedule:
    - cron: '0 0 * * *'  # Daily at midnight

# Manual trigger
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        type: choice
        options:
          - dev
          - staging
          - prod
```

### Job Configuration

```yaml
jobs:
  job-name:
    name: Human-readable name
    runs-on: ubuntu-latest  # or ubuntu-22.04, macos-latest, windows-latest

    # Job dependencies
    needs: [previous-job]

    # Conditional execution
    if: github.event_name == 'push'

    # Environment variables
    env:
      NODE_ENV: production

    # Timeout (default: 360 minutes)
    timeout-minutes: 30

    # Permissions
    permissions:
      contents: read
      pull-requests: write

    # Environment deployment
    environment:
      name: production
      url: https://example.com

    # Strategy for matrix/parallel builds
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
        node: [18, 20]
      fail-fast: false
      max-parallel: 4

    steps:
      # ... steps here
```

### Common Actions

```yaml
# Checkout code
- uses: actions/checkout@v4
  with:
    fetch-depth: 0  # Full history
    submodules: true

# Setup languages/tools
- uses: actions/setup-node@v4
  with:
    node-version: '20'
    cache: 'npm'

- uses: actions/setup-python@v5
  with:
    python-version: '3.12'
    cache: 'pip'

- uses: actions/setup-go@v5
  with:
    go-version: '1.22'
    cache: true

# Upload/download artifacts
- uses: actions/upload-artifact@v4
  with:
    name: test-results
    path: test-results/
    retention-days: 30

- uses: actions/download-artifact@v4
  with:
    name: test-results

# Cache dependencies
- uses: actions/cache@v4
  with:
    path: |
      ~/.npm
      ~/.cache
    key: ${{ runner.os }}-${{ hashFiles('**/package-lock.json') }}

# Create GitHub releases
- uses: actions/create-release@v1
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    tag_name: ${{ github.ref }}
    release_name: Release ${{ github.ref }}
```

### Expressions and Contexts

```yaml
# Access contexts
steps:
  - name: Print context
    run: |
      echo "Event: ${{ github.event_name }}"
      echo "Actor: ${{ github.actor }}"
      echo "Repo: ${{ github.repository }}"
      echo "Branch: ${{ github.ref_name }}"
      echo "SHA: ${{ github.sha }}"
      echo "Runner OS: ${{ runner.os }}"
      echo "Job status: ${{ job.status }}"

# Conditional expressions
- name: Conditional step
  if: |
    github.event_name == 'push' &&
    startsWith(github.ref, 'refs/tags/') &&
    !contains(github.event.head_commit.message, '[skip ci]')
  run: echo "Deploy!"

# Functions
- name: With functions
  if: |
    success() &&
    contains(needs.*.result, 'success') &&
    !cancelled()
  run: echo "All jobs succeeded"
```

### Secrets and Variables

```yaml
# Use secrets (encrypted)
- name: Deploy
  env:
    API_KEY: ${{ secrets.API_KEY }}
    AWS_ACCESS_KEY: ${{ secrets.AWS_ACCESS_KEY }}
  run: ./deploy.sh

# Use variables (not encrypted)
- name: Build
  env:
    ENVIRONMENT: ${{ vars.ENVIRONMENT }}
    API_URL: ${{ vars.API_URL }}
  run: npm run build

# Set output for later steps
- name: Set output
  id: vars
  run: echo "sha_short=$(git rev-parse --short HEAD)" >> $GITHUB_OUTPUT

- name: Use output
  run: echo "Short SHA: ${{ steps.vars.outputs.sha_short }}"
```

## Best Practices

### Security

1. **Use specific action versions:**
   ```yaml
   # Good: pinned to SHA
   - uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1

   # Acceptable: pinned to major version
   - uses: actions/checkout@v4

   # Bad: uses latest
   - uses: actions/checkout@main
   ```

2. **Minimize permissions:**
   ```yaml
   permissions:
     contents: read  # Only what's needed
   ```

3. **Use environment secrets, not inline:**
   ```yaml
   # Good
   env:
     API_KEY: ${{ secrets.API_KEY }}
   run: ./script.sh

   # Bad: could leak in logs
   run: ./script.sh ${{ secrets.API_KEY }}
   ```

4. **Validate external inputs:**
   ```yaml
   - name: Validate input
     if: github.event_name == 'workflow_dispatch'
     run: |
       if [[ ! "${{ inputs.environment }}" =~ ^(dev|staging|prod)$ ]]; then
         echo "Invalid environment"
         exit 1
       fi
   ```

### Performance

1. **Use caching aggressively:**
   ```yaml
   - uses: actions/cache@v4
     with:
       path: |
         ~/.cargo/bin/
         ~/.cargo/registry/index/
         ~/.cargo/registry/cache/
         ~/.cargo/git/db/
         target/
       key: ${{ runner.os }}-cargo-${{ hashFiles('**/Cargo.lock') }}
   ```

2. **Run jobs in parallel:**
   ```yaml
   jobs:
     lint:
       # Runs independently
     test:
       # Runs independently
     build:
       needs: [lint, test]  # Waits for both
   ```

3. **Skip unnecessary steps:**
   ```yaml
   - name: Skip on draft
     if: "!github.event.pull_request.draft"
     run: npm run e2e
   ```

4. **Use self-hosted runners for heavy workloads:**
   ```yaml
   runs-on: [self-hosted, linux, x64, gpu]
   ```

### Maintainability

1. **Use reusable workflows:**
   ```yaml
   # .github/workflows/reusable-test.yml
   on:
     workflow_call:
       inputs:
         node-version:
           required: true
           type: string

   # .github/workflows/ci.yml
   jobs:
     test:
       uses: ./.github/workflows/reusable-test.yml
       with:
         node-version: '20'
   ```

2. **Use composite actions for repeated steps:**
   ```yaml
   # .github/actions/setup-env/action.yml
   name: Setup Environment
   runs:
     using: composite
     steps:
       - uses: actions/setup-node@v4
       - run: npm ci

   # Use it
   - uses: ./.github/actions/setup-env
   ```

3. **Document complex workflows:**
   ```yaml
   name: Complex Deployment
   # This workflow:
   # 1. Builds the application
   # 2. Runs security scans
   # 3. Deploys to staging
   # 4. Runs smoke tests
   # 5. Requires manual approval
   # 6. Deploys to production
   ```

## Common Patterns

### CI/CD Pipeline

```yaml
name: CI/CD

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm test
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: test-results
          path: test-results/

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint

  deploy:
    needs: [test, lint]
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: ./deploy.sh
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
```

### Matrix Testing

```yaml
name: Matrix Test

on: [push, pull_request]

jobs:
  test:
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        node: [18, 20, 22]
        include:
          # Add specific config for certain combinations
          - os: ubuntu-latest
            node: 20
            experimental: true
        exclude:
          # Skip certain combinations
          - os: windows-latest
            node: 18

    runs-on: ${{ matrix.os }}
    continue-on-error: ${{ matrix.experimental || false }}

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
      - run: npm ci
      - run: npm test
```

### Release Automation

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    permissions:
      contents: write

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Generate changelog
        id: changelog
        run: |
          CHANGELOG=$(git log --oneline $(git describe --tags --abbrev=0 HEAD^)..HEAD)
          echo "changelog<<EOF" >> $GITHUB_OUTPUT
          echo "$CHANGELOG" >> $GITHUB_OUTPUT
          echo "EOF" >> $GITHUB_OUTPUT

      - name: Create Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref_name }}
          release_name: Release ${{ github.ref_name }}
          body: ${{ steps.changelog.outputs.changelog }}
          draft: false
          prerelease: false
```

### Scheduled Maintenance

```yaml
name: Scheduled Maintenance

on:
  schedule:
    # Run at 2 AM UTC every Sunday
    - cron: '0 2 * * 0'
  workflow_dispatch:  # Allow manual trigger

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - name: Clean up old artifacts
        uses: actions/github-script@v7
        with:
          script: |
            const days = 90;
            const timestamp = Date.now() - (days * 24 * 60 * 60 * 1000);

            const artifacts = await github.rest.actions.listArtifactsForRepo({
              owner: context.repo.owner,
              repo: context.repo.repo,
            });

            for (const artifact of artifacts.data.artifacts) {
              if (Date.parse(artifact.created_at) < timestamp) {
                await github.rest.actions.deleteArtifact({
                  owner: context.repo.owner,
                  repo: context.repo.repo,
                  artifact_id: artifact.id,
                });
                console.log(`Deleted artifact: ${artifact.name}`);
              }
            }
```

## Troubleshooting

### Common Issues

**Workflow not triggering:**
- Check event trigger configuration
- Verify branch/path filters match
- Ensure `.github/workflows/` path is correct
- Check if workflow file has syntax errors (use actionlint)

**Permission denied:**
```yaml
# Add necessary permissions
permissions:
  contents: write
  pull-requests: write
```

**Checkout fails on PR from fork:**
```yaml
- uses: actions/checkout@v4
  with:
    # Use PR head ref for forks
    ref: ${{ github.event.pull_request.head.sha }}
```

**Secrets not available:**
- Secrets aren't available in workflows triggered by forks
- Use `pull_request_target` carefully (security risk)
- Or use conditional logic:
  ```yaml
  if: github.event.pull_request.head.repo.full_name == github.repository
  ```

**Timeout issues:**
```yaml
# Increase timeout
timeout-minutes: 60

# Or add timeout to specific step
- name: Long-running test
  timeout-minutes: 30
  run: npm run e2e
```

## Resources

### Official Documentation
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)

### Tools
- [actionlint](https://github.com/rhysd/actionlint) - Fast workflow linter
- [actionlint usage docs](https://github.com/rhysd/actionlint/blob/v1.7.7/docs/usage.md) - Complete validation guide
- [act](https://github.com/nektos/act) - Run workflows locally
- [GitHub CLI](https://cli.github.com/) - Manage workflows from terminal

### Best Practices
- [GitHub Actions Security Best Practices](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [Workflow Optimization](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstrategy)

## Quick Reference

**Validate workflow:**
```bash
actionlint .github/workflows/*.yml
```

**Test locally:**
```bash
act -j test
```

**View runs:**
```bash
gh run list
gh run view <run-id> --log
```

**Debug expressions:**
```yaml
- run: echo '${{ toJSON(github) }}'
- run: echo '${{ toJSON(runner) }}'
- run: echo '${{ toJSON(job) }}'
```

**Common contexts:**
- `github.event_name` - Event that triggered workflow
- `github.ref` - Full ref (e.g., refs/heads/main)
- `github.ref_name` - Short ref name (e.g., main)
- `github.sha` - Commit SHA
- `github.actor` - User who triggered workflow
- `runner.os` - Runner operating system
- `secrets.GITHUB_TOKEN` - Auto-generated auth token
