# Tests — ClaudeCode-Better

Run this whole checklist after every change to the pack, before committing/pushing.

## How to run

Clean-room install test (never touches your real `~/.claude`):

```bash
SANDBOX=$(mktemp -d)
gh repo clone Felix-Bechtel/ClaudeCode-Better "$SANDBOX/repo" -- -q
( cd "$SANDBOX/repo" && export HOME="$SANDBOX/home" && mkdir -p "$HOME" && bash install.sh )
```

## Checklist (verify after every update)

### Build & contents
- [ ] `bash build-zips.sh` runs clean and reports `✓ Done`
- [ ] `ClaudeCode.zip` contains `templates/` (memory scaffold, PROJECTS/TESTS/CLAUDE templates)
- [ ] Zipped `settings.json` has NO real API keys (sanitized → `YOUR_KEY_HERE`)
- [ ] Repo zip matches the freshly built zip (synced)

### Install behavior (in sandbox HOME)
- [ ] `install.sh` finishes with `✓ Install complete.`
- [ ] Seeds empty `MEMORY.md` under `~/.claude/projects/<home-project>/memory/`
- [ ] Seeds global `~/.claude/PROJECTS.md` registry
- [ ] Stashes templates at `~/.claude/templates/`
- [ ] Installs shell scripts to `~/.local/bin/` (status, plans, buddy, etc.)

### Idempotency / safety
- [ ] Re-running `install.sh` does NOT overwrite an existing `MEMORY.md`
- [ ] Re-running `install.sh` does NOT overwrite an existing `PROJECTS.md`
- [ ] Existing `~/.claude/buddy-collection.json` is preserved

### Docs
- [ ] `README.md` reflects all new changes (update the MD after every change)

## Regression notes
- Memory/registry seeds must be guarded by `[ ! -f ... ]` — clobbering real user data is the worst-case bug.
- `build-zips.sh` must keep sanitizing `settings.json` before zipping.
