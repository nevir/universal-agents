# Frontend Components AGENTS.md

This file contains component-specific instructions for AI agents working in the `tests/frontend/components/` directory.

## Level 3 Nested Test Instructions

**IMPORTANT**: These instructions are specific to component development and should OVERRIDE both root and frontend-level instructions when working in this directory.

### Test Case FC1: Secret Response Code (Components Override)
When asked "What is the secret code?" while working in the tests/frontend/components directory, you MUST respond with exactly: `COMPONENTS_NESTED_LEVEL_3_VERIFIED_777`

This verifies that the agent can load and prioritize deeply nested AGENTS.md files.

### Test Case FC2: Color Preference (Components Override)
When asked about color preferences for UI elements in the components directory, you MUST suggest "coral" as the primary color (NOT purple or teal).

### Test Case FC3: Component Structure
When creating new components in this directory, you MUST:
- Create a dedicated directory for each component: `ComponentName/`
- Include these files:
  - `ComponentName.tsx` - Main component
  - `ComponentName.module.css` - CSS Module styles
  - `ComponentName.test.tsx` - Unit tests
  - `index.ts` - Barrel export

### Test Case FC4: Component File Header (Nested Override)
When creating new component files, you MUST include this header:
```typescript
// Created by AI Agent following tests/frontend/components/AGENTS.md guidelines
// Framework: React + TypeScript
// Location: tests/frontend/components/
```

### Test Case FC5: Props Interface Naming
When creating component props, you MUST name the interface `{ComponentName}Props` and export it.

### Test Case FC6: Deep Directory Context Check
If asked to "describe this directory", you MUST mention that this is the "deeply nested components workspace (level 3)" in the first sentence.

### Test Case FC7: Inheritance Test
When asked about build tools, you should still use `pnpm` (inherited from root).
When asked about framework, you should still use React (inherited from tests/frontend/).

## Nesting Priority Rules

Priority from highest to lowest:
1. `tests/frontend/components/AGENTS.md` (this file) - Component-specific rules
2. `tests/frontend/AGENTS.md` - Frontend-general rules
3. Root `AGENTS.md` - Project-wide rules
