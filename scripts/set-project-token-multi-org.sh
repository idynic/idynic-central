#!/bin/bash
# Set PROJECT_TOKEN secret across multiple organizations

# First, check if PROJECT_TOKEN is provided as argument or environment variable
if [ -n "$1" ]; then
    PROJECT_TOKEN="$1"
elif [ -z "$PROJECT_TOKEN" ]; then
    echo "Error: PROJECT_TOKEN not provided"
    echo "Usage: $0 <project-token>"
    echo "   or: PROJECT_TOKEN=<token> $0"
    exit 1
fi

# Define organizations to process
ORGS=("atriumn" "vestige-labs" "idynic")

# Array to hold all repositories
ALL_REPOS=()

echo "Fetching repositories from organizations: ${ORGS[*]}"
echo ""

# Fetch repositories from each organization
for org in "${ORGS[@]}"; do
    echo "📁 Fetching repositories for $org..."
    
    # Try to fetch repos, skip if no access
    REPOS=$(gh repo list "$org" --limit 100 --json nameWithOwner -q '.[].nameWithOwner' 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$REPOS" ]; then
        # Convert to array (macOS compatible)
        IFS=$'\n'
        ORG_REPOS=($REPOS)
        unset IFS
        
        echo "  Found ${#ORG_REPOS[@]} repositories in $org"
        ALL_REPOS+=("${ORG_REPOS[@]}")
    else
        echo "  ⚠️  No access to $org or no repositories found"
    fi
done

echo ""
echo "Total repositories found: ${#ALL_REPOS[@]}"
echo ""
echo "Setting PROJECT_TOKEN secret for all repositories..."
echo ""

SUCCESS_COUNT=0
FAIL_COUNT=0

for repo in "${ALL_REPOS[@]}"; do
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
echo "  - You don't have access to the organization"