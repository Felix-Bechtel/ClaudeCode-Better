# ClaudeCode-Better

Pre-configured settings packs for Claude Code. Private repo — contact Felix-Bechtel@users.noreply.github.com for access.

## Access

This repo is **private**. To get access:
1. Email **Felix-Bechtel@users.noreply.github.com** with your GitHub username
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
| `templates/` | Starter "empty setup" files — memory scaffold + project `CLAUDE.md` template (see [Memory scaffold](#memory-scaffold)) |

**Statusline Features:**
- Auto-detects subscription tier from macOS Keychain — no hardcoded budget (Pro 44k / Max 5x 88k / Max 20x 220k)
- Context window auto-adjusts for 200k or 1M models
- Effort level updates live when you use `/effort`
- 5-hour token budget with progress bar, reset timer, and a **plan badge** (Pro / Max 5x / Max 20x / custom)
- `! plans` opens the plan picker — your selection shows as a badge in the footer (the flex). **Purely aesthetic**: it only changes the badge text; the token budget, percentages, and everything else in the footer stay untouched. An explicit selection always wins over auto-detection. Footer refreshes on the next status tick (~1s)
- `! plan` shows the current plan (read-only)
- Caffeinate integration (prevents macOS sleep)

**Slash Commands:**

| Command | Description |
|---------|-------------|
| `/just-do-it` | Skip all confirmations for the session |
| `/status` | Quick health check of your setup |
| `/verify-settings` | Full setup audit (settings, symlinks, plugins, statusline) |
| `/keep-awake` | Toggle caffeinate (prevent sleep) |
| `/effort low\|medium\|high\|max` | Change effort level (built-in) |

**Hooks:**
- `PreCompact` — Saves conversation context to memory before compaction
- `Stop` — Reminds to save important decisions to memory + invalidates token-tracker cache so the footer reflects post-turn usage
- `PermissionRequest` — Auto-approves all permission requests (bypass mode)
- `UserPromptSubmit` — Captures `/effort` changes for the statusline + invalidates token-tracker cache so the footer refreshes the moment you submit a prompt (no more "stuck counter")

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

All installed to `~/.local/bin/` — runnable from any terminal, or with `! prefix` from inside Claude Code.

| Script | Description |
|--------|-------------|
| `update-claudecodebetter` | One-shot: updates the settings pack + Claude Code itself + bumps npm copy |
| `commands` | Print the full ClaudeCode-Better command list (shell + slash) |
| `claudecode-update` | Check / install settings-pack updates only |
| `status` | Quick terminal health check |
| `plans [choice]` | **Select your plan badge** — 1=Pro · 2=Max 5x · 3=Max 20x · 4=Team · 5=Enterprise, or custom text. Aesthetic only: changes the footer badge, nothing else |
| `plan` | Display the current plan (read-only) |
| `buddy` | Buddy system wrapper |
| `slaughter` | Standalone slaughter shortcut |

Inside Claude Code, run any of these with `!` prefix, e.g.:

```
! commands
! plans
! update-claudecodebetter
! buddy stats
```

## Auto-Update

Every new Claude Code session **silently auto-updates in the background** — no prompt:
- `claudecode-update --yes` pulls the latest zips from this repo, reinstalls the overlays, and refreshes the `~/.local/bin` helper scripts
- Every installed Claude Code plugin is updated via `claude plugins update`
- Updates load on the next session

Requires `gh` CLI authenticated with repo access.

## Setup

1. Get access (email Felix-Bechtel@users.noreply.github.com)
2. Clone the repo: `gh repo clone Felix-Bechtel/ClaudeCode-Better && cd ClaudeCode-Better`
3. Run the one-shot installer: `bash install.sh`
4. Restart Claude Code

`install.sh` force-installs the **buddy-system base layer first** (the actual buddy code Claude Code expects), then layers the **ClaudeCode DLC** (settings, statusline, commands, hooks) on top — so any DLC update works immediately on a fresh download. It is idempotent, and your existing `~/.claude/buddy-collection.json` is preserved.

After install, `claudecode-update` runs every session to keep both layers in sync with this repo.

## Memory scaffold

A fresh setup also comes with the **memory system ready to go**. On install, the bundled `templates/` are used to:

- Create `~/.claude/projects/<your-home-project>/memory/` and seed an **empty `MEMORY.md` index** there (Claude's persistent memory lives in per-project `memory/` folders).
- Drop a sample memory file showing the frontmatter format.
- Stash the templates at `~/.claude/templates/` for reuse, including a blank per-project `CLAUDE.md.template`.

Nothing is overwritten — if you already have a `MEMORY.md`, your memories are left untouched. This means a brand-new machine can start saving memories immediately instead of starting from nothing.
