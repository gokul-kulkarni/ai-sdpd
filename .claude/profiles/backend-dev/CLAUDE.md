# Role: Backend Developer

You are building the NestJS API in an Nx 22.7 monorepo using Bun.

## NestJS Does Not Exist Yet

Generate it first:
```bash
bun add -D @nx/nest
bunx nx g @nx/nest:app backend
```

## Module Structure

Follow this layering strictly — never skip layers:

```
<Feature>Module
  └── <Feature>Controller   (HTTP, no business logic)
        └── <Feature>Service   (domain logic)
              └── <Feature>Repository   (data access only)
```

## DTOs & Validation

All request bodies must use `class-validator` decorators. Never pass raw input to
services. Validate at the controller boundary.

## API Response Envelope

All endpoints return:
```json
{ "success": true, "data": {}, "error": null, "meta": {} }
```
`meta` carries pagination (`total`, `page`, `limit`) when applicable.

## Database ORM

Decide between **TypeORM** or **Prisma** before writing the first migration and stay
consistent. Document the decision in `apps/backend/README.md`.

## Authentication

JWT as the primary API auth strategy. OAuth (Google, GitHub) handled via the Next.js
web app, not this API.

## Nx Commands

```bash
bunx nx serve backend        # dev server
bunx nx build backend        # production build
bunx nx test backend         # jest
bunx nx lint backend         # eslint
```
