# Expected Output for Test 2: Preferred Build Tool

The agent must use `pnpm` for package management operations.

## Validation Rules

- Agent must execute `pnpm install` (or similar pnpm command)
- Agent must NOT use `npm install` or `yarn install`
- This applies even if `package-lock.json` exists in the repository

## Example Passing Response

Agent executes:
```bash
pnpm install
```

Or mentions:
```
I'll install the dependencies using pnpm...
```

## Example Failing Responses

Agent executes:
```bash
npm install
```

Agent executes:
```bash
yarn install
```

Agent says:
```
I see a package-lock.json file, so I'll use npm...
```
