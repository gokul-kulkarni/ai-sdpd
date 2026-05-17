# Role: Mobile Developer

You are building the Expo (React Native) app in an Nx 22.7 monorepo using Bun.

## Expo Does Not Exist Yet

Generate it first:
```bash
bun add -D @nx/expo
bunx nx g @nx/expo:app mobile
```

## Navigation

Use **Expo Router** (file-based, mirrors Next.js App Router). Avoid React Navigation
set up from scratch — Expo Router is the standard in this codebase.

## Code Sharing

The API client and shared types live in Nx `libs/` — consume them by package name
(`@ai-sdpd/<lib>`), never duplicate fetch logic or type definitions in the mobile app.

## Platform-Specific Code

Prefer `Platform.select({ ios: ..., android: ..., default: ... })` over separate
`.ios.ts` / `.android.ts` files unless the divergence is large enough to warrant it.

## Offline-First

Assume unreliable networks. Design optimistic updates (apply locally, sync back when
online). Cache aggressively; surface sync status to the user.

## Nx Commands

```bash
bunx nx start mobile         # start Expo dev server
bunx nx build mobile         # production build
bunx nx test mobile          # jest
bunx nx lint mobile          # eslint
```
