---
name: ui-styling
description: UI and styling conventions for the Ontellus ChartSwap Next.js frontend (`ontellus.chartswap/`). Use when creating or modifying UI components, Tailwind styles, global SCSS overrides, tokens (colors/z-index/spacing), responsive layout, and third-party UI wrappers (react-select, react-datepicker, rc-tooltip, react-toastify).
---

# ChartSwap UI & Styling (New Portal)

Apply this skill to **UI/styling work** in the Next.js app under `ontellus.chartswap/` (Pages Router).

Keep changes consistent with the repo’s existing patterns:

- Prefer existing reusable UI primitives in `src/components/UI/` over one-off markup.
- Prefer Tailwind utilities and existing Tailwind tokens (colors, z-index).
- Put cross-cutting overrides and vendor component tweaks in `src/styles/globals.scss`.

## Repo reality (styling stack and wiring)

- **Tailwind is loaded via SCSS**: `ontellus.chartswap/src/styles/globals.scss` contains `@tailwind base/components/utilities`.
- **Global styles are imported once** in `ontellus.chartswap/src/pages/_app.tsx` (`import "@/styles/globals.scss";`).
- **Sass is used for one global stylesheet** (`globals.scss`); there are **no CSS modules** (`*.module.css` / `*.module.scss`) in the app during the audit.
- **Vendor CSS imports exist** (don’t “purify” them away):
  - `react-toastify/dist/ReactToastify.css` is imported in `src/components/Layout/Layout.tsx`
  - `react-datepicker/dist/react-datepicker.css` is imported in `src/components/UI/Datepicker/Datepicker.tsx`
  - `rc-tooltip/assets/bootstrap_white.css` is imported in a feature area where needed
- **Font**: Roboto is loaded in `src/pages/_document.tsx` (Google Fonts link). Don’t introduce new font-loading approaches unless required.

## Workflow (use this order)

1. **Find the closest existing UI primitive**
   - Search under `ontellus.chartswap/src/components/UI/` first (button, input, dropdown, modal, table, etc.).
   - If a primitive exists, extend it or reuse it rather than adding duplicate UI behavior elsewhere.

2. **Use project tokens instead of inventing new ones**
   - **Tailwind tokens**: use keys like `primary/300`, `grey/200`, `z-navbar`, etc. (see `tailwind.config.js`).
   - **TypeScript tokens**: when you need inline styles (e.g., `react-select` style objects), use `src/constants/UI/ColorEnum.ts`.

3. **Choose the right styling mechanism**
   - **Tailwind `className`**: default for components.
   - **`tailwind-merge`**: use when combining conditional class strings that might conflict.
   - **Inline style objects**: acceptable for libraries that require them (notably `react-select`).
   - **Global overrides**: use `src/styles/globals.scss` for:
     - vendor component overrides (datepicker, tooltip, scrollbar)
     - shared utility classes used across the app

4. **Use the repo wrappers for third-party UI**
   - Dropdown/Select: `src/components/UI/Dropdown/*` (wraps `react-select`)
   - Date picker: `src/components/UI/Datepicker/*` (wraps `react-datepicker`)
   - Tooltip: `src/components/UI/CSTooltip/CSTooltip.tsx` (wraps `rc-tooltip`)
   - Toasts: call `toast(...)`; container is already mounted in `src/components/Layout/Layout.tsx`

5. **Be careful with global button reset**
   - `src/styles/globals.scss` resets `button { all: unset; ... }`
   - Any new `<button>` must explicitly set:
     - layout (flex/grid), padding, border, background
     - focus/hover/active states
     - disabled states

## Do / Don’t (to stay consistent with this repo)

- **Do** reuse existing Tailwind palette keys like `primary/300`, `grey/200`, `danger/300`, and z-index keys like `z-navbar`, `z-tooltip`.
- **Do** use `ColorEnum` when a library forces inline styles (e.g., `react-select` style objects).
- **Do** put third-party component overrides in `globals.scss` when they’re global concerns (e.g., datepicker z-index issues).
- **Don’t** add a second source of truth for colors (avoid inventing new hex constants outside Tailwind/`ColorEnum`/global SCSS variables).
- **Don’t** introduce CSS modules “just because”; the app is currently structured around Tailwind + one global SCSS layer.

## Common edits (where to change things)

- **Theme tokens**
  - Tailwind: `ontellus.chartswap/tailwind.config.js`
  - TS color enum: `ontellus.chartswap/src/constants/UI/ColorEnum.ts`

- **Global overrides / utilities / typography**
  - `ontellus.chartswap/src/styles/globals.scss`
  - Useful for global typography helpers (`.label-medium`, etc.), scrollbar styles, and vendor overrides (datepicker/tooltip).

- **Buttons**
  - Component: `ontellus.chartswap/src/components/UI/CSButton/CSButton.tsx`
  - Variant/size classes: `ontellus.chartswap/src/lib/server/services/Client/CSButton/CSButtonHelper.ts`

- **react-select styling**
  - Default styles: `ontellus.chartswap/src/components/UI/Dropdown/DropdownDefaultStyle.ts`
  - Component: `ontellus.chartswap/src/components/UI/Dropdown/Dropdown.tsx`

## Reference

For the full repo audit (packages used, tokens, file map, and observed conventions), read:

- `references/repo-ui-styling.md`
