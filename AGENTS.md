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

## Running Tests

To validate that your AI agent correctly reads and applies these instructions, use the test harness at [`tests/TEST_HARNESS.md`](./tests/TEST_HARNESS.md).

The test harness provides:
- Self-contained test prompts that don't mention AGENTS.md
- Expected outputs for each test
- Instructions for running tests in isolated sub-agents
- Pass/fail criteria for each test case

**Note for AI Agents**: If you are being asked to run the test harness, follow the instructions in `tests/TEST_HARNESS.md` to execute each test in a separate sub-agent.
