# Speech - ElevenLabs Text-to-Speech CLI

Quick CLI tool to convert text to speech and play it through your speakers.

## Quick Start

```bash
# Speak text (random voice)
uv run text_to_speech_eleven_labs.py "Hello, this is a test"

# Specify a voice
uv run text_to_speech_eleven_labs.py -v grandpa "Hello, this is a test"

# See available voices
uv run text_to_speech_eleven_labs.py --help
```

## Setup

1. **Install dependencies** (one-time):
   ```bash
   uv sync
   ```

2. **Set API key** - add to your shell exports or `.env` file:
   ```bash
   export ELEVENLABS_API_KEY="your-key-here"
   ```
   
   Get your key at: https://elevenlabs.io/app/settings/api-keys

## Configuration

| Setting | Current Value |
|---------|---------------|
| Voice | Grandpa (`NOpBlnGInO9m6vDvFkFC`) |
| Model | `eleven_multilingual_v2` |
| Output | MP3 44.1kHz 128kbps |
| Archive | `outputs/` (timestamped MP3s) |

All generated audio is automatically saved to `outputs/` folder with timestamp filenames (e.g., `20251218_101530.mp3`).

To change voices, edit `VOICES` dict in `text_to_speech_eleven_labs.py` and add more voice IDs from your ElevenLabs account.

## Shell Function

There's a `speak()` function in `~/.dotfiles/shell/.zsh_functions` that wraps this:
```bash
speak "Text to speak"
```

## Troubleshooting

- **No sound?** Check your system audio output
- **API errors?** Verify your `ELEVENLABS_API_KEY` is set and valid
- **Dependencies?** Run `uv sync` to reinstall
