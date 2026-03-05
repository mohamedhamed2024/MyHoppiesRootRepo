# Next.js Code Standards — Reference

Detailed rules referenced from [SKILL.md](SKILL.md).

---

## Code style (full)

**Indentation and punctuation**
- Tabs for indentation
- Single quotes for strings (except to avoid escaping)
- Omit semicolons unless required for disambiguation

**Variables and spacing**
- No unused variables
- Space after keywords and before function parentheses
- Strict equality (`===`) only
- Space around infix operators and after commas

**Control flow**
- Else on same line as closing brace
- Curly braces for multi-line conditionals

**Callbacks and formatting**
- Always handle error parameters in callbacks
- Line length ≤ 80 characters
- Trailing commas in multiline object/array literals

---

## Naming conventions (full)

| Convention | Use for | Examples |
|------------|---------|----------|
| **PascalCase** | Components, types, interfaces | `UserProfile`, `AuthWizard`, `OrderItem` |
| **kebab-case** | Directories, file names | `components/auth-wizard`, `user-profile.tsx` |
| **camelCase** | Variables, functions, methods, hooks, props | `getUserById`, `handleSubmit`, `useAuth` |
| **UPPERCASE** | Env vars, constants, global config | `API_URL`, `MAX_RETRIES`, `DEFAULT_TIMEOUT` |

**Patterns**
- Event handlers: `handleClick`, `handleSubmit`, `handleChange`
- Booleans: `isLoading`, `hasError`, `canSubmit`
- Custom hooks: `useAuth`, `useForm`, `useOrder`
- Prefer full words; allow: err, req, res, props, ref

---

## Zustand store structure and performance

**Store structure**
- Dedicated `stores/` directory or feature-scoped directory
- Export the store hook and typed selectors
- Name hooks `use<Feature>Store` (e.g. `useAuthStore`, `useOrderStore`)

**Performance**
- Use shallow comparison or selectors to avoid unnecessary re-renders
- Avoid subscribing to the whole store
- Keep actions synchronous
- Validate before persisting

**Avoid**
- Single giant store
- Mixing UI and business state
- Mutating nested refs
- Storing raw API responses
- Using Zustand as server cache
- Using React Context for new API/server state (use Zustand instead; existing Context may remain)

---

## Backend / API integration (summary)

For API route location (`src/pages/api/`), prefixes (`/api/` internal, `apexrest/` external), env vars (`NEXT_PUBLIC_BASE_API_URL`), and the common pattern (`AxiosClientMiddleware`, `AxiosServerMiddleware`, `RouteHandler`, `ENDPOINTS` / `EXTERNAL_ENDPOINTS` in `AppConfig.ts`), see [SKILL.md](SKILL.md) — section **Backend / Salesforce integration**.
