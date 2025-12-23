---
name: openai-image-gen
description: Generate images via OpenAI gpt-image-1.5 API. Supports batch generation with custom prompts or random prompt sampling. Features transparent backgrounds, multiple output formats (png/jpeg/webp), quality levels, and size options. Use when user wants to generate images, create image batches, explore visual prompts, or needs AI-generated artwork.
---

# OpenAI Image Gen (gpt-image-1.5)

Batch-generate images using OpenAI's gpt-image-1.5 model with full API parameter support.

## Workflow

### 1. Gather Requirements

For vague prompts, ask clarifying questions **one at a time**:

| If unclear... | Ask about |
|---------------|-----------|
| Subject/style | "What style? (photo-realistic, illustration, painting, etc.)" |
| Use case suggests transparency | "Need transparent background? (for logos, overlays, compositing)" |
| Orientation unclear | "Landscape (1536x1024), portrait (1024x1536), or square?" |
| Web/app usage | "Need compressed format? (webp/jpeg for smaller files)" |
| Batch vs single | "How many variations?" |

**Skip questions when context is clear.** E.g., "logo on transparent background" → no need to ask about background.

### 2. Generate

```bash
python3 ~/.dotfiles/agents/skills/openai-image-gen/scripts/gen.py [options]
```

### 3. Show Results

After generation, show the output path and offer to open the gallery.

## Setup

Requires `OPENAI_API_KEY` environment variable.

## Parameters

| Flag | Values | Default | Description |
|------|--------|---------|-------------|
| `--count` | int | 8 | Number of images |
| `--size` | `1024x1024`, `1536x1024`, `1024x1536`, `auto` | 1024x1024 | Dimensions |
| `--quality` | `low`, `medium`, `high`, `auto` | high | Quality level |
| `--background` | `transparent`, `opaque`, `auto` | API default | Background type |
| `--format` | `png`, `jpeg`, `webp` | png | Output format |
| `--compression` | 0-100 | API default | Compression (jpeg/webp only) |
| `--moderation` | `low`, `auto` | API default | Content moderation |
| `--prompt` | text | random | Custom prompt (repeatable) |
| `--out-dir` | path | auto | Output directory |
| `--dry-run` | flag | - | Print prompts without API calls |

## Examples

```bash
# Custom prompt, landscape orientation
python3 ~/.dotfiles/agents/skills/openai-image-gen/scripts/gen.py \
  --prompt "a cozy cabin in snow, warm light from windows" \
  --size 1536x1024

# Transparent PNG for overlays
python3 ~/.dotfiles/agents/skills/openai-image-gen/scripts/gen.py \
  --prompt "a floating crystal orb with internal glow" \
  --background transparent

# Compressed webp for web use
python3 ~/.dotfiles/agents/skills/openai-image-gen/scripts/gen.py \
  --prompt "minimalist logo, geometric shapes" \
  --format webp --compression 80

# Multiple prompts
python3 ~/.dotfiles/agents/skills/openai-image-gen/scripts/gen.py \
  --prompt "sunset over mountains" \
  --prompt "northern lights over lake" \
  --prompt "milky way over desert"

# Preview prompts without generating
python3 ~/.dotfiles/agents/skills/openai-image-gen/scripts/gen.py --count 4 --dry-run
```

## Output

- Image files (`*.png`, `*.jpg`, or `*.webp`)
- `prompts.json` — prompt ↔ file mapping
- `index.html` — thumbnail gallery

Output goes to `~/Projects/tmp/openai-image-gen-{timestamp}/` if that directory exists, otherwise `./tmp/`.
