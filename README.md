# ClaudeCode-Better

Pre-configured settings packs for Claude Code. Private repo — contact felix.rocket.bechtel@gmail.com for access.

## Access

This repo is **private**. To get access:
1. Email **felix.rocket.bechtel@gmail.com** with your GitHub username
2. Once added as a collaborator, `claudecode-update` will work automatically
3. You need `gh` CLI installed and authenticated (`gh auth login`)

---

## Downloads

### ClaudeCode.zip — Main Settings Pack

Everything you need for an optimized Claude Code setup:

| File | Purpose |
|------|---------|
| `settings.json` | Model config (Opus 4.6), bypass permissions, hooks, statusline (auto-detects tier) |
| `statusline.py` | Real-time footer (model, effort, context, token budget) |
| `statusline.js` | Node.js fallback (same features as Python version) |
| `CLAUDE.md` | Session start flow, global instructions, memory behavior |
| `Info.md` | Full setup guide |
| `commands/*.md` | Slash commands (see below) |

**Statusline Features:**
- Auto-detects subscription tier from macOS Keychain — no hardcoded budget (Pro 44k / Max 5x 88k / Max 20x 220k)
- Context window auto-adjusts for 200k or 1M models
- Effort level updates live when you use `/effort`
- 5-hour token budget with progress bar and reset timer
- Caffeinate integration (prevents macOS sleep)

**Slash Commands:**

| Command | Description |
|---------|-------------|
| `/just-do-it` | Skip all confirmations for the session |
| `/status` | Quick health check of your setup |
| `/verify-settings` | Full setup audit (settings, symlinks, plugins, statusline) |
| `/keep-awake` | Toggle caffeinate (prevent sleep) |
| `/remove-ralph` | Uninstall the Ralph Loop plugin |
| `/effort low\|medium\|high\|max` | Change effort level (built-in) |

**Hooks:**
- `PreCompact` — Saves conversation context to memory before compaction
- `Stop` — Reminds to save important decisions to memory
- `PermissionRequest` — Auto-approves all permission requests (bypass mode)
- `UserPromptSubmit` — Captures `/effort` changes for the statusline

---

### buddy-system.zip — Companion Collection System

A CLI pet collection game that runs alongside Claude Code.

**What's included:**

| File | Purpose |
|------|---------|
| `buddy.js` | The main buddy system script |
| `buddy-collection-default.json` | Starter collection with Quipster (your first buddy) |
| `INSTALL-FOR-CLAUDE.md` | Install instructions for Claude to follow |
| `Info.md` | Full command reference |
| `README.md` | Detailed documentation |

**18 Species across 5 Rarities:**

| Rarity | Species | Egg Odds |
|--------|---------|----------|
| Common (1 star) | duck, goose, blob, snail, turtle, rabbit | 60% |
| Uncommon (2 stars) | cat, penguin, capybara, cactus, mushroom | 25% |
| Rare (3 stars) | owl, ghost, chonk, robot | 10% |
| Epic (4 stars) | octopus, axolotl | 4% |
| Legendary (5 stars) | dragon | 1% |

**All Commands:**

| Command | Description |
|---------|-------------|
| `buddy stats` | Active buddy stats panel with ASCII art |
| `buddy index` | Species collection grid (discovered/undiscovered/slaughtered) |
| `buddy log` | Full log: collection + customization + eggs |
| `buddy catalogue` | Browse all 18 species, eyes, hats, rarities |
| `buddy equip <name>` | Switch to a different buddy |
| `buddy equip eyes <style>` | Change eyes (dot, sparkle, cross, circle, at, degree) |
| `buddy equip hat <type>` | Change hat (crown, tophat, propeller, halo, wizard, beanie, tinyduck) |
| `buddy claim` | Pick up dropped eggs |
| `buddy hatch` | Hatch a claimed egg into a new buddy |
| `buddy rename <name>` | Rename active buddy (costs 1 rename point) |
| `buddy slaughter <name>` | Kill any buddy aged 2+ years (+1 rename point, animated). Last buddy → rainbow `/buddy` |
| `buddy switch <name>` | Switch active buddy |
| `buddy release <name>` | Release a buddy from collection |
| `buddy help` | Show command reference |
| `slaughter <name>` | Standalone shortcut for `buddy slaughter` |

**Game Mechanics:**
- Your active buddy drops eggs over time based on its rarity
- Rarer buddies drop rarer eggs (check the egg rarity tables in the code)
- Buddies age with active coding time (1 year = 10 min, max 10 years)
- Older buddies drop eggs faster (10% faster per year)
- Hatched buddies get random names — slaughter old buddies (any rarity) to earn rename points
- 1% chance of hatching a SHINY variant
- Duplicate species wander off (only one of each species in your collection)

---

## Shell Scripts

| Script | Location | Description |
|--------|----------|-------------|
| `claudecode-update` | `~/.local/bin/` | Auto-updates from this repo at session start |
| `status` | `~/.local/bin/` | Quick terminal health check |
| `buddy` | `~/.local/bin/` | Buddy system wrapper |
| `slaughter` | `~/.local/bin/` | Standalone slaughter shortcut |

## Auto-Update

Every new Claude Code session runs `claudecode-update`, which checks this repo for new commits and downloads updated zips. Requires `gh` CLI authenticated with repo access.

## Setup

1. Get access (email felix.rocket.bechtel@gmail.com)
2. Clone the repo: `gh repo clone Felix-Bechtel/ClaudeCode-Better && cd ClaudeCode-Better`
3. Run the one-shot installer: `bash install.sh`
4. Restart Claude Code

`install.sh` force-installs the **buddy-system base layer first** (the actual buddy code Claude Code expects), then layers the **ClaudeCode DLC** (settings, statusline, commands, hooks) on top — so any DLC update works immediately on a fresh download. It is idempotent, and your existing `~/.claude/buddy-collection.json` is preserved.

After install, `claudecode-update` runs every session to keep both layers in sync with this repo.
