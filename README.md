# Claude Code Configuration Backup

This repository contains a backup of Claude Code settings, hooks, and audio files for easy restoration on new computers.

## What's Included

- `settings.json` - Main Claude Code configuration
- `hooks/` - Custom hook scripts for notifications and audio
- `audio/` - Sound clips for different events
- Scripts for backup and restoration

## What's NOT Included (for security/privacy)

- `.credentials.json` - Contains API keys (set up manually)
- `projects/` - Chat history (privacy sensitive)
- Temporary files and caches

## Install libraries needed to run Claude Code /hooks
1. sudo apt update && sudo apt install jq
2. sudo apt install ffmpeg -y

## Quick Restore

```bash
# Clone this repository
git clone <your-repo-url> claude-code-backup
cd claude-code-backup

# Run the restoration script
./restore.sh

# Set up your Claude Code credentials manually
claude auth login
```

## Manual Setup Required After Restore

1. Run `claude auth login` to set up authentication
2. Verify audio playback works with your system's audio players
3. Test hooks and notifications

## Files Structure

```
~/.claude/
├── settings.json          # Main configuration
├── hooks/                 # Custom scripts
│   ├── play_audio.py      # Audio player hook
│   ├── macos_notification.py # Notification script  
│   ├── PostToolUse        # Post-tool hook
│   └── PreToolUse         # Pre-tool hook
└── audio/                 # Sound clips
    ├── alert.mp3
    ├── awaiting_instructions.mp3
    ├── build_complete.mp3
    ├── error_fixed.mp3
    ├── ready.mp3
    ├── start.mp3
    └── task_complete.mp3
```