#!/bin/bash

task_name="$1"

if [ -z "$task_name" ]; then
  echo "Error: Branch name is required"
  echo "Usage: addYTWorkTree.sh <branch-name>"
  exit 1
fi

worktree_path="$HOME/dev/worktrees/$(basename $PWD)-$task_name"

# Create worktree
git worktree add "$worktree_path" -b "$task_name"

# Copy .claude directory if it exists
if [ -d ".claude" ]; then
    cp -r .claude "$worktree_path/"
    echo "📂 Copied .claude directory to worktree"
fi

# Copy all .env* files if they exist
for env_file in .env*; do
    if [ -f "$env_file" ]; then
        cp "$env_file" "$worktree_path/"
        echo "📂 Copied $env_file to worktree"
    fi
done

# Create workspace with auto-running Claude Code task
cat > "$worktree_path/${task_name}.code-workspace" << EOF
{
    "folders": [{"path": "."}],
    "settings": {
        "terminal.integrated.defaultProfile.osx": "zsh"
    },
    "tasks": {
        "version": "2.0.0",
        "tasks": [
            {
                "label": "Start Claude Code",
                "type": "shell",
                "command": "claude --dangerously-skip-permissions /youtube-pipeline ${task_name}",
                "runOptions": {
                    "runOn": "folderOpen"
                },
                "presentation": {
                    "reveal": "always",
                    "panel": "new"
                }
            }
        ]
    }
}
EOF

# Open workspace
cursor "$worktree_path/${task_name}.code-workspace"

echo "✅ Created worktree with Claude Code task for youtube-pipeline: $task_name"
echo "   The workspace will automatically run: claude --dangerously-skip-permissions /youtube-pipeline ${task_name}"
