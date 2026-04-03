# Claude Code Zips

Two zip packs for setting up Claude Code with all the good stuff.

---

## ClaudeCode.zip

Settings, commands, status line, and plugins for Claude Code.

### Quick Setup

1. Unzip and give `claude-code-setup.md` to a new Claude Code instance
2. Tell it: "Apply the settings from this file"
3. Add your own API key, plugins, and MCP servers to `settings.json` as needed

### What's Inside

| File | Description |
|------|-------------|
| `settings.json` | Model, hooks, permissions, status line, effort level |
| `claude-code-setup.md` | Full setup guide with statusline script, CLAUDE.md, and plugin install |
| `commands/` | Slash commands (see below) |
| `Info.md` | Detailed reference |

### Commands

| Command | Description |
|---------|-------------|
| `/just-do-it` | Skip all confirmation prompts for the session. Claude applies every edit, install, and change immediately. |
| `/verify-settings` | Full health check — symlinks, settings.json, commands, statusline, plugins, zips. Reports pass/fail. |
| `/status` | Quick setup overview — plugins, model, permissions, keep-awake, available commands. |
| `/keep-awake` | Turn OFF sleep prevention. Caffeinate runs automatically every session — this command disables it. |
| `/remove-ralph` | Uninstall the ralph-loop plugin. |

### Session Start

Every new conversation prompts you sequentially:
1. **"Would you like to use just-do-it? (yes/no)"**
2. **"Would you like me to check for Ralph Loop updates? (yes/no)"**

### Settings Highlights

- **Model**: `claude-opus-4-6`
- **Permissions**: bypassPermissions + PermissionRequest hook (auto-approves everything). Cycle with Shift+Tab.
- **Keep-Awake**: always on via statusline (caffeinate auto-starts)
- **Hooks**: PreCompact (save context), Stop (save decisions), PermissionRequest (auto-approve all)
- **Status Line**: token tracker, 5h budget, context window bar, rate limit display
- **Effort Level**: high

### Plugins

- **Ralph Loop** (`ralph-loop@claude-plugins-official`) — autonomous dev loops, iterates until task is done

### Shell Commands

| Command | Description |
|---------|-------------|
| `! status` | Quick terminal status readout (model, plugins, commands, keep-awake) |
| `! claudecode-update` | Check for and install updates from ClaudeCode-Better GitHub |

### Auto-Update

Every new Claude Code session automatically runs `claudecode-update` to check GitHub for the latest version. If an update is available, it downloads new zips and syncs commands. Requires `gh` CLI.

---

## buddy-system.zip

Companion collection game for Claude Code. Hatch eggs, collect all 18 species, customize eyes and hats.

### Quick Setup

1. Unzip both `buddy-system/` and `any-buddy/` folders
2. Give `INSTALL-FOR-CLAUDE.md` to Claude Code
3. Tell it: "Set this up"

### Buddy Commands

| Command | Description |
|---------|-------------|
| `! buddy stats` | Show active buddy with ASCII art, stat bars, and egg status |
| `! buddy index` | Collection grid — discovered and undiscovered species |
| `! buddy log` | Full view: collection + catalogue + customization reference |
| `! buddy catalogue` | Browse all 18 species grouped by rarity with hatch odds |
| `! buddy equip` | List your buddies and which one is equipped |
| `! buddy equip <name>` | Switch active buddy |
| `! buddy equip eyes <style>` | Change eyes (dot/sparkle/cross/circle/at/degree) |
| `! buddy equip hat <type>` | Change hat (crown/tophat/propeller/halo/wizard/beanie/tinyduck/none) |
| `! buddy rename <name>` | Rename active buddy |
| `! buddy claim` | Pick up dropped eggs |
| `! buddy hatch` | Hatch an egg into a new random buddy |
| `! buddy switch <name>` | Switch active buddy (alias for equip) |
| `! buddy release <name>` | Release a buddy from your collection |
| `! buddy help` | Show all commands |

### Egg System

- Active buddy drops eggs over time (check via `! buddy stats`)
- Ducks: 50% drop chance, all others: 20%
- Min 10 minutes between checks, longer gaps increase odds (up to 1.5x at 2+ hours)
- Workflow: `stats` (trigger drop) -> `claim` (pick up) -> `hatch` (new buddy)
- Duplicates wander off — completing all 18 species is the real challenge

### 18 Species

```
duck   goose   blob   cat   dragon   octopus
owl   penguin   turtle   snail   ghost   axolotl
capybara   cactus   robot   rabbit   mushroom   chonk
```

### Rarities

| Rarity | Stars | Hatch Odds |
|--------|-------|------------|
| Common | 1 | 60% |
| Uncommon | 2 | 25% |
| Rare | 3 | 10% |
| Epic | 4 | 4% |
| Legendary | 5 | 1% |

### Any-Buddy (Companion Customizer)

Included in the zip. Pick any companion you want — species, rarity, eyes, hat, name — by brute-force searching for a matching salt and patching the Claude Code binary.

```bash
npx any-buddy@latest
```

| Command | Description |
|---------|-------------|
| `any-buddy` | Interactive pet picker |
| `any-buddy current` | Show current pet |
| `any-buddy preview` | Browse without applying |
| `any-buddy apply` | Re-apply after Claude Code update |
| `any-buddy restore` | Restore original pet |
| `any-buddy rehatch` | Delete companion for fresh hatch |

### Data

All collection data stored in `~/.claude/buddy-collection.json`. Delete to reset.
