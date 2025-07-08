#!/usr/bin/env node

/**
 * SETUP INSTRUCTIONS:
 *
 * 1. Install terminal-notifier:
 *    brew install terminal-notifier
 *
 * 2. Grant notification permissions:
 *    - Go to System Settings > Privacy & Security > Notifications
 *    - Find "terminal-notifier" in the list
 *    - Enable "Allow Notifications"
 *    - You may also want to adjust the notification style and other settings
 *
 * 3. Test the notification:
 *    terminal-notifier -title "Test" -message "Hello" -execute "echo 'Clicked!'"
 *
 * Note: The first time terminal-notifier runs, macOS may prompt you to allow notifications.
 */

const { exec } = require("child_process");
const path = require("path");

// Read input from stdin
let inputData = "";
process.stdin.on("data", (chunk) => {
  inputData += chunk;
});

process.stdin.on("end", () => {
  try {
    const data = JSON.parse(inputData);

    // For Notification events, speak the notification message
    let message = "";

    // The notification event uses hook_event_name, not event
    if (data.hook_event_name === "Notification" && data.message) {
      // Extract the notification text
      message = data.message;
    } else if (data.message) {
      // Fallback to just use message if present
      message = data.message;
    }

    // Clean up the message for speech (remove markdown, etc)
    if (message) {
      message = message.replace(/[*_`]/g, "").trim();

      // Limit length for very long messages
      if (message.length > 200) {
        message = message.substring(0, 200) + "... message truncated";
      }
    }

    // Only speak if we have a message
    if (message) {
      // Get the working directory from the environment or data
      const pwd = process.env.PWD || process.cwd();

      // Get just the project name (last part of the path)
      const projectName = path.basename(pwd);

      // Escape double quotes in message for shell command
      const escapedMessage = message.replace(/"/g, '\\"');

      // Use terminal-notifier to display notification
      // -execute opens cursor with the project directory when clicked
      // Note: -execute requires escaping quotes properly
      const command = `terminal-notifier -title "${projectName}" -message "${escapedMessage}" -execute '/usr/local/bin/cursor ${pwd}'`;

      exec(command, (error) => {
        if (error) {
          console.error(`Error notifying: ${error.message}`);
          process.exit(1);
        }
        process.exit(0);
      });
    } else {
      process.exit(0);
    }
  } catch (error) {
    console.error(`Error in speak-notification hook: ${error.message}`);
    process.exit(1);
  }
});
