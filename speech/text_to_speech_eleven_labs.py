from dotenv import load_dotenv
from elevenlabs.client import ElevenLabs
from elevenlabs import play
from elevenlabs.core.api_error import ApiError
import os
import sys
import random

# Voice IDs and names from ElevenLabs API
VOICES = {
    "Grandpa": "NOpBlnGInO9m6vDvFkFC",
}

load_dotenv()

elevenlabs = ElevenLabs(
    api_key=os.getenv("ELEVENLABS_API_KEY"),
)

if len(sys.argv) < 2:
    print("Usage: python text_to_speech_eleven_labs.py 'text to speak'")
    sys.exit(1)

text = " ".join(sys.argv[1:])

# Choose a random voice
voice_id = random.choice(list(VOICES.values()))
voice_name = [name for name, id in VOICES.items() if id == voice_id][0]

try:
    audio = elevenlabs.text_to_speech.convert(
        text=text,
        voice_id=voice_id,
        model_id="eleven_multilingual_v2",
        output_format="mp3_44100_128",
    )
    play(audio)
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
