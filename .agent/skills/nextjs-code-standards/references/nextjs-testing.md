# Next.js Unit Testing - Technical Reference

## Table of Contents

- [Component Testing](#component-testing)
- [Custom Hook Testing](#custom-hook-testing)
- [Context Provider Testing](#context-provider-testing)
- [Service/Utility Testing](#serviceutility-testing)
- [API Route Testing](#api-route-testing)
- [Mocking Strategies](#mocking-strategies)
- [Best Practices Checklist](#best-practices-checklist)

---

Comprehensive testing patterns for Next.js 14 components, hooks, services, and API routes using Jest and React Testing Library.

## Component Testing

### Basic Component Test Structure

```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import MyComponent from './MyComponent';

// Mock dependencies at top of file
jest.mock('@/hooks/useAPI');

describe('MyComponent', () => {
  // Setup before each test
  beforeEach(() => {
    jest.clearAllMocks();
  });

  // Clean up after tests (optional)
  afterEach(() => {
    jest.restoreAllMocks();
  });

  test('renders component correctly', () => {
    // Arrange: Set up test data and mocks
    render(<MyComponent title="Test" />);

    // Act: Query elements
    const heading = screen.getByText('Test');

    // Assert: Verify expectations
    expect(heading).toBeInTheDocument();
  });

  test('handles user interaction', () => {
    const mockOnClick = jest.fn();
    render(<MyComponent onClick={mockOnClick} />);

    const button = screen.getByRole('button', { name: /submit/i });
    fireEvent.click(button);

    expect(mockOnClick).toHaveBeenCalledTimes(1);
  });
});
```

### Query Priority (Use in Order)

1. **getByRole**: Most accessible, semantic queries
   ```typescript
   screen.getByRole('button', { name: /submit/i })
   screen.getByRole('textbox', { name: /email/i })
   ```

2. **getByLabelText**: For form inputs with labels
   ```typescript
   screen.getByLabelText('Email Address')
   ```

3. **getByText**: For non-interactive text content
   ```typescript
   screen.getByText('Welcome back')
   ```

4. **getByTestId**: Last resort when semantic queries don't work
   ```typescript
   screen.getByTestId('custom-widget')
   ```

### User Interactions

```typescript
import { fireEvent } from '@testing-library/react';

// Click events
fireEvent.click(button);

// Input changes
const input = screen.getByRole('textbox');
fireEvent.change(input, { target: { value: 'new value' } });

// File uploads
const file = new File(['content'], 'file.pdf', { type: 'application/pdf' });
fireEvent.change(fileInput, { target: { files: [file] } });

// Drag and drop
fireEvent.drop(dropzone, { dataTransfer: { files: [file] } });
```

### Async Operations

```typescript
import { waitFor } from '@testing-library/react';

test('loads data asynchronously', async () => {
  render(<AsyncComponent />);

  // Wait for element to appear
  const data = await screen.findByText('Loaded data');
  expect(data).toBeInTheDocument();

  // Or use waitFor for more complex scenarios
  await waitFor(() => {
    expect(screen.getByText('Success')).toBeInTheDocument();
  });
});
```

## Custom Hook Testing

### Basic Hook Test

```typescript
import { renderHook, act } from '@testing-library/react';
import useCustomHook from './useCustomHook';

// Mock dependencies
jest.mock('@/hooks/useAPI');

describe('useCustomHook', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('returns initial state', () => {
    const { result } = renderHook(() => useCustomHook());
    
    expect(result.current.data).toBeNull();
    expect(result.current.isLoading).toBe(false);
  });

  test('updates state on action', async () => {
    const { result } = renderHook(() => useCustomHook());

    await act(async () => {
      await result.current.fetchData();
    });

    expect(result.current.data).toBeDefined();
  });
});
```

### Hook with Context Provider

```typescript
const wrapper = ({ children }: { children: React.ReactNode }) => (
  <MyContextProvider>
    {children}
  </MyContextProvider>
);

test('hook uses context correctly', () => {
  const { result } = renderHook(() => useMyHook(), { wrapper });
  
  expect(result.current.contextValue).toBeDefined();
});
```

### Testing State Updates

```typescript
test('increments counter', () => {
  const { result } = renderHook(() => useCounter());

  // Initial state
  expect(result.current.count).toBe(0);

  // Update state (synchronous)
  act(() => {
    result.current.increment();
  });

  expect(result.current.count).toBe(1);
});
```

## Context Provider Testing

### Testing Provider Functionality

```typescript
import { render, act } from '@testing-library/react';
import { MyProvider, useMyContext } from './MyProvider';

describe('MyProvider', () => {
  const getContextValue = () => {
    let contextValue;
    
    const TestComponent = () => {
      contextValue = useMyContext();
      return null;
    };

    render(
      <MyProvider>
        <TestComponent />
      </MyProvider>
    );

    return contextValue;
  };

  test('provides correct initial values', () => {
    const context = getContextValue();
    
    expect(context.items).toEqual([]);
    expect(context.isLoading).toBe(false);
  });

  test('updates state correctly', async () => {
    const context = getContextValue();

    await act(async () => {
      await context.addItem('new-item');
    });

    expect(context.items).toContain('new-item');
  });
});
```

### Testing Context Consumers

```typescript
test('component uses context correctly', () => {
  const wrapper = ({ children }: { children: React.ReactNode }) => (
    <MyProvider>{children}</MyProvider>
  );

  render(<MyComponent />, { wrapper });
  
  expect(screen.getByText('Context data')).toBeInTheDocument();
});
```

## Service/Utility Testing

### Pure Function Tests

```typescript
import { formatDate, sortRecords } from './Helper';

describe('Helper functions', () => {
  describe('formatDate', () => {
    test('formats valid date correctly', () => {
      const result = formatDate('2024-01-15T10:30:00');
      expect(result).toBe('01/15/2024');
    });

    test('returns null for invalid date', () => {
      const result = formatDate('invalid-date');
      expect(result).toBeNull();
    });
  });

  describe('sortRecords', () => {
    test('sorts by number ascending', () => {
      const items = [{ id: 3 }, { id: 1 }, { id: 2 }];
      const result = sortRecords(items, 'id', 'ASC');
      
      expect(result).toEqual([
        { id: 1 },
        { id: 2 },
        { id: 3 }
      ]);
    });

    test('handles undefined values', () => {
      const items = [{ id: 1 }, { id: undefined }, { id: 2 }];
      const result = sortRecords(items, 'id', 'ASC');
      
      expect(result[0].id).toBeUndefined();
    });
  });
});
```

### Service with Dependencies

```typescript
import { AxiosServerMiddleware } from '../HTTP/Server/AxiosServerMiddleware';
import { getRequests } from './RequestsService';

jest.mock('../HTTP/Server/AxiosServerMiddleware');

describe('RequestsService', () => {
  let mockClient: any;

  beforeEach(() => {
    mockClient = {
      postData: jest.fn(),
    };
  });

  test('fetches and transforms data', async () => {
    const mockResponse = {
      data: {
        requests: [{ id: '1', name: 'Test' }],
        overallCount: 1
      }
    };

    mockClient.postData.mockResolvedValue(mockResponse);

    const result = await getRequests('url', 'query', {}, mockClient);

    expect(mockClient.postData).toHaveBeenCalledWith('url', 'query');
    expect(result.totalCount).toBe(1);
    expect(result.items).toHaveLength(1);
  });

  test('handles errors gracefully', async () => {
    mockClient.postData.mockRejectedValue(new Error('Network error'));

    await expect(
      getRequests('url', 'query', {}, mockClient)
    ).rejects.toThrow('Network error');
  });
});
```

## API Route Testing

### Basic API Route Test

```typescript
import { NextApiRequest, NextApiResponse } from 'next';
import { postHandler } from './consent';

jest.mock('@/utils/Helper');

describe('API Route Handler', () => {
  let mockReq: Partial<NextApiRequest>;
  let mockRes: Partial<NextApiResponse>;

  beforeEach(() => {
    mockReq = {
      body: { data: 'test' },
      method: 'POST'
    };

    mockRes = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn(),
    };
  });

  test('handles POST request successfully', async () => {
    await postHandler(
      mockReq as NextApiRequest,
      mockRes as NextApiResponse
    );

    expect(mockRes.status).toHaveBeenCalledWith(200);
    expect(mockRes.json).toHaveBeenCalledWith(
      expect.objectContaining({ success: true })
    );
  });

  test('returns error on failure', async () => {
    mockReq.body = null;

    await postHandler(
      mockReq as NextApiRequest,
      mockRes as NextApiResponse
    );

    expect(mockRes.status).toHaveBeenCalledWith(400);
  });
});
```

## Mocking Strategies

### Module Mocking

```typescript
// Mock entire module at top of file
jest.mock('@/hooks/useAPI');

// Use in test
import useAPI from '@/hooks/useAPI';

test('component uses API hook', () => {
  (useAPI as jest.Mock).mockReturnValue({
    data: mockData,
    isLoading: false
  });

  render(<MyComponent />);
  // ...assertions
});
```

### Next-Auth Mocking

```typescript
// Custom mock already exists in __mocks__/next-auth/index.ts
jest.mock('next-auth/react', () => ({
  useSession: jest.fn().mockReturnValue({
    data: {
      user: { name: 'Test User', email: 'test@example.com' }
    },
    status: 'authenticated'
  })
}));
```

### Mocking Implementation

```typescript
// Mock function
const mockFn = jest.fn();

// Mock return value
mockFn.mockReturnValue('result');

// Mock resolved promise
mockFn.mockResolvedValue({ data: 'async result' });

// Mock rejected promise
mockFn.mockRejectedValue(new Error('Failed'));

// Mock implementation
mockFn.mockImplementation((arg) => arg * 2);

// Mock different returns per call
mockFn
  .mockReturnValueOnce('first')
  .mockReturnValueOnce('second')
  .mockReturnValue('default');
```

### Partial Mocking

```typescript
jest.mock('./utils', () => ({
  ...jest.requireActual('./utils'),
  fetchData: jest.fn() // Only mock fetchData
}));
```

### Clearing Mocks

```typescript
beforeEach(() => {
  jest.clearAllMocks();      // Clear call history
  // or
  jest.resetAllMocks();      // Clear history + reset implementation
  // or
  jest.restoreAllMocks();    // Restore original implementation
});
```

## Best Practices Checklist

### Test Structure

- [ ] Use **AAA pattern** (Arrange, Act, Assert)
- [ ] Group related tests in `describe` blocks
- [ ] Use descriptive test names (what + expected outcome)
- [ ] One assertion concept per test (can have multiple expects)
- [ ] Clear mocks in `beforeEach` to ensure test isolation

### Query Selection

- [ ] Prefer `getByRole` over `getByTestId`
- [ ] Use accessible queries (role, label, text)
- [ ] Only use `getByTestId` as last resort
- [ ] Test user-visible behavior, not implementation

### Async Handling

- [ ] Always wrap state updates in `act()`
- [ ] Use `await` with async operations
- [ ] Use `findBy*` for async elements
- [ ] Use `waitFor` for complex async scenarios

### Mocking

- [ ] Mock external dependencies (APIs, modules)
- [ ] Mock at module level, not internal functions
- [ ] Set up mock return values before render
- [ ] Verify mock calls with `toHaveBeenCalledWith`

### Coverage

- [ ] Test happy path (primary user flow)
- [ ] Test edge cases (empty data, undefined, null)
- [ ] Test error scenarios (failed requests, validation)
- [ ] Test user interactions (clicks, inputs, form submission)

### Type Safety

- [ ] Use `Partial<Type>` for mock objects
- [ ] Type mock return values correctly
- [ ] Use `as jest.Mock` for type assertions
- [ ] Avoid `@ts-ignore` unless absolutely necessary
