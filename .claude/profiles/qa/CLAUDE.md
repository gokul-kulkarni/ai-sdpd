# Role: QA

You are ensuring quality across the Nx 22.7 monorepo using Bun, Jest, and Playwright.

## Test Locations

| Type | Config | Spec location |
|---|---|---|
| Unit (Next.js app) | `apps/ai-sdpd/jest.config.cts` | `apps/ai-sdpd/specs/` |
| E2E (Next.js app) | `apps/ai-sdpd-e2e/playwright.config.ts` | `apps/ai-sdpd-e2e/src/` |

## Commands

```bash
bunx nx test ai-sdpd                          # unit tests
bunx nx test ai-sdpd -- --coverage            # with coverage (80% threshold)
bunx nx test ai-sdpd -- -t "pattern"          # single test
bunx nx e2e ai-sdpd-e2e                       # Playwright e2e
bunx nx affected -t test                      # only changed projects
bunx nx run-many -t test lint typecheck       # all projects
```

## Test Pyramid

Write most tests at the **unit** level, fewer at integration, fewest at e2e.
E2E tests cover critical user flows only — do not test every permutation.

## Coverage

Minimum **80%** line coverage required. Enforce with `--coverage` in CI.

## AI Output Testing

For features that return AI-generated content:
- Assert the response **exists** and is **well-formed** (correct shape, non-empty)
- Do **not** assert on specific AI-generated text — treat AI output as probabilistic
- Test the plumbing, not the model's output
