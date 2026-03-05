# ChartSwap Frontend — UI & Styling Findings

Last audited: 2026-02-17  
App: Next.js frontend in `ontellus.chartswap/` (Pages Router).

This document summarizes **how UI/styling is implemented in this repo** (packages, conventions, tokens, and where to extend things). It’s intended to be used as source material for creating a dedicated **UI/styling Cursor skill**.

---

## Styling stack (what’s actually used)

### Tailwind CSS + PostCSS

- **Tailwind**: `tailwindcss` (devDependency), configured in `tailwind.config.js`.
- **PostCSS**: `postcss` + `autoprefixer`, configured in `postcss.config.js`.
- **Tailwind is loaded via SCSS**: `src/styles/globals.scss` starts with Tailwind directives:
  - `@tailwind base;`
  - `@tailwind components;`
  - `@tailwind utilities;`

Files:
- `tailwind.config.js`
- `postcss.config.js`
- `src/styles/globals.scss`

### Sass (global SCSS)

- **Sass is installed** (`sass` dependency) but this repo currently appears to use it primarily for **one global stylesheet**:
  - `src/styles/globals.scss`
- There are **no CSS Modules** in this codebase (no `*.module.css` / `*.module.scss` found in `ontellus.chartswap/` during this audit).

### Vendor CSS imports (component-level)

The app also imports some third-party CSS directly from packages:

- **React Toastify CSS** imported in layout:
  - `src/components/Layout/Layout.tsx`: `import "react-toastify/dist/ReactToastify.css";`
- **React Datepicker CSS** imported inside the Datepicker component:
  - `src/components/UI/Datepicker/Datepicker.tsx`: `import "react-datepicker/dist/react-datepicker.css";`
- **rc-tooltip CSS** imported where used:
  - `src/components/Requests/CreateNewRequest/RecordDetails/RecordInformation/RecordInformation.tsx`: `import "rc-tooltip/assets/bootstrap_white.css";`

---

## Tailwind configuration (design tokens in `tailwind.config.js`)

### Content scanning

- `content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"]`

### Extended tokens (important)

**Z-index tokens** (semantic names used for layering):

- `content: 60`
- `navbar: 65`
- `sidebar: 70`
- `modalContainer: 2000`
- `overlay: 2010`
- `floating: 2015`
- `modal: 2020`
- `overSideModalContainer: 2030`
- `overSideModalOverlay: 2040`
- `overSideModal: 2050`
- `tooltip: 2070`

**Color tokens** (note the slash naming like `primary/300`):

- `primary/100`, `primary/200`, `primary/300`
- `secondary/100`, `secondary/200`, `secondary/300`
- `teritary/100`…`teritary/600` (spelled `teritary` in config)
- `grey/100`, `grey/200`, `grey/300`
- `danger/100`, `danger/300`

**Spacing tokens** (PDF-specific):

- `halfPDF: "73.55417mm"`
- `fullPDF: "158mm"`

File:
- `tailwind.config.js`

---

## Global stylesheet (`src/styles/globals.scss`)

This file functions as the project’s “global UI layer” and includes:

- **Global font + margin reset**:
  - `* { font-family: "Roboto", sans-serif; margin: 0; }`
- **Base layout height + background** via Tailwind `@apply`:
  - `html, body, #__next { height: 100%; @apply bg-grey/100; }`
- **Utility classes** defined under `@layer utilities`, including (examples):
  - `.table-custom` (table layout + nested styles using `@apply`)
  - `.animate-shadowRolling` (custom keyframe animation + Tailwind `@apply`)
  - `.rtl` (direction override)
- **Global overrides / fixes** for third-party UI:
  - `react-datepicker` z-index and triangle positioning
  - `rc-tooltip` arrow styling (placement-specific)
- **Custom scrollbar** styling via `::-webkit-scrollbar*`
- **A global `<button>` reset**:
  - `button { all: unset; ... cursor: pointer; }`
  - Implication: every button must explicitly set needed layout/typography/interaction styles via classes.
- **Typography utility classes** (non-Tailwind) like:
  - `.paragraph-large`, `.label-medium`, etc.

Notable: `globals.scss` also defines **SCSS color variables** (`$Primary300`, `$Grey200`, etc.) which largely mirror Tailwind’s custom palette.

File:
- `src/styles/globals.scss`

---

## Font loading (Roboto)

- Font is loaded via Google Fonts in `src/pages/_document.tsx`:
  - `<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap" />`

File:
- `src/pages/_document.tsx`

---

## Reusable UI component library (project “design system”)

### Where it lives

The core reusable UI primitives/components live under:

- `src/components/UI/`

This folder includes (non-exhaustive categories seen during audit):

- **Inputs**: `TextInput`, `TextAreaInput`, `NumericInput`, `Checkbox`, `Radio`, `Datepicker`
- **Buttons/links**: `CSButton`, `CSLink`, `ToggleButton`
- **Feedback**: `Toast`, `LoadingToast`, `NotificationMessage`, `AlertBanner`, `SkeletonLoader`, `OverlayLoader`
- **Navigation**: `Tabs`, `TabFilter`, `CSPagination`, `NavigationSteps`
- **Data display**: `Table/*`, `Badge`, `Card`, `Chip`, `Divider`
- **Overlays**: `Popups/Modal`, `Popups/Dialog`, `Popups/Drawer`, `Popups/ModalContainer`, `InlineModal`
- **Selects**: `Dropdown`, `MultiSelect` (wrapping `react-select`)
- **Tooltip**: `CSTooltip` (wrapping `rc-tooltip`)

### Primary styling pattern

- Most UI components style via **Tailwind class strings** (often built with template literals).
- Some components combine Tailwind with **inline style objects** (notably `react-select` style config).
- `tailwind-merge` is available and used selectively to merge computed class strings:
  - Example: `RecordInformation.tsx` merges a computed width class and a dynamic `customClass`.

Key files (examples):
- `src/components/UI/CSButton/CSButton.tsx`
- `src/lib/server/services/Client/CSButton/CSButtonHelper.ts` (variant/size class helpers)
- `src/components/UI/Dropdown/Dropdown.tsx`
- `src/components/UI/Dropdown/DropdownDefaultStyle.ts` (react-select style object)
- `src/components/UI/Datepicker/Datepicker.tsx`
- `src/components/UI/CSTooltip/CSTooltip.tsx`

---

## UI-related packages (from `package.json`)

### Tailwind / styling tooling

- `tailwindcss` (devDependency)
- `postcss` (devDependency)
- `autoprefixer` (devDependency)
- `sass`
- `tailwind-merge`

### UI widgets / visuals

- `@phosphor-icons/react` (icon set; widely used across pages + UI components)
- `react-select` (wrapped by `src/components/UI/Dropdown/*` + `MultiSelect/*`)
- `react-datepicker` (wrapped by `src/components/UI/Datepicker/*`, with global overrides in `globals.scss`)
- `rc-tooltip` (wrapped by `src/components/UI/CSTooltip/CSTooltip.tsx`, plus CSS import in some pages)
- `react-toastify` (toast notifications; container is mounted in layout)

File:
- `package.json`

---

## Design tokens (where to look)

### Tailwind tokens

- `tailwind.config.js` is the authoritative source for:
  - semantic `zIndex.*`
  - palette keys like `primary/300`, `grey/200`, etc.
  - PDF spacing tokens

### TypeScript tokens

- `src/constants/UI/ColorEnum.ts`: color hex values used in inline styles (e.g. react-select styles, icon colors).
- `src/constants/UI/DefaultStyles.ts`: shared inline styles (e.g. tooltip inner styles).

### SCSS tokens / global utilities

- `src/styles/globals.scss`: SCSS variables + global typography classes + component overrides.

Important note: **colors exist in three places** (Tailwind config, SCSS variables, and `ColorEnum`). If you’re building a UI skill, it should strongly encourage **reusing existing tokens** rather than introducing new color sources.

---

## App composition points affecting UI

### Global CSS is wired in `_app.tsx`

- `src/pages/_app.tsx` imports `@/styles/globals.scss` once for the entire app.

### Toasts are mounted in the main Layout

- `src/components/Layout/Layout.tsx` renders `<ToastContainer ... />`
- Any `toast(...)` calls in hooks/components will use this container.

---

## Linting / formatting standards (what’s enforced vs documented)

### Enforced (ESLint)

- `.eslintrc.json` extends `next/core-web-vitals`
- `react-hooks/exhaustive-deps` is turned **off**

File:
- `.eslintrc.json`

### Documented “standards” (skills docs)

There are existing standards documents under `chartswap.root.repo/.agent/skills/`, notably:

- `chartswap.root.repo/.agent/skills/nextjs-code-standards/SKILL.md`
- `chartswap.root.repo/.agent/skills/nextjs-code-standards/reference.md`
- `chartswap.root.repo/.agent/skills/pr-review/references/chartswap-standards.md`

Practical observation: some documented items (e.g., “single quotes”, “no semicolons”, “kebab-case directories”, “Tailwind exclusively”, “Zustand”, “Zod”) **do not fully match** the current codebase conventions/choices (the code frequently uses double quotes + semicolons; directories are often PascalCase; there is global SCSS + vendor CSS; forms use Formik/Yup).

If you’re creating a **UI skill**, it should follow **observed repo patterns first**, and treat the skills docs as “aspirational” unless/until the repo is refactored to match them.

---

## Conventions & patterns to encode into a UI skill (high-signal)

- **Prefer using existing primitives in `src/components/UI/`** before introducing new one-off UI.
- **Use Tailwind tokens** (`primary/300`, `z-navbar`, etc.) rather than hardcoding colors/z-index.
- **When you must use inline styles**, prefer `ColorEnum` and existing shared style objects (e.g. react-select styles).
- **Global overrides belong in `src/styles/globals.scss`**, especially for third-party components (datepicker, tooltip, scrollbar).
- **Be careful with `<button>`**: global `all: unset` means semantics remain, but all appearance must be rebuilt with classes.
- **Use `tailwind-merge`** when combining computed Tailwind class fragments that may conflict (e.g. conditional border/background/spacing).
- **Font**: Roboto is assumed globally; don’t introduce additional font-loading mechanisms unless necessary.

---

## Quick file map (UI/styling hotspots)

- Tailwind: `tailwind.config.js`
- PostCSS: `postcss.config.js`
- Global styles + overrides: `src/styles/globals.scss`
- Global CSS import: `src/pages/_app.tsx`
- Font + document head: `src/pages/_document.tsx`
- UI primitives: `src/components/UI/**`
- Button style system: `src/components/UI/CSButton/CSButton.tsx`, `src/lib/server/services/Client/CSButton/CSButtonHelper.ts`
- Dropdown/Select style system: `src/components/UI/Dropdown/*`
- Tooltip wrapper: `src/components/UI/CSTooltip/CSTooltip.tsx`
- Toast container: `src/components/Layout/Layout.tsx`

