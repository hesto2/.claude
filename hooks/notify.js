#!/usr/bin/env node
// afplay ~/dev/zshrc/OOT_Carrot.wav

const { exec } = require("child_process");

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
      // Use macOS 'notify' command to speak the message
      exec(
        `osascript -e 'display notification "Test with sound" with title "Test"'`,
        (error) => {
          if (error) {
            console.error(`Error notifying: ${error.message}`);
            process.exit(1);
          }
          process.exit(0);
        }
      );
    } else {
      process.exit(0);
    }
  } catch (error) {
    console.error(`Error in speak-notification hook: ${error.message}`);
    process.exit(1);
  }
});
