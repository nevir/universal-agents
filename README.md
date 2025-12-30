# Universal AGENTS.md Polyfill

A comprehensive example repository demonstrating how to configure popular AI coding agents to support the `AGENTS.md` standard.

## What is AGENTS.md?

`AGENTS.md` is an open format designed to provide AI coding agents with specific context and instructions they need to work on a project. It's currently used by over 60,000 open-source projects and is supported by tools like:

- **Aider** - AI pair programming in your terminal
- **Gemini CLI** - Google's AI coding assistant
- **Cursor** - AI-first code editor
- **OpenAI Codex** - OpenAI's coding agent
- **GitHub Copilot** - Microsoft's AI pair programmer
- And many more...

## Quick Start

1. **Clone this repository**:
   ```bash
   git clone <repository-url>
   cd universal-agents
   ```

2. **Choose your AI agent** and follow the configuration guide in `CONFIG_GUIDE.md`

3. **Test the configuration** using the test suite in `tests/`

## Repository Structure

```
universal-agents/
├── AGENTS.md                    # Root AGENTS.md with project-wide rules
├── CLAUDE.md                    # Claude Code configuration (imports AGENTS.md)
├── .aider.conf.yml              # Aider configuration
├── .gemini/
│   └── settings.json            # Gemini CLI configuration
├── .claude/
│   ├── settings.json            # Claude Code SessionStart hook config
│   └── hooks/
│       └── append_agentsmd_context.sh
├── CONFIG_GUIDE.md              # Detailed configuration guide
├── tests/                       # Nested AGENTS.md test suite
│   ├── frontend/
│   │   ├── AGENTS.md            # Frontend-specific rules (Level 2)
│   │   └── components/
│   │       └── AGENTS.md        # Component rules (Level 3)
│   ├── backend/
│   │   ├── AGENTS.md            # Backend-specific rules (Level 2)
│   │   └── api/
│   │       └── AGENTS.md        # API endpoint rules (Level 3)
│   └── docs/
│       ├── AGENTS.md            # Documentation rules (Level 2)
│       └── guides/
│           └── AGENTS.md        # Tutorial guide rules (Level 3)
└── README.md                    # This file
```

## Configuration by Agent

| Agent | Status | Config File | Details |
|-------|--------|-------------|---------|
| **Aider** | ✅ Supported | `.aider.conf.yml` | See [CONFIG_GUIDE.md](CONFIG_GUIDE.md#aider-configuration) |
| **Gemini CLI** | ✅ Supported | `.gemini/settings.json` | See [CONFIG_GUIDE.md](CONFIG_GUIDE.md#gemini-cli-configuration) |
| **Cursor/Codex** | ✅ Native | None required | See [CONFIG_GUIDE.md](CONFIG_GUIDE.md#cursorcodex-configuration) |
| **Claude Code** | ⚠️ Workaround | `CLAUDE.md` + hooks | See [CONFIG_GUIDE.md](CONFIG_GUIDE.md#claude-code-configuration) |

## Testing AGENTS.md Support

This repository includes a comprehensive test suite to verify that your AI agent correctly reads and follows `AGENTS.md` instructions.

### Quick Test

Start your AI agent and ask:
```
What is the secret code?
```

**Expected response**: `AGENTS_MD_VERIFIED_42`

If you get this response, your agent is correctly reading `AGENTS.md`!

### Full Test Suite

The repository includes comprehensive tests for both basic and nested AGENTS.md support:

#### Basic Tests (Root Level)
- ✅ File loading verification (Secret code test)
- ✅ Build tool preferences (pnpm requirement)
- ✅ File creation conventions (Header comments)
- ✅ Documentation priority (Repository description)
- ✅ Project-specific preferences (Color preferences)

#### Nested AGENTS.md Tests

This repository includes **nested AGENTS.md files** to test directory-specific context loading:

**Test Directories:**
1. **`tests/frontend/`** - Frontend-specific rules
   - Secret code: `FRONTEND_AGENTS_VERIFIED_99`
   - Color preference: purple (overrides root teal)
   - Framework: React + TypeScript

2. **`tests/frontend/components/`** - Component-specific rules (Level 3)
   - Secret code: `COMPONENTS_NESTED_LEVEL_3_VERIFIED_777`
   - Color preference: coral (overrides frontend purple)
   - Component structure conventions

3. **`tests/backend/`** - Backend-specific rules
   - Secret code: `BACKEND_API_VERIFIED_2048`
   - API response format requirements
   - Error handling conventions

4. **`tests/backend/api/`** - API endpoint rules (Level 3)
   - Secret code: `API_ENDPOINTS_NESTED_VERIFIED_4096`
   - Endpoint naming conventions
   - Rate limiting requirements

5. **`tests/docs/`** - Documentation rules
   - Secret code: `DOCUMENTATION_VERIFIED_512`
   - Formal tone and structure requirements
   - Code example formatting

6. **`tests/docs/guides/`** - Tutorial guide rules (Level 3)
   - Secret code: `GUIDES_NESTED_TUTORIAL_VERIFIED_8192`
   - Friendly tone (overrides formal docs tone)
   - Tutorial-specific structure

#### Testing Nested Context

To test nested AGENTS.md support:

1. **Navigate to a nested directory** (e.g., `cd tests/frontend/components/`)
2. **Ask the agent**: "What is the secret code?"
3. **Expected response**: The directory-specific secret code (e.g., `COMPONENTS_NESTED_LEVEL_3_VERIFIED_777`)

This verifies that the agent:
- ✅ Loads the directory-specific AGENTS.md
- ✅ Prioritizes nested context over parent/root context
- ✅ Correctly handles multiple nesting levels

#### Context Priority Test

To test context inheritance and priority:

1. **Navigate to** `tests/frontend/components/`
2. **Ask**: "What color should I use for UI elements?"
3. **Expected**: "coral" (from components/AGENTS.md, overriding "purple" from frontend/AGENTS.md and "teal" from root)
4. **Ask**: "What build tool should I use?"
5. **Expected**: "pnpm" (inherited from root AGENTS.md)

This verifies proper inheritance: specific rules override general ones, but non-overridden rules are inherited.

## Contributing

This is an example repository demonstrating `AGENTS.md` configuration patterns. Contributions are welcome, especially:

- Additional agent configurations
- Improved test cases
- Better workarounds for agents without native support
- Documentation improvements

## Resources

- **AGENTS.md Specification**: https://agents.md
- **GitHub Repository**: https://github.com/agentsmd/agents.md
- **Claude Code Feature Request**: https://github.com/anthropics/claude-code/issues/6235

## License

MIT
