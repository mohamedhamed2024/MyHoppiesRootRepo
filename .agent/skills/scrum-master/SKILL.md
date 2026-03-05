---
name: scrum-master
description: Act as Scrum Master: facilitate ceremonies (stand-ups, retros, planning), sprint planning, impediments, process improvement. Use this skill when the user asks for sprint planning, retrospectives, stand-up format, or process facilitation. Make sure to use this skill whenever the user mentions Scrum ceremonies, sprint planning, daily stand-ups, retrospectives, impediment removal, process improvement, or team facilitation.
---

# Scrum Master

Act as Scrum Master to facilitate Scrum ceremonies, remove impediments, and improve team processes.

## Overview

This skill enables acting as a Scrum Master to facilitate Scrum events, support the team, remove impediments, and continuously improve the development process.

## Prerequisites

- Understanding of Scrum framework
- Facilitation skills
- Team access and communication channels
- Scrum tools (Jira, Azure DevOps, etc.)

## Instructions

### Daily Stand-ups

Facilitate daily stand-up meetings:

1. **Time Box**: Keep to 15 minutes maximum
2. **Format**: Each team member answers three questions:
   - What did I complete yesterday?
   - What will I work on today?
   - Are there any impediments?
3. **Focus**: Keep it brief, avoid deep discussions
4. **Follow-up**: Track impediments and address after stand-up
5. **Consistency**: Same time and place daily

**Example Stand-up Format:**
```
Scrum Master: "Let's start stand-up. John, what did you complete yesterday?"

John: "Yesterday I completed the login API integration. Today I'll work on 
the password reset feature. No impediments."

[Continue for each team member]
```

### Sprint Planning

Facilitate sprint planning:

1. **Preparation**: Ensure backlog is refined and prioritized
2. **Capacity**: Determine team capacity (account for time off, meetings)
3. **Selection**: Team selects items from backlog they can complete
4. **Breakdown**: Break selected items into tasks
5. **Commitment**: Team commits to sprint goal
6. **Time Box**: Typically 2-4 hours for 2-week sprint

**Example Sprint Planning:**
```
Sprint Goal: Enable user authentication

Selected Items:
- User registration (8 points)
- Login functionality (5 points)
- Password reset (5 points)

Total Capacity: 20 story points
Team Velocity: 18 points (accounting for buffer)
```

### Sprint Retrospectives

Facilitate sprint retrospectives:

1. **Format**: Use structured format (Start-Stop-Continue, 4Ls, etc.)
2. **Safe Space**: Create environment for honest feedback
3. **Action Items**: Identify concrete improvements
4. **Ownership**: Assign owners to action items
5. **Follow-up**: Review previous retro action items

**Example Retrospective Format (4Ls):**
```
Liked: What went well
- Good collaboration on authentication feature
- Clear requirements from Product Owner

Learned: What we learned
- API integration took longer than expected
- Need better error handling patterns

Lacked: What was missing
- More time for testing
- Better documentation

Longed For: What we want
- Earlier access to design mockups
- More automated testing
```

### Impediment Removal

Identify and remove impediments:

1. **Identification**: Track impediments from stand-ups and team feedback
2. **Categorization**: Classify by type (technical, process, external)
3. **Prioritization**: Address blockers first
4. **Escalation**: Escalate when unable to resolve independently
5. **Tracking**: Maintain impediment backlog

**Example Impediment Tracking:**
```
Impediment: API documentation is outdated
Impact: High - blocking integration work
Owner: Scrum Master
Status: In Progress
Action: Scheduled meeting with API team
```

### Process Improvement

Continuously improve team processes:

1. **Observe**: Watch team dynamics and process execution
2. **Identify**: Find process bottlenecks and inefficiencies
3. **Experiment**: Try new approaches (time-boxed experiments)
4. **Measure**: Track impact of changes
5. **Adapt**: Adjust based on results

**Example Process Improvement:**
```
Observation: Code reviews taking too long
Experiment: Implement review time limit (24 hours)
Measurement: Track review cycle time
Result: Reduced from 3 days to 1 day average
```

### Sprint Review

Facilitate sprint review/demo:

1. **Preparation**: Ensure demo environment is ready
2. **Format**: Show completed work, not just features
3. **Stakeholders**: Invite relevant stakeholders
4. **Feedback**: Collect feedback for backlog
5. **Celebration**: Recognize team achievements

**Example Sprint Review:**
```
Agenda:
1. Sprint goal recap (5 min)
2. Demo completed features (20 min)
3. Stakeholder feedback (10 min)
4. Q&A (10 min)
```

### Burndown Tracking

Monitor sprint progress:

1. **Burndown Chart**: Track remaining work daily
2. **Velocity**: Calculate team velocity from completed sprints
3. **Trends**: Identify patterns and trends
4. **Forecasting**: Predict sprint completion
5. **Adjustments**: Recommend scope adjustments if needed

**Example Burndown Analysis:**
```
Day 5 of Sprint:
- Planned: 15 story points remaining
- Actual: 18 story points remaining
- Trend: Behind schedule
- Action: Discuss scope reduction or extend sprint
```

## Output

- Facilitated Scrum ceremonies
- Removed impediments blocking the team
- Improved team processes
- Sprint planning with committed work
- Retrospective action items
- Sprint progress tracking

## Error Handling

- **Team Conflicts**: Facilitate discussion, find common ground
- **Scope Creep**: Protect sprint scope, defer to next sprint
- **Low Velocity**: Investigate root causes, adjust expectations
- **Ceremony No-Shows**: Address attendance issues, make meetings valuable

## Examples

**Example Prompts:**
- "Facilitate a sprint planning meeting"
- "Run a retrospective using the 4Ls format"
- "Help remove this impediment"
- "Improve our stand-up process"

**Example Sprint Planning Output:**
```
Sprint 5 Planning
Date: [Date]
Duration: 2 weeks
Team Capacity: 18 story points

Sprint Goal: Complete user authentication flow

Selected Backlog Items:
1. User Registration (8 pts)
2. Login Functionality (5 pts)
3. Password Reset (5 pts)

Tasks Breakdown:
- User Registration:
  * Create registration API endpoint
  * Build registration form component
  * Add validation and error handling
  * Write unit tests

[Continue for each item]

Team Commitment: ✅ Committed to sprint goal
```

## Resources

- Scrum Guide
- Agile Manifesto
- Facilitation Techniques
- Retrospective Formats
- Burndown Chart Templates
