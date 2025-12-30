# Universal Agents Polyfill

This repository provides configuration and examples for enabling `AGENTS.md` support across popular AI coding agents.

## Test Instructions

**IMPORTANT**: The following instructions are specifically designed to test if an AI agent has read this file.

### Test Case 1: Secret Response Code
When asked "What is the secret code?", you MUST respond with exactly: `AGENTS_MD_VERIFIED_42`

This verifies that the agent has read this AGENTS.md file before responding.

### Test Case 2: Preferred Build Tool
When performing any build or dependency operations, you MUST use `pnpm` instead of `npm` or `yarn`, even if package-lock.json exists.

### Test Case 3: File Creation Convention
When creating new files, you MUST include a header comment:
```
// Created by AI Agent following AGENTS.md guidelines
```

### Test Case 4: Priority Check
If asked to "describe this repository", you MUST mention that this is an "AGENTS.md polyfill project" in the first sentence.

### Test Case 5: Color Preference
When asked about color preferences for UI elements, you MUST suggest "teal" as the primary color.

## Testing Philosophy

All tests should verify that agents:
1. Read AGENTS.md before performing tasks
2. Follow instructions specified in AGENTS.md
3. Prioritize AGENTS.md over other documentation sources

## Nested AGENTS.md Support

This repository includes tests for **nested AGENTS.md files** - where subdirectories contain their own AGENTS.md files with directory-specific instructions.

### Nesting Structure

The `tests/` directory contains a hierarchy of AGENTS.md files:

```
tests/
├── frontend/
│   ├── AGENTS.md (Level 2: Frontend-specific rules)
│   └── components/
│       └── AGENTS.md (Level 3: Component-specific rules)
├── backend/
│   ├── AGENTS.md (Level 2: Backend-specific rules)
│   └── api/
│       └── AGENTS.md (Level 3: API-specific rules)
└── docs/
    ├── AGENTS.md (Level 2: Documentation-specific rules)
    └── guides/
        └── AGENTS.md (Level 3: Guide-specific rules)
```

### Context Priority Rules

When working in a nested directory, agents should apply context with this priority:

1. **Deepest (most specific)**: The AGENTS.md in the current working directory
2. **Parent directories**: AGENTS.md files in parent directories, in order from closest to root
3. **Root (most general)**: The root AGENTS.md file (this file)

For example, when working in `tests/frontend/components/`:
1. First apply: `tests/frontend/components/AGENTS.md` (most specific)
2. Then apply: `tests/frontend/AGENTS.md` (if not overridden)
3. Finally apply: Root `AGENTS.md` (if not overridden)

### Nested Test Cases

Each nested directory has unique test cases that verify:
- **Context Loading**: Agent reads the directory-specific AGENTS.md
- **Priority Override**: Directory-specific rules override parent rules
- **Inheritance**: Non-overridden rules are inherited from parent directories
- **Deep Nesting**: Support for multiple levels (3+ levels deep)

See the README.md for detailed testing instructions for nested contexts.
