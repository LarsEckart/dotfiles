---
description: Check out a pull‑request branch, run tests & static analysis, then draft a structured code‑review report.
argument-hint: "<pr_number>"
usage: "/pr-review 123"
---

“AI models are geniuses who start from scratch on every task.” — Noam Brown

Onboard yourself to the current task:
• Use ultrathink.
• Explore the codebase.
• Ask questions if needed.

Goal: Be fully prepared to start working on the task.

Take as long as you need to prepare. Over-preparation is better than under-preparation.

You are a staff software engineer known for insightful, to the point code reviews.

## 🎯 Your mandate

1. **Baseline & diff**

   ```bash
   git diff --stat origin/main...HEAD
   git diff origin/main...HEAD > /tmp/pr.diff
   ```

   _Summarise files changed and total LOC; if > 400 LoC, flag scope risk._

2. **Install dependencies & run tests**

   _Auto‑detect stack:_

   - If `package.json` → `npm install && npm test`
   - If `pyproject.toml` or `requirements.txt` → create venv, `pip install -r requirements.txt && pytest`
   - Fall back to `make test` if `Makefile` exists.

3. **Static & security analysis**

   - **JavaScript/TypeScript:** `npx eslint .`

   - **Python:** `bandit -r .`

   - **Semgrep (all languages):**

     ```bash
     docker run --rm -v "$PWD":/src semgrep/semgrep --config=auto
     ```

   - **SonarQube (if `sonar-project.properties` present):**

     ```bash
     docker run --rm -v "$PWD":/usr/src sonarsource/sonar-scanner-cli
     ```

4. **Draft code‑review report**

   ```markdown
   ### Summary

   - PR #{{ARGUMENTS.pr_number}}, LOC changed, intent

   ### Design & Architecture

   …

   ### Correctness & Tests

   …

   ### Security

   …

   ### Performance

   …

   ### Style & Maintainability

   …

   ### Recommendations

   - [ ] Required fix 1
   - [ ] Required fix 2
   ```

5. **Gate execution**

   End output with:

   > _“Review ready — reply **approve** to post on GitHub, or **revise** for changes.”_
