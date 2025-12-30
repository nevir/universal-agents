# AGENTS.md Test Harness

This test harness validates that AI agents correctly read and apply instructions from `AGENTS.md` files.

## How to Run These Tests

**IMPORTANT**: Each test MUST be run in a separate sub-agent to ensure clean context. Do not run tests in your current context.

For each test below:
1. Launch a new sub-agent (using Task tool or equivalent)
2. Provide ONLY the prompt from the test's `prompt.md` file
3. Compare the agent's response against the `expected.md` file
4. Mark the test as PASS or FAIL

## Test Suite

### Test 1: Secret Response Code
**Purpose**: Verify agent reads AGENTS.md before responding
**Prompt**: [`test-1-secret-code/prompt.md`](./test-1-secret-code/prompt.md)
**Expected**: [`test-1-secret-code/expected.md`](./test-1-secret-code/expected.md)
**Pass Criteria**: Response must contain exactly `AGENTS_MD_VERIFIED_42`

---

### Test 2: Preferred Build Tool
**Purpose**: Verify agent follows build tool preferences from AGENTS.md
**Prompt**: [`test-2-build-tool/prompt.md`](./test-2-build-tool/prompt.md)
**Expected**: [`test-2-build-tool/expected.md`](./test-2-build-tool/expected.md)
**Pass Criteria**: Agent must use `pnpm` for package operations, not `npm` or `yarn`

---

### Test 3: File Creation Convention
**Purpose**: Verify agent follows file creation conventions from AGENTS.md
**Prompt**: [`test-3-file-creation/prompt.md`](./test-3-file-creation/prompt.md)
**Expected**: [`test-3-file-creation/expected.md`](./test-3-file-creation/expected.md)
**Pass Criteria**: Created file must include header comment: `// Created by AI Agent following AGENTS.md guidelines`

---

### Test 4: Repository Description
**Purpose**: Verify agent prioritizes AGENTS.md context when describing the project
**Prompt**: [`test-4-repository-description/prompt.md`](./test-4-repository-description/prompt.md)
**Expected**: [`test-4-repository-description/expected.md`](./test-4-repository-description/expected.md)
**Pass Criteria**: First sentence must mention "AGENTS.md polyfill project"

---

### Test 5: Color Preference
**Purpose**: Verify agent applies UI preferences from AGENTS.md
**Prompt**: [`test-5-color-preference/prompt.md`](./test-5-color-preference/prompt.md)
**Expected**: [`test-5-color-preference/expected.md`](./test-5-color-preference/expected.md)
**Pass Criteria**: Agent must suggest "teal" as the primary color

---

## Running the Full Suite

To run all tests:

```bash
# Example pseudocode for running all tests
for test in test-*; do
  echo "Running $test..."
  # Launch sub-agent with prompt from $test/prompt.md
  # Compare output with $test/expected.md
  # Record PASS/FAIL
done
```

## Important Notes

- **Never mention AGENTS.md in prompts**: The prompts are intentionally generic to test automatic discovery
- **Clean context per test**: Each test MUST run in a fresh sub-agent
- **Exact matching**: Some tests require exact string matches, others require pattern matches (see Pass Criteria)
