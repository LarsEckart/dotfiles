# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Python command-line utility for text-to-speech using the ElevenLabs API. The project converts text input to audio and plays it back using pre-configured voice models.

## Package Management

Uses `uv` for Python package management (requires Python >=3.13):
```bash
uv sync          # Install dependencies
uv add <package> # Add new dependencies
uv run <script>  # Run scripts in virtual environment
```

## Core Components

- **`text_to_speech_eleven_labs.py`**: Main TTS script with 18 predefined voices
- **`main.py`**: Basic entry point (placeholder)
- **`pyproject.toml`**: UV project configuration

## Running the Application

```bash
# Run text-to-speech with command line argument
uv run text_to_speech_eleven_labs.py "your text here"

# Direct Python execution (ensure environment is activated)
python text_to_speech_eleven_labs.py "your text here"
```

## Configuration

Requires `ELEVENLABS_API_KEY` environment variable. The script uses python-dotenv to load from `.env` file for local development.

## Voice Configuration

The VOICES dictionary contains 18 predefined voice IDs mapped to human-readable names. Currently hardcoded to use "Grandpa" voice with "eleven_multilingual_v2" model. To change voices, modify the `voice_id` parameter in the convert call.

## Dependencies

- `elevenlabs`: ElevenLabs API client for TTS conversion
- `python-dotenv`: Environment variable management from .env files

## Architecture Notes

Simple single-purpose CLI tool that:
1. Accepts text via command line arguments
2. Loads API credentials from environment
3. Converts text using ElevenLabs API
4. Plays audio directly through system speakers

The project follows the ElevenLabs quickstart documentation pattern with minimal dependencies and focused functionality.