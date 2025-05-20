# Documentation Standards

This document outlines the standards for documentation across all Idynic repositories. Following these standards ensures consistency, clarity, and usefulness of documentation.

## 1. Required Sections

### 1.1 Repository-Level Documentation

Each repository MUST include the following files:

| File | Purpose | Required Sections |
|------|---------|-------------------|
| `README.md` | Primary documentation | Title, Description, Installation, Usage, Architecture Overview, Contributing, License |
| `CONTRIBUTING.md` | Contribution guidelines | Setup, Workflow, PR Process, Code Style, Testing |
| `CLAUDE.md` | Instructions for Claude Code | Project Context, Command Conventions, Workflow Automation |

### 1.2 Feature-Level Documentation

For each new feature, the following documentation is required:

1. **Feature Description** - What the feature does and why
2. **Architecture Impact** - How it fits into the system
3. **API Changes** - Any new or modified endpoints
4. **Configuration** - Required configuration options
5. **Usage Examples** - How to use the feature

### 1.3 API Documentation

All API endpoints must be documented with:

1. **Endpoint Description** - Purpose of the endpoint
2. **Request Format** - Parameters, headers, and body
3. **Response Format** - Status codes, headers, and body
4. **Authentication** - Required authentication
5. **Error Handling** - Possible errors and their codes
6. **Examples** - Request and response examples

### 1.4 Architecture Documentation

Architecture documentation must include:

1. **System Overview** - High-level description
2. **Component Diagram** - Major components and their relationships
3. **Data Flow** - How data moves through the system
4. **Technology Stack** - Technologies used and why
5. **Integration Points** - External systems and interactions
6. **Deployment Architecture** - How the system is deployed

## 2. Style Guide

### 2.1 Markdown Formatting

#### Headers
- Use ATX-style headers with a space after the hash signs (`#`)
- Use title case for headers (e.g., "Document Title")
- Structure headers logically (H1 > H2 > H3)
- Limit to 3 levels of nesting when possible

#### Lists
- Use `-` for unordered lists
- Use `1.` for ordered lists
- Maintain consistent indentation (2 spaces)
- Nest lists with 2-space indentation

#### Code Blocks
- Use triple backticks with language identifier
- Example:
  ```markdown
  ```javascript
  function example() {
    return 'This is code';
  }
  ```
  ```

#### Tables
- Use tables for structured information
- Include header row and separator
- Example:
  ```markdown
  | Header 1 | Header 2 |
  |----------|----------|
  | Value 1  | Value 2  |
  ```

#### Links
- Use descriptive link text
- Format: `[Link text](URL)`
- For repository internal links, use relative paths

#### Emphasis
- Use **bold** for emphasis
- Use *italics* for secondary emphasis
- Use ~~strikethrough~~ sparingly

### 2.2 Diagram Standards

#### Tools
- Use [Mermaid](https://mermaid-js.github.io/) for diagrams in Markdown
- Use [Draw.io](https://draw.io/) for complex diagrams that can't be represented in Mermaid
- Export complex diagrams as SVG and include in documentation

#### Diagram Types
- **Architecture Diagrams**: C4 model preferred
- **Sequence Diagrams**: Mermaid sequence diagrams
- **Database Schema**: Entity-Relationship diagrams
- **State Diagrams**: For complex state machines

#### Diagram Guidelines
- Include a descriptive title
- Label all components clearly
- Use consistent colors and shapes
- Include a legend when necessary
- Keep diagrams focused and concise

### 2.3 Naming Conventions

#### File Names
- Use ALL_CAPS for standard documents (e.g., `README.md`, `CONTRIBUTING.md`)
- Use UPPER_SNAKE_CASE for policy and standards documents (e.g., `CODE_STYLE.md`, `API_STANDARDS.md`)
- Use lower-kebab-case for guides and tutorials (e.g., `getting-started.md`, `advanced-usage.md`)

#### Directory Structure
- Use lowercase for directory names
- Use hyphen-separated words for multi-word directories
- Standard documentation directories:
  - `/docs` - General documentation
  - `/docs/standards` - Standards documents
  - `/docs/templates` - Document templates
  - `/docs/guides` - User guides
  - `/docs/api` - API documentation

## 3. Templates

See the following template files in the `/docs/templates` directory:

- `README_TEMPLATE.md` - Template for repository README
- `ARCHITECTURE_TEMPLATE.md` - Template for architecture documentation
- `API_DOCUMENTATION_TEMPLATE.md` - Template for API documentation
- `INTEGRATION_TEMPLATE.md` - Template for integration documentation

## 4. Maintenance Guidelines

### 4.1 Documentation Review Process

- **Initial Review**: All documentation must be reviewed as part of the PR process
- **Periodic Review**: Documentation must be reviewed at least quarterly
- **Update Triggers**: Documentation must be updated when:
  - New features are added
  - Existing features are modified
  - Architecture changes
  - APIs change

### 4.2 Freshness Requirements

- **README.md**: Must be reviewed monthly
- **API Documentation**: Must be updated with each API change
- **Architecture Documentation**: Must be reviewed quarterly
- **Guides and Tutorials**: Must be reviewed bi-annually

### 4.3 Update Process

1. **Identify Outdated Documentation**
   - Regular audits
   - User feedback
   - Error reports

2. **Update Documentation**
   - Make changes in a separate branch
   - Follow the documentation standards
   - Update all affected documents

3. **Review Updates**
   - Technical review for accuracy
   - Editorial review for clarity
   - Ensure standards compliance

4. **Publish Updates**
   - Merge changes
   - Announce significant updates
   - Update version number if applicable

### 4.4 Version Control

- Document major changes in a `CHANGELOG.md` file
- Use semantic versioning for documentation
- Reference documentation version in footer

## 5. Cross-Repository References

### 5.1 Linking to Other Repositories

- Use absolute GitHub URLs for cross-repository links
- Format: `[Repository Name](https://github.com/idynic/repository-name)`
- Include specific commit or version if necessary

### 5.2 Shared Documentation

- Core concepts should be documented in `idynic-central`
- Other repositories should reference `idynic-central` documentation
- Don't duplicate documentation across repositories

### 5.3 Dependency Documentation

- Document upstream dependencies
- Document downstream consumers
- Clearly indicate version compatibility

## 6. Documentation Checklist for PRs

The following checklist should be included in PR templates:

```markdown
## Documentation Checklist

- [ ] README.md updated (if applicable)
- [ ] API documentation updated (if applicable)
- [ ] Architecture documentation updated (if applicable)
- [ ] New features documented
- [ ] Example code provided (if applicable)
- [ ] Documentation follows Idynic standards
```

## 7. Implementation Plan

1. **Initial Rollout**
   - Implement standards in `idynic-central`
   - Create templates
   - Update PR templates

2. **Training**
   - Train team on documentation standards
   - Provide examples of good documentation
   - Conduct documentation workshops

3. **Gradual Adoption**
   - Apply standards to new repositories
   - Update existing repositories on a rolling basis
   - Prioritize high-visibility repositories

4. **Monitoring and Enforcement**
   - Regular documentation audits
   - Include documentation review in code review
   - Recognize good documentation practices