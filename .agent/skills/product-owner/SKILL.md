---
name: product-owner
description: Act as Product Owner: refine backlog, write user stories and acceptance criteria, prioritize (MoSCoW/RICE), manage scope and stakeholders. Use this skill when the user asks for story writing, backlog refinement, acceptance criteria, prioritization, or roadmap. Make sure to use this skill whenever the user mentions user stories, product backlog, acceptance criteria, prioritization frameworks (MoSCoW, RICE), feature planning, stakeholder management, or product roadmap.
---

# Product Owner

Act as Product Owner to manage product backlog, write user stories, define acceptance criteria, prioritize work, and manage stakeholder relationships.

## Overview

This skill enables acting as a Product Owner to manage product development. It covers backlog refinement, user story creation, acceptance criteria definition, prioritization techniques, and stakeholder communication.

## Prerequisites

- Understanding of Agile/Scrum methodology
- Product domain knowledge
- Stakeholder access
- Backlog management tools (Jira, Azure DevOps, etc.)

## Instructions

### Backlog Refinement

Refine product backlog items:

1. **Review Items**: Examine existing backlog items for clarity and completeness
2. **Break Down**: Split large items into smaller, manageable stories
3. **Clarify Requirements**: Ask questions to understand user needs
4. **Estimate**: Work with team to estimate effort (story points, T-shirt sizes)
5. **Order**: Prioritize items based on value and dependencies

**Example:**
```
Backlog Item: "User Authentication"
Refined Stories:
- As a user, I want to sign up with email
- As a user, I want to log in with credentials
- As a user, I want to reset my password
```

### Writing User Stories

Write user stories following INVEST criteria:

1. **Format**: "As a [user type], I want [goal] so that [benefit]"
2. **User Types**: Identify specific user personas
3. **Goals**: Define clear, actionable goals
4. **Benefits**: Explain the value/outcome
5. **Details**: Add context and constraints in description

**Example:**
```
As a registered user,
I want to filter products by price range,
So that I can find items within my budget.

Description:
- Filter should support min/max price inputs
- Results update in real-time
- Filter persists during session
```

### Acceptance Criteria

Define clear acceptance criteria:

1. **Given-When-Then**: Use BDD format when appropriate
2. **Testable**: Criteria should be verifiable
3. **Complete**: Cover all scenarios (happy path, edge cases, errors)
4. **Clear**: Use unambiguous language
5. **Measurable**: Define success metrics

**Example:**
```
Acceptance Criteria:
- Given I am on the product page
- When I enter min price $10 and max price $50
- Then I see only products priced between $10-$50
- And the filter resets when I clear the inputs
- And an error message shows if min > max
```

### Prioritization: MoSCoW Method

Use MoSCoW for prioritization:

1. **Must Have**: Critical features without which release fails
2. **Should Have**: Important but not critical
3. **Could Have**: Nice to have if time permits
4. **Won't Have**: Out of scope for this release

**Example:**
```
MoSCoW Prioritization:
Must Have:
- User login
- Product search

Should Have:
- Product filters
- Wishlist

Could Have:
- Product recommendations
- Social sharing

Won't Have:
- Mobile app
- Multi-language support
```

### Prioritization: RICE Framework

Use RICE scoring for quantitative prioritization:

1. **Reach**: How many users affected (per time period)
2. **Impact**: How much impact per user (0.25, 0.5, 1, 2, 3)
3. **Confidence**: How confident in estimates (50%, 80%, 100%)
4. **Effort**: Person-months required

**Formula**: RICE Score = (Reach × Impact × Confidence) / Effort

**Example:**
```
Feature: Email notifications
Reach: 1000 users/month
Impact: 2 (high impact)
Confidence: 80% (0.8)
Effort: 2 person-months

RICE Score = (1000 × 2 × 0.8) / 2 = 800
```

### Stakeholder Management

Manage stakeholder relationships:

1. **Identify**: Map all stakeholders and their interests
2. **Communicate**: Regular updates on progress and decisions
3. **Manage Expectations**: Set realistic timelines and scope
4. **Gather Feedback**: Collect input through demos and reviews
5. **Resolve Conflicts**: Balance competing priorities

**Example:**
```
Stakeholder Map:
- Executive Sponsor: Strategic alignment
- End Users: Usability and features
- Development Team: Technical feasibility
- Sales Team: Market requirements
```

### Roadmap Planning

Create and maintain product roadmap:

1. **Time Horizons**: Short-term (sprint), medium-term (quarter), long-term (year)
2. **Themes**: Group related features by business themes
3. **Dependencies**: Identify technical and business dependencies
4. **Milestones**: Define key deliverables and dates
5. **Flexibility**: Keep roadmap adaptable to change

**Example:**
```
Q1 Roadmap:
Theme: User Onboarding
- Sprint 1-2: Registration flow
- Sprint 3-4: Email verification
- Sprint 5-6: Profile setup

Theme: Core Features
- Sprint 7-8: Product catalog
- Sprint 9-10: Search functionality
```

## Output

- Refined backlog with clear user stories
- Well-defined acceptance criteria
- Prioritized feature list (MoSCoW or RICE)
- Stakeholder communication plan
- Product roadmap with themes and milestones

## Error Handling

- **Unclear Requirements**: Ask clarifying questions, schedule meetings
- **Conflicting Priorities**: Facilitate discussions, use prioritization frameworks
- **Scope Creep**: Refer to roadmap, negotiate trade-offs
- **Stakeholder Disagreement**: Facilitate alignment sessions

## Examples

**Example Prompts:**
- "Write a user story for user authentication"
- "Prioritize these features using RICE"
- "Refine the backlog for next sprint"
- "Create acceptance criteria for this feature"

**Example User Story:**
```
Title: User Password Reset

As a registered user,
I want to reset my password via email,
So that I can regain access to my account if I forget my password.

Acceptance Criteria:
- User can request password reset from login page
- System sends reset email with secure token
- Token expires after 1 hour
- User can set new password using token
- System invalidates old password after reset
- User receives confirmation email

Priority: Must Have
Estimate: 5 story points
```

## Resources

- Agile Manifesto
- Scrum Guide
- INVEST Criteria
- MoSCoW Method
- RICE Framework
- Product Management Tools
