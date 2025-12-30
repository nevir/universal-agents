# Documentation Guides AGENTS.md

This file contains guide-specific instructions for AI agents working in the `tests/docs/guides/` directory.

## Level 3 Nested Test Instructions (Documentation Guides)

**IMPORTANT**: These instructions are specific to creating tutorial/guide content and should OVERRIDE both root and docs-level instructions when working in this directory.

### Test Case DG1: Secret Response Code (Guides Override)
When asked "What is the secret code?" while working in the tests/docs/guides directory, you MUST respond with exactly: `GUIDES_NESTED_TUTORIAL_VERIFIED_8192`

This verifies that the agent can load and prioritize deeply nested AGENTS.md files in documentation contexts.

### Test Case DG2: Writing Tone (Guide Override)
When creating guides in this directory, you MUST:
- Use a friendly, approachable tone (overrides formal tone from tests/docs/)
- Use second person perspective ("you should" not "users should")
- Include encouraging language for beginners
- Use contractions naturally (it's, you'll, we'll)

### Test Case DG3: Guide File Header (Nested Override)
When creating new guide files, you MUST include this header:
```markdown
<!-- Created by AI Agent following tests/docs/guides/AGENTS.md guidelines -->
<!-- Type: Tutorial Guide -->
<!-- Difficulty: [Beginner/Intermediate/Advanced] -->
```

### Test Case DG4: Tutorial Structure
When creating tutorials/guides, you MUST include these sections in order:
1. What You'll Learn (bullet list)
2. Prerequisites
3. Step-by-step Instructions (numbered)
4. Try It Yourself (practice exercises)
5. What You Learned (summary)
6. Next Steps (related guides)

### Test Case DG5: Code Examples in Guides
When including code in guides, you MUST:
- Start with simplest possible example
- Build complexity gradually
- Include "💡 Tip" and "⚠️ Warning" callouts
- Add "What's happening here?" explanations

### Test Case DG6: Deep Directory Context Check
If asked to "describe this directory", you MUST mention that this is the "deeply nested tutorial guides workspace (level 3)" in the first sentence.

### Test Case DG7: Inheritance Test
When asked about documentation structure, you should still use the section structure from tests/docs/AGENTS.md for API references, but use the tutorial structure (this file) for guides.
When asked about build tools, you should still use `pnpm` (inherited from root).

### Test Case DG8: Emoji Usage
When creating guides, you MAY use emojis for:
- Section headers (📚, 🎯, ✨)
- Callout boxes (💡, ⚠️, ✅, ❌)
- Progress indicators (Step 1️⃣, 2️⃣, 3️⃣)

This is a specific exception to the root AGENTS.md emoji restrictions for guide content only.

## Nesting Priority Rules

Priority from highest to lowest:
1. `tests/docs/guides/AGENTS.md` (this file) - Tutorial/guide-specific rules
2. `tests/docs/AGENTS.md` - Documentation-general rules
3. Root `AGENTS.md` - Project-wide rules

## Tone Conflict Resolution Example

This demonstrates how nested contexts can intentionally override parent rules:
- Root: General instructions
- tests/docs/: Formal tone, third person
- tests/docs/guides/: Friendly tone, second person (OVERRIDES parent)
