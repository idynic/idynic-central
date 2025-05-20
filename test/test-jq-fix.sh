#!/bin/bash
# Test specifically for the JQ command fix

echo "Testing JQ syntax fixes..."

# Create a sample JSON object
echo '{"idynic-central": 0}' > /tmp/repo_counts.json

# Test our fixed JQ command
REPO_NAME="idynic-web"
REPO_COUNTS=$(cat /tmp/repo_counts.json | jq --arg repo "$REPO_NAME" '. + {($repo): (.[$repo] // 0) + 1}')

echo "Result of JQ command:"
echo "$REPO_COUNTS"

# Now test the original syntax
REPO_COUNTS='{"idynic-central": 1}'
REPO_NAME="idynic-api"
FIXED_REPO_COUNTS=$(echo $REPO_COUNTS | jq --arg repo "$REPO_NAME" '. + {($repo): (.["$repo"] // 0) + 1}')

echo "Result of fixed JQ command:"
echo "$FIXED_REPO_COUNTS"

# Test the GraphQL project number conversion
echo "Testing GraphQL project number fix..."
PROJECT_NUMBER=2
echo "Project number string: '$PROJECT_NUMBER'"
echo "Query would be: -f number=$PROJECT_NUMBER (original, problematic)"
echo "Query is now: -f number=\"$PROJECT_NUMBER\" (fixed)"