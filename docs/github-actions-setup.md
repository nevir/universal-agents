# Claude GitHub Action Setup Guide

This guide walks through setting up the Claude GitHub Action for this repository.

## Prerequisites

- Repository admin access
- An Anthropic API key (get one at [console.anthropic.com](https://console.anthropic.com))
- GitHub CLI (optional, for easier setup)

## Setup Methods

### Option 1: Quick Setup (Recommended)

The easiest way to set up is through Claude Code in the terminal:

1. Open Claude Code CLI:
   ```bash
   claude
   ```

2. Run the installer:
   ```
   /install-github-app
   ```

3. Follow the prompts to:
   - Install the GitHub app
   - Add the API key as a repository secret
   - Create the workflow file

This method automatically handles authentication and permissions.

### Option 2: Manual Setup

If the quick setup doesn't work or you prefer manual configuration:

#### Step 1: Add API Key to Repository Secrets

1. Go to your repository on GitHub
2. Navigate to: **Settings → Secrets and variables → Actions**
3. Click **"New repository secret"**
4. Name: `ANTHROPIC_API_KEY`
5. Value: Your Anthropic API key (starts with `sk-ant-api03-`)
6. Click **"Add secret"**

⚠️ **Never commit API keys to the repository!** Always use GitHub Secrets.

#### Step 2: Install the Claude GitHub App

1. Visit: [https://github.com/apps/claude](https://github.com/apps/claude)
2. Click **"Install"** or **"Configure"**
3. Select this repository (or your organization)
4. Grant the required permissions:
   - **Contents**: Read & Write (to modify files and create branches)
   - **Issues**: Read & Write (to respond to issues)
   - **Pull requests**: Read & Write (to create PRs)

#### Step 3: Copy the Workflow File

The workflow file is already created at `.github/workflows/claude.yml`.

If you need to customize it, see the [Configuration](#configuration) section below.

#### Step 4: Configure Repository Settings

1. Go to: **Settings → Actions → General**
2. Under "Fork pull request workflows from outside collaborators":
   - ✅ Enable: **"Require approval for first-time contributors"** (recommended)
   - ✅ Enable: **"Require approval for all outside collaborators"** (extra security)
3. Under "Workflow permissions":
   - Select: **"Read and write permissions"** (required for Claude to push commits)
   - ✅ Enable: **"Allow GitHub Actions to create and approve pull requests"**

## Configuration

### Basic Configuration

The workflow is configured in `.github/workflows/claude.yml`:

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

### Advanced Configuration

#### Change the Model

To use a different Claude model (e.g., Opus for more complex tasks):

```yaml
claude_args: |
  --model claude-opus-4-5-20251101
```

Available models:
- `claude-sonnet-4-5-20250929` (default, balanced performance)
- `claude-opus-4-5-20251101` (most capable, higher cost)
- `claude-haiku-4-5-20250929` (fastest, lower cost)

#### Limit Conversation Turns

To prevent runaway costs, limit the number of turns Claude can take:

```yaml
claude_args: |
  --max-turns 10
```

#### Add Custom Instructions

Provide project-specific guidance to Claude:

```yaml
claude_args: |
  --system-prompt "Follow the shell script style guide in AGENTS.md. Add tests for all new features. Use tabs for indentation in shell scripts."
```

#### Restrict Allowed Tools

Limit what commands Claude can run for security:

```yaml
claude_args: |
  --allowedTools "Bash(npm install),Bash(npm run build),Bash(npm run test:*),Bash(npm run lint:*)"
```

#### Change the Trigger Phrase

Use a different trigger phrase instead of `@claude`:

```yaml
with:
  trigger_phrase: "/claude"
```

### Cost Control Configuration

To prevent unexpected API charges:

```yaml
jobs:
  claude:
    timeout-minutes: 30  # Kill workflow after 30 minutes
    concurrency:
      group: claude-${{ github.ref }}
      cancel-in-progress: true  # Cancel duplicate runs

- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    claude_args: |
      --max-turns 10  # Limit conversation length
```

## Usage

Once set up, you can use Claude by mentioning `@claude` in:

### Issues

```
@claude implement user authentication using JWT tokens
```

### Pull Request Comments

```
@claude review this PR for security issues and suggest improvements
```

### Pull Request Review Comments

```
@claude explain why this function is slow and suggest optimizations
```

## Verification

Test the setup with these steps:

### 1. Test Basic Functionality

1. Create a new issue in your repository
2. Add a comment: `@claude Hello! Can you see this?`
3. Wait a few seconds - Claude should respond with a comment

### 2. Verify Security Protections

To verify non-contributors cannot abuse the action:

1. Ask someone **without write access** to comment `@claude` on an issue
2. The workflow should not trigger, or Claude should refuse to run
3. Check: Actions → All workflows → Claude Code
4. Verify the workflow either didn't run or showed an access denied message

### 3. Check API Usage

1. Visit [console.anthropic.com](https://console.anthropic.com)
2. Go to **Usage** or **Billing**
3. Verify you see API calls from the test

## Troubleshooting

### Claude Doesn't Respond

**Problem**: You mention `@claude` but nothing happens.

**Solutions**:
1. Check workflow runs: **Actions → All workflows → Claude Code**
2. Look for error messages in the workflow logs
3. Verify `ANTHROPIC_API_KEY` secret is set: **Settings → Secrets**
4. Ensure the GitHub app is installed: **Settings → Integrations → Applications**
5. Confirm you have write access to the repository

### "Permission denied" Error

**Problem**: Workflow fails with permission errors.

**Solutions**:
1. Check workflow permissions: **Settings → Actions → General → Workflow permissions**
2. Enable "Read and write permissions"
3. Enable "Allow GitHub Actions to create and approve pull requests"

### API Key Invalid

**Problem**: Workflow fails with "Invalid API key" or authentication errors.

**Solutions**:
1. Verify the API key in [console.anthropic.com](https://console.anthropic.com)
2. Regenerate the API key if necessary
3. Update the `ANTHROPIC_API_KEY` secret in GitHub
4. Ensure there are no extra spaces or characters in the secret

### High API Costs

**Problem**: Unexpected API charges.

**Solutions**:
1. Add `--max-turns` limit in `claude_args`
2. Set workflow `timeout-minutes`
3. Add concurrency limits to cancel duplicate runs
4. Review who has write access (can trigger Claude)
5. Set up billing alerts in Anthropic Console

### Workflow Runs on Every Comment

**Problem**: The workflow triggers even without `@claude` mention.

**Solution**:
Check the workflow `if` condition includes the mention check:
```yaml
if: |
  contains(github.event.comment.body, '@claude')
```

## Security Checklist

Before using in production, verify:

- ✅ `ANTHROPIC_API_KEY` is stored in GitHub Secrets (not hardcoded)
- ✅ "Require approval for first-time contributors" is enabled
- ✅ Workflow uses comment events (not `pull_request` event)
- ✅ Branch protection rules are configured for main branch
- ✅ You've tested that non-contributors cannot trigger the workflow
- ✅ Workflow has reasonable `timeout-minutes` set
- ✅ You've set up billing alerts in Anthropic Console

See [docs/github-actions-security.md](./github-actions-security.md) for detailed security analysis.

## Examples

### Feature Implementation

Create an issue:
```
Title: Add user authentication

Body:
@claude Please implement JWT-based authentication with the following requirements:
- Login endpoint that returns a JWT token
- Middleware to verify tokens
- Protect existing endpoints with authentication
- Add tests for the authentication flow
```

### Code Review

Comment on a PR:
```
@claude Review this PR focusing on:
1. Security vulnerabilities (SQL injection, XSS, etc.)
2. Performance issues
3. Code style consistency with our AGENTS.md guidelines
4. Test coverage
```

### Bug Fixes

Create an issue:
```
Title: TypeError in user dashboard

Body:
When loading the user dashboard, I get this error:
```
TypeError: Cannot read property 'map' of undefined at UserDashboard.js:42
```

@claude can you investigate and fix this?
```

### Documentation

Comment on an issue:
```
@claude Add documentation to README.md explaining how to set up the development environment and run tests
```

## Alternative: Using AWS Bedrock or Google Vertex AI

If you need to use Claude through AWS Bedrock or Google Vertex AI instead of the direct API:

See the [official documentation](https://code.claude.com/docs/en/github-actions#using-with-aws-bedrock-%26-google-vertex-ai) for setup instructions with:
- AWS Bedrock with OIDC authentication
- Google Vertex AI with Workload Identity Federation

This is recommended for enterprise environments that need:
- Control over data residency
- Integration with existing cloud billing
- Additional compliance requirements

## Support

- **Documentation**: [code.claude.com/docs/en/github-actions](https://code.claude.com/docs/en/github-actions)
- **Issues**: [github.com/anthropics/claude-code-action/issues](https://github.com/anthropics/claude-code-action/issues)
- **Security**: [docs/github-actions-security.md](./github-actions-security.md)
