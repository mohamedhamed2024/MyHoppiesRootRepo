---
name: pr-review
description: Reviews code and pull requests for correctness, code quality, security, performance, and adherence to Chartswap standards. Use this skill when reviewing pull requests, examining code changes, reviewing individual files, or when the user asks for a code review or PR review. Make sure to use this skill whenever the user mentions code review, pull request review, code quality, security review, performance review, or code standards compliance.
---

# PR Review

Review code and pull requests for correctness, code quality, security, performance, and adherence to ChartSwap standards.

## Overview

This skill enables comprehensive code and pull request reviews. It covers code correctness, quality standards, security vulnerabilities, performance issues, and compliance with project conventions.

## Prerequisites

- Understanding of code review best practices
- Knowledge of ChartSwap code standards
- Familiarity with codebase architecture
- Security awareness
- Performance optimization knowledge

## Instructions

### Code Correctness

Review code for correctness:

1. **Logic**: Verify logic is correct and handles edge cases
2. **Error Handling**: Check proper error handling and edge cases
3. **Boundary Conditions**: Verify handling of limits and boundaries
4. **Data Validation**: Ensure input validation and sanitization
5. **Business Rules**: Confirm implementation matches requirements

**Example Review:**
```
Issue: Missing null check
Location: UserProfile.tsx:45
Code: const userName = user.name.toUpperCase();

Problem: user.name could be null/undefined
Fix: const userName = user?.name?.toUpperCase() || 'Unknown';
```

### Code Quality

Assess code quality:

1. **Readability**: Code is clear and easy to understand
2. **Maintainability**: Code is maintainable and well-structured
3. **DRY Principle**: No unnecessary duplication
4. **Naming**: Variables and functions have clear names
5. **Comments**: Comments explain why, not what

**Example Review:**
```
Issue: Magic numbers
Location: PaymentProcessor.ts:120
Code: if (amount > 1000) { ... }

Problem: Unclear what 1000 represents
Fix: const MAX_SINGLE_PAYMENT = 1000;
     if (amount > MAX_SINGLE_PAYMENT) { ... }
```

### Security Review

Check for security vulnerabilities:

1. **Input Validation**: All inputs are validated and sanitized
2. **Authentication**: Proper authentication checks
3. **Authorization**: Correct permission checks
4. **Sensitive Data**: No hardcoded secrets or sensitive data
5. **SQL Injection**: Parameterized queries, no string concatenation
6. **XSS**: Output is properly escaped
7. **CSRF**: CSRF protection in place

**Example Review:**
```
Security Issue: Hardcoded API key
Location: config.ts:15
Code: const API_KEY = 'sk_live_1234567890';

Problem: Secret exposed in code
Fix: Move to environment variable
     const API_KEY = process.env.API_KEY;
```

### Performance Review

Identify performance issues:

1. **N+1 Queries**: Check for inefficient database queries
2. **Unnecessary Renders**: React components re-rendering unnecessarily
3. **Large Bundles**: Check bundle size impact
4. **Memory Leaks**: Identify potential memory leaks
5. **Async Operations**: Proper handling of async/await
6. **Lazy Loading**: Use lazy loading where appropriate

**Example Review:**
```
Performance Issue: Unnecessary re-renders
Location: ProductList.tsx:30
Code: const filtered = products.filter(p => p.category === category);

Problem: Filter runs on every render
Fix: Use useMemo to memoize filtered results
     const filtered = useMemo(() => 
       products.filter(p => p.category === category), 
       [products, category]
     );
```

### ChartSwap Standards Compliance

Verify adherence to project standards:

1. **Code Style**: Follows project style guide
2. **File Structure**: Matches project structure conventions
3. **Naming Conventions**: Follows project naming patterns
4. **Testing**: Includes appropriate tests
5. **Documentation**: Code is documented where needed
6. **TypeScript**: Proper TypeScript usage

**Example Review:**
```
Standards Issue: Missing TypeScript types
Location: api.ts:10
Code: function fetchUser(id) { ... }

Problem: Missing type annotations
Fix: function fetchUser(id: string): Promise<User> { ... }
```

### Review Checklist

Use systematic review checklist:

1. **Functionality**: Does it work as intended?
2. **Tests**: Are there adequate tests?
3. **Documentation**: Is code documented?
4. **Performance**: Any performance concerns?
5. **Security**: Any security vulnerabilities?
6. **Standards**: Follows project standards?
7. **Dependencies**: Are new dependencies justified?

**Example Checklist:**
```
PR Review Checklist:
✅ Code works as expected
✅ Tests added/updated
✅ No security vulnerabilities
✅ Follows code style guide
✅ Performance acceptable
✅ Documentation updated
⚠️ Missing error handling in one function
❌ Needs refactoring for readability
```

### Review Comments

Provide constructive feedback:

1. **Be Specific**: Point to exact lines and issues
2. **Be Constructive**: Suggest improvements, not just problems
3. **Be Respectful**: Maintain professional tone
4. **Prioritize**: Mark critical vs. nice-to-have issues
5. **Explain Why**: Explain reasoning behind suggestions

**Example Review Comment:**
```
Good: "Consider extracting this logic into a separate function 
for better testability. The current implementation mixes data 
fetching with transformation logic."

Better: "Line 45-60: Consider extracting the data transformation 
logic into a separate `transformUserData` function. This would:
1. Improve testability (can test transformation separately)
2. Follow single responsibility principle
3. Make the code more reusable

Example:
function transformUserData(rawData: RawUser): User {
  // transformation logic
}"
```

## Output

- Comprehensive code review with specific feedback
- Security vulnerability assessment
- Performance analysis
- Standards compliance report
- Actionable recommendations
- Approval status (approve/request changes/comment)

## Error Handling

- **False Positives**: Verify issues before reporting
- **Missing Context**: Ask for clarification when needed
- **Conflicting Standards**: Refer to project style guide
- **Complex Changes**: Break down into smaller reviews

## Examples

**Example Prompts:**
- "Review this pull request"
- "Check this code for security issues"
- "Review code quality of this file"
- "Perform a performance review"

**Example Review Summary:**
```
PR Review Summary: #123 - User Authentication Feature

Overall: ✅ Approve with minor suggestions

Strengths:
- Clean implementation
- Good test coverage
- Follows project patterns

Issues Found:
1. 🔴 Critical: Missing input validation (line 45)
2. 🟡 Medium: Could use error boundary (line 120)
3. 🟢 Minor: Consider extracting helper function (line 78)

Security: ✅ No vulnerabilities found
Performance: ✅ No concerns
Standards: ✅ Compliant

Recommendations:
- Add input validation before processing
- Consider adding error boundary for better UX
- Extract helper function for reusability
```

## Resources

- Code Review Best Practices
- Security Checklist
- Performance Guidelines
- ChartSwap Style Guide
- TypeScript Best Practices
