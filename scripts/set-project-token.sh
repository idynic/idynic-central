#!/bin/bash
# Set PROJECT_TOKEN secret across multiple repositories

# First, check if PROJECT_TOKEN is provided as argument or environment variable
if [ -n "$1" ]; then
    PROJECT_TOKEN="$1"
elif [ -z "$PROJECT_TOKEN" ]; then
    echo "Error: PROJECT_TOKEN not provided"
    echo "Usage: $0 <project-token>"
    echo "   or: PROJECT_TOKEN=<token> $0"
    exit 1
fi

# List of repositories to update
REPOS=(
    "atriumn/idynic-tailor-cli"
    "atriumn/atriumn-site"
    # Add more repositories here as needed
)

echo "Setting PROJECT_TOKEN secret for ${#REPOS[@]} repositories..."
echo ""

for repo in "${REPOS[@]}"; do
    echo "🔧 Setting secret for $repo..."
    
    # Set the secret using gh CLI
    echo "$PROJECT_TOKEN" | gh secret set PROJECT_TOKEN --repo="$repo"
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully set PROJECT_TOKEN for $repo"
    else
        echo "❌ Failed to set PROJECT_TOKEN for $repo"
    fi
    echo ""
done

echo "🎉 Done! PROJECT_TOKEN has been set for all repositories."
echo ""
echo "Note: You can verify the secrets were set by visiting:"
for repo in "${REPOS[@]}"; do
    echo "  https://github.com/$repo/settings/secrets/actions"
done