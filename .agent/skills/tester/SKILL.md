---
name: tester
description: Combine QA test planning (strategy, scenarios, test cases, regression/edge coverage, requirements testability review) with browser-style automation using Playwright Test in JavaScript/TypeScript (Next.js-friendly). Use this skill when you need to decide what to test, produce a QA checklist/test cases, and/or create Playwright specs to verify real user flows in a running web app (selectors, screenshots, traces, console logs). For Jest/React Testing Library implementation patterns, refer to nextjs-code-standards. Make sure to use this skill whenever the user mentions testing, QA, test cases, Playwright, browser automation, test strategy, regression testing, or end-to-end testing.
---

# Tester

Combine QA test planning with browser automation using Playwright Test. This skill covers test strategy, test case creation, and Playwright test implementation for Next.js applications.

## Overview

This skill enables comprehensive testing approaches combining manual test planning with automated browser testing. It covers test strategy development, test case creation, and Playwright test implementation for verifying real user flows.

## Prerequisites

- Understanding of testing principles
- Playwright Test framework
- JavaScript/TypeScript knowledge
- Next.js application structure
- Access to test environment

## Instructions

### Test Strategy

Develop comprehensive test strategy:

1. **Test Levels**: Unit, Integration, E2E, Visual Regression
2. **Test Types**: Functional, Performance, Security, Accessibility
3. **Coverage Goals**: Define coverage targets per level
4. **Test Data**: Plan test data management
5. **Environment**: Define test environments and configurations

**Example Test Strategy:**
```
Test Strategy:
- Unit Tests: 80% code coverage (Jest + React Testing Library)
- Integration Tests: API endpoints, database operations
- E2E Tests: Critical user journeys (Playwright)
- Visual Regression: UI component snapshots
```

### Test Scenarios

Identify test scenarios:

1. **Happy Path**: Primary user flows work correctly
2. **Edge Cases**: Boundary conditions and limits
3. **Error Cases**: Invalid inputs and error handling
4. **Regression**: Previously fixed bugs don't reoccur
5. **Cross-Browser**: Different browsers and devices

**Example Test Scenarios:**
```
Feature: User Login

Scenarios:
1. Happy Path: Valid credentials → successful login
2. Invalid Password: Wrong password → error message
3. Empty Fields: Submit without input → validation errors
4. Network Error: API failure → error handling
5. Session Expiry: Expired session → redirect to login
```

### Test Cases

Create detailed test cases:

1. **Structure**: Test ID, Description, Steps, Expected Result
2. **Clarity**: Clear, unambiguous steps
3. **Coverage**: Cover all scenarios
4. **Maintainability**: Easy to update when features change
5. **Traceability**: Link to requirements/user stories

**Example Test Case:**
```
Test Case: TC-LOGIN-001
Title: User Login with Valid Credentials
Priority: High

Steps:
1. Navigate to login page
2. Enter valid email address
3. Enter valid password
4. Click "Sign In" button

Expected Result:
- User is redirected to dashboard
- User session is created
- Welcome message displays user name
```

### Playwright Test Implementation

Write Playwright tests for E2E scenarios:

1. **Test Structure**: Use describe/it blocks
2. **Page Objects**: Create reusable page object models
3. **Selectors**: Use data-testid attributes for stable selectors
4. **Assertions**: Use Playwright assertions
5. **Fixtures**: Use fixtures for setup/teardown

**Example Playwright Test:**
```typescript
import { test, expect } from '@playwright/test';

test.describe('User Login', () => {
  test('should login with valid credentials', async ({ page }) => {
    await page.goto('/login');
    
    await page.fill('[data-testid="email"]', 'user@example.com');
    await page.fill('[data-testid="password"]', 'password123');
    await page.click('[data-testid="submit-button"]');
    
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="welcome-message"]'))
      .toContainText('Welcome');
  });
});
```

### Screenshots and Traces

Capture debugging information:

1. **Screenshots**: Capture screenshots on failure
2. **Traces**: Record trace files for debugging
3. **Console Logs**: Capture console errors and warnings
4. **Video**: Record test execution videos
5. **Artifacts**: Save artifacts for failed tests

**Example Configuration:**
```typescript
// playwright.config.ts
export default defineConfig({
  use: {
    screenshot: 'only-on-failure',
    trace: 'retain-on-failure',
    video: 'retain-on-failure',
  },
});
```

### Regression Testing

Plan regression test coverage:

1. **Critical Paths**: Test core user journeys
2. **Fixed Bugs**: Verify previously fixed issues
3. **Smoke Tests**: Quick validation of key features
4. **Full Regression**: Comprehensive test suite
5. **Automation**: Automate repetitive regression tests

**Example Regression Suite:**
```
Regression Test Suite:
- User Authentication (Login, Logout, Password Reset)
- Product Catalog (Search, Filter, View Details)
- Shopping Cart (Add, Remove, Checkout)
- User Profile (View, Edit, Settings)
```

### Requirements Testability Review

Review requirements for testability:

1. **Clarity**: Requirements are clear and testable
2. **Acceptance Criteria**: Well-defined acceptance criteria
3. **Testability**: Can be verified objectively
4. **Coverage**: All requirements have corresponding tests
5. **Traceability**: Tests trace back to requirements

**Example Review:**
```
Requirement: "User can filter products by price"

Testability Review:
✅ Clear and specific
✅ Has acceptance criteria
✅ Can be verified with automated tests
✅ Test cases created: TC-FILTER-001 to TC-FILTER-005
```

## Output

- Comprehensive test strategy document
- Test scenarios covering all cases
- Detailed test cases with steps
- Playwright test specifications
- Test execution reports
- Bug reports with reproduction steps

## Error Handling

- **Flaky Tests**: Investigate timing issues, add waits, stabilize selectors
- **Test Failures**: Analyze screenshots/traces, reproduce locally
- **Environment Issues**: Document environment setup, use Docker
- **Data Issues**: Use test fixtures, clean up test data

## Examples

**Example Prompts:**
- "Create test cases for user registration"
- "Write Playwright test for checkout flow"
- "Develop test strategy for this feature"
- "Review requirements for testability"

**Example Playwright Test Suite:**
```typescript
import { test, expect } from '@playwright/test';

test.describe('Checkout Flow', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    // Login and add items to cart
  });

  test('should complete checkout successfully', async ({ page }) => {
    await page.click('[data-testid="cart-icon"]');
    await page.click('[data-testid="checkout-button"]');
    
    // Fill shipping information
    await page.fill('[data-testid="shipping-name"]', 'John Doe');
    await page.fill('[data-testid="shipping-address"]', '123 Main St');
    
    // Select payment method
    await page.click('[data-testid="payment-card"]');
    await page.fill('[data-testid="card-number"]', '4111111111111111');
    
    // Complete checkout
    await page.click('[data-testid="place-order"]');
    
    await expect(page).toHaveURL('/order-confirmation');
    await expect(page.locator('[data-testid="order-number"]'))
      .toBeVisible();
  });
});
```

## Resources

- Playwright Documentation
- Testing Best Practices
- Test Case Templates
- QA Checklist Templates
- Next.js Testing Guide
