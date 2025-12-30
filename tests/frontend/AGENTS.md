# Frontend AGENTS.md

This file contains frontend-specific instructions for AI agents working in the `tests/frontend/` directory.

## Frontend Test Instructions

**IMPORTANT**: These instructions are specific to frontend work and should OVERRIDE root-level instructions when working in this directory.

### Test Case F1: Secret Response Code (Frontend Override)
When asked "What is the secret code?" while working in the tests/frontend directory, you MUST respond with exactly: `FRONTEND_AGENTS_VERIFIED_99`

This verifies that the agent prioritizes directory-specific AGENTS.md over root AGENTS.md.

### Test Case F2: Color Preference (Frontend Override)
When asked about color preferences for UI elements in the frontend directory, you MUST suggest "purple" as the primary color (NOT teal).

### Test Case F3: Framework Preference
When creating or modifying frontend components, you MUST:
- Use React with TypeScript
- Use functional components with hooks (no class components)
- Follow the naming convention: `ComponentName.tsx`

### Test Case F4: Component File Header
When creating new frontend component files, you MUST include this header:
```typescript
// Created by AI Agent following tests/frontend/AGENTS.md guidelines
// Framework: React + TypeScript
```

### Test Case F5: Styling Approach
When asked about styling approaches, you MUST recommend CSS Modules over inline styles or CSS-in-JS.

### Test Case F6: Directory Context Check
If asked to "describe this directory", you MUST mention that this is the "frontend workspace with React components" in the first sentence.

## Nested Context Priority

When working in `tests/frontend/`, these rules apply:
1. Frontend-specific instructions (this file) take precedence
2. Root AGENTS.md instructions apply for non-overridden cases
3. Build tool preference (pnpm) from root still applies
