# Universal AGENTS.md Polyfill

Universal AGENTS.md support for all AI coding agents.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/agentsmd/universal-agents/main/install.sh | sh
```

Or install for specific agents:

```bash
./install.sh claude
./install.sh gemini
```

## What is AGENTS.md?

AGENTS.md is an open standard for providing AI coding agents with project-specific context and instructions. It's used by 60,000+ open source projects, but not all AI agents support it natively.

This tool adds AGENTS.md support to any agent through intelligent polyfills.

## Features

✨ **One-Command Setup** - Install and configure in seconds
🔧 **Smart Polyfills** - Implements AGENTS.md support via SessionStart hooks
📂 **Hierarchical Support** - Proper inheritance from nested AGENTS.md files
🎯 **Agent-Specific** - Install only what you need
🔄 **Idempotent** - Safe to re-run, updates only what's needed

## Supported Agents

| Agent | Support Method |
|-------|----------------|
| **Claude Code** | SessionStart hook with inheritance logic |
| **Gemini CLI** | Native `context.fileName` configuration |

More agents coming soon.

## How It Works

The installer configures each agent to recognize AGENTS.md files:

1. **Detects existing configuration** - Won't overwrite your settings
2. **Creates polyfill hooks** - Adds missing AGENTS.md behavior where needed
3. **Enables hierarchical loading** - Scoped instructions work correctly
4. **Shows you exactly what changed** - Interactive diff before applying

### For Claude Code

Installs a SessionStart hook at `.agents/polyfills/claude_agentsmd.sh` that:
- Discovers all AGENTS.md files in your project
- Loads the root AGENTS.md automatically (applies to everything)
- Instructs Claude to load nested AGENTS.md files as you work
- Enforces correct precedence (closer = higher priority)

### For Gemini

Updates `.gemini/settings.json` to include AGENTS.md in the context file list.

## Usage

After installation, just create an `AGENTS.md` file in your project root:

```bash
# AGENTS.md

This project uses TypeScript with strict mode enabled.
Always run `npm test` before committing.
```

Your AI agent will now automatically load and follow these instructions.

### Nested AGENTS.md

Create scoped instructions for specific directories:

```
project/
├── AGENTS.md                  # Applies to entire project
├── src/
│   └── api/
│       └── AGENTS.md          # Applies only to API code
```

More specific instructions override general ones.

## CLI Reference

```bash
./install.sh [OPTIONS] [PATH] [AGENTS...]

Options:
  -h, --help       Show help
  -y, --yes        Auto-confirm changes
  -n, --dry-run    Show planned changes without applying

Examples:
  ./install.sh                    # All agents, current directory
  ./install.sh claude             # Claude only
  ./install.sh /path/to/project   # All agents, specific path
  ./install.sh -n                 # Preview changes
```

## Testing

Verify AGENTS.md support is working:

```bash
./tests/test.sh              # Run all tests on all agents
./tests/test.sh claude       # Test Claude only
./tests/test.sh basic-load   # Run specific test
```

## Resources

- **AGENTS.md Spec**: https://agents.md
- **GitHub**: https://github.com/agentsmd/agents.md
- **Issues**: https://github.com/anthropics/claude-code/issues/6235

## License

MIT
