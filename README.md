# Atriumn Central

This repository contains centralized configurations, workflows, and automations used across all Atriumn projects.

## Purpose
- Maintain single source of truth for common configurations
- Reduce duplication across repositories
- Ensure consistency in development workflows

## Structure

### `.claude/commands/`
Contains Claude AI command templates for common development tasks:
- `implement-issue-updated.md` - Standard workflow for implementing GitHub issues

### CICD
(Coming soon) Centralized CI/CD configurations and workflows

## Usage

Other repositories can reference these resources by:
1. Cloning this repository locally
2. Referencing files directly in their own `.claude/commands/` directories
3. Using symbolic links or copying files as needed

## Updates

When updating any shared resource:
1. Make changes in this central repository first
2. Test in a pilot project
3. Propagate to other projects as needed