---
name: ui-styling
description: UI and styling conventions for the Ontellus ChartSwap Next.js frontend (`ontellus.chartswap/`). Use this skill when creating or modifying UI components, Tailwind styles, global SCSS overrides, tokens (colors/z-index/spacing), responsive layout, and third-party UI wrappers (react-select, react-datepicker, rc-tooltip, react-toastify). Make sure to use this skill whenever the user mentions UI components, styling, Tailwind CSS, SCSS, design tokens, responsive design, or any third-party UI library integration in the ChartSwap project.
---

# UI Styling

UI and styling conventions for the Ontellus ChartSwap Next.js frontend. This skill provides guidance on creating consistent, maintainable UI components and styles following project standards.

## Overview

This skill covers styling patterns, conventions, and best practices for the ChartSwap frontend. It includes Tailwind CSS usage, SCSS overrides, design tokens, responsive layouts, and integration with third-party UI libraries.

## Prerequisites

- Next.js project structure
- Tailwind CSS configured
- SCSS support enabled
- Understanding of React component patterns
- Access to design tokens and style guide

## Instructions

### Tailwind Styles

Use Tailwind utility classes for component styling. Follow these patterns:

1. **Component Structure**: Apply Tailwind classes directly in JSX
2. **Responsive Design**: Use Tailwind breakpoint prefixes (`sm:`, `md:`, `lg:`, `xl:`)
3. **State Variants**: Use conditional classes for hover, focus, active states
4. **Custom Utilities**: Extend Tailwind config for project-specific utilities

**Example:**
```tsx
<button className="px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-md transition-colors">
  Click me
</button>
```

### Global SCSS Overrides

Use SCSS files for global styles and overrides:

1. **Global Styles**: Place in `styles/globals.scss`
2. **Component Styles**: Use CSS modules when needed
3. **Overrides**: Target third-party component styles via SCSS
4. **Variables**: Use SCSS variables for dynamic values

**Example:**
```scss
// Override third-party component
.react-select-container {
  .react-select__control {
    border-color: $primary-color;
  }
}
```

### Design Tokens

Use design tokens for consistent spacing, colors, and z-index:

1. **Colors**: Reference token variables, not hardcoded values
2. **Spacing**: Use spacing scale tokens
3. **Z-Index**: Follow z-index layering system
4. **Typography**: Use typography scale tokens

**Example:**
```tsx
<div style={{ 
  color: 'var(--color-primary)',
  padding: 'var(--spacing-md)',
  zIndex: 'var(--z-index-dropdown)'
}}>
```

### Responsive Layout

Implement responsive layouts using Tailwind breakpoints:

1. **Mobile First**: Start with mobile styles, add breakpoints upward
2. **Breakpoints**: Use `sm:`, `md:`, `lg:`, `xl:` consistently
3. **Grid Systems**: Use Tailwind grid utilities
4. **Flexbox**: Prefer flex utilities for component layouts

**Example:**
```tsx
<div className="flex flex-col md:flex-row gap-4">
  <div className="w-full md:w-1/2">Content</div>
</div>
```

### Third-Party UI Wrappers

Integrate third-party components following project patterns:

1. **react-select**: Use wrapper component with consistent styling
2. **react-datepicker**: Apply theme classes
3. **rc-tooltip**: Configure positioning and styling
4. **react-toastify**: Use project toast configuration

**Example:**
```tsx
import Select from '@/components/ui/Select';

<Select
  options={options}
  value={selected}
  onChange={handleChange}
  className="custom-select"
/>
```

## Output

- Styled UI components following project conventions
- Consistent use of design tokens
- Responsive layouts that work across breakpoints
- Properly integrated third-party components
- Maintainable SCSS structure

## Error Handling

- **Missing Tokens**: Check token definitions in design system
- **Style Conflicts**: Use CSS specificity or CSS modules to resolve
- **Responsive Issues**: Verify breakpoint usage and test on devices
- **Third-Party Conflicts**: Use SCSS overrides or wrapper components

## Examples

**Example Prompts:**
- "Style this button component using Tailwind"
- "Make this layout responsive for mobile and desktop"
- "Integrate react-select with our design tokens"
- "Create a card component following our styling conventions"

**Example Component:**
```tsx
import { Button } from '@/components/ui/Button';

export function Card({ title, children }) {
  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <h2 className="text-xl font-semibold mb-4">{title}</h2>
      <div className="space-y-4">{children}</div>
      <Button className="mt-4">Action</Button>
    </div>
  );
}
```

## Resources

- Tailwind CSS Documentation
- Project Design System
- Component Library Documentation
- SCSS Style Guide
