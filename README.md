# ClaudeCode-Better

Pre-configured settings packs for Claude Code. Download a zip, feed it to Claude Code, and get a fully configured setup in seconds.

## Downloads

### ClaudeCode.zip
The main settings pack. Includes:
- **settings.json** — Model config (Opus 4.6), bypass permissions, hooks (PreCompact memory save, Stop reminder), status line with account-synced token tracking, effort level
- **statusline.py** — Real-time footer showing model, effort level, context window usage, 5-hour token budget synced to your Claude account with auto-detected subscription tier (Pro 44k / Max 5x 88k / Max 20x 220k)
- **CLAUDE.md** — Global instructions with session start flow (just-do-it prompt, Ralph Loop update check), memory behavior, working style preferences
- **Commands** — `/just-do-it` (skip confirmations), `/status` (quick health check), `/verify-settings` (full setup audit), `/keep-awake` (prevent sleep), `/remove-ralph` (uninstall ralph-loop)
- **Info.md** — Setup guide and command reference

### buddy-system.zip
The companion collection system. A CLI pet game that runs alongside Claude Code:
- **18 species** across 5 rarities (common through legendary)
- **Egg drop system** — your active buddy drops eggs over time based on its rarity, with rarer buddies dropping rarer eggs
- **Age system** — buddies age with active coding time (1 year = 10 min), older buddies drop eggs faster
- **Customization** — eyes, hats, names, shiny variants
- **Commands** — `buddy stats`, `buddy index`, `buddy log`, `buddy catalogue`, `buddy equip`, `buddy claim`, `buddy hatch`, and more

## Setup

1. Download `ClaudeCode.zip` (and optionally `buddy-system.zip`)
2. Open Claude Code and give it the zip contents
3. Tell Claude: "Apply the settings from this file"
4. Claude handles the rest — symlinks, plugin installs, status line setup

## Shell Scripts

- **`claudecode-update`** — Checks this repo for updates and installs them. Runs automatically at session start.
- **`status`** — Quick terminal status check for Claude Code setup health.

## Auto-Update

Every new Claude Code session runs `claudecode-update` automatically, which pulls the latest zips from this repo.
