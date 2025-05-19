#!/bin/bash
# Sync template files from central repo to all projects

CENTRAL_REPO="/Users/jro/atriumn/atriumn-central"
TEMPLATE_FILE=".claude/commands/implement-issue-updated.md"
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
        # Create directory structure
        mkdir -p "$project_path/.claude/commands"
        
        # Copy template file
        cp "$CENTRAL_REPO/$TEMPLATE_FILE" "$project_path/$TEMPLATE_FILE"
        
        # Optional: Add project-specific header
        echo "# Project: $project" > "$project_path/$TEMPLATE_FILE.tmp"
        echo "# Synced from: $CENTRAL_REPO on $(date)" >> "$project_path/$TEMPLATE_FILE.tmp"
        echo "" >> "$project_path/$TEMPLATE_FILE.tmp"
        cat "$project_path/$TEMPLATE_FILE" >> "$project_path/$TEMPLATE_FILE.tmp"
        mv "$project_path/$TEMPLATE_FILE.tmp" "$project_path/$TEMPLATE_FILE"
        
        echo "✅ Synced template to $project"
    else
        echo "⚠️  Project not found: $project"
    fi
done

echo "🎉 Template sync complete!"