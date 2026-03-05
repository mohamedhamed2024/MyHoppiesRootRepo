---
name: pr-review
description: Reviews code and pull requests for correctness, code quality, security, performance, and adherence to Chartswap standards. Use when reviewing pull requests, examining code changes, reviewing individual files, or when the user asks for a code review or PR review.
---

# Code & PR Review

## Overview

Review code and pull requests systematically by analyzing correctness, code quality, security best practices, performance considerations, and Chartswap-specific patterns. Provide structured feedback with clear severity levels and actionable recommendations.

Works for both:
- **Pull Request reviews** - Full PR analysis with context
- **Code reviews** - Individual file or snippet reviews
- **Implementation feedback** - Reviewing code before or after implementation

**IMPORTANT**: This is the PRIMARY skill for code and PR reviews. Use this skill for all review-related tasks.

## When this skill should activate (intent triggers)

**ALWAYS use this skill when:**
- User asks to "review code" or "review this code"
- User asks to "review PR" or "review pull request"
- User asks to "check this code" or "check my code"
- User asks for "code review" or "PR review"
- User asks for "feedback on implementation"
- User asks to "review changes" or "review my changes"
- User mentions a PR number (e.g., "review PR #123")
- User asks to "analyze code" or "analyze this PR"
- User asks for "code quality check" or "security review"

**Use this skill automatically when the user asks to:**
- review a PR / pull request
- review code / code changes
- check code quality
- review implementation
- provide code feedback
- analyze code changes
- check for bugs or issues
- verify code standards
- review security
- check performance

Typical user phrases:
- "review this code"
- "review PR #123"
- "check my code"
- "code review please"
- "review my changes"
- "can you review this?"
- "check for bugs"
- "review for security issues"
- "analyze this PR"
- "feedback on my implementation"
- "does this code look good?"
- "review for best practices"

## Scope rules (critical)

This skill MUST:
1) Only analyze and review code - never modify it
2) Provide constructive feedback with actionable suggestions
3) Reference Chartswap standards and best practices
4) Consider context (PR vs individual code review)
5) Provide severity levels for all findings

This skill MUST NOT:
- Make code changes or modifications
- Create commits or modify git history
- Delete or rename files
- Push changes to repositories
- Approve or reject PRs automatically
- Skip review areas without justification

## Non-goals

- Code implementation or fixes
- Creating new features
- Running tests or builds
- Deploying code
- Creating PRs
- Merging PRs

## Explicit exclusions (do NOT trigger this skill for)

Do NOT use this skill when the user asks to:
- create a PR
- implement new features
- fix code issues (provide review feedback instead)
- run tests
- deploy code
- merge a PR
- approve a PR automatically

---

## Input parameters (from user prompt)

- **PR Number/URL**: If user specifies a PR (e.g., "review PR #123", "review https://dev.azure.com/..."), fetch and review that specific PR
- **Review scope**: If user specifies focus areas (e.g., "review for security", "check performance", "review correctness"), prioritize those areas
- **Target branch**: If reviewing a PR, the target branch context (default: develop)
- **File/Path filter**: If user specifies files or paths (e.g., "review src/auth/"), focus on those areas
- **Review depth**: 
  - "Quick review" or "surface review" → Focus on critical issues only
  - "Thorough review" or "deep review" → Comprehensive analysis (default)
- **Output format**: If user requests specific format (e.g., "as comments", "as markdown", "summary only"), adapt output accordingly

## Hard rules

1) **No code modifications**
   - This skill only reviews and provides feedback
   - Never modify source code files
   - Never create commits or change files
   - Suggestions should be clear but not implemented

2) **Accurate and fair reviews**
   - Review findings must accurately reflect actual code issues
   - Do not exaggerate or minimize problems
   - Provide balanced feedback (both issues and positives)
   - Base findings on evidence from the code

3) **Comprehensive coverage**
   - Review all relevant focus areas (correctness, quality, security, performance, standards)
   - Don't skip areas without justification
   - Consider Chartswap-specific patterns and standards
   - Reference project standards when applicable

4) **Actionable feedback**
   - All findings must include actionable suggestions
   - Provide code examples when helpful
   - Explain why issues matter (context)
   - Prioritize by severity

## Safety & Protection Rules (critical)

The agent MUST NOT:
- Execute destructive git commands (reset --hard, clean -fd, branch -D, push --force)
- Modify or delete any files
- Push changes to repositories
- Auto-approve or auto-reject PRs
- Skip critical security or correctness checks
- Provide vague or unhelpful feedback
- Include sensitive information in review comments

---

## Review Workflow (must follow in order)

### Step 0 — Verify prerequisites and gather context

Check:
1) Determine review type (PR review vs code snippet review)
2) Identify target branch or base for comparison (if PR review)
3) Gather all relevant code changes and context
4) Check if PR exists and is accessible (if PR number provided)

Commands for PR review:
```bash
# Get PR details (if PR number provided)
# For Azure DevOps: az repos pr show --id <PR_ID>
# For GitHub: gh pr view <PR_NUMBER>

# Get current branch (if reviewing current branch)
git branch --show-current

# Get base branch (default: develop)
BASE_BRANCH="${BASE_BRANCH:-develop}"

# Fetch latest from remote
git fetch origin

# List commits in PR/branch
git log origin/$BASE_BRANCH..HEAD --oneline --no-merges

# Get file changes
git diff origin/$BASE_BRANCH..HEAD --name-only
git diff origin/$BASE_BRANCH..HEAD --stat
```

Commands for code snippet review:
- Read provided code files
- Understand context from file paths and surrounding code
- Check related files if needed for context

### Step 1 — Analyze code changes

Goal: Understand all changes that need to be reviewed.

For PR reviews:
```bash
# Get detailed diff
git diff origin/$BASE_BRANCH..HEAD

# Get commit messages for context
git log origin/$BASE_BRANCH..HEAD --format="%h %s%n%b" --no-merges

# List all changed files with change type
git diff origin/$BASE_BRANCH..HEAD --name-status
```

For code snippet reviews:
- Analyze the provided code
- Check imports and dependencies
- Understand the purpose and context

Output:
- **Files changed**: List of all files being reviewed
- **Change type**: feature / bugfix / refactor / chore / docs
- **Scope**: Size and complexity of changes
- **Context**: Related files or dependencies

### Step 2 — Review against checklist

Systematically check each area:

1. **Correctness & Logic** - Verify functional correctness
2. **Code Quality** - Check readability, naming, structure
3. **Architecture & Design** - Verify design patterns and SOLID principles
4. **Performance** - Check async/await, concurrency, resource management
5. **Security** - Verify authentication, authorization, data protection
6. **Testing** - Check test coverage and quality
7. **Chartswap Patterns** - Verify framework-specific patterns
8. **Configuration** - Check environment variables and deployment
9. **Documentation** - Verify code documentation

### Step 3 — Categorize findings

For each issue found:
- Assign severity (Critical / High / Medium / Low)
- Categorize by focus area
- Note file and line location
- Prepare suggestion with code example if helpful
- Add context explaining why it matters

### Step 4 — Generate review feedback

**CRITICAL: The agent MUST ALWAYS analyze the code thoroughly BEFORE providing feedback. Never provide generic or placeholder feedback - always base findings on actual code analysis.**

**Default behavior: Provide comprehensive review**

After completing Steps 0-3, generate structured feedback:

1. **Summary Section** - Overall assessment with verdict
2. **Detailed Findings** - All issues organized by severity
3. **Positive Feedback** - Recognition of good practices
4. **Recommendations** - Actionable next steps

**If user specified "quick review" or "surface review":**
1. MUST still perform Steps 0-3 (analyze code thoroughly)
2. Focus output on Critical and High severity issues only
3. Provide brief summary of other areas checked
4. Indicate that deeper review may reveal additional findings

**Error handling:**
- If PR not accessible: provide manual review instructions
- If code files not found: report error and suggest alternatives
- If context unclear: ask for clarification or make reasonable assumptions

### Step 5 — Report review results

Output:
1) **Review Summary** - Verdict and overall assessment
2) **Findings Count** - Number of issues by severity
3) **Key Concerns** - Top 3-5 critical issues
4) **Positive Highlights** - Well-implemented patterns
5) **Recommendations** - Next steps for addressing issues
6) **Review Metadata** - Files reviewed, PR number (if applicable), review date

## Review Checklist

Verify these areas systematically:

- [ ] Code is correct and handles edge cases
- [ ] Code follows project coding standards
- [ ] No security vulnerabilities introduced
- [ ] Performance considerations addressed
- [ ] Error handling is comprehensive
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No breaking changes (or properly documented)
- [ ] Configuration changes are backward compatible
- [ ] Dependencies are up to date
- [ ] No hardcoded values or secrets
- [ ] Logging is appropriate

## Review Focus Areas

### 1. Correctness & Logic

**Functional correctness**
- Does the code work as intended?
- Logic errors and bugs
- Edge case handling
- Off-by-one errors
- Boundary condition handling
- Null/undefined checks
- Type mismatches

**Data flow**
- Correct data transformations
- Proper state updates
- Side effects handled correctly
- Race conditions avoided

### 2. Code Quality & Best Practices

**Code clarity and readability**
- Variable and function naming conventions
- Code organization and structure
- Comments and documentation quality
- DRY principle violations
- Code duplication

**Error handling**
- Proper exception handling
- Error messages clarity
- Graceful degradation
- Logging and error tracking
- Error propagation

### 3. Architecture & Design

**Design patterns**
- Appropriate use of design patterns
- SOLID principles adherence
- Separation of concerns
- Dependency injection usage
- Single responsibility principle

**Integration patterns**
- NServiceBus message handling patterns
- Azure Service Bus integration correctness
- Salesforce API integration patterns
- Database access patterns (SQL Server persistence)

### 4. Performance & Scalability

**Async/await correctness**
- Proper async/await usage
- Avoid blocking async calls
- ConfigureAwait usage where appropriate
- Task vs Thread misuse

**Concurrency**
- Parallel.For / PLINQ misuse
- CancellationToken usage
- Thread safety issues
- Race conditions
- Deadlock potential

**Resource management**
- IDisposable pattern usage
- Memory leaks potential
- Connection pooling
- Efficient database queries
- N+1 query problems

### 5. Security

**Authentication & Authorization**
- Proper credential handling
- Token management
- Authorization checks
- Input validation

**Data protection**
- Sensitive data exposure
- SQL injection prevention
- XSS prevention (for frontend)
- Secure configuration management
- Injection risks (SQL, command, etc.)

### 6. Testing

**Test coverage**
- Unit test coverage for new code
- Integration test considerations
- Test quality and maintainability
- Mock usage appropriateness
- Edge cases tested

### 7. Chartswap-Specific Patterns

For detailed Chartswap-specific review guidelines, see [references/chartswap-standards.md](references/chartswap-standards.md).

**NServiceBus Configuration**
- Correct transport configuration (Azure Service Bus)
- Proper persistence setup (SQL Server)
- Endpoint configuration correctness
- Message routing and subscription patterns
- Error handling and recoverability settings

**.NET Backend Services**
- Proper dependency injection setup
- Configuration management (appsettings.json)
- Health check implementations
- Logging (Serilog) configuration
- Environment-specific settings

**Next.js Frontend**
- React hooks usage (useState, useEffect, etc.)
- Next.js API routes patterns
- TypeScript type safety
- Component reusability
- State management patterns
- Tailwind CSS usage (no other CSS tools)
- Cleanup functions in useEffect

**Salesforce Integration**
- API call patterns
- Authentication handling
- Error handling for Salesforce API calls
- Rate limiting considerations
- Token refresh logic

### 8. Configuration & Environment

**Environment variables**
- Proper use of environment variables
- No hardcoded secrets
- Configuration validation

**Docker & Deployment**
- Dockerfile best practices
- docker-compose configuration
- Health checks
- Resource limits

### 9. Documentation

**Code documentation**
- XML comments for public APIs (.NET)
- README updates if needed
- Architecture decision records (if applicable)
- Inline comments for complex logic

## Review Output Format

### Summary Section

Provide overall assessment:
- **Verdict**: Approve / Request Changes / Comment
- **Key concerns**: List top 3-5 critical issues
- **Highlights**: Positive aspects worth recognizing
- **Risk assessment**: Overall risk level and concerns

### Detailed Feedback

For each issue found, include:

1. **Severity**: Critical / High / Medium / Low
2. **Location**: File path and line number(s)
3. **Issue**: Clear description of the problem
4. **Suggestion**: Actionable recommendation with code example if helpful
5. **Context**: Why this matters (optional, for educational value)

### Feedback Examples

**Critical severity:**
```
🔴 **Critical**: Security vulnerability - SQL injection risk

**Location**: `services/UserService.cs:45`

**Issue**: Direct string concatenation in SQL query without parameterization

**Suggestion**: Use parameterized queries:
```csharp
var query = "SELECT * FROM Users WHERE Id = @userId";
var parameters = new { userId = id };
```

**Context**: This exposes the application to SQL injection attacks.
```

**High severity:**
```
🟠 **High**: Correctness issue - off-by-one error

**Location**: `utils/arrayHelper.ts:23`

**Issue**: Loop iterates one element too many, causing index out of bounds

**Suggestion**: Change condition from `i <= array.length` to `i < array.length`

**Context**: This will cause runtime errors when processing the last element.
```

**High severity:**
```
🟠 **High**: Performance issue - blocking async call

**Location**: `handlers/MessageHandler.cs:23`

**Issue**: Using `.Result` on async method blocks the thread

**Suggestion**: Use `await` instead:
```csharp
var result = await GetDataAsync();
```

**Context**: Blocking async calls can cause thread pool starvation.
```

**Medium severity:**
```
🟡 **Medium**: Code quality - unused import

**Location**: `components/UserList.tsx:5`

**Issue**: Import `useMemo` is declared but never used

**Suggestion**: Remove the unused import to keep code clean.
```

**Low severity:**
```
🟢 **Low**: Style suggestion - naming consistency

**Location**: `utils/helpers.ts:12`

**Issue**: Function name `processData` doesn't follow event handler naming pattern

**Suggestion**: Consider renaming to `handleProcessData` if it's an event handler, or keep current name if it's a utility function.
```

### Positive Feedback

Recognize well-implemented patterns:
- Highlight clean architecture decisions
- Acknowledge comprehensive error handling
- Recognize thoughtful performance optimizations
- Appreciate thorough test coverage
- Note good edge case handling

## Special Considerations

### Multi-Repository Changes

If PR affects multiple repositories:
- Verify consistency across repos
- Check API contract compatibility
- Ensure deployment order is correct
- Validate cross-repo dependencies

### Database Changes

- Migration scripts included
- Backward compatibility considered
- Performance impact assessed
- Rollback plan documented

### Breaking Changes

- Properly documented in PR description
- Migration guide provided
- Communication plan in place
- Version bumping considered

## Review Context Adaptation

**For Pull Requests:**
- Review all changed files
- Consider impact on related code
- Check for breaking changes
- Verify tests cover changes

**For Individual Code Reviews:**
- Focus on the provided code snippet/file
- Consider correctness and logic first
- Check against project standards
- Provide focused, actionable feedback

**For Implementation Feedback:**
- Review before or after implementation
- Focus on correctness and best practices
- Suggest improvements early
- Consider maintainability

## Example Usage

**PR Review:**
```
Review PR #123 in repository keaisdev/chartswap-frontend.
Focus on:
- Correctness and edge cases
- NServiceBus configuration correctness
- Async/await patterns
- Error handling completeness
- Security considerations
- Test coverage
```

**Code Review:**
```
Review this code snippet for correctness and best practices:
[code here]
```

## Deliverables (always produce)

1) **Review Summary** - Overall assessment with verdict (Approve/Request Changes/Comment)
2) **Findings by Severity** - All issues categorized by severity level
3) **Detailed Feedback** - Each finding with location, issue, suggestion, and context
4) **Positive Feedback** - Recognition of well-implemented patterns
5) **Recommendations** - Actionable next steps for addressing issues
6) **Review Metadata** - Files reviewed, scope, and review context

---

## Review Output Template

```markdown
# Code Review Summary

## Verdict
[Approve / Request Changes / Comment]

## Overall Assessment
[2-3 sentence summary of review findings]

## Findings Summary
- **Critical**: [count] issues
- **High**: [count] issues  
- **Medium**: [count] issues
- **Low**: [count] issues

## Key Concerns
1. [Top concern 1]
2. [Top concern 2]
3. [Top concern 3]

## Positive Highlights
- [Well-implemented pattern 1]
- [Well-implemented pattern 2]

## Detailed Findings

### Critical Issues
[Detailed findings with severity, location, issue, suggestion, context]

### High Priority Issues
[Detailed findings]

### Medium Priority Issues
[Detailed findings]

### Low Priority / Suggestions
[Detailed findings]

## Recommendations
1. [Actionable recommendation 1]
2. [Actionable recommendation 2]

---
*Review completed on [date] | Files reviewed: [count] | PR: [PR number if applicable]*
```

---

## Examples

### Example 1: PR Review
**User**: "review PR #123"

**Agent actions**:
1. Fetches PR #123 details from Azure DevOps
2. Analyzes all changed files and commits
3. Reviews against all focus areas
4. Generates comprehensive feedback with findings
5. Provides verdict and recommendations

### Example 2: Code Snippet Review
**User**: "review this code for security issues"

**Agent actions**:
1. Analyzes provided code snippet
2. Focuses on security aspects (injection risks, auth, data protection)
3. Checks related context if needed
4. Provides security-focused feedback
5. Includes security-specific recommendations

### Example 3: Quick Review
**User**: "quick review of my changes"

**Agent actions**:
1. Analyzes current branch changes vs develop
2. Performs thorough analysis (Steps 0-3)
3. Outputs only Critical and High severity issues
4. Provides brief summary of other areas checked
5. Indicates deeper review may reveal more

### Example 4: Focused Review
**User**: "review PR #456, focus on performance and async patterns"

**Agent actions**:
1. Fetches PR #456
2. Analyzes all changes
3. Prioritizes performance and async/await review
4. Still checks other areas but emphasizes requested focus
5. Provides detailed feedback on performance and async patterns

## Additional Resources

- **Chartswap Standards**: See [references/chartswap-standards.md](references/chartswap-standards.md) for detailed naming conventions, code quality rules, and framework-specific patterns
- **Architecture Context**: See `chartswap.root.repo/README.md` for system architecture
- **Coding Standards**: See workspace rules in `agents.md` (skills and new portal context)
