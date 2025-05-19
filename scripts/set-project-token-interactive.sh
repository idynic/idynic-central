#!/bin/bash
# Interactively set PROJECT_TOKEN secret across repositories

# Prompt for token if not provided
if [ -z "$PROJECT_TOKEN" ]; then
    echo "Enter your PROJECT_TOKEN (input will be hidden):"
    read -s PROJECT_TOKEN
    echo ""
fi

if [ -z "$PROJECT_TOKEN" ]; then
    echo "Error: No token provided"
    exit 1
fi

# Ask which repositories to update
echo "Update PROJECT_TOKEN for:"
echo "1) Specific repositories (idynic-tailor-cli, atriumn-site)"
echo "2) All atriumn repositories"
echo -n "Choose (1 or 2): "
read choice

case $choice in
    1)
        REPOS=(
            "atriumn/idynic-tailor-cli"
            "atriumn/atriumn-site"
        )
        ;;
    2)
        echo "Fetching all repositories for atriumn organization..."
        REPOS=$(gh repo list atriumn --limit 100 --json nameWithOwner -q '.[].nameWithOwner')
        # Convert to array (macOS compatible)
        IFS=$'\n'
        REPOS=($REPOS)
        unset IFS
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "Setting PROJECT_TOKEN secret for ${#REPOS[@]} repositories..."
echo ""

SUCCESS_COUNT=0
FAIL_COUNT=0

for repo in "${REPOS[@]}"; do
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

# Clear the token from memory
unset PROJECT_TOKEN