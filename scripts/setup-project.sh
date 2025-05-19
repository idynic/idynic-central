#!/bin/bash
# Setup a project with Claude commands and GitHub Actions workflows

CENTRAL_REPO="/Users/jro/atriumn/atriumn-central"
PROJECT_PATH=$1

if [ -z "$PROJECT_PATH" ]; then
    echo "Usage: $0 <project-path>"
    echo "Example: $0 /Users/jro/atriumn/idynic-tailor-cli"
    exit 1
fi

if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ Error: Project path does not exist: $PROJECT_PATH"
    exit 1
fi

echo "Setting up project: $PROJECT_PATH"

# Step 1: Setup Claude commands symlink
echo "1️⃣ Setting up Claude commands..."
mkdir -p "$PROJECT_PATH/.claude/commands"
rm -f "$PROJECT_PATH/.claude/commands/implement-issue-updated.md"
ln -s "$CENTRAL_REPO/.claude/commands/implement-issue-updated.md" \
    "$PROJECT_PATH/.claude/commands/implement-issue-updated.md"
echo "✅ Claude commands symlink created"

# Step 2: Setup GitHub Actions workflow
echo "2️⃣ Setting up GitHub Actions workflow..."
mkdir -p "$PROJECT_PATH/.github/workflows"
cp "$CENTRAL_REPO/workflows/issue-comment-commands.yml" \
    "$PROJECT_PATH/.github/workflows/issue-comment-commands.yml"
echo "✅ GitHub Actions workflow copied"

# Step 3: Check if PROJECT_TOKEN secret needs to be added
echo "3️⃣ Checking repository settings..."
echo ""
echo "⚠️  IMPORTANT: Make sure your repository has the following secrets:"
echo "   - PROJECT_TOKEN: A GitHub token with project permissions"
echo ""
echo "To add secrets, go to:"
echo "https://github.com/atriumn/$(basename $PROJECT_PATH)/settings/secrets/actions"
echo ""

# Step 4: Create a setup documentation file
cat > "$PROJECT_PATH/.github/AUTOMATED_SETUP.md" << EOF
# Automated Setup

This project has been configured with automated issue handling workflows.

## Features

- \`/start\` command: Creates a branch and updates issue status to "In Progress"
- \`/done\` command: Updates issue status to "Done"
- \`/review\` command: Updates issue status to "Waiting for Review"
- \`/close\` command: Closes the issue and updates status to "Done"

## Requirements

The following repository secrets must be configured:
- \`PROJECT_TOKEN\`: GitHub token with project permissions
- \`GITHUB_TOKEN\`: (Automatically provided by GitHub)

## Files

- \`.claude/commands/implement-issue-updated.md\`: Claude AI command for implementing issues
- \`.github/workflows/issue-comment-commands.yml\`: Workflow for handling issue commands

Setup completed on: $(date)
EOF

echo "✅ Documentation created"

echo ""
echo "🎉 Project setup complete!"
echo ""
echo "Next steps:"
echo "1. Ensure PROJECT_TOKEN secret is configured in repository settings"
echo "2. Commit and push the new workflow file:"
echo "   cd $PROJECT_PATH"
echo "   git add .github/workflows/issue-comment-commands.yml .github/AUTOMATED_SETUP.md"
echo "   git commit -m 'Add automated issue handling workflows'"
echo "   git push"
echo ""
echo "3. Test by creating an issue and commenting '/start'"