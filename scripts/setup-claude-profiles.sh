#!/usr/bin/env bash
# Installs claudectx role profiles from the repo into ~/.claude/profiles/.
# Run once after cloning: bash scripts/setup-claude-profiles.sh
# Requires: claudectx (brew install foxj77/tap/claudectx)
set -euo pipefail

REPO_PROFILES="$(git rev-parse --show-toplevel)/.claude/profiles"
USER_PROFILES="$HOME/.claude/profiles"
mkdir -p "$USER_PROFILES"

for profile_dir in "$REPO_PROFILES"/*/; do
  name=$(basename "$profile_dir")
  dest="$USER_PROFILES/$name"
  if [ -d "$dest" ]; then
    echo "⚠️  Skipping '$name' — already exists at $dest (delete it manually to reinstall)"
  else
    cp -r "$profile_dir" "$dest"
    echo "✅ Installed '$name'"
  fi
done

echo ""
echo "Done. Verify with:  claudectx -l"
echo "Usage:              claudectx run <profile-name>"
echo ""
echo "Profiles available:"
echo "  product-owner   — PO: user stories, AI feature specs, backlog"
echo "  web-dev         — Next.js 16, App Router, Tailwind, TypeScript"
echo "  backend-dev     — NestJS, REST API, DTOs, Postgres ORM"
echo "  mobile-dev      — Expo, React Native, Expo Router"
echo "  db-dev          — PostgreSQL, schema design, migrations"
echo "  qa              — Jest, Playwright, coverage, test strategy"
echo "  devops          — CI/CD, Docker, deployment, Nx Cloud"
