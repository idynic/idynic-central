#!/bin/bash
# Test script for task generation workflow without Claude

# Make sure script exits on any error
set -e

# Configuration
ISSUE_NUMBER=29
REPO_ORG="idynic"
TEST_MODE=true

echo "Starting task generation test..."

# Create necessary directories
mkdir -p /tmp

# Create a mock Claude output with the task JSON
echo "<task_json>" > /tmp/claude-output.md
cat "$(dirname "$0")/sample-tasks.json" >> /tmp/claude-output.md
echo "</task_json>" >> /tmp/claude-output.md
echo "Generated 2 tasks for testing purposes." >> /tmp/claude-output.md

# Extract the content between <task_json> and </task_json> tags
TASK_JSON=$(sed -n '/<task_json>/,/<\/task_json>/p' /tmp/claude-output.md | sed '1d;$d' || echo "")

if [ -z "$TASK_JSON" ]; then
  echo "No valid task JSON found in test file"
  exit 1
fi

# Save task JSON to a file
echo "$TASK_JSON" > /tmp/tasks.json

# Create a summary file for reporting
echo "## Tasks Generated from PRD #$ISSUE_NUMBER 📋" > /tmp/task-summary.md
echo "" >> /tmp/task-summary.md
echo "The following tasks have been automatically created based on the PRD:" >> /tmp/task-summary.md
echo "" >> /tmp/task-summary.md

# Extract summary from Claude's output (after the JSON)
SUMMARY=$(sed -n "/<\/task_json>/,\$p" /tmp/claude-output.md | sed '1d')

# Process each task and create GitHub issues
TASK_COUNT=0

echo "Processing tasks from JSON..."
# Use a simple loop instead of piping to a subshell which loses variables
for task in $(jq -c '.[]' /tmp/tasks.json); do
  TITLE=$(echo $task | jq -r '.title')
  DESC=$(echo $task | jq -r '.description')
  REPO=$(echo $task | jq -r '.repository')
  PRIORITY=$(echo $task | jq -r '.priority')
  ESTIMATE=$(echo $task | jq -r '.estimate')
  DEPENDENCIES=$(echo $task | jq -r '.dependencies | join(", ")')
  
  echo "Processing task: $TITLE (repo: $REPO)"
  
  # Create the issue body with safe content
  echo "## Task from PRD #$ISSUE_NUMBER" > /tmp/issue-body.md
  echo "" >> /tmp/issue-body.md
  echo "$DESC" >> /tmp/issue-body.md
  echo "" >> /tmp/issue-body.md
  echo "**Priority:** $PRIORITY" >> /tmp/issue-body.md
  echo "**Estimate:** $ESTIMATE" >> /tmp/issue-body.md
  if [ -n "$DEPENDENCIES" ]; then
    echo "**Dependencies:** $DEPENDENCIES" >> /tmp/issue-body.md
  fi
  echo "" >> /tmp/issue-body.md
  echo "---" >> /tmp/issue-body.md
  echo "*This task was automatically generated from [PRD #$ISSUE_NUMBER](https://github.com/$REPO_ORG/idynic-central/issues/$ISSUE_NUMBER)*" >> /tmp/issue-body.md
  
  # Create issue in target repository
  if [[ "$REPO" == *"idynic-"* ]]; then
    REPO_ORG="idynic"
    REPO_NAME="${REPO}"
  else
    REPO_ORG="idynic"
    REPO_NAME="idynic-${REPO}"
  fi
  
  echo "Creating issue in ${REPO_ORG}/${REPO_NAME}"
  
  if [ "$TEST_MODE" = true ]; then
    # In test mode, just simulate issue creation and output the details
    echo "TEST MODE: Would create issue with title '$TITLE' in ${REPO_ORG}/${REPO_NAME}"
    echo "Issue body:"
    cat /tmp/issue-body.md
    
    # Simulate issue URL and issue number
    ISSUE_URL="https://github.com/${REPO_ORG}/${REPO_NAME}/issues/999"
    ISSUE_NUMBER="999"
  else
    # Create the issue (without requiring labels)
    ISSUE_URL=$(gh issue create --repo "${REPO_ORG}/${REPO_NAME}" --title "$TITLE" --body-file /tmp/issue-body.md || echo "")
    
    if [ -z "$ISSUE_URL" ]; then
      echo "Failed to create issue in ${REPO_ORG}/${REPO_NAME}"
      echo "- ⚠️ ~~$TITLE~~ (Failed to create in $REPO_NAME)" >> /tmp/task-summary.md
      continue
    fi
    
    # Try to add label only if issue creation was successful (but don't fail if label doesn't exist)
    gh issue edit "$ISSUE_URL" --add-label "from-prd" 2>/dev/null || echo "Note: Could not add 'from-prd' label (it may not exist)"
    
    ISSUE_NUMBER=$(echo $ISSUE_URL | grep -oP '(?<=issues/)[0-9]+$')
  fi
  
  echo "Issue created: $ISSUE_URL"
  
  if [ "$TEST_MODE" = false ]; then
    # Add to project board (Project #2)
    # Use the GraphQL API to add the issue to the project
    PROJECT_NUMBER=2
    
    # First, we need the project ID
    PROJECT_ID=$(gh api graphql -f query='
      query($org: String!, $number: Int!) {
        organization(login: $org) {
          projectV2(number: $number) {
            id
          }
        }
      }' -f org="${REPO_ORG}" -f number="$PROJECT_NUMBER" -q '.data.organization.projectV2.id' || echo "")
    
    if [ -n "$PROJECT_ID" ]; then
      echo "Adding issue to project board..."
      
      # Get the node ID of the issue
      ISSUE_NODE_ID=$(gh api repos/${REPO_ORG}/${REPO_NAME}/issues/${ISSUE_NUMBER} --jq .node_id)
      
      # Add the issue to the project
      gh api graphql -f query='
        mutation($project:ID!, $item:ID!) {
          addProjectV2ItemById(input: {projectId: $project, contentId: $item}) {
            item {
              id
            }
          }
        }' -f project="$PROJECT_ID" -f item="$ISSUE_NODE_ID" > /dev/null || echo "Failed to add to project"
    else
      echo "Could not find project #$PROJECT_NUMBER for organization $REPO_ORG"
    fi
    
    # Add priority label if available (but don't fail if it doesn't exist)
    if [ -n "$PRIORITY" ]; then
      gh issue edit "$ISSUE_URL" --add-label "priority:$PRIORITY" 2>/dev/null || echo "Note: Could not add priority label (it may not exist)"
    fi
  else
    echo "TEST MODE: Would add issue to project board and add priority label"
  fi
  
  # Add to summary
  echo "- [[$TITLE]]($ISSUE_URL) (in $REPO_NAME, Priority: $PRIORITY, Estimate: $ESTIMATE)" >> /tmp/task-summary.md
  
  # Increment task count
  TASK_COUNT=$((TASK_COUNT + 1))
  
  # We'll track repo counts differently in the test mode
  echo "Updated task count for repository: $REPO_NAME"
done

# Add summary information
echo "" >> /tmp/task-summary.md
echo "## Summary" >> /tmp/task-summary.md
echo "" >> /tmp/task-summary.md
echo "**Total tasks created:** $TASK_COUNT" >> /tmp/task-summary.md
echo "" >> /tmp/task-summary.md

# Add Claude's summary if available
if [ -n "$SUMMARY" ]; then
  echo "## Claude's Task Analysis" >> /tmp/task-summary.md
  echo "" >> /tmp/task-summary.md
  echo "$SUMMARY" >> /tmp/task-summary.md
fi

# Display the final summary
echo "Summary of tasks:"
cat /tmp/task-summary.md
echo "Task generation test completed successfully"