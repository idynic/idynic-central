#!/bin/bash
# Setup GitHub Actions workflows for issue management

# Parse arguments
if [ "$1" == "--all" ]; then
    SETUP_ALL=true
else
    SETUP_ALL=false
    REPO_PATH=$1
    
    if [ -z "$REPO_PATH" ]; then
        echo "Usage: $0 /path/to/repo or $0 --all"
        exit 1
    fi
    
    if [ ! -d "$REPO_PATH" ]; then
        echo "❌ Error: Repository path does not exist: $REPO_PATH"
        exit 1
    fi
fi

# Find the central GitHub Actions repository
ACTIONS_REPO="/Users/jro/github/idynic/idynic-github-actions"
if [ ! -d "$ACTIONS_REPO" ]; then
    echo "❌ Error: GitHub Actions repository not found at $ACTIONS_REPO"
    exit 1
fi

setup_repo() {
    local repo_path=$1
    local repo_name=$(basename "$repo_path")
    
    echo "Setting up workflows for $repo_name"

    # Create workflows directory
    mkdir -p "$repo_path/.github/workflows"
    
    # Remove any existing symlinks
    if [ -L "$repo_path/.github/workflows/issue-comment-commands.yml" ]; then
        rm "$repo_path/.github/workflows/issue-comment-commands.yml"
    fi
    
    if [ -L "$repo_path/.github/workflows/pr-issue-status-update.yml" ]; then
        rm "$repo_path/.github/workflows/pr-issue-status-update.yml"
    fi
    
    # Copy workflow files (as regular files, not symlinks)
    cp "$ACTIONS_REPO/issue-comment-commands-template.yml" "$repo_path/.github/workflows/issue-comment-commands.yml"
    cp "$ACTIONS_REPO/pr-issue-status-update-template.yml" "$repo_path/.github/workflows/pr-issue-status-update.yml"
    
    # Add, commit, and push
    (cd "$repo_path" && \
     git add .github/workflows/issue-comment-commands.yml .github/workflows/pr-issue-status-update.yml && \
     git commit -m "Add GitHub Actions workflows for issue management" && \
     git push) || echo "Failed to commit workflows for $repo_name"
    
    echo "✅ Workflows added to $repo_name"
}

if [ "$SETUP_ALL" = true ]; then
    # Setup all repositories
    for repo in /Users/jro/github/idynic/idynic-*; do
        # Skip the GitHub Actions repo itself
        if [ "$repo" != "$ACTIONS_REPO" ] && [ "$repo" != "/Users/jro/github/idynic/idynic-github-actions" ]; then
            setup_repo "$repo"
        fi
    done
else
    # Setup single repository
    setup_repo "$REPO_PATH"
fi

echo "🎉 Done!"