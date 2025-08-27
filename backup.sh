#!/bin/bash

# Claude Code Configuration Backup Script
# Safely backs up Claude Code settings to this repository

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo -e "${GREEN}Claude Code Configuration Backup${NC}"
echo "================================="

# Check if Claude directory exists
if [[ ! -d "$CLAUDE_DIR" ]]; then
    echo -e "${RED}Error: Claude Code directory not found at $CLAUDE_DIR${NC}"
    exit 1
fi

# Create backup directories
echo "Creating backup directories..."
mkdir -p "$SCRIPT_DIR/config/hooks"
mkdir -p "$SCRIPT_DIR/config/audio"
mkdir -p "$SCRIPT_DIR/config/commands" 

# Backup settings.json
echo "Backing up settings.json..."
if [[ -f "$CLAUDE_DIR/settings.json" ]]; then
    cp "$CLAUDE_DIR/settings.json" "$SCRIPT_DIR/config/"
    echo -e "${GREEN}✓ settings.json backed up${NC}"
else
    echo -e "${YELLOW}⚠ settings.json not found${NC}"
fi

# Backup hooks directory
echo "Backing up hooks..."
if [[ -d "$CLAUDE_DIR/hooks" ]]; then
    cp -r "$CLAUDE_DIR/hooks/"* "$SCRIPT_DIR/config/hooks/" 2>/dev/null || true
    echo -e "${GREEN}✓ hooks backed up${NC}"
else
    echo -e "${YELLOW}⚠ hooks directory not found${NC}"
fi

# Backup audio files
echo "Backing up audio files..."
if [[ -d "$CLAUDE_DIR/audio" ]]; then
    cp "$CLAUDE_DIR/audio/"*.mp3 "$SCRIPT_DIR/config/audio/" 2>/dev/null || true
    echo -e "${GREEN}✓ audio files backed up${NC}"
else
    echo -e "${YELLOW}⚠ audio directory not found${NC}"
fi

# Backup custom slash commands
echo "Backing up custom slash commands..."
if [[ -d "$CLAUDE_DIR/commands" ]]; then
    cp -r "$CLAUDE_DIR/commands/"* "$SCRIPT_DIR/config/commands/" 2>/dev/null || true
    echo -e "${GREEN}✓ custom slash commands backed up${NC}"
else
    echo -e "${YELLOW}⚠ commands directory not found${NC}"
fi

# Backup todo_done.md
echo "Backing up todo_done.md..."
if [[ -f "$CLAUDE_DIR/todo_done.md" ]]; then
    cp "$CLAUDE_DIR/todo_done.md" "$SCRIPT_DIR/config/"
    echo -e "${GREEN}✓ todo_done.md backed up${NC}"
else
    echo -e "${YELLOW}⚠ todo_done.md not found${NC}"
fi

# Create backup summary
echo "Creating backup summary..."
cat > "$SCRIPT_DIR/BACKUP_INFO.txt" << EOF
Claude Code Backup Summary
=========================
Backup Date: $(date)
Source Directory: $CLAUDE_DIR
Backup Directory: $SCRIPT_DIR

Files Backed Up:
$(find "$SCRIPT_DIR/config" -type f | sort)

EXCLUDED (for security/privacy):
- .credentials.json (contains API keys)
- projects/ (chat history)
- todos/ (temporary files)
- shell-snapshots/ (temporary files) 
- statsig/ (analytics cache)
- local/ (downloaded packages)
- ide/ (IDE temp files)
- bash-command-log.txt (command history)

INCLUDED:
- settings.json (main configuration)
- hooks/ (custom hook scripts)
- audio/ (notification sounds)
- commands/ (custom slash commands)
- todo_done.md (task completion log)

To restore: run ./restore.sh on the target system
EOF

echo -e "${GREEN}✓ Backup completed successfully!${NC}"
echo "Files backed up to: $SCRIPT_DIR/config/"
echo "Review BACKUP_INFO.txt for details"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review the backed up files"
echo "2. Initialize git repository if not done: git init && git add . && git commit -m 'Initial backup'"
echo "3. Push to GitHub: git remote add origin <your-repo-url> && git push -u origin main"