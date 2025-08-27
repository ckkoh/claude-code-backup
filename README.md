# Claude Code Configuration Backup System

A comprehensive backup and restore solution for Claude Code configurations, featuring automated scripts, cross-platform notification hooks, and audio feedback system.

## 🎯 Overview

This repository provides a complete backup system for Claude Code settings, including sophisticated hook systems for notifications, audio feedback, and command logging. Designed for developers who want to maintain consistent Claude Code configurations across multiple machines.

## 🚀 Features

### Automated Backup & Restore

- **Smart backup script** (`backup.sh`) - Safely backs up configurations with detailed logging
- **One-command restore** (`restore.sh`) - Restores configurations with conflict handling
- **Backup validation** - Automatically generates detailed backup summaries

### Advanced Hook System

- **Session Management** - Custom SessionStart hooks with Pac-Man themed audio
- **Tool Monitoring** - PreToolUse hooks for command logging and tracking
- **Real-time Notifications** - Cross-platform desktop notifications for tool usage
- **Audio Feedback** - Rich audio library with task completion sounds

### Cross-Platform Support

- **Linux** - Full support with multiple audio players and notification systems
- **macOS** - Native AppleScript notifications and afplay audio
- **Windows** - PowerShell notifications and Windows Media Player integration

## 📦 What's Included

### Configuration Files

- `settings.json` - Complete Claude Code configuration with hooks, status line, and preferences
- `hooks/` - Executable hook scripts with type hints and error handling
- `audio/` - High-quality audio clips for different events

### Audio Library (11 clips)

- `alert.mp3` - General notifications
- `awaiting_instructions.mp3` - Waiting for user input
- `build_complete.mp3` - Build/compilation completion
- `error_fixed.mp3` - Error resolution success
- `ready.mp3` - System ready state
- `readtr.mp3` - Ready-to-receive state (Stop hook audio)
- `start.mp3` - General startup sound
- `task_complete.mp3` - Task completion
- **Pac-Man Collection**:
  - `pacman_start.mp3` - Session start sound
  - `pacman_death.mp3` - Error/failure events
  - `pacman_eatghost.mp3` - Success/achievement sounds

### Automation Scripts

- `backup.sh` - Comprehensive backup with safety checks
- `restore.sh` - Intelligent restore with conflict resolution
- Detailed logging and error handling throughout

## 🛡️ Security & Privacy

### Excluded Files (for security)

- `.credentials.json` - API keys and authentication tokens
- `projects/` - Chat history and conversation data
- `todos/` - Temporary todo files
- `shell-snapshots/` - Command history snapshots
- `statsig/` - Analytics and usage data
- `local/` - Downloaded packages and cached data
- `ide/` - Temporary IDE files
- `bash-command-log.txt` - Command execution logs

### Security Best Practices

- No sensitive data in version control
- Executable permissions preserved during restore
- Backup validation before overwriting existing configurations
- Clear separation of public configuration and private credentials

## 🔧 Prerequisites

### Required Dependencies

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install jq ffmpeg -y
sudo apt install mypy # Optional static type checker for Python
sudo apt install flake8 # Tool For Style Guide Enforcement
sudo apt install pylint # Static code analyser

# macOS
brew install jq ffmpeg

# Fedora/RHEL
sudo dnf install jq ffmpeg

# Arch Linux
sudo pacman -S jq ffmpeg
```

### Optional Dependencies (auto-detected)

- **Linux Audio**: paplay, aplay, mpg123, ffplay
- **Linux Notifications**: notify-send, zenity
- **Python**: Required for hook scripts (usually pre-installed)

## ⚡ Quick Start

### Clone and Restore

```bash
# Clone this repository
git clone <your-repo-url> claude-code-backup
cd claude-code-backup

# Make scripts executable
chmod +x backup.sh restore.sh

# Run the restoration script
./restore.sh

# Authenticate with Claude Code
claude auth login
```

### Verify Installation

```bash
# Test audio system
python3 ~/.claude/hooks/play_audio.py alert

# Check configuration
cat ~/.claude/settings.json

# Verify hooks are executable
ls -la ~/.claude/hooks/
```

## 📋 Detailed Configuration

### Hook System Architecture

#### SessionStart Hook

Triggers when Claude Code session begins:

```json
{
  "SessionStart": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "uv run ~/.claude/hooks/play_audio.py pacman_start"
        }
      ]
    }
  ]
}
```

#### PreToolUse Hook

Logs Bash commands for audit trail:

```json
{
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "jq -r '\"\\(.tool_input.command) - \\(.tool_input.description // \"No description\")\"' >> ~/.claude/bash-command-log.txt"
        }
      ]
    }
  ]
}
```

#### Notification System

Provides real-time feedback for all tool usage:

```json
{
  "Notification": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "uv run ~/.claude/hooks/play_audio.py alert"
        },
        {
          "type": "command",
          "command": "uv run ~/.claude/hooks/macos_notification.py"
        }
      ]
    }
  ]
}
```

#### Stop Hook System

Triggers when Claude Code session ends or pauses, signaling ready-to-receive state:

```json
{
  "Stop": [
    {
      "matcher": "",
      "hooks": [
        {
          "type": "command",
          "command": "uv run ~/.claude/hooks/play_audio.py readtr"
        },
        {
          "type": "command",
          "command": "uv run ~/.claude/hooks/macos_notification.py"
        }
      ]
    }
  ]
}
```

### Status Line Configuration

Claude Code's status line feature displays information at the bottom of the terminal interface. This enhanced configuration shows the current user, hostname, working directory, and AI model information with advanced shell environment detection:

```bash
debian_chroot=$([ -r /etc/debian_chroot ] && cat /etc/debian_chroot); printf '%s\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m \033[38;5;208mSonnet 4\033[00m' "${debian_chroot:+($debian_chroot)}" "$(whoami)" "$(hostname -s)" "$(pwd)"
```

**Status Line Breakdown:**

- `debian_chroot=$(...` - Detects if running in a Debian chroot environment
- `${debian_chroot:+($debian_chroot)}` - Shows `(chroot_name)` if in chroot, empty otherwise
- `\033[01;32m` - Bold green color for username and hostname
- `%s@%s` - Format: `username@hostname`
- `\033[00m` - Reset color formatting
- `:` - Separator between host and directory
- `\033[01;34m` - Bold blue color for current directory path
- `%s` - Current working directory from `$(pwd)`
- `\033[38;5;208m` - Orange color (256-color palette) for model name
- `Sonnet 4` - Current Claude model identifier
- `\033[00m` - Reset color at the end

**Example Outputs:**

```bash
# Normal environment
claude@dev-machine:/home/claude/projects Sonnet 4

# In Debian chroot
(ubuntu-focal)claude@dev-machine:/home/claude/projects Sonnet 4
```

This enhanced status line provides comprehensive context about your environment, including chroot detection for containerized development and clear identification of the AI model you're working with. The status line updates automatically as you navigate between directories and environments.

## 🔄 Backup Management

### Creating Backups

```bash
./backup.sh
```

- Safely backs up all configurations
- Creates detailed backup summary (`BACKUP_INFO.txt`)
- Preserves file permissions and structure
- Validates backup completion

### Restoring Configurations

```bash
./restore.sh
```

- Creates backups of existing configurations
- Restores all backed-up files and settings
- Sets proper permissions on hook scripts
- Generates restore summary (`RESTORE_INFO.txt`)

## 🎵 Audio System Details

### Supported Audio Players

- **Linux**: paplay (PulseAudio), aplay (ALSA), mpg123, ffplay
- **macOS**: afplay (native)
- **Windows**: PowerShell Media.SoundPlayer

### Audio Usage Examples

```bash
# Play specific sounds
python3 ~/.claude/hooks/play_audio.py alert
python3 ~/.claude/hooks/play_audio.py task_complete
python3 ~/.claude/hooks/play_audio.py pacman_start
python3 ~/.claude/hooks/play_audio.py readtr

# Test all audio files
for sound in alert awaiting_instructions build_complete error_fixed pacman_death pacman_eatghost pacman_start ready readtr start task_complete; do
    python3 ~/.claude/hooks/play_audio.py $sound
    sleep 1
done
```

## 🔍 Troubleshooting

### Common Issues

#### Audio Not Playing

```bash
# Check audio players
which paplay aplay mpg123 ffplay

# Test system audio
paplay /usr/share/sounds/alsa/Front_Left.wav

# Verify audio files exist
ls -la ~/.claude/audio/
```

#### Notifications Not Working

```bash
# Check notification systems
which notify-send zenity

# Test notifications
notify-send "Test" "Claude Code notification test"
```

#### Hook Scripts Not Executing

```bash
# Verify permissions
ls -la ~/.claude/hooks/

# Make executable if needed
chmod +x ~/.claude/hooks/*

# Test hooks directly
python3 ~/.claude/hooks/play_audio.py alert
```

### Log Files

- `~/.claude/bash-command-log.txt` - Command execution history
- `~/.claude/RESTORE_INFO.txt` - Last restore operation details
- `BACKUP_INFO.txt` - Last backup operation summary

## 🤝 Contributing

Feel free to submit issues and enhancement requests! This backup system is designed to be extensible and customizable for different workflows.

## 📄 Files Structure

```
~/.claude/
├── settings.json              # Main Claude Code configuration
├── hooks/                     # Executable hook scripts
│   ├── play_audio.py         # Cross-platform audio player (Python 3)
│   ├── macos_notification.py # Cross-platform notifications (Python 3)
│   ├── PostToolUse          # Simple post-tool hook (Bash)
│   └── PreToolUse           # Command logging hook (Bash)
├── audio/                    # Audio clip library
│   ├── alert.mp3            # General notifications
│   ├── awaiting_instructions.mp3
│   ├── build_complete.mp3   # Success sounds
│   ├── error_fixed.mp3
│   ├── ready.mp3
│   ├── readtr.mp3           # Ready-to-receive (Stop hook)
│   ├── start.mp3
│   ├── task_complete.mp3
│   ├── pacman_start.mp3     # Themed audio collection
│   ├── pacman_death.mp3
│   └── pacman_eatghost.mp3
└── bash-command-log.txt      # Command audit trail
```

## 📈 Recent Updates

- ✅ **Enhanced Status Line** - Added Debian chroot detection and Sonnet 4 model identifier with orange color coding
- ✅ **New Audio File** - Added `readtr.mp3` for Stop hook ready-to-receive state
- ✅ **Audio Library Expansion** - Now includes 11 audio clips with comprehensive event coverage
- ✅ **Environment Detection** - Improved containerized development support with chroot identification
- ✅ **SessionStart Hook** - Pac-Man themed audio for engaging session startup
- ✅ **Enhanced Python Scripts** - Comprehensive type hints and cross-platform compatibility
- ✅ **Pac-Man Collection** - 3 themed audio files for gamified development experience
- ✅ **Backup System** - Detailed logging and intelligent conflict resolution
- ✅ **Error Handling** - Robust fallback systems for audio and notifications
