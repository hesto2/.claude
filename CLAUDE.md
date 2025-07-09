# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Claude Code configuration repository that extends Claude's functionality through custom hooks and commands. It serves as a personal dotfiles repository for Claude Code customizations.

## Architecture

The repository follows a modular architecture with clear separation between different types of extensions:

- **Hooks** (`hooks/`): Event-driven scripts that execute at specific points in Claude's lifecycle
- **Commands** (`commands/`): Custom slash commands that extend Claude's interactive capabilities
- **Configuration**: JSON-based settings that control behavior

### Key Components

#### Notification System (`hooks/notify.js`)
A sophisticated notification system that:
- Detects whether the user is actively working in the project window
- Sends desktop notifications via macOS `terminal-notifier`
- Plays different sounds based on event type (notifications vs completion)
- Reads configuration from `customConfig.json` for sound preferences
- Handles both `Notification` and `Stop` events

Key configuration options in `customConfig.json`:
- `notificationSoundEnabled`: Enable/disable sounds
- `notificationSound`: Sound for regular notifications
- `stopSound`: Sound for task completion
- `forceNotifyIfFocused`: Show notifications even when window is focused

#### Logging System (`hooks/log-tool-use.js`)
Comprehensive logging that:
- Records all tool usage to `~/.claude/logs/[project-name]/tool-use.log`
- Captures timestamp, tool name, inputs, and outputs
- Creates project-specific log directories automatically

#### Sound Control Commands
- `commands/soundOn.md`: Enables notification sounds
- `commands/soundOff.md`: Disables notification sounds

Both commands use inline Node.js to update `customConfig.json` while preserving other settings.

## Configuration Files

### `settings.json`
Main configuration defining:
- Permissions (e.g., WebFetch for docs.anthropic.com)
- Hook mappings for events (PostToolUse, Notification, Stop)

### `customConfig.json`
User preferences for notifications and sounds. This file is read by hooks at runtime.

## Development Commands

### Testing Hooks
```bash
# Test notification hook
echo '{"hook_event_name": "Notification", "message": "Test message"}' | node ~/.claude/hooks/notify.js

# Test stop hook
echo '{"hook_event_name": "Stop"}' | node ~/.claude/hooks/notify.js
```

### Modifying Configuration
```bash
# Enable sounds
node -e "const fs=require('fs'); const path=require('path'); const configPath=path.join(process.env.HOME, '.claude', 'customConfig.json'); let config={}; try { if(fs.existsSync(configPath)) { config=JSON.parse(fs.readFileSync(configPath, 'utf8')); } } catch(e) {} config.notificationSoundEnabled=true; fs.writeFileSync(configPath, JSON.stringify(config, null, 2));"

# Check current configuration
cat ~/.claude/customConfig.json
```

## Hook Event Data Structure

Hooks receive JSON via stdin with this structure:
```json
{
  "hook_event_name": "Notification|Stop",
  "event": "Notification|Stop",
  "message": "notification text",
  "tool_name": "tool name",
  "tool_input": { /* tool-specific parameters */ },
  "tool_output": { /* available in PostToolUse */ }
}
```

## Platform Requirements

- **macOS**: Required for notification system (uses `terminal-notifier` and AppleScript)
- **Node.js**: All hooks are written in Node.js
- **terminal-notifier**: Must be installed via `brew install terminal-notifier`

## Important Directories

- `logs/`: Tool usage logs (gitignored)
- `projects/`: Project-specific data (gitignored)
- `todos/`: Task tracking data (gitignored)
- `statsig/`: Analytics data (gitignored)

## Adding New Features

When extending this configuration:

1. **New Hooks**: Place JavaScript files in `hooks/` and register them in `settings.json`
2. **New Commands**: Create markdown files in `commands/` following the existing pattern
3. **Configuration**: Add new settings to `customConfig.json` and ensure hooks handle missing values gracefully
4. **Logging**: The existing log infrastructure in `log-tool-use.js` can be extended for new event types

## Security Considerations

- Hooks run with full user permissions
- Always validate and sanitize inputs from stdin
- Use absolute paths to prevent path traversal
- Quote shell variables properly in commands