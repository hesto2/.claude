#!/bin/bash

task_name="$1"
shift  # Remove first argument
prompt="${*:-Working on: $task_name}"  # Capture all remaining arguments
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

# Create workspace with auto-running task
cat > "$worktree_path/${task_name}.code-workspace" << EOF
{
    "folders": [{"path": "."}],
    "settings": {
        "terminal.integrated.defaultProfile.osx": "zsh"
    },
    "tasks": {
        "version": "2.0.0",
        "tasks": [
        ]
    }
}
EOF

# Open workspace
cursor "$worktree_path/${task_name}.code-workspace"
cd "$worktree_path"

echo "✅ Opened Cursor with Claude Code auto-starting for task: $task_name"