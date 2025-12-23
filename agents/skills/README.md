# Shared Agent Skills

Skills are self-contained capability packages that AI coding agents load on-demand. This directory manages skills from external repositories and local custom skills, symlinking them to all supported agents.

## Usage

```bash
./sync.sh
```

This will:
1. Clone/pull external repositories listed in `repos.txt`
2. Discover all skills (local + external)
3. Create symlinks to all agent skill directories

## Supported Agents

| Agent | Target Location |
|-------|-----------------|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.codex/skills/` |
| Pi | `~/.pi/agent/skills/` |

## External Repositories

External skill repos are listed in `repos.txt` (one URL per line). They get cloned to `.repos/` which is gitignored.

Current external repos:
- [badlogic/pi-skills](https://github.com/badlogic/pi-skills) - Web search, browser automation, Google APIs, transcription
- [mitsuhiko/agent-commands](https://github.com/mitsuhiko/agent-commands) - tmux skill for interactive CLIs

## Adding a Local Skill

1. Create a directory with your skill name (lowercase, hyphens only)
2. Add a `SKILL.md` file with required frontmatter
3. Add any helper scripts in `scripts/`
4. Run `./sync.sh`

### SKILL.md Format

```markdown
---
name: my-skill
description: What this skill does and when to use it. Be specific.
license: MIT
---

# My Skill

Instructions go here...
```

See [Agent Skills Specification](https://agentskills.io/specification) for details.

## Directory Structure

```
agents/skills/
├── README.md         # This file
├── repos.txt         # External repos to clone
├── sync.sh           # Sync script
├── .gitignore        # Ignores .repos/
├── .repos/           # Cloned external repos (gitignored)
│   ├── pi-skills/
│   └── agent-commands/
└── my-local-skill/   # Local skills live here directly
    └── SKILL.md
```
