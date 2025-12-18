from dotenv import load_dotenv
from elevenlabs.client import ElevenLabs
from elevenlabs import play
from elevenlabs.core.api_error import ApiError
import anthropic
import os
import sys
import argparse
import random
import re
from datetime import datetime
from pathlib import Path

# Voice IDs and names from ElevenLabs API
VOICES = {
    "grandpa": "NOpBlnGInO9m6vDvFkFC",
}

load_dotenv()

elevenlabs = ElevenLabs(
    api_key=os.getenv("ELEVENLABS_API_KEY"),
)

claude = anthropic.Anthropic()


def generate_filename(text: str) -> str:
    """Use Claude Haiku to generate a 3-5 word description for the filename."""
    response = claude.messages.create(
        model="claude-haiku-4-5-20251001",
        max_tokens=50,
        messages=[
            {
                "role": "user",
                "content": f"""Generate a short filename description for this spoken text.
Rules:
- Use 3-5 words, lowercase, separated by hyphens
- Describe the content/topic, not that it's speech
- No special characters, just letters and hyphens
- Reply with ONLY the filename, nothing else

Text: "{text[:500]}"
""",
            }
        ],
    )
    
    result = response.content[0].text.strip().lower()
    # Sanitize: keep only letters and hyphens, collapse multiple hyphens
    result = re.sub(r"[^a-z-]", "-", result)
    result = re.sub(r"-+", "-", result).strip("-")
    return result or "speech"

parser = argparse.ArgumentParser(description="Text-to-speech using ElevenLabs API")
parser.add_argument("text", nargs="+", help="Text to speak")
parser.add_argument(
    "-v", "--voice",
    choices=list(VOICES.keys()),
    default=None,
    help=f"Voice to use (default: random). Options: {', '.join(VOICES.keys())}"
)
args = parser.parse_args()

text = " ".join(args.text)

# Choose voice: specified or random
if args.voice:
    voice_name = args.voice
    voice_id = VOICES[voice_name]
else:
    voice_id = random.choice(list(VOICES.values()))
    voice_name = [name for name, id in VOICES.items() if id == voice_id][0]

try:
    audio = elevenlabs.text_to_speech.convert(
        text=text,
        voice_id=voice_id,
        model_id="eleven_multilingual_v2",
        output_format="mp3_44100_128",
    )
    
    # Collect audio bytes
    audio_bytes = b"".join(audio)
    
    # Save to outputs folder with descriptive name
    outputs_dir = Path(__file__).parent / "outputs"
    outputs_dir.mkdir(exist_ok=True)
    
    description = generate_filename(text)
    base_filename = f"{voice_name}-{description}"
    output_file = outputs_dir / f"{base_filename}.mp3"
    
    # Handle duplicates by adding a number suffix
    counter = 1
    while output_file.exists():
        output_file = outputs_dir / f"{base_filename}-{counter}.mp3"
        counter += 1
    
    output_file.write_bytes(audio_bytes)
    print(f"Saved: {output_file.name}")
    
    play(audio_bytes)
except KeyboardInterrupt:
    print("\nStopped.")
    sys.exit(0)
except ApiError as e:
    print(
        f"ElevenLabs API Error: {e.body.get('detail', {}).get('message', 'Unknown error')}"
    )
    print(f"Status: {e.body.get('detail', {}).get('status', 'Unknown status')}")
    print(
        f"Request details: text='{text}', voice='{voice_name}', model='eleven_multilingual_v2'"
    )
    sys.exit(1)
except Exception as e:
    print(f"Unexpected error: {str(e)}")
    print(
        f"Request details: text='{text}', voice='{voice_name}', model='eleven_multilingual_v2'"
    )
    sys.exit(1)
