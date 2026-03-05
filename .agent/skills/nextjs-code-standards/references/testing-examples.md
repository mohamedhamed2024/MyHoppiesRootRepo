# Next.js Testing - Code Examples and Patterns

Real-world testing patterns and examples for common scenarios in Next.js applications.

## Pattern: Render with Helper Function

```typescript
const renderComponent = (props = {}) => {
  const defaultProps = { title: 'Test', onClose: jest.fn() };
  return render(<Component {...defaultProps} {...props} />);
};

test('renders with custom props', () => {
  renderComponent({ title: 'Custom' });
  expect(screen.getByText('Custom')).toBeInTheDocument();
});
```

## Pattern: Testing Error States

```typescript
test('displays error message on failure', async () => {
  mockAPI.fetchData.mockRejectedValue(new Error('Network Error'));

  render(<Component />);

  await waitFor(() => {
    expect(screen.getByText(/network error/i)).toBeInTheDocument();
  });
});
```

## Pattern: Testing Form Submission

```typescript
test('submits form with valid data', async () => {
  const mockSubmit = jest.fn().mockResolvedValue({ success: true });
  render(<Form onSubmit={mockSubmit} />);

  fireEvent.change(screen.getByLabelText('Email'), {
    target: { value: 'test@example.com' }
  });

  fireEvent.click(screen.getByRole('button', { name: /submit/i }));

  await waitFor(() => {
    expect(mockSubmit).toHaveBeenCalledWith(
      expect.objectContaining({ email: 'test@example.com' })
    );
  });
});
```

## Pattern: Testing Conditional Rendering

```typescript
test('shows loading state', () => {
  render(<Component isLoading={true} />);
  expect(screen.getByText('Loading...')).toBeInTheDocument();
});

test('shows data when loaded', () => {
  render(<Component isLoading={false} data={mockData} />);
  expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
  expect(screen.getByText('Data loaded')).toBeInTheDocument();
});
```

## Pattern: Testing Toast Notifications

```typescript
jest.mock('@/components/UI/Toast/Toast', () => ({
  __esModule: true,
  default: jest.fn()
}));

test('shows error toast on failure', async () => {
  const Toast = require('@/components/UI/Toast/Toast').default;
  
  // Trigger error
  fireEvent.click(screen.getByRole('button'));

  await waitFor(() => {
    expect(Toast).toHaveBeenCalledWith({
      id: 'error-id',
      message: 'Operation failed',
      toastType: 'error'
    });
  });
});
```

## Test Organization Template

```typescript
import { render, screen } from '@testing-library/react';
import Component from './Component';

// Mocks at top
jest.mock('@/hooks/useDependency');

describe('Component', () => {
  // Test data/helpers
  const mockData = { id: '1', name: 'Test' };
  
  // Setup/teardown
  beforeEach(() => {
    jest.clearAllMocks();
  });

  // Group by feature
  describe('rendering', () => {
    test('renders initial state', () => {
      // Test implementation
    });
  });

  describe('user interactions', () => {
    test('handles click event', () => {
      // Test implementation
    });
  });

  describe('error handling', () => {
    test('displays error message', () => {
      // Test implementation
    });
  });
});
```

## Essential Imports

```typescript
// Component testing
import { render, screen, fireEvent, waitFor } from '@testing-library/react';

// Hook testing
import { renderHook, act } from '@testing-library/react';

// Custom matchers
import '@testing-library/jest-dom';

// Next.js types
import { NextApiRequest, NextApiResponse } from 'next';
```

## Common Assertions

```typescript
// Existence
expect(element).toBeInTheDocument();
expect(element).not.toBeInTheDocument();

// Visibility
expect(element).toBeVisible();
expect(element).not.toBeVisible();

// Attributes
expect(element).toHaveAttribute('href', '/path');
expect(element).toHaveClass('active');

// Form elements
expect(input).toHaveValue('text');
expect(checkbox).toBeChecked();
expect(button).toBeDisabled();

// Mock calls
expect(mockFn).toHaveBeenCalled();
expect(mockFn).toHaveBeenCalledTimes(2);
expect(mockFn).toHaveBeenCalledWith('arg1', 'arg2');
expect(mockFn).toHaveBeenLastCalledWith('last-arg');

// Arrays/Objects
expect(array).toHaveLength(3);
expect(obj).toEqual({ key: 'value' });
expect(obj).toStrictEqual({ key: 'value' }); // Stricter
expect(result).toMatchObject({ partial: 'match' });
```
