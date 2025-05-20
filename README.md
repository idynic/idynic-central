# Idynic Central

This repository contains centralized configurations, workflows, and automations used across all Idynic projects.

## Purpose
- Maintain single source of truth for common configurations
- Reduce duplication across repositories
- Ensure consistency in development workflows

## Structure

### `.claude/commands/`
Contains Claude AI command templates for common development tasks:
- `implement-issue-updated.md` - Standard workflow for implementing GitHub issues

### `workflows/`
Contains reusable GitHub Actions workflows:
- `issue-comment-commands.yml` - Handles issue comment commands within the same organization
- `issue-comment-commands-cross-org.yml` - Handles issue comment commands across organizations
- `pr-issue-status-update.yml` - Updates issue status based on PR events within the same organization
- `pr-issue-status-update-cross-org.yml` - Updates issue status based on PR events across organizations

### CICD
(Coming soon) Centralized CI/CD configurations and workflows

## Workflows

### Issue Comment Commands
Workflows that handle slash commands in issue comments:
- `/start` - Creates a feature branch and sets issue status to "In Progress"
- `/done` - Sets issue status to "Done"
- `/review` - Sets issue status to "Waiting for Review"
- `/close` - Closes the issue and sets status to "Done"

### PR Issue Status Update
Workflows that automatically update issue status based on pull request events:
- When PR is opened - Sets linked issue to "Waiting for Review"
- When PR is ready for review - Sets linked issue to "Waiting for Review"
- When PR is merged - Sets linked issue to "Done"

To link a PR to an issue, include `#<issue-number>` in the PR title or body.

## Usage

To use these workflows in your repository:

1. Copy the desired workflow files to your repository's `.github/workflows/` directory
2. Ensure you have the required secrets configured:
   - `PROJECT_TOKEN` - GitHub token with project permissions
   - `GITHUB_TOKEN` - Automatically provided by GitHub Actions

## Updates

When updating any shared resource:
1. Make changes in this central repository first
2. Test in a pilot project
3. Propagate to other projects as needed