#!/bin/bash
# Create a GitHub Actions repository for an organization

ORG=$1
if [ -z "$ORG" ]; then
    echo "Usage: $0 <organization>"
    echo "Example: $0 idynic"
    exit 1
fi

echo "Creating ${ORG}-github-actions repository..."

# Create the repository
gh repo create "${ORG}/${ORG}-github-actions" \
    --private \
    --description "Reusable GitHub Actions for ${ORG} repositories" \
    --clone

if [ $? -ne 0 ]; then
    echo "Failed to create repository"
    exit 1
fi

cd "${ORG}-github-actions"

# Copy actions from atriumn-github-actions
echo "Copying actions from atriumn-github-actions..."
cp -r /Users/jro/atriumn/atriumn-github-actions/create-issue-branch .
cp -r /Users/jro/atriumn/atriumn-github-actions/handle-issue-commands .
cp -r /Users/jro/atriumn/atriumn-github-actions/update-issue-status .
cp -r /Users/jro/atriumn/atriumn-github-actions/README.md .
cp -r /Users/jro/atriumn/atriumn-github-actions/LICENSE .

# Update organization references
echo "Updating organization references..."
find . -type f -name "*.yml" -exec sed -i '' "s/atriumn/${ORG}/g" {} \;
find . -type f -name "*.yaml" -exec sed -i '' "s/atriumn/${ORG}/g" {} \;
find . -type f -name "*.md" -exec sed -i '' "s/atriumn/${ORG}/g" {} \;

# Commit and push
git add .
git commit -m "Initial commit: Copy actions from atriumn-github-actions"
git push

echo "✅ Created ${ORG}-github-actions repository"
echo ""
echo "Next steps:"
echo "1. Update workflows in ${ORG} repositories to use ${ORG}/${ORG}-github-actions"
echo "2. Ensure PROJECT_TOKEN secret has access to the new repository"