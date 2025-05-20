# Documentation Standards

This document outlines the standards for documentation across all Idynic repositories. Following these standards ensures consistency, clarity, and usefulness of documentation.

## Documentation Structure

### Repository Documentation

Each repository must include the following documentation:

1. **README.md** - Primary documentation for the repository
2. **CONTRIBUTING.md** - Guidelines for contributing to the repository
3. **CLAUDE.md** - Instructions for Claude Code when working with the repository

### Documentation Locations

Documentation should be organized as follows:

1. **Repository Root** - General documentation about the repository
   - README.md
   - CONTRIBUTING.md
   - CLAUDE.md

2. **`/docs` Directory** - Detailed documentation
   - Architecture documentation
   - API documentation
   - User guides
   - Process documentation

3. **`/.claude/commands/` Directory** - Claude-specific command templates
   - Task-specific command templates
   - Prompt templates

## Documentation Format

### Markdown Standards

1. **Headers**
   - Use ATX-style headers with a space after the hash signs (`#`)
   - Use title case for headers
   - Structure headers logically (H1 > H2 > H3)

2. **Lists**
   - Use `-` for unordered lists
   - Use `1.` for ordered lists
   - Maintain consistent indentation (2 spaces)

3. **Code Blocks**
   - Use triple backticks with language identifier
   - Example: ```javascript

4. **Links**
   - Use descriptive link text
   - Format: `[Link text](URL)`
   - For repository internal links, use relative paths

### README Structure

Every README.md should include:

1. **Project Name and Description**
2. **Installation Instructions**
3. **Usage Examples**
4. **Architecture Overview**
5. **Contributing Guidelines** (or link to CONTRIBUTING.md)
6. **License Information**

## Documentation Maintenance

### Update Process

1. **Change Tracking**
   - Document significant changes in a CHANGELOG.md
   - Follow semantic versioning for documentation versions

2. **Review Process**
   - All documentation changes should be reviewed by at least one team member
   - Check for technical accuracy, clarity, and adherence to these standards

3. **Synchronization**
   - When making changes, ensure consistency across related documents
   - Update related repositories when central concepts change

## Cross-Repository References

1. **Central Documentation Repository**
   - The `idynic-central` repository serves as the source of truth for shared documentation
   - Other repositories should reference this when appropriate

2. **Reference Format**
   - When referencing other repositories: `[Repository Name](https://github.com/idynic/repository-name)`
   - When referencing documentation in other repositories: `[Document Title](https://github.com/idynic/repository-name/docs/DOCUMENT.md)`

## Implementation Guidelines

1. Start by implementing these standards in the `idynic-central` repository
2. Create templates for common documentation types
3. Gradually update existing repositories to follow these standards
4. Include documentation requirements in code review process

## Documentation Types

### Architecture Documentation

Architecture documentation should include:

1. **System Overview**
2. **Component Diagram**
3. **Data Flow Diagram**
4. **Technology Stack**
5. **Integration Points**

### API Documentation

API documentation should include:

1. **Endpoint Descriptions**
2. **Request/Response Formats**
3. **Authentication Requirements**
4. **Error Handling**
5. **Example Requests and Responses**

## Continuous Improvement

These standards should evolve over time. Suggestions for improvements should be submitted as issues to the `idynic-central` repository.