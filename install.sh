#!/bin/bash
# One-shot installer for ClaudeCode-Better.
#
# When you download (clone) this repo, run:
#   bash install.sh
#
# It force-installs the buddy-system code FIRST (the base layer), then layers
# the ClaudeCode DLC on top. This guarantees the DLC's commands/hooks/bin
# scripts have the buddy code they expect to interact with.
#
# Idempotent: running it again re-installs from the bundled zips, overwriting
# anything in place (your collection at ~/.claude/buddy-collection.json is
# preserved — it's only seeded on first install).

set -e

GREEN='\033[32m'
YEL='\033[33m'
RED='\033[31m'
DIM='\033[2m'
BOLD='\033[1m'
R='\033[0m'

# Resolve repo root from this script's location, regardless of cwd.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZIPS_DIR="$SCRIPT_DIR/Claude Code Zips"

BUDDY_ZIP="$ZIPS_DIR/buddy-system.zip"
DLC_ZIP="$ZIPS_DIR/ClaudeCode.zip"

if [ ! -f "$BUDDY_ZIP" ] || [ ! -f "$DLC_ZIP" ]; then
  printf "${RED}✗ Missing zip(s) in '%s'${R}\n" "$ZIPS_DIR"
  printf "  Expected: buddy-system.zip and ClaudeCode.zip\n"
  exit 1
fi

printf "${BOLD}ClaudeCode-Better installer${R}\n"
printf "${DIM}Repo: %s${R}\n\n" "$SCRIPT_DIR"

# ---------- STEP 1: force-install buddy-system (base layer) ----------
printf "${BOLD}[1/3]${R} Force-installing buddy-system (base layer)...\n"
BTMP=$(mktemp -d)
unzip -qo "$BUDDY_ZIP" -d "$BTMP"

if [ ! -f "$BTMP/buddy.js" ]; then
  printf "  ${RED}✗ buddy.js not found in buddy-system.zip${R}\n"
  rm -rf "$BTMP"
  exit 1
fi

BUDDY_DEST="$HOME/Claude/buddy-system"
mkdir -p "$BUDDY_DEST"
cp -f "$BTMP/buddy.js" "$BUDDY_DEST/buddy.js"
[ -f "$BTMP/buddy-collection-default.json" ] && cp -f "$BTMP/buddy-collection-default.json" "$BUDDY_DEST/buddy-collection-default.json"
[ -f "$BTMP/README.md" ] && cp -f "$BTMP/README.md" "$BUDDY_DEST/README.md"
[ -f "$BTMP/Info.md" ] && cp -f "$BTMP/Info.md" "$BUDDY_DEST/Info.md"
[ -f "$BTMP/INSTALL-FOR-CLAUDE.md" ] && cp -f "$BTMP/INSTALL-FOR-CLAUDE.md" "$BUDDY_DEST/INSTALL-FOR-CLAUDE.md"

mkdir -p "$HOME/.claude"
if [ ! -f "$HOME/.claude/buddy-collection.json" ] && [ -f "$BTMP/buddy-collection-default.json" ]; then
  cp "$BTMP/buddy-collection-default.json" "$HOME/.claude/buddy-collection.json"
  printf "  ${DIM}seeded default collection at ~/.claude/buddy-collection.json${R}\n"
fi
rm -rf "$BTMP"
printf "  ${GREEN}✓${R} buddy-system installed at %s\n\n" "$BUDDY_DEST"

# ---------- STEP 2: install ClaudeCode DLC overlay ----------
printf "${BOLD}[2/3]${R} Installing ClaudeCode DLC overlay...\n"
DTMP=$(mktemp -d)
unzip -qo "$DLC_ZIP" -d "$DTMP"

# settings + statusline + CLAUDE.md go to ~/Claude/Claude Code Settings/
SETTINGS_DEST="$HOME/Claude/Claude Code Settings"
mkdir -p "$SETTINGS_DEST"
# Preserve the user's selected plan + budget across re-installs. The template
# in the zip ships without statusLineTokenBudget / statusLinePlanName, but if
# the user already set one with `! plan`, copying the template would silently
# revert their footer to the auto-detected budget.
EXISTING_SETTINGS="$SETTINGS_DEST/settings.json"
PRESERVED_BUDGET=""
PRESERVED_PLAN=""
if command -v jq >/dev/null 2>&1 && [ -f "$EXISTING_SETTINGS" ]; then
  PRESERVED_BUDGET=$(jq -r '.statusLineTokenBudget // empty' "$EXISTING_SETTINGS" 2>/dev/null)
  PRESERVED_PLAN=$(jq -r '.statusLinePlanName // empty' "$EXISTING_SETTINGS" 2>/dev/null)
fi
if [ -f "$DTMP/settings.json" ]; then
  cp -f "$DTMP/settings.json" "$SETTINGS_DEST/settings.json"
  if [ -n "$PRESERVED_BUDGET" ] && command -v jq >/dev/null 2>&1; then
    TMP="$SETTINGS_DEST/settings.json.tmp.$$"
    jq --argjson b "$PRESERVED_BUDGET" --arg n "$PRESERVED_PLAN" \
      '. + {statusLineTokenBudget: $b} + (if $n == "" then {} else {statusLinePlanName: $n} end)' \
      "$SETTINGS_DEST/settings.json" > "$TMP" && mv "$TMP" "$SETTINGS_DEST/settings.json" \
      && printf "  ${DIM}preserved your plan: ${R}${PRESERVED_PLAN:-custom}${DIM} (${PRESERVED_BUDGET} tokens)${R}\n"
  fi
fi
[ -f "$DTMP/statusline.py" ]  && cp -f "$DTMP/statusline.py"  "$SETTINGS_DEST/statusline.py"
[ -f "$DTMP/statusline.js" ]  && cp -f "$DTMP/statusline.js"  "$SETTINGS_DEST/statusline.js"
[ -f "$DTMP/CLAUDE.md" ]      && cp -f "$DTMP/CLAUDE.md"      "$SETTINGS_DEST/CLAUDE.md"
[ -f "$DTMP/Info.md" ]        && cp -f "$DTMP/Info.md"        "$SETTINGS_DEST/Info.md"

# Symlink ~/.claude/{settings.json,statusline.py,statusline.js,CLAUDE.md} → settings dest
for f in settings.json statusline.py statusline.js CLAUDE.md; do
  if [ -f "$SETTINGS_DEST/$f" ]; then
    ln -sfn "$SETTINGS_DEST/$f" "$HOME/.claude/$f"
  fi
done

# commands → ~/.claude/commands/
if [ -d "$DTMP/commands" ]; then
  mkdir -p "$HOME/.claude/commands"
  cp -f "$DTMP/commands/"*.md "$HOME/.claude/commands/" 2>/dev/null || true
fi

# bin → ~/.claude/bin/
if [ -d "$DTMP/bin" ]; then
  mkdir -p "$HOME/.claude/bin"
  cp -f "$DTMP/bin/"* "$HOME/.claude/bin/" 2>/dev/null || true
  chmod +x "$HOME/.claude/bin/"* 2>/dev/null || true
fi

rm -rf "$DTMP"
printf "  ${GREEN}✓${R} DLC overlay installed (settings, commands, hooks, bin)\n\n"

# ---------- STEP 3: install shell scripts to ~/.local/bin ----------
printf "${BOLD}[3/3]${R} Installing shell scripts to ~/.local/bin...\n"
mkdir -p "$HOME/.local/bin"
for script in claudecode-update status update-claudecodebetter commands plan; do
  if [ -f "$SCRIPT_DIR/$script" ]; then
    cp -f "$SCRIPT_DIR/$script" "$HOME/.local/bin/$script"
    chmod +x "$HOME/.local/bin/$script"
    printf "  ${GREEN}✓${R} %s\n" "$script"
  fi
done

# buddy + slaughter wrappers (point at the just-installed buddy.js)
cat > "$HOME/.local/bin/buddy" <<'EOF'
#!/bin/bash
exec node "$HOME/Claude/buddy-system/buddy.js" "$@"
EOF
chmod +x "$HOME/.local/bin/buddy"
printf "  ${GREEN}✓${R} buddy\n"

cat > "$HOME/.local/bin/slaughter" <<'EOF'
#!/bin/bash
exec node "$HOME/Claude/buddy-system/buddy.js" slaughter "$@"
EOF
chmod +x "$HOME/.local/bin/slaughter"
printf "  ${GREEN}✓${R} slaughter\n\n"

# Cache the current commit so claudecode-update doesn't re-prompt right after install.
if command -v git &>/dev/null && git -C "$SCRIPT_DIR" rev-parse --short=7 HEAD &>/dev/null; then
  CURRENT_SHA=$(git -C "$SCRIPT_DIR" rev-parse --short=7 HEAD)
  echo "$CURRENT_SHA" > "${TMPDIR:-/tmp}/claudecode-update-last"
  rm -f "${TMPDIR:-/tmp}/claudecode-update-pending"
fi

printf "${GREEN}${BOLD}✓ Install complete.${R}\n\n"
printf "${BOLD}${YEL}→ Set your Claude plan with${R} ${BOLD}${GREEN}! plan${R}${BOLD}${YEL} so the footer shows the right token budget.${R}\n"
printf "${DIM}    1 = Pro 44k   ·   2 = Max 5x 88k   ·   3 = Max 20x 220k${R}\n\n"
printf "${DIM}Next steps:${R}\n"
printf "  • Make sure ${BOLD}~/.local/bin${R} is on your PATH (add to ~/.zshrc if needed)\n"
printf "  • Restart Claude Code to load the new settings\n"
printf "  • Run ${BOLD}! plan${R} to set your Claude plan\n"
printf "  • Run ${BOLD}! buddy stats${R} to see your starter buddy\n\n"

# ---------- Show the full command list at the end of install ----------
if [ -x "$HOME/.local/bin/commands" ]; then
  printf "${DIM}════════════════════════════════════════════════════════════════════${R}\n\n"
  "$HOME/.local/bin/commands"
fi
