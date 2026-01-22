# Claude GitHub Action - Security Analysis

This document explains how the Claude GitHub Action is secured against abuse in this public repository.

## Security Concerns in Public Repositories

When using GitHub Actions with API keys in public repositories, there are three main attack vectors:

1. **API Key Exfiltration**: A malicious contributor could modify the workflow to steal the API key
2. **Unauthorized API Usage**: A non-contributor could trigger expensive API calls against your key
3. **Code Injection**: A malicious user could inject commands through PR content

## How This Repository is Protected

### 1. Built-in Access Control (Primary Defense)

**The claude-code-action has built-in protection that only allows users with write access to trigger it.**

From the [official security documentation](https://github.com/anthropics/claude-code-action/blob/main/docs/security.md):

> "Only users with write access can trigger the action by default"

This means:
- ✅ Repository collaborators with write permissions can use `@claude`
- ✅ Organization members can use `@claude` (if configured)
- ❌ Random users who comment on PRs **cannot** trigger the action
- ❌ First-time contributors **cannot** trigger the action

**This protection is automatic and requires no additional configuration.**

### 2. GitHub's Fork PR Protections

GitHub provides multiple layers of protection for workflows triggered by fork PRs:

#### Secrets Not Available to Forks
- Secrets (including `ANTHROPIC_API_KEY`) are **never** passed to workflows triggered by fork PRs
- Even if a malicious actor modifies the workflow in their fork, they cannot access your API key
- Source: [GitHub Actions Security Best Practices](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions)

#### Required Approval for First-Time Contributors
- GitHub requires maintainer approval before running workflows from first-time contributors
- This is configured in: **Settings → Actions → General → "Require approval for first-time contributors"**
- This setting should be enabled (it's GitHub's default for public repos)

### 3. Safe Event Triggers

The workflow uses comment-based events instead of code-change events:

```yaml
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
```

**Why this is safe:**
- These events run in the **base repository context**, not the fork's context
- The workflow code comes from the base branch (protected), not the PR branch
- Malicious actors cannot modify the workflow by creating a PR

**Contrast with unsafe patterns:**
```yaml
# ⚠️ UNSAFE: Don't use this pattern with secrets
on:
  pull_request:  # Runs workflow from the PR branch
```

### 4. Limited Permissions (Principle of Least Privilege)

The workflow only grants necessary permissions:

```yaml
permissions:
  contents: write       # Push commits and create branches
  pull-requests: write  # Create and comment on PRs
  issues: write         # Comment on issues
  id-token: write       # OIDC authentication
  actions: read         # Read CI results
```

These permissions are:
- Scoped to the repository only (cannot access other repos)
- Short-lived tokens that expire after the workflow completes
- Cannot modify repository settings, manage teams, or perform admin actions

### 5. Network Egress Monitoring (Optional)

The workflow includes [StepSecurity Harden-Runner](https://github.com/step-security/harden-runner):

```yaml
- uses: step-security/harden-runner@v2
  with:
    egress-policy: audit
```

This provides:
- Logging of all outbound network connections
- Detection of unusual network activity
- Visibility into potential data exfiltration attempts
- Runtime security insights for each workflow run

### 6. Output Sanitization

The action has `show_full_output: false` by default, which:
- Prevents accidental exposure of sensitive data in public logs
- Sanitizes tool outputs before displaying them
- Removes potential credentials from command outputs

⚠️ **Warning**: Never enable `show_full_output: true` in public repositories, as this exposes full command outputs including potential secrets.

## What Can Contributors vs Non-Contributors Do?

### Contributors (with write access) can:
- ✅ Mention `@claude` in issues and PR comments
- ✅ Trigger the Claude workflow using their API quota
- ✅ Have Claude create branches and prepare PRs
- ⚠️ Still need manual approval to merge PRs (standard GitHub protection)

### Non-contributors (without write access) cannot:
- ❌ Trigger the Claude workflow (blocked by claude-code-action)
- ❌ Access the `ANTHROPIC_API_KEY` secret (GitHub protection)
- ❌ Modify the workflow file in a way that affects the base repo
- ❌ Cause any API charges on your account

## Verification Steps

To verify your repository is properly secured:

1. **Check Repository Settings**:
   - Go to: Settings → Actions → General
   - Verify "Require approval for first-time contributors" is enabled
   - Recommended: Set "Require approval for all outside collaborators"

2. **Verify Secrets are Set**:
   - Go to: Settings → Secrets and variables → Actions
   - Confirm `ANTHROPIC_API_KEY` is listed (value should be hidden)
   - Never commit secrets to the repository

3. **Review Collaborator Access**:
   - Go to: Settings → Collaborators
   - Review who has write access (these users can trigger Claude)
   - Remove any users who shouldn't have this access

4. **Test with a Non-Contributor Account**:
   - Have someone without write access comment `@claude` on an issue
   - The workflow should either not trigger, or Claude should refuse to run
   - Verify no API calls are made

## Additional Security Recommendations

1. **Enable Branch Protection**:
   - Require PR reviews before merging
   - Require status checks to pass
   - Prevent force pushes to main branch

2. **Monitor API Usage**:
   - Regularly check your Anthropic API usage dashboard
   - Set up billing alerts for unexpected charges
   - Review who is triggering the Claude workflow (GitHub Actions logs)

3. **Audit Workflow Runs**:
   - Go to: Actions → All workflows → Claude Code
   - Review who triggered each run
   - Check for suspicious activity

4. **Use CODEOWNERS** (optional):
   - Create `.github/CODEOWNERS` file
   - Require review from specific people for workflow changes
   - Example: `.github/workflows/* @yourname`

5. **Consider Environment Protection** (for extra security):
   ```yaml
   jobs:
     claude:
       environment: production  # Requires manual approval
   ```

## Real-World Examples

Several public repositories successfully use Claude GitHub Actions with these security measures:

- [anthropics/claude-code-action](https://github.com/anthropics/claude-code-action) - The official repository uses these patterns
- [step-security/claude-code-action](https://github.com/step-security/claude-code-action) - Security-hardened fork with additional protections

## Cost Management

Even with security protections, consider setting limits to prevent accidental high costs:

1. **Set Max Turns**:
   ```yaml
   claude_args: "--max-turns 10"
   ```

2. **Use Concurrency Limits**:
   ```yaml
   concurrency:
     group: claude-${{ github.ref }}
     cancel-in-progress: true
   ```

3. **Set Workflow Timeouts**:
   ```yaml
   jobs:
     claude:
       timeout-minutes: 30
   ```

4. **Monitor with Billing Alerts**:
   - Set up alerts in Anthropic Console
   - Set up GitHub Actions spending limits

## References

- [Claude Code Action Security Documentation](https://github.com/anthropics/claude-code-action/blob/main/docs/security.md)
- [GitHub Actions Security Hardening](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions)
- [GitHub Actions Secret Protection](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)
- [StepSecurity: Defend Your GitHub Actions](https://www.stepsecurity.io/blog/defend-your-github-actions-ci-cd-environment-in-public-repositories)
- [Preventing Pull Request Exploits](https://securitylab.github.com/resources/github-actions-new-patterns-and-mitigations/)

## Summary

**Is it safe to use Claude GitHub Actions in a public repository?**

**Yes**, with the proper configuration:

1. ✅ The action only responds to users with write access (built-in)
2. ✅ Secrets are never exposed to fork PRs (GitHub protection)
3. ✅ Comment-based events run workflow from base branch (safe pattern)
4. ✅ Limited permissions prevent lateral movement (least privilege)
5. ✅ Output sanitization prevents data leakage (default behavior)

**The combination of claude-code-action's built-in access control + GitHub's fork PR protections + safe event triggers makes this configuration secure against the three main attack vectors.**
