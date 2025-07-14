# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Claude Code configuration repository that extends Claude's functionality through custom hooks and commands. It serves as a personal dotfiles repository for Claude Code customizations on macOS.

## Commands

### Testing Hooks
```bash
# Test notification hook
echo '{"hook_event_name": "Notification", "message": "Test message"}' | node ~/.claude/hooks/notify.js

# Test stop hook (completion sound)
echo '{"hook_event_name": "Stop"}' | node ~/.claude/hooks/notify.js

# Test with custom configuration
echo '{"hook_event_name": "Notification", "message": "Test", "forceNotifyIfFocused": true}' | node ~/.claude/hooks/notify.js
```

### Managing Sound Settings
```bash
# Enable notification sounds
node -e "const fs=require('fs'); const path=require('path'); const configPath=path.join(process.env.HOME, '.claude', 'customConfig.json'); let config={}; try { if(fs.existsSync(configPath)) { config=JSON.parse(fs.readFileSync(configPath, 'utf8')); } } catch(e) {} config.notificationSoundEnabled=true; fs.writeFileSync(configPath, JSON.stringify(config, null, 2));"

# Disable notification sounds
node -e "const fs=require('fs'); const path=require('path'); const configPath=path.join(process.env.HOME, '.claude', 'customConfig.json'); let config={}; try { if(fs.existsSync(configPath)) { config=JSON.parse(fs.readFileSync(configPath, 'utf8')); } } catch(e) {} config.notificationSoundEnabled=false; fs.writeFileSync(configPath, JSON.stringify(config, null, 2));"

# Check current configuration
cat ~/.claude/customConfig.json
```

### Git Worktree Management
```bash
# Add a new worktree
./helper-scripts/addWorkTree.sh <branch-name>

# Remove a worktree
./helper-scripts/removeWorkTree.sh <worktree-path>
```

## Architecture

### Core Components

1. **Notification System** (`hooks/notify.js`)
   - Detects window focus state to avoid redundant notifications
   - Sends macOS desktop notifications via `terminal-notifier`
   - Plays configurable sounds for different events
   - Reads settings from `customConfig.json`

2. **Logging System** (`hooks/log-tool-use.js`)
   - Logs all tool usage to `~/.claude/logs/[project-name]/tool-use.log`
   - Creates project-specific directories automatically
   - Captures timestamp, tool name, inputs, and outputs

3. **Sound Control Commands** (`commands/soundOn.md`, `commands/soundOff.md`)
   - Toggle notification sounds via slash commands
   - Modifies `customConfig.json` while preserving other settings

### Configuration Files

- **`settings.json`**: Defines hook mappings and permissions
- **`customConfig.json`**: User preferences for notifications and sounds
  - `notificationSoundEnabled`: Toggle for sound effects
  - `notificationSound`: Sound name for regular notifications
  - `stopSound`: Sound name for task completion
  - `forceNotifyIfFocused`: Show notifications even when focused

### Hook Event Structure

Hooks receive JSON via stdin:
```json
{
  "hook_event_name": "Notification|Stop|PostToolUse",
  "message": "notification text (for Notification events)",
  "tool_name": "tool name (for PostToolUse)",
  "tool_input": {},
  "tool_output": {}
}
```

## Development Guidelines

### Adding New Hooks
1. Create JavaScript file in `hooks/`
2. Register in `settings.json` under appropriate event
3. Test with echo command and JSON payload
4. Handle missing configuration gracefully

### Adding New Commands
1. Create markdown file in `commands/`
2. Include inline Node.js for configuration changes
3. Follow existing pattern of reading/writing `customConfig.json`

### Platform Requirements
- **macOS**: Required for notification system
- **Node.js**: All hooks written in Node.js
- **terminal-notifier**: Install via `brew install terminal-notifier`

## Important Notes

- Hooks run with full user permissions - validate all inputs
- The repository uses absolute paths to prevent security issues
- Logs, projects, todos, and statsig directories are gitignored
- Window focus detection uses AppleScript for intelligent notifications