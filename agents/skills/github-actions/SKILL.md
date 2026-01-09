---
name: github-actions
description: "Create, debug, and optimize GitHub Actions workflows (.github/workflows/*.yml): triggers, jobs, matrices, caching, artifacts, permissions/OIDC, reusable workflows, and actionlint-driven troubleshooting. Use when the user shares workflow YAML, actionlint output, or GitHub Actions run logs, or asks for CI/CD improvements."
license: MIT
compatibility: "Designed for Claude Code (repo filesystem access). Optional tools - actionlint, gh, act."
metadata:
  version: "2.0"
---

# GitHub Actions

Practical guidance for building, debugging, and hardening GitHub Actions workflows that are:
- **Valid** (actionlint passes)
- **Secure** (least privilege, safe with forks)
- **Fast & cost-aware** (caching, concurrency, matrices)

---

## 0) When to use / when NOT to use

Use this skill when the user:
- Is creating or editing `.github/workflows/*.yml`
- Has **actionlint output** or **workflow run logs** they need help interpreting
- Wants CI improvements: caching, matrices, concurrency, artifacts, permissions, OIDC, reusable workflows
- Needs advice on GitHub-hosted vs self-hosted runners, containers, or service containers

Do **NOT** use this skill for:
- Generic YAML questions not tied to GitHub Actions semantics
- Application deployment architecture (Docker/Kubernetes/etc.) unless it directly affects the workflow
- Debugging test failures inside the codebase (use language/testing skills)

---

## 1) Guardrails (MUST / MUST NOT)

MUST:
- Ask for missing constraints instead of guessing (see §2).
- Treat **actionlint output and runner logs as the source of truth**; never fabricate them.
- Recommend pinning actions to a **major tag** (e.g., `@v6`) or, for higher assurance, a **full commit SHA**.
- Add explicit `permissions:` (workflow-level + job overrides) with least privilege.
- End with **copy‑pastable YAML** (or a minimal diff against the user's current YAML).

MUST NOT:
- Print secrets/tokens or dump secrets contexts.
- Suggest `pull_request_target` as a quick fix unless you explain the security implications and add hard gates.
- Use floating refs (`@main`, `@master`) or `:latest` in production examples without calling out the risk.

---

## 2) First questions to ask (fast triage)

If the user didn't provide these, ask (briefly) before writing YAML:

1. **Trigger(s):** `push`, `pull_request`, `workflow_dispatch`, `schedule`, `release`, `workflow_call`, etc.
2. **Branches / paths filters:** what should run on `main`, PRs, tags, docs-only changes, etc.?
3. **Runtime:** language + version(s), build tool (npm/pnpm/yarn, Gradle/Maven, pip/poetry, etc.)
4. **Runners:** GitHub-hosted vs self-hosted; OS matrix needed?
5. **Secrets/vars:** which external services? Are PRs from forks expected? (affects secrets/permissions)
6. **Write actions:** does the workflow need to push tags, create releases, comment on PRs, auto-merge, deploy? (determines permissions)

---

## 3) Output contract (what you should produce)

When replying, output in this order:

1. **Diagnosis / plan (2–6 bullets)** — what you're changing and why.
2. **The workflow YAML** (or a minimal patch) — copy‑pastable.
3. **How to verify** — e.g. `actionlint`, optional `act`, and what to look for in the GitHub run UI.
4. **Optional optimizations** — only after a correct baseline is provided.

---

## 4) Workflow anatomy (mental checklist)

Make sure the workflow has:

- `name`
- `on:` triggers with correct event names + filters
- `permissions:` (workflow-level; override per job when needed)
- `concurrency:` if the workflow can be spammed (PR updates, fast pushes)
- `jobs.<job_id>.runs-on` (pin runner images when stability matters)
- `timeout-minutes` on jobs
- `strategy.matrix` when it reduces duplication
- Steps with correct `uses: owner/repo@ref` format and correct contexts in `${{ }}` expressions
- Caching and artifacts where it materially improves runtime
- A reporting step with `if: success() || failure()` (or `if: always()`) for diagnostics

---

## 5) Create a new workflow (template-first)

Start from a minimal, valid skeleton and then specialize.

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

permissions:
  contents: read

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest # consider pinning (e.g. ubuntu-24.04) for stability
    timeout-minutes: 10
    steps:
      - name: Check out repo
        uses: actions/checkout@v6
      - name: Run tests
        run: echo "TODO: add your build/test command"
```

Then add (in this order): setup toolchain → cache → build/test → artifacts/reports.

---

## 6) Debug a failing workflow (actionlint-first)

### 6.1 If the user has actionlint output

- Fix errors **top-to-bottom**; one typo can cascade into many errors.
- The bracketed suffix is the rule ID (e.g. `[events]`, `[expression]`, `[action]`).

#### Real actionlint output examples (verbatim)

```text
bad-workflow.yml:3:12: unknown Webhook event "pull_requests". see https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#webhook-events for list of all Webhook event names [events]
  |
3 | on: [push, pull_requests]  # typo: should be pull_request
  |            ^~~~~~~~~~~~~~
bad-workflow.yml:11:23: property "secret" is not defined in object type {action: string; ...} [expression]
   |
11 |         run: echo ${{ github.secret }}  # invalid context
   |                       ^~~~~~~~~~~~~
bad-workflow.yml:15:15: specifying action "actions/setup-node" in invalid format because ref is missing. available formats are "{owner}/{repo}@{ref}" or "{owner}/{repo}/{path}@{ref}" [action]
   |
15 |         uses: actions/setup-node
   |               ^~~~~~~~~~~~~~~~~~
```

#### Fix patterns for the above

1) **Bad trigger name** (`pull_requests` → `pull_request`):

```yaml
on:
  push:
  pull_request:
```

2) **Wrong context** (`github.secret` doesn't exist). Use:
- `secrets.*` for secrets
- `vars.*` for non-secret variables
- `github.*` only for documented GitHub context fields

```yaml
- run: echo "${{ secrets.MY_TOKEN }}"
```

3) **Missing action ref** (must include `@ref`):

```yaml
- uses: actions/setup-node@v6
```

### 6.2 If actionlint passes but the run fails

Ask for:
- failing step log lines (include the command + exit code)
- runner OS + shell (`bash`, `pwsh`, etc.)
- whether the PR is from a fork (secrets/permissions change)

Then apply common fixes:
- Make shell explicit (especially on Windows)
- Add `set -euo pipefail` (bash) / `$ErrorActionPreference='Stop'` (pwsh)
- Ensure expected files exist (`actions/checkout`, correct working directory)
- Fix permissions (403s are usually token scope issues)
- Pin action versions and rerun

---

## 7) Canonical production pattern (inspired by a real Java workflow)

This pattern demonstrates:
- Trigger filtering (`branches`, `paths`, `workflow_dispatch`)
- `concurrency` to cancel stale runs
- A cross‑OS matrix
- An always-run test report
- A gated Dependabot auto-merge job

```yaml
name: Run tests

on:
  workflow_dispatch:
  push:
    branches:
      - main
    paths:
      - '**.java'
      - 'build.gradle'
      - 'gradle/wrapper/**'
      - '.github/workflows/test.yml'
  pull_request:
    branches:
      - main
    paths:
      - '**.java'
      - 'build.gradle'
      - 'gradle/wrapper/**'

permissions:
  contents: read

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build:
    runs-on: ${{ matrix.os }}-latest
    timeout-minutes: 10
    strategy:
      fail-fast: false
      matrix:
        java: [25]
        os: [ubuntu, windows]

    # Make shell explicit so a single command can work cross-OS (optional).
    defaults:
      run:
        shell: bash

    permissions:
      contents: read
      checks: write # required by many test-report actions that create check runs

    steps:
      - name: Check out repo
        uses: actions/checkout@v6

      - name: Set up latest JDK N from oracle.com
        uses: oracle-actions/setup-java@v1
        with:
          website: oracle.com
          release: ${{ matrix.java }}

      - name: Run Gradle's test task
        run: ./gradlew -i --no-daemon --parallel --continue --build-cache --stacktrace test
        env:
          GH_USERNAME: 'GitHub Action'
          GH_TOKEN: ${{ secrets.GH_TOKEN }}

      - name: Publish Test Report
        uses: mikepenz/action-junit-report@v6
        if: success() || failure()
        with:
          report_paths: '**/build/test-results/test/TEST-*.xml'
          retention-days: 1

  auto-merge:
    needs: build
    runs-on: ubuntu-latest

    permissions:
      contents: write
      pull-requests: write

    steps:
      - name: Check out repo
        uses: actions/checkout@v6

      - name: auto-merge
        if: |
          github.actor == 'dependabot[bot]' &&
          github.event_name == 'pull_request'
        run: |
          gh pr merge --auto --rebase "$PR_URL"
        env:
          PR_URL: ${{ github.event.pull_request.html_url }}
          GITHUB_TOKEN: ${{ secrets.GH_ACTION_TOKEN }}
```

---

## 8) Recipe library (copy/paste snippets)

### 8.1 Lint workflows in CI (actionlint)

Pin the image/action ref (avoid `:latest` in production).

```yaml
jobs:
  actionlint:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v6
      - name: actionlint
        uses: docker://rhysd/actionlint:1.7.4
        with:
          args: -color
```

Tip: If shellcheck findings are noisy (e.g., non-bash shells), set `shell:` explicitly on `run:` steps so the linter knows what it's analyzing.

### 8.2 Permissions cheat sheet (least privilege)

Start with:

```yaml
permissions:
  contents: read
```

Common adds:
- `checks: write` → create/update check runs (test reporters)
- `pull-requests: write` → comment/label/merge PRs
- `contents: write` → push commits/tags, create releases
- `packages: write` → publish packages
- `id-token: write` → OIDC federation to cloud providers

Prefer job-level escalation:

```yaml
jobs:
  deploy:
    permissions:
      contents: read
      id-token: write
```

### 8.3 Concurrency (cancel stale runs)

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true
```

### 8.4 Caching (prefer setup-* built-ins when available)

**Node (setup-node with caching):**

```yaml
- uses: actions/setup-node@v6
  with:
    node-version: 24
    cache: npm
- run: npm ci
```

**Gradle (simple):**

```yaml
- run: ./gradlew --no-daemon --build-cache test
```

### 8.5 Upload artifacts (share between jobs)

```yaml
- uses: actions/upload-artifact@v4
  if: always()
  with:
    name: test-results
    path: '**/build/test-results/test/TEST-*.xml'
    retention-days: 1
```

### 8.6 Job summary (human-friendly output in the run UI)

```yaml
- name: Summary
  if: always()
  run: |
    {
      echo "## CI Summary"
      echo ""
      echo "- OS: ${{ runner.os }}"
      echo "- Ref: ${{ github.ref }}"
    } >> "$GITHUB_STEP_SUMMARY"
```

### 8.7 Step outputs + job outputs (pass data across jobs)

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.meta.outputs.version }}
    steps:
      - id: meta
        run: echo "version=1.2.3" >> "$GITHUB_OUTPUT"

  publish:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Publishing ${{ needs.build.outputs.version }}"
```

### 8.8 Manual runs with inputs (workflow_dispatch)

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: "Where to deploy"
        type: choice
        options: [staging, production]
        required: true
      run_integration:
        description: "Run integration tests?"
        type: boolean
        default: false
```

Use them as `${{ inputs.environment }}` and `${{ inputs.run_integration }}`.

### 8.9 Scheduled workflows (cron)

```yaml
on:
  schedule:
    - cron: '0 3 * * 1' # Mondays 03:00 UTC
```

### 8.10 Service containers (integration tests)

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: postgres
        ports:
          - 5432:5432
        options: >-
          --health-cmd "pg_isready -U postgres"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v6
      - run: ./gradlew test
        env:
          DATABASE_URL: postgres://postgres:postgres@localhost:5432/postgres
```

### 8.11 Environments (approvals + environment secrets)

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: echo "deploying..."
```

Environment-scoped secrets live in GitHub "Environments," not repo-level secrets.

### 8.12 Reusable workflows (workflow_call)

**Reusable workflow (callee):** `.github/workflows/reusable-test.yml`

```yaml
name: Reusable test

on:
  workflow_call:
    inputs:
      node-version:
        type: string
        required: true
    secrets:
      NPM_TOKEN:
        required: false

permissions:
  contents: read

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v6
      - uses: actions/setup-node@v6
        with:
          node-version: ${{ inputs.node-version }}
          cache: npm
      - run: npm ci
      - run: npm test
```

**Caller:**

```yaml
jobs:
  test:
    uses: ./.github/workflows/reusable-test.yml
    with:
      node-version: '24'
    secrets: inherit
```

### 8.13 Common "why didn't my workflow run?" checks

- Wrong event name (e.g. `pull_requests` instead of `pull_request`)
- Branch filters don't match the push/PR target
- `paths` filters exclude the changed files
- Workflow file isn't on the default branch yet (for `push`/`pull_request`)
- YAML indentation errors cause the workflow to be ignored

---

## 9) Security & reliability rules of thumb

- Pin actions (major tag or SHA). Avoid `@main`.
- Prefer `contents: read` and escalate per job.
- Assume PRs from forks are untrusted: secrets may be unavailable and you must not run privileged steps.
- Be extremely cautious with `pull_request_target` (it runs with base repo privileges).
- Add `timeout-minutes` and `concurrency.cancel-in-progress: true` for noisy workflows.
- Use `fail-fast: false` on big matrices to maximize feedback.

---

## 10) Local tools (optional but recommended)

```bash
# Lint workflows
actionlint

# Run a job locally (best-effort; not all features match GitHub)
act -j build

# Inspect a run
gh run view --log
```

---

## 11) Further reading

- https://docs.github.com/actions
- https://github.com/rhysd/actionlint
- https://github.com/nektos/act
