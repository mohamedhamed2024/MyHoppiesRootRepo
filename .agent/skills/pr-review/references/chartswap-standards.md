# Chartswap Standards Reference

This document provides detailed Chartswap-specific standards for PR reviews.

## Naming Conventions

### Components and Interfaces
- **Components**: PascalCase (`MyComponent.tsx`)
- **Interfaces**: PascalCase (`IUserService`, `UserProps`)

### Variables and Functions
- **Variables**: camelCase (`myVariable`, `userData`)
- **Functions**: camelCase (`getUserData`, `processPayment`)
- **Event handlers**: Prefix with "handle" (`handleClick`, `handleSubmit`)
- **Flags**: Use verbs (`canResubmit`, `isLoading`, `hasError`)

### Directories and Files
- **Directories**: kebab-case (`auth-service`, `user-management`)
- **Constants**: UPPER_CASE (`MAX_RETRIES`, `API_BASE_URL`)

### Hooks
- **Custom hooks**: Prefix with "useSherif" (`useSherifAuth`, `useSherifData`)

## Code Quality Standards

### Equality Checks
- Use strict equality (`===` not `==`)
- Use strict inequality (`!==` not `!=`)

### Code Organization
- Remove unused imports
- Limit line length to 100 characters max
- Use functional and declarative programming over imperative
- Split constants into separate files
- Add comments explaining function purpose

### State Management
- Use cleanup functions in useEffect hooks
- Use context for state management
- Avoid prop drilling

## Framework-Specific Patterns

### NServiceBus Configuration

**Transport Configuration**
- Use Azure Service Bus as transport
- Configure connection strings via environment variables
- Set appropriate retry policies

**Persistence Setup**
- Use SQL Server for persistence
- Configure connection strings securely
- Set up appropriate retention policies

**Endpoint Configuration**
- Configure endpoints correctly
- Set up message routing and subscriptions
- Configure error handling and recoverability

**Message Handling**
- Implement proper message handlers
- Handle errors gracefully
- Use appropriate message types

### .NET Backend Services

**Dependency Injection**
- Register services in DI container
- Use constructor injection
- Follow service lifetime best practices

**Configuration Management**
- Use `appsettings.json` for configuration
- Support environment-specific overrides
- Validate configuration on startup

**Health Checks**
- Implement health check endpoints
- Monitor critical dependencies
- Provide meaningful health status

**Logging**
- Use Serilog for logging
- Configure appropriate log levels
- Include contextual information
- Avoid logging sensitive data

**Environment-Specific Settings**
- Use environment variables for secrets
- Support multiple environments (Dev, PreProd, Prod)
- Validate environment configuration

### Next.js Frontend

**React Hooks**
- Use hooks appropriately (`useState`, `useEffect`, `useContext`)
- Include cleanup functions in `useEffect`
- Avoid stale closures

**Next.js API Routes**
- Follow Next.js API route patterns
- Handle errors appropriately
- Return proper HTTP status codes
- Validate request data

**TypeScript**
- Use type safety throughout
- Define proper interfaces and types
- Avoid `any` types
- Use type inference where appropriate

**Component Patterns**
- Create reusable components
- Follow single responsibility principle
- Use composition over inheritance

**Styling**
- Use Tailwind CSS exclusively
- Do not use other CSS tools or frameworks
- Follow Tailwind utility patterns
- Keep styles co-located with components

**State Management**
- Use React Context for global state
- Use local state for component-specific state
- Avoid unnecessary re-renders

### Salesforce Integration

**API Call Patterns**
- Use consistent API call patterns
- Handle rate limiting appropriately
- Implement retry logic for transient failures

**Authentication Handling**
- Manage Salesforce authentication securely
- Handle token refresh automatically
- Store credentials securely

**Error Handling**
- Handle Salesforce API errors gracefully
- Provide meaningful error messages
- Log errors appropriately

**Rate Limiting**
- Respect Salesforce API limits
- Implement backoff strategies
- Monitor API usage

**Token Refresh Logic**
- Implement automatic token refresh
- Handle refresh failures appropriately
- Cache tokens securely

## Security Standards

### Input Validation
- Validate all user inputs
- Sanitize data before processing
- Use DOMPurify for HTML content sanitization

### Secret Management
- Never hardcode secrets
- Use environment variables for sensitive data
- Do not expose secrets in logs or error messages
- Use secure credential storage

### Data Protection
- Prevent SQL injection (use parameterized queries)
- Prevent XSS attacks (sanitize user input)
- Encrypt sensitive data at rest
- Use HTTPS for all communications

## Testing Standards

### Unit Tests
- Write unit tests for new code
- Aim for high code coverage
- Test edge cases and error conditions
- Mock external dependencies

### Integration Tests
- Write integration tests for critical paths
- Test API endpoints
- Test database interactions
- Test external service integrations

### Test Quality
- Write maintainable tests
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)
- Keep tests independent and isolated

## Documentation Standards

### Code Documentation
- Add XML comments for public APIs (.NET)
- Document complex logic
- Explain "why" not just "what"
- Keep documentation up to date

### README Updates
- Update README when adding features
- Document breaking changes
- Include setup instructions if needed
- Keep examples current
