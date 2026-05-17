# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Goal

`ai-sdpd` is an **AI-native task management tool** — a JIRA-like system where AI is a
first-class part of the workflow (not a bolt-on). Intended surface area:

- **Web**: Next.js (App Router)
- **Backend API**: NestJS
- **Mobile**: Expo (React Native)
- **Database**: PostgreSQL

> ⚠️ **Current state**: the repo is a fresh Nx workspace containing only the scaffolded
> Next.js app (`apps/ai-sdpd`) and its Playwright e2e project (`apps/ai-sdpd-e2e`).
> NestJS, Expo, Postgres, and any shared libraries **do not exist yet** and must be
> generated/added. Do not assume backend, mobile, or DB code exists — check first.

## Monorepo Layout & Tooling

This is an **Nx 22.7 monorepo** managed with **Bun** (`bun.lock`, `workspaces: ["apps/*"]`).
Use `bun` for dependency operations and `bunx nx` (or `npx nx`) to drive tasks.

- Nx targets are **inferred from plugins** (see `nx.json` `plugins`), not declared in
  `project.json`. There are no `project.json` files — targets like `dev`, `build`,
  `lint`, `test`, `e2e`, `typecheck` come from `@nx/next`, `@nx/eslint`, `@nx/jest`,
  `@nx/playwright`, `@nx/js/typescript` respectively.
- TypeScript path aliases use Nx's **workspace package** model via the
  `customConditions: ["@ai-sdpd/source"]` setting in `tsconfig.base.json`. New shared
  libraries should be consumed by their package name (e.g. `@ai-sdpd/<lib>`), not by
  deep relative paths.
- TS is **strict** with `noUnusedLocals`, `noImplicitReturns`,
  `noFallthroughCasesInSwitch`, `noImplicitOverride` enabled — unused locals and
  missing returns are hard errors.
- Project naming: Nx projects are scoped `@ai-sdpd/<name>`; the web app's Nx project
  name is `ai-sdpd`.

## Commands

Run from the repo root. Replace `ai-sdpd` with the target project as new apps are added.

```sh
bun install                      # install dependencies (uses bun.lock)

bunx nx dev ai-sdpd              # run web dev server
bunx nx build ai-sdpd            # production build
bunx nx lint ai-sdpd             # eslint
bunx nx typecheck ai-sdpd        # tsc --noEmit
bunx nx test ai-sdpd             # jest unit tests
bunx nx e2e ai-sdpd-e2e          # Playwright e2e

bunx nx run-many -t lint test typecheck   # all projects, one target set
bunx nx affected -t test                  # only projects affected by current changes
bunx nx show project ai-sdpd              # list all available targets for a project
bunx nx graph                             # visualize project graph
```

Run a single unit test:

```sh
bunx nx test ai-sdpd -- --testFile=path/to/file.spec.tsx
# or pass jest args through:
bunx nx test ai-sdpd -- -t "test name pattern"
```

Generators (when adding the planned surfaces):

```sh
bunx nx g @nx/next:app <name>          # additional Next.js app
bunx nx g @nx/react:lib <name>         # shared library
# NestJS / Expo require adding @nx/nest and @nx/expo plugins first, then their generators
```

## Architectural Notes

- **`apps/ai-sdpd`** is a Next.js App Router app. API route handlers live under
  `src/app/api/**/route.ts` — these are the current stand-in for backend logic but
  should migrate to the NestJS service once it exists. Keep web↔API contracts in a
  shared library so the Next.js app, NestJS backend, and Expo client stay in sync.
- **`apps/ai-sdpd-e2e`** drives the running web app via Playwright; its `webServer`
  config in `playwright.config.ts` controls how the app under test is started.
- When introducing the backend/mobile/db, prefer **shared Nx libraries** for domain
  models, API DTOs, and validation schemas so types are enforced across web, mobile,
  and API. This is the main reason to keep things in this monorepo.
- Styling is **Tailwind CSS 3** (`apps/ai-sdpd/tailwind.config.js`); global styles in
  `src/app/global.css`.

## Onboarding (run once after cloning)

```sh
bash scripts/setup-claude-profiles.sh
```

This installs two required tools via Homebrew (`Brewfile`) and sets up Claude Code
role profiles:

- **rtk** — token-optimized CLI proxy (60-90% token savings on dev operations).
  The RTK hook is pre-configured in `.claude/settings.json` — it activates automatically
  for everyone who opens this repo in Claude Code, no per-machine setup needed.
- **claudectx** — role-based Claude Code sessions

**Start a session in a role:**
```sh
claudectx run product-owner   # PO: user stories, AI feature specs, backlog
claudectx run web-dev         # Next.js 16, App Router, Tailwind
claudectx run backend-dev     # NestJS, REST API, DTOs
claudectx run mobile-dev      # Expo, React Native, Expo Router
claudectx run db-dev          # PostgreSQL, schema, migrations
claudectx run qa              # Jest, Playwright, coverage
claudectx run devops          # CI/CD, Docker, deployment
```

Always use `claudectx run` (not bare `claudectx`) — it keeps your global Claude config
untouched and allows concurrent role sessions.

## Conventions

- Follow the immutability and file-organization rules in the user's global rules:
  prefer many small, feature-organized files; never mutate inputs, return new objects.
- Commit messages use Conventional Commits (`feat:`, `fix:`, `refactor:`, etc.).
- Nx Cloud analytics is enabled (`nx.json` `analytics: true`).
