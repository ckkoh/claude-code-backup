#!/bin/bash

# Claude Code Configuration Restore Script
# Restores Claude Code settings from backup

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo -e "${BLUE}Claude Code Configuration Restore${NC}"
echo "=================================="

# Check if backup exists
if [[ ! -d "$SCRIPT_DIR/config" ]]; then
    echo -e "${RED}Error: Backup config directory not found at $SCRIPT_DIR/config${NC}"
    echo "Make sure you're running this from the backup repository directory"
    exit 1
fi

# Create Claude directory if it doesn't exist
echo "Setting up Claude Code directory..."
mkdir -p "$CLAUDE_DIR"

# Backup existing settings if they exist
if [[ -f "$CLAUDE_DIR/settings.json" ]]; then
    echo -e "${YELLOW}Existing settings.json found, creating backup...${NC}"
    cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Restore settings.json
echo "Restoring settings.json..."
if [[ -f "$SCRIPT_DIR/config/settings.json" ]]; then
    cp "$SCRIPT_DIR/config/settings.json" "$CLAUDE_DIR/"
    echo -e "${GREEN}✓ settings.json restored${NC}"
else
    echo -e "${YELLOW}⚠ settings.json not found in backup${NC}"
fi

# Restore hooks directory
echo "Restoring hooks..."
if [[ -d "$SCRIPT_DIR/config/hooks" ]] && [[ "$(ls -A $SCRIPT_DIR/config/hooks 2>/dev/null)" ]]; then
    mkdir -p "$CLAUDE_DIR/hooks"
    cp -r "$SCRIPT_DIR/config/hooks/"* "$CLAUDE_DIR/hooks/"
    chmod +x "$CLAUDE_DIR/hooks/"* 2>/dev/null || true  # Make executable if needed
    echo -e "${GREEN}✓ hooks restored${NC}"
else
    echo -e "${YELLOW}⚠ hooks not found in backup${NC}"
fi

# Restore audio files
echo "Restoring audio files..."
if [[ -d "$SCRIPT_DIR/config/audio" ]] && [[ "$(ls -A $SCRIPT_DIR/config/audio 2>/dev/null)" ]]; then
    mkdir -p "$CLAUDE_DIR/audio"
    cp "$SCRIPT_DIR/config/audio/"* "$CLAUDE_DIR/audio/"
    echo -e "${GREEN}✓ audio files restored${NC}"
else
    echo -e "${YELLOW}⚠ audio files not found in backup${NC}"
fi

# Create restore summary
echo "Creating restore summary..."
cat > "$CLAUDE_DIR/RESTORE_INFO.txt" << EOF
Claude Code Restore Summary
==========================
Restore Date: $(date)
Source Backup: $SCRIPT_DIR/config
Target Directory: $CLAUDE_DIR

Files Restored:
$(find "$CLAUDE_DIR" -type f -name "*.json" -o -name "*.py" -o -name "*.mp3" -o -name "PreToolUse" -o -name "PostToolUse" | grep -v RESTORE_INFO.txt | sort)

MANUAL SETUP STILL REQUIRED:
1. Authentication: Run 'claude auth login' to set up API credentials
2. Test audio: Verify sound playback works on your system
3. Verify hooks: Check that notifications work as expected
EOF

echo -e "${GREEN}✓ Restore completed successfully!${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT - Manual setup required:${NC}"
echo "1. Run: ${BLUE}claude auth login${NC}"
echo "2. Test audio playback and hooks"
echo "3. Review RESTORE_INFO.txt for details"
echo ""
echo -e "${GREEN}Your Claude Code configuration has been restored!${NC}"