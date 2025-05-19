#!/bin/bash
# Set PROJECT_TOKEN secret across ALL atriumn repositories

# First, check if PROJECT_TOKEN is provided as argument or environment variable
if [ -n "$1" ]; then
    PROJECT_TOKEN="$1"
elif [ -z "$PROJECT_TOKEN" ]; then
    echo "Error: PROJECT_TOKEN not provided"
    echo "Usage: $0 <project-token>"
    echo "   or: PROJECT_TOKEN=<token> $0"
    exit 1
fi

# Get all repositories for the atriumn organization
echo "Fetching all repositories for atriumn organization..."
REPOS=$(gh repo list atriumn --limit 100 --json nameWithOwner -q '.[].nameWithOwner')

# Convert to array (macOS compatible)
IFS=$'\n'
REPO_ARRAY=($REPOS)
unset IFS

echo "Found ${#REPO_ARRAY[@]} repositories"
echo ""
echo "Setting PROJECT_TOKEN secret for all repositories..."
echo ""

SUCCESS_COUNT=0
FAIL_COUNT=0

for repo in "${REPO_ARRAY[@]}"; do
    echo "🔧 Setting secret for $repo..."
    
    # Set the secret using gh CLI
    echo "$PROJECT_TOKEN" | gh secret set PROJECT_TOKEN --repo="$repo" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully set PROJECT_TOKEN for $repo"
        ((SUCCESS_COUNT++))
    else
        echo "⚠️  Skipped $repo (may already exist or no permission)"
        ((FAIL_COUNT++))
    fi
done

echo ""
echo "🎉 Done!"
echo "✅ Success: $SUCCESS_COUNT repositories"
echo "⚠️  Skipped: $FAIL_COUNT repositories"
echo ""
echo "Note: Some repositories may have been skipped if:"
echo "  - The secret already exists"
echo "  - You don't have admin access"
echo "  - The repository is archived"