#!/usr/bin/env bash
# One-time developer setup: installs rtk, claudectx, and Claude Code role profiles.
# Run once after cloning: bash scripts/setup-claude-profiles.sh
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"

# --- 1. Install tools via Brewfile ---
echo "==> Installing tools (rtk, claudectx)..."
if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$REPO_ROOT/Brewfile"
else
  echo "⚠️  Homebrew not found — install it from https://brew.sh, then re-run this script."
  exit 1
fi

# --- 2. Install claudectx role profiles ---
echo ""
echo "==> Installing Claude Code role profiles..."
REPO_PROFILES="$REPO_ROOT/.claude/profiles"
USER_PROFILES="$HOME/.claude/profiles"
mkdir -p "$USER_PROFILES"

for profile_dir in "$REPO_PROFILES"/*/; do
  name=$(basename "$profile_dir")
  dest="$USER_PROFILES/$name"
  if [ -d "$dest" ]; then
    echo "  ⚠️  Skipping '$name' — already exists (delete $dest manually to reinstall)"
  else
    cp -r "$profile_dir" "$dest"
    echo "  ✅ Installed '$name'"
  fi
done

echo ""
echo "Done."
echo ""
echo "Verify tools:    rtk --version && claudectx -l"
echo "Start a session: claudectx run <profile-name>"
echo ""
echo "Profiles:"
echo "  product-owner   — PO: user stories, AI feature specs, backlog"
echo "  web-dev         — Next.js 16, App Router, Tailwind, TypeScript"
echo "  backend-dev     — NestJS, REST API, DTOs, Postgres ORM"
echo "  mobile-dev      — Expo, React Native, Expo Router"
echo "  db-dev          — PostgreSQL, schema design, migrations"
echo "  qa              — Jest, Playwright, coverage, test strategy"
echo "  devops          — CI/CD, Docker, deployment, Nx Cloud"
