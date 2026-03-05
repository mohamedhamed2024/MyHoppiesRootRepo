---
name: nextjs-code-standards
description: Next.js and React code standards for the ChartSwap new portal (Ontellus ChartSwap). Use this skill when writing or reviewing the new portal frontend (ontellus.chartswap), adding components, implementing state (Zustand), calling Salesforce or .NET APIs, adding a new API integration, writing unit tests, or applying project code style and naming conventions. Make sure to use this skill whenever the user mentions Next.js code, React components, ChartSwap portal, Zustand state management, API integration, unit tests, or code style in the Ontellus ChartSwap project.
---

# Next.js Code Standards

Next.js and React code standards for the ChartSwap new portal. This skill provides coding conventions, patterns, and best practices for the Ontellus ChartSwap frontend.

## Overview

This skill covers code standards, patterns, and conventions for the ChartSwap Next.js application. It includes component structure, state management with Zustand, API integration patterns, testing approaches, and naming conventions.

## Prerequisites

- Next.js 13+ (App Router)
- React 18+
- TypeScript
- Zustand for state management
- Understanding of React Server Components and Client Components

## Instructions

### Component Structure

Follow these patterns for component organization:

1. **File Naming**: Use PascalCase for component files (`UserProfile.tsx`)
2. **Component Naming**: Match component name to file name
3. **Exports**: Use named exports for components
4. **Types**: Define TypeScript interfaces/types in same file or separate types file
5. **Server vs Client**: Mark client components with `'use client'` directive

**Example:**
```tsx
'use client';

import { useState } from 'react';

interface UserProfileProps {
  userId: string;
}

export function UserProfile({ userId }: UserProfileProps) {
  // Component implementation
}
```

### State Management with Zustand

Use Zustand for global state management:

1. **Store Creation**: Create stores in `stores/` directory
2. **Store Naming**: Use descriptive names (`useUserStore`, `useAuthStore`)
3. **Actions**: Define actions within the store
4. **Selectors**: Use selectors for computed values
5. **Persistence**: Use persist middleware when needed

**Example:**
```tsx
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface UserState {
  user: User | null;
  setUser: (user: User) => void;
  clearUser: () => void;
}

export const useUserStore = create<UserState>()(
  persist(
    (set) => ({
      user: null,
      setUser: (user) => set({ user }),
      clearUser: () => set({ user: null }),
    }),
    { name: 'user-storage' }
  )
);
```

### API Integration

Follow patterns for calling Salesforce and .NET APIs:

1. **API Routes**: Create API routes in `app/api/` directory
2. **Client Calls**: Use fetch or axios for client-side calls
3. **Server Actions**: Use Server Actions for form submissions
4. **Error Handling**: Implement consistent error handling
5. **Type Safety**: Type API responses with TypeScript

**Example:**
```tsx
// Server Action
'use server';

export async function fetchUserData(userId: string) {
  try {
    const response = await fetch(`${API_BASE_URL}/users/${userId}`);
    if (!response.ok) throw new Error('Failed to fetch');
    return await response.json();
  } catch (error) {
    console.error('Error fetching user:', error);
    throw error;
  }
}
```

### Adding New API Integration

When adding a new API integration:

1. **Create API Route**: Add route in `app/api/` or use Server Actions
2. **Define Types**: Create TypeScript interfaces for request/response
3. **Error Handling**: Implement error boundaries and error states
4. **Loading States**: Add loading indicators
5. **Documentation**: Document API endpoints and usage

**Example:**
```tsx
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const userId = searchParams.get('userId');
  
  // API logic
  return NextResponse.json({ data });
}
```

### Unit Testing

Write unit tests following project patterns:

1. **Test Files**: Place tests next to components (`Component.test.tsx`)
2. **Testing Library**: Use React Testing Library
3. **Test Structure**: Follow AAA pattern (Arrange, Act, Assert)
4. **Mocking**: Mock API calls and external dependencies
5. **Coverage**: Aim for meaningful coverage, not just high percentages

**Example:**
```tsx
import { render, screen } from '@testing-library/react';
import { UserProfile } from './UserProfile';

describe('UserProfile', () => {
  it('renders user information', () => {
    render(<UserProfile userId="123" />);
    expect(screen.getByText('User Profile')).toBeInTheDocument();
  });
});
```

### Code Style and Naming Conventions

Follow these naming conventions:

1. **Variables**: camelCase (`userName`, `isLoading`)
2. **Components**: PascalCase (`UserProfile`, `NavigationBar`)
3. **Constants**: UPPER_SNAKE_CASE (`API_BASE_URL`, `MAX_RETRIES`)
4. **Files**: Match component name or use kebab-case for utilities
5. **Functions**: camelCase with verb prefix (`fetchUser`, `handleSubmit`)

**Example:**
```tsx
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL;
const MAX_RETRY_ATTEMPTS = 3;

export function fetchUserData(userId: string) {
  // Implementation
}
```

## Output

- Code following Next.js and React best practices
- Consistent naming conventions
- Proper TypeScript typing
- Well-structured components and stores
- Testable code with unit tests

## Error Handling

- **Type Errors**: Ensure proper TypeScript types are defined
- **API Errors**: Implement error boundaries and error states
- **State Errors**: Validate state updates and handle edge cases
- **Test Failures**: Review test assertions and mocks

## Examples

**Example Prompts:**
- "Create a new component following our code standards"
- "Add Zustand store for user authentication"
- "Integrate a new API endpoint"
- "Write unit tests for this component"

**Example Component:**
```tsx
'use client';

import { useUserStore } from '@/stores/useUserStore';
import { fetchUserData } from '@/actions/user';

interface UserCardProps {
  userId: string;
}

export function UserCard({ userId }: UserCardProps) {
  const { user, setUser } = useUserStore();
  
  const handleLoad = async () => {
    const data = await fetchUserData(userId);
    setUser(data);
  };
  
  return (
    <div>
      {user ? <div>{user.name}</div> : <button onClick={handleLoad}>Load</button>}
    </div>
  );
}
```

## Resources

- Next.js Documentation
- React Documentation
- Zustand Documentation
- TypeScript Handbook
- Project Style Guide
