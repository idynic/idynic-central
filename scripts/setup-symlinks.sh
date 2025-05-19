#!/bin/bash
# Setup symbolic links for all projects to use centralized commands

CENTRAL_REPO="/Users/jro/atriumn/atriumn-central"
PROJECTS=(
    "atriumn"
    "atriumn-ai"
    "atriumn-auth"
    "atriumn-build"
    "atriumn-cli"
    "atriumn-github-actions"
    "atriumn-ingest"
    "atriumn-platform-infra"
    "atriumn-retriever"
    "atriumn-sdk-go"
    "atriumn-site"
    "atriumn-storage"
    "idynic-api"
    "idynic-infra"
    "idynic-tailor-cli"
    "idynic-web"
)

for project in "${PROJECTS[@]}"; do
    project_path="/Users/jro/atriumn/$project"
    if [ -d "$project_path" ]; then
        # Create .claude/commands directory if it doesn't exist
        mkdir -p "$project_path/.claude/commands"
        
        # Remove existing file if it exists
        rm -f "$project_path/.claude/commands/implement-issue-updated.md"
        
        # Create symbolic link
        ln -s "$CENTRAL_REPO/.claude/commands/implement-issue-updated.md" \
            "$project_path/.claude/commands/implement-issue-updated.md"
        
        echo "✅ Created symlink for $project"
    else
        echo "⚠️  Project not found: $project"
    fi
done

echo "🎉 Symlinks setup complete!"