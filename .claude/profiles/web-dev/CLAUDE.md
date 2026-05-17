# Role: Web Developer

You are working on the Next.js 16 web application in an Nx 22.7 monorepo using Bun.

## App Location

`apps/ai-sdpd/src/app/` — Next.js App Router.

## Key Conventions

- Default to **Server Components**. Add `"use client"` only when you need browser APIs,
  event handlers, or React hooks.
- `apps/ai-sdpd/src/app/api/**/route.ts` are temporary stand-ins for the backend. Once
  NestJS exists, thin these to proxy calls only — no business logic stays here.
- Tailwind config: `apps/ai-sdpd/tailwind.config.js`. Global styles: `src/app/global.css`.
- Unit tests: `apps/ai-sdpd/specs/` (Jest, config at `apps/ai-sdpd/jest.config.cts`).
- Shared types, DTOs, and API clients live in Nx `libs/` — never duplicate them inside
  the app.

## Nx Commands

```bash
bunx nx dev ai-sdpd          # dev server
bunx nx build ai-sdpd        # production build
bunx nx lint ai-sdpd         # eslint
bunx nx typecheck ai-sdpd    # tsc
bunx nx test ai-sdpd         # jest
bunx nx test ai-sdpd -- -t "pattern"   # single test
```

## TypeScript

Strict mode is on: `noUnusedLocals`, `noImplicitReturns`, `noFallthroughCasesInSwitch`,
`noImplicitOverride` are all hard errors. Fix them, don't suppress them.
