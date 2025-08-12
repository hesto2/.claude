#!/bin/bash

# Function to display menu and get selection
select_worktree() {
    local worktrees=()
    local display_names=()
    
    # Get all worktrees
    local worktree_list=$(git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2 | grep -E "${repo_name}-[^/]+$")
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            worktrees+=("$line")
            # Extract just the task name from the path
            local task_name=$(basename "$line" | sed "s/^${repo_name}-//")
            display_names+=("$task_name")
        fi
    done <<< "$worktree_list"
    
    if [ ${#worktrees[@]} -eq 0 ]; then
        echo "❌ No worktrees found for repository: $repo_name"
        exit 1
    fi
    
    echo "🌳 Select a worktree to remove:"
    echo ""
    
    # Display menu with arrow key navigation
    local selected=0
    local key=""
    local first_draw=true
    
    # Hide cursor
    tput civis
    
    while true; do
        # Clear previous menu items (except on first draw)
        if [ "$first_draw" != true ]; then
            for ((i=0; i<${#display_names[@]}; i++)); do
                tput cuu1
                tput el
            done
        fi
        first_draw=false
        
        # Display menu
        for ((i=0; i<${#display_names[@]}; i++)); do
            if [ $i -eq $selected ]; then
                echo -e "\033[1;36m❯ ${display_names[$i]}\033[0m"
            else
                echo "  ${display_names[$i]}"
            fi
        done
        
        # Read single character
        IFS= read -rsn1 key
        
        # Handle arrow keys and escape sequences
        if [[ $key == $'\x1b' ]]; then
            # Try to read the rest of the escape sequence
            if IFS= read -rsn2 -t 1 key2; then
                case "$key2" in
                    '[A') # Up arrow
                        ((selected--))
                        if [ $selected -lt 0 ]; then
                            selected=$((${#display_names[@]} - 1))
                        fi
                        ;;
                    '[B') # Down arrow
                        ((selected++))
                        if [ $selected -ge ${#display_names[@]} ]; then
                            selected=0
                        fi
                        ;;
                esac
            else
                # Escape key pressed (no sequence follows)
                tput cnorm
                echo ""
                echo "❌ Cancelled"
                exit 1
            fi
        elif [[ $key == "" ]]; then # Enter key
            break
        elif [[ $key == $'\x03' ]]; then # Ctrl+C
            tput cnorm
            echo ""
            echo "❌ Cancelled"
            exit 1
        fi
    done
    
    # Show cursor again
    tput cnorm
    echo ""
    
    # Return selected worktree path and task name
    selected_path="${worktrees[$selected]}"
    task_name="${display_names[$selected]}"
}

# Get repository name
repo_name=$(basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null)

if [ -z "$repo_name" ]; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check if task name was provided as argument
if [ -n "$1" ] && [[ "$1" =~ [^[:space:]] ]]; then
    task_name="$1"
    worktree_path="$HOME/dev/worktrees/${repo_name}-${task_name}"
    worktree_path=$(eval echo "$worktree_path")
    
    if [ ! -d "$worktree_path" ]; then
        echo "❌ Error: Worktree not found at $worktree_path"
        exit 1
    fi
    selected_path="$worktree_path"
else
    # Interactive selection
    select_worktree
    worktree_path="$selected_path"
fi

echo "🔍 Selected worktree: $worktree_path"
echo ""

# Confirmation prompt
read -p "⚠️  Are you sure you want to remove this worktree? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled"
    exit 1
fi

# Check if there are uncommitted changes
cd "$worktree_path"
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo ""
    echo "⚠️  Warning: Uncommitted changes detected in worktree"
    git status --porcelain
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted"
        exit 1
    fi
fi

# Go back to original repo
cd - > /dev/null

echo ""
echo "🧹 Cleaning up worktree: $task_name"

# Close any Cursor windows for this workspace (macOS)
if command -v osascript &> /dev/null; then
    osascript << EOF 2>/dev/null
tell application "Cursor"
    set windowList to every window
    repeat with w in windowList
        if name of w contains "$task_name" then
            close w
        end if
    end repeat
end tell
EOF
fi

# Remove the worktree
echo "🗑️  Removing worktree..."
git worktree remove "$worktree_path" --force

# Delete the feature branch
echo "🌿 Deleting branch feature/$task_name..."
git branch -D "feature/$task_name" 2>/dev/null || echo "   (branch may have been already deleted)"

# Clean up any leftover workspace files
workspace_file="$worktree_path/${task_name}.code-workspace"
if [ -f "$workspace_file" ]; then
    rm "$workspace_file"
fi

echo "✅ Successfully cleaned up task: $task_name"