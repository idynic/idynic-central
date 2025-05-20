# Task Generation Guide

This guide explains how to use the automated task generation feature to break down Product Requirements Documents (PRDs) into actionable GitHub issues.

## Overview

The task generation feature allows you to automatically:

1. Analyze a PRD to identify discrete implementation tasks
2. Create GitHub issues for each task in the appropriate repositories
3. Add tasks to the project board for tracking
4. Generate a comprehensive task summary

This feature works best in conjunction with the repository impact analysis feature, as it can leverage the analysis results to make better task assignment decisions.

## Usage

To generate tasks from a PRD:

1. Create an issue containing your PRD (following the [PRD template](./templates/PRD_TEMPLATE.md))
2. Allow Claude to analyze the PRD first (optional but recommended)
   - Comment `/claude-analyze-prd` or `🤔` on the issue
   - Review the repository impact analysis
3. Trigger task generation by commenting on the issue:
   - Comment `/generate-tasks` or `📋` on the issue

The system will:
1. Process the PRD content using Claude AI
2. Break it down into actionable tasks
3. Create GitHub issues in the appropriate repositories
4. Add tasks to Project Board #2
5. Post a summary comment with links to all created tasks

## Task Structure

Generated tasks include:

- **Title**: Clear, descriptive task name
- **Description**: Detailed explanation of what needs to be done
- **Repository Assignment**: Placed in the most appropriate repository
- **Priority**: high, medium, or low
- **Estimate**: small, medium, or large
- **Dependencies**: Links to related tasks

## Example

**Step 1**: Create a PRD issue following the template

**Step 2**: Request impact analysis
```
/claude-analyze-prd
```

**Step 3**: After reviewing the analysis, generate tasks
```
/generate-tasks
```

**Step 4**: Review the generated tasks in the summary comment

## Best Practices

1. **Use Structured PRDs**: Follow the PRD template to ensure the best results
2. **Run Repository Analysis First**: This helps with accurate repository assignment
3. **Review Tasks Before Implementation**: Always review generated tasks for accuracy
4. **Adjust as Needed**: Edit task titles, descriptions, or priorities after creation
5. **Link Tasks in Project View**: Ensure dependency relationships are reflected

## Troubleshooting

If task generation fails:

1. **Check PRD Structure**: Ensure your PRD clearly defines requirements
2. **Verify Repository Names**: Make sure referenced repositories exist
3. **Check Permissions**: The GitHub Action needs appropriate permissions
4. **Review Action Logs**: Check the GitHub Action logs for detailed error information

## Implementation Details

The task generation system uses:

1. Claude AI to analyze the PRD content
2. GitHub Actions to create issues and add them to projects
3. GraphQL API for project board integration
4. JSON for structured task definitions

See the [claude-implementation.yml](../.github/workflows/claude-implementation.yml) workflow for implementation details.