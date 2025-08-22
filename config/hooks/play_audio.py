#!/usr/bin/env python3
"""
Claude Code Stop Hook - Task Completion Announcer
Plays pre-generated audio clips when tasks are completed
"""

import sys
import subprocess
import platform
from pathlib import Path
from typing import Union


def play_audio(audio_file: Union[str, Path]) -> None:
    """Play audio file using system audio player"""
    system = platform.system().lower()
    
    try:
        if system == "linux":
            # Try different Linux audio players in order of preference
            players = ["paplay", "aplay", "mpg123", "ffplay"]
            for player in players:
                try:
                    if player == "paplay":
                        subprocess.run(["paplay", str(audio_file)], check=True, capture_output=True)
                    elif player == "aplay":
                        subprocess.run(["aplay", str(audio_file)], check=True, capture_output=True)
                    elif player == "mpg123":
                        subprocess.run(["mpg123", "-q", str(audio_file)], check=True, capture_output=True)
                    elif player == "ffplay":
                        subprocess.run(["ffplay", "-nodisp", "-autoexit", str(audio_file)], check=True, capture_output=True)
                    return  # Success, exit function
                except (subprocess.CalledProcessError, FileNotFoundError):
                    continue  # Try next player
            
            # If no players work, print helpful message
            print(f"No audio player found. Install one of: {', '.join(players)}")
            
        elif system == "darwin":
            # macOS
            subprocess.run(["afplay", str(audio_file)], check=True)
        elif system == "windows":
            # Windows
            subprocess.run(["powershell", "-c", f"(New-Object Media.SoundPlayer '{audio_file}').PlaySync()"], check=True)
        else:
            print(f"Unsupported system: {system}")
            
    except subprocess.CalledProcessError:
        print(f"Failed to play audio: {audio_file}")
    except FileNotFoundError:
        print(f"Audio player not found for {system}")
    except Exception as e:
        print(f"Error playing audio: {e}")


def main() -> None:
    """Main function for Claude Code stop hook"""
    print("Stop hook triggered!")
    # Get audio directory
    audio_dir = Path(__file__).parent.parent / "audio"

    # Default to task_complete sound
    audio_file = "task_complete.mp3"

    # Override with specific sound if provided as argument
    if len(sys.argv) > 1:
        audio_file = f"{sys.argv[1]}.mp3"

    # Full path to audio file
    audio_path = audio_dir / audio_file

    # Check if audio file exists
    if not audio_path.exists():
        print(f"Audio file not found: {audio_path}")
        print("Run generate_audio_clips.py first to create audio files.")
        sys.exit(1)

    # Play the audio
    play_audio(audio_path)


main()
