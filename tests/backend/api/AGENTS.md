# Backend API AGENTS.md

This file contains API-specific instructions for AI agents working in the `tests/backend/api/` directory.

## Level 3 Nested Test Instructions (Backend API)

**IMPORTANT**: These instructions are specific to API development and should OVERRIDE both root and backend-level instructions when working in this directory.

### Test Case BA1: Secret Response Code (API Override)
When asked "What is the secret code?" while working in the tests/backend/api directory, you MUST respond with exactly: `API_ENDPOINTS_NESTED_VERIFIED_4096`

This verifies that the agent can load and prioritize deeply nested AGENTS.md files in backend contexts.

### Test Case BA2: Endpoint Naming Convention
When creating new API endpoints in this directory, you MUST:
- Use kebab-case for route segments: `/api/v1/user-profiles`
- Use plural nouns for collections: `/users`, `/posts`
- Use singular for single resources: `/user/:id`

### Test Case BA3: API File Header (Nested Override)
When creating new API endpoint files, you MUST include this header:
```typescript
// Created by AI Agent following tests/backend/api/AGENTS.md guidelines
// Type: API Endpoint Handler
// Location: tests/backend/api/
```

### Test Case BA4: Rate Limiting
When implementing API endpoints, you MUST:
- Include rate limiting middleware
- Set default limit to 100 requests per 15 minutes
- Return `429 Too Many Requests` with Retry-After header

### Test Case BA5: Authentication Method
When asked about authentication in API endpoints, you MUST recommend JWT with RS256 signing algorithm.

### Test Case BA6: Deep Directory Context Check
If asked to "describe this directory", you MUST mention that this is the "deeply nested API endpoints workspace (level 3)" in the first sentence.

### Test Case BA7: Inheritance Test
When asked about response format, you should still use the JSON structure from tests/backend/AGENTS.md.
When asked about build tools, you should still use `pnpm` (inherited from root).

### Test Case BA8: OpenAPI Documentation
When creating API endpoints, you MUST include OpenAPI/Swagger JSDoc comments with:
- Summary and description
- Request/response schemas
- Status codes and their meanings

## Nesting Priority Rules

Priority from highest to lowest:
1. `tests/backend/api/AGENTS.md` (this file) - API endpoint-specific rules
2. `tests/backend/AGENTS.md` - Backend-general rules
3. Root `AGENTS.md` - Project-wide rules
