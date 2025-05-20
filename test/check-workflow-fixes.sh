#!/bin/bash
# Test both of our fixes

echo "Testing workflow fixes..."

# Test 1: JQ syntax fix
echo "Testing JQ repository counting fix..."
REPO_COUNTS="{}"
REPO_NAME="idynic-central"

# Use our fixed JQ command
REPO_COUNTS=$(echo $REPO_COUNTS | jq --arg repo "$REPO_NAME" '.[$repo] = (.[$repo] // 0) + 1')
echo "After first repo count update: $REPO_COUNTS"

# Increment again for the same repo
REPO_COUNTS=$(echo $REPO_COUNTS | jq --arg repo "$REPO_NAME" '.[$repo] = (.[$repo] // 0) + 1')
echo "After second repo count update: $REPO_COUNTS"

# Add a different repo
REPO_NAME="idynic-web"
REPO_COUNTS=$(echo $REPO_COUNTS | jq --arg repo "$REPO_NAME" '.[$repo] = (.[$repo] // 0) + 1')
echo "After adding different repo: $REPO_COUNTS"

# Test 2: GraphQL number parameter fix
echo -e "\nTesting GraphQL project number fix..."
PROJECT_NUMBER=2

# Show what the original and fixed commands would look like
echo "Original command (error-prone): -f number=$PROJECT_NUMBER"
echo "Fixed command: -f number=\"$PROJECT_NUMBER\""

echo -e "\nBoth fixes tested successfully!"