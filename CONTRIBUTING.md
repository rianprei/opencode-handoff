# Contributing

## Ground rules

- **One source of truth per runtime**: `src/opencode/handoff.md` is the master. The claude variant must keep a **byte-identical body** (only frontmatter differs); codex and grok must be **byte-identical to each other** and carry every content marker of the master.
- **Content markers are load-bearing**: the CI job and the local drift-killer (`ultra-suite-sync.sh`) enforce them. If you change a rule (gate, taxonomy, redaction list, budget), update the corresponding marker — never delete one.
- **All bodies are PT-BR** (suite convention). Frontmatter descriptions follow each runtime's convention; codex/grok descriptions are EN.
- The codex/grok skills are **explicit-only** (`disable-model-invocation: true`) — handoff has terminal semantics; do not add casual trigger phrases to the description.

## Workflow

1. Fork/clone, branch.
2. Edit `src/` — never the installed copies on your machine.
3. Validate locally:
   ```bash
   # frontmatter
   python3 -c "import yaml; parts=open('src/opencode/handoff.md').read().split('---'); yaml.safe_load(parts[1])"
   # parity
   cmp src/codex/SKILL.md src/grok/SKILL.md
   diff <(tail -n +5 src/opencode/handoff.md) <(tail -n +6 src/claude/handoff.md)
   ```
4. Regenerate checksums if `src/` changed: `sha256sum src/opencode/handoff.md src/claude/handoff.md src/codex/SKILL.md src/grok/SKILL.md > CHECKSUMS.sha256`
5. Update `CHANGELOG.md`.
6. PR with a description of the rule you changed and why (behavioral rationale, not just the diff).

## Review bar

Changes to WRITE/LOAD behavior go through an adversarial review before merge: every claimed fix needs evidence (line citation or command output), and hypotheses get refuted, not assumed. See [docs/ULTRAREVIEW-v2.md](docs/ULTRAREVIEW-v2.md) for the bar the v2.0 release was held to.

## License

By contributing you agree your work is MIT-licensed.
