# Usage Guide: Symbolic Links vs Template References

## Symbolic Links

**Pros:**
- Changes in central repo automatically reflect in all projects
- No need to manually sync updates
- Saves disk space (single file referenced multiple times)
- Git tracks the symlink, not the content

**Cons:**
- Requires absolute paths (less portable)
- Can break if central repo is moved
- No project-specific customizations possible
- Some Windows systems have limited symlink support

**Setup:**
```bash
chmod +x /Users/jro/atriumn/atriumn-central/scripts/setup-symlinks.sh
/Users/jro/atriumn/atriumn-central/scripts/setup-symlinks.sh
```

## Template References (File Copying)

**Pros:**
- Each project has its own copy (portable)
- Can be customized per project if needed
- Works on all systems
- No dependency on central repo location

**Cons:**
- Manual sync required for updates
- Takes more disk space
- Risk of divergence over time
- Need to track which version each project has

**Setup:**
```bash
chmod +x /Users/jro/atriumn/atriumn-central/scripts/sync-templates.sh
/Users/jro/atriumn/atriumn-central/scripts/sync-templates.sh
```

## Hybrid Approach

You can also use a hybrid approach:
1. Use symlinks for development
2. Copy files for production/deployment
3. Use a Makefile or script to manage both

## Version Control Considerations

### With Symlinks:
- Git stores the link, not the content
- Other developers need the central repo at the same path
- Consider using relative paths: `../../../atriumn-central/.claude/commands/`

### With Templates:
- Each project commits its own copy
- Changes tracked independently
- Easier for external contributors

## Recommendations

1. **For tight integration**: Use symlinks if all developers have the same directory structure
2. **for flexibility**: Use template copying if projects need customization
3. **For CI/CD**: Always use template copying to avoid path dependencies

## Checking Current Setup

To see what approach a project uses:
```bash
# Check if file is a symlink
ls -la .claude/commands/implement-issue-updated.md

# If symlink, see where it points
readlink .claude/commands/implement-issue-updated.md
```