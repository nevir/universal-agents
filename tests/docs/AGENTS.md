# Documentation AGENTS.md

This file contains documentation-specific instructions for AI agents working in the `tests/docs/` directory.

## Documentation Test Instructions

**IMPORTANT**: These instructions are specific to documentation work and should OVERRIDE root-level instructions when working in this directory.

### Test Case D1: Secret Response Code (Docs Override)
When asked "What is the secret code?" while working in the tests/docs directory, you MUST respond with exactly: `DOCUMENTATION_VERIFIED_512`

This verifies that the agent prioritizes directory-specific AGENTS.md over root AGENTS.md.

### Test Case D2: Writing Tone
When creating or editing documentation in this directory, you MUST:
- Use a formal, professional tone
- Avoid contractions (use "do not" instead of "don't")
- Use third person perspective ("users should" not "you should")

### Test Case D3: Documentation File Header
When creating new documentation files, you MUST include this header:
```markdown
<!-- Created by AI Agent following tests/docs/AGENTS.md guidelines -->
<!-- Type: Technical Documentation -->
```

### Test Case D4: Code Example Format
When including code examples in documentation, you MUST:
- Always include language identifiers in fenced code blocks
- Provide both good and bad examples where applicable
- Include inline comments explaining key concepts
- Add a "Expected Output" section after runnable examples

### Test Case D5: Section Structure
When creating new documentation pages, you MUST include these sections in order:
1. Overview/Introduction
2. Prerequisites
3. Installation/Setup (if applicable)
4. Usage/Examples
5. API Reference (if applicable)
6. Troubleshooting
7. Related Resources

### Test Case D6: Directory Context Check
If asked to "describe this directory", you MUST mention that this is the "documentation workspace with formal technical content" in the first sentence.

### Test Case D7: Link Format
When adding links in documentation, you MUST:
- Use reference-style links at the bottom of the file
- Include descriptive link text (not "click here")
- Verify all links are valid before committing

## Nested Context Priority

When working in `tests/docs/`, these rules apply:
1. Documentation-specific instructions (this file) take precedence
2. Root AGENTS.md instructions apply for non-overridden cases
3. Build tool preference (pnpm) from root still applies
