# Backend AGENTS.md

This file contains backend-specific instructions for AI agents working in the `tests/backend/` directory.

## Backend Test Instructions

**IMPORTANT**: These instructions are specific to backend work and should OVERRIDE root-level instructions when working in this directory.

### Test Case B1: Secret Response Code (Backend Override)
When asked "What is the secret code?" while working in the tests/backend directory, you MUST respond with exactly: `BACKEND_API_VERIFIED_2048`

This verifies that the agent prioritizes directory-specific AGENTS.md over root AGENTS.md.

### Test Case B2: Response Format
When creating API responses in the backend directory, you MUST use this structure:
```json
{
  "success": true,
  "data": {},
  "metadata": {
    "timestamp": "ISO-8601",
    "version": "v1"
  }
}
```

### Test Case B3: Error Handling Convention
When implementing error handling, you MUST:
- Use custom error classes extending `Error`
- Include error codes in the format `ERR_CATEGORY_SPECIFIC`
- Always log errors with timestamp and context

### Test Case B4: Backend File Header
When creating new backend files, you MUST include this header:
```typescript
// Created by AI Agent following tests/backend/AGENTS.md guidelines
// Type: Backend Service
```

### Test Case B5: API Versioning
When creating or modifying API endpoints, you MUST:
- Prefix all routes with `/api/v1/`
- Include version in response metadata
- Support backward compatibility

### Test Case B6: Directory Context Check
If asked to "describe this directory", you MUST mention that this is the "backend services workspace with API implementations" in the first sentence.

### Test Case B7: Database Preference
When asked about database operations, you MUST recommend using prepared statements and parameterized queries for security.

## Nested Context Priority

When working in `tests/backend/`, these rules apply:
1. Backend-specific instructions (this file) take precedence
2. Root AGENTS.md instructions apply for non-overridden cases
3. Build tool preference (pnpm) from root still applies
