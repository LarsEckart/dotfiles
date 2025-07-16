# Todo Implementation Program (No Worktrees)
Structured workflow to transform vague todos into implemented features. Works on current branch with single commit at completion.

## Workflow

**CRITICAL**
- You MUST follow workflow phases in order: INIT → SELECT → REFINE → IMPLEMENT → COMMIT
- You MUST get user confirmation or input at each STOP
- You MUST iterate on refinement STOPs until user confirms
- You MUST NOT mention yourself in commit messages or add yourself as a commiter
- You MUST consult with the user in case of unexpected errors
- You MUST not forget to stage files you added/deleted/modified in the IMPLEMENT phase

### INIT
1. Read `todos/project-description.md` in full
   - If missing:
      - Use parallel Task agents to analyze codebase:
         - Identify purpose, features
         - Identify languages, frameworks, tools (build, dependency management, test, etc.)
         - Identify components and architecture
         - Extract commands from build scripts (package.json, CMakeLists.txt, etc.)
         - Map structure, key files, and entry points
         - Identify test setup and how to create new tests
      - Present proposed project description using template below
         ```markdown
         # Project: [Name]
         [Concise description]

         ## Features
         [List of key features and purpose]

         ## Tech Stack
         [Languages, frameworks, build tools, etc.]

         ## Structure
         [Key directories, entry points, important files]

         ## Architecture
         [How components interact, main modules]

         ## Commands
         - Build: [command]
         - Test: [command]
         - Lint: [command]
         - Dev/Run: [command if applicable]

         ## Testing
         [How to create and run tests]
         ```
      - STOP → Any corrections needed? (y/n)"
      - Write confirmed content to `todos/project-description.md`

2. Check for orphaned tasks: `mkdir -p todos/work todos/done && orphaned_count=0 && for d in todos/work/*/task.md; do [ -f "$d" ] || continue; pid=$(grep "^**Agent PID:" "$d" | cut -d' ' -f3); [ -n "$pid" ] && ps -p "$pid" >/dev/null 2>&1 && continue; orphaned_count=$((orphaned_count + 1)); task_name=$(basename $(dirname "$d")); task_title=$(head -1 "$d" | sed 's/^# //'); echo "$orphaned_count. $task_name: $task_title"; done`
   - If orphaned tasks exist:
      - Present numbered list of orphaned tasks
      - STOP → "Resume orphaned task? (number or title/ignore)"
      - If resume:
         - Get task folder from numbered list
         - Read task.md from selected task in full
         - Update `**Agent PID:** [Bash(echo $PPID)]` in task.md
         - If Status is "Refining": Continue to REFINE
         - If Status is "InProgress": Continue to IMPLEMENT
         - If Status is "AwaitingCommit": Continue to COMMIT
      - If ignore: Continue to SELECT

### SELECT
1. Read `todos/todos.md` in full
2. Present numbered list of todos with one line summaries
3. STOP → "Which todo would you like to work on? (enter number)"
4. Create task folder: `mkdir -p todos/work/$(date +%Y-%m-%d-%H-%M-%S)-[task-title-slug]/`
5. Initialize `todos/work/[timestamp]-[task-title-slug]/task.md` from template:
   ```markdown
   # [Task Title]
   **Status:** Refining
   **Agent PID:** [Bash(echo $PPID)]

   ## Original Todo
   [raw todo text from todos/todos.md]

   ## Description
   [what we're building]

   ## Implementation Plan
   [how we are building it]
   - [ ] Code change with location(s) if applicable (src/file.ts:45-93)
   - [ ] Automated test: ...
   - [ ] User test: ...

   ## Notes
   [Implementation notes]
   ```
6. Remove selected todo from `todos/todos.md`

### REFINE
1. Research codebase with parallel Task agents:
   - Where in codebase changes are needed for this todo
   - What existing patterns/structures to follow
   - Which files need modification
   - What related features/code already exist
2. Append analysis by agents verbatim to `todos/work/[timestamp]-[task-title-slug]/analysis.md`
3. Draft description → STOP → "Use this description? (y/n)"
4. Draft implementation plan → STOP → "Use this implementation plan? (y/n)"
5. Update `task.md` with fully refined content and set `**Status**: InProgress`

### IMPLEMENT
1. Execute the implementation plan checkbox by checkbox:
   - **During this process, if you discover unforeseen work is needed, you MUST:**
      - Pause and propose a new checkbox for the plan
      - STOP → "Add this new checkbox to the plan? (y/n)"
      - Add new checkbox to `task.md` before proceeding
   - For the current checkbox:
      - Make code changes
      - Summarize changes
      - STOP → "Approve these changes? (y/n)"
      - Mark checkbox complete in `task.md`
      - Stage progress: `git add -A`
2. After all checkboxes are complete, run project validation (lint/test/build).
    - If validation fails:
      - Report full error(s)
      - Propose one or more new checkboxes to fix the issue
      - STOP → "Add these checkboxes to the plan? (y/n)"
      - Add new checkbox(es) to implementation plan in `task.md`
      - Go to step 1 of `IMPLEMENT`.
3. Present user test steps → STOP → "Do all user tests pass? (y/n)"
   - If no: Gather information from user on what failed and return to step 1 to fix issues
4. Check if project description needs updating:
   - If implementation changed structure, features, or commands:
      - Present proposed updates to `todos/project-description.md`
      - STOP → "Update project description as shown? (y/n)"
      - If yes, update `todos/project-description.md`
5. Set `**Status**: AwaitingCommit` in `task.md`

### COMMIT
1. Present summary of what was done
2. STOP → "Ready to commit all changes? (y/n)"
3. Set `**Status**: Done` in `task.md`
4. Move task and analysis to done:
   - `mv todos/work/[timestamp]-[task-title-slug]/task.md todos/done/[timestamp]-[task-title-slug].md`
   - `mv todos/work/[timestamp]-[task-title-slug]/analysis.md todos/done/[timestamp]-[task-title-slug]-analysis.md`
   - `rmdir todos/work/[timestamp]-[task-title-slug]/`
5. Stage all changes: `git add -A`
6. Create single commit with descriptive message: `git commit -m "[task-title]: [summary of changes]"`
7. STOP → "Task complete! Continue with next todo? (y/n)"
