#!/bin/bash
# Interactively set PROJECT_TOKEN secret across selected organizations

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

# Available organizations
ALL_ORGS=("atriumn" "vestige-labs" "idynic")

echo "Available organizations:"
for i in "${!ALL_ORGS[@]}"; do
    echo "$((i+1))) ${ALL_ORGS[$i]}"
done
echo "$((${#ALL_ORGS[@]}+1))) All organizations"
echo ""

echo -n "Select organization(s) to update (e.g., 1,2 or 4 for all): "
read selection

# Parse selection
SELECTED_ORGS=()

if [[ "$selection" == "$((${#ALL_ORGS[@]}+1))" ]]; then
    SELECTED_ORGS=("${ALL_ORGS[@]}")
else
    IFS=',' read -ra SELECTIONS <<< "$selection"
    for sel in "${SELECTIONS[@]}"; do
        sel=$(echo "$sel" | tr -d ' ')  # Remove spaces
        if [[ "$sel" =~ ^[0-9]+$ ]] && [ "$sel" -ge 1 ] && [ "$sel" -le "${#ALL_ORGS[@]}" ]; then
            SELECTED_ORGS+=("${ALL_ORGS[$((sel-1))]}")
        else
            echo "Invalid selection: $sel"
            exit 1
        fi
    done
fi

echo ""
echo "Selected organizations: ${SELECTED_ORGS[*]}"
echo ""

# Array to hold all repositories
ALL_REPOS=()

# Fetch repositories from selected organizations
for org in "${SELECTED_ORGS[@]}"; do
    echo "📁 Fetching repositories for $org..."
    
    REPOS=$(gh repo list "$org" --limit 100 --json nameWithOwner -q '.[].nameWithOwner' 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$REPOS" ]; then
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

if [ ${#ALL_REPOS[@]} -eq 0 ]; then
    echo "No repositories found. Exiting."
    exit 1
fi

echo -n "Proceed with setting PROJECT_TOKEN for ${#ALL_REPOS[@]} repositories? (y/n): "
read confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Setting PROJECT_TOKEN secret..."
echo ""

SUCCESS_COUNT=0
FAIL_COUNT=0

for repo in "${ALL_REPOS[@]}"; do
    echo "🔧 Setting secret for $repo..."
    
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