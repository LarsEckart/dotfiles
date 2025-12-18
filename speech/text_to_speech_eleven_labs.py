from dotenv import load_dotenv
from elevenlabs.client import ElevenLabs
from elevenlabs import play
from elevenlabs.core.api_error import ApiError
import os
import sys
import argparse
import random
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
    
    # Save to outputs folder
    outputs_dir = Path(__file__).parent / "outputs"
    outputs_dir.mkdir(exist_ok=True)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_file = outputs_dir / f"{timestamp}.mp3"
    output_file.write_bytes(audio_bytes)
    
    play(audio_bytes)
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
