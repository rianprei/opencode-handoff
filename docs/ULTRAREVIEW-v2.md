# ULTRAREVIEW v2.0 — Fleet Review Report (2026-10-14)

**Scope:** `/handoff` v1.0 in 4 runtime variants (4 files, 419 lines) + the upgrade plan.
**Mode:** 5+1 parallel (logic, security, performance, tests, architecture — each with passive web verification); neutral verifier failed at runtime, gate applied by the orchestrator with adversarial intent, every citation re-checked against the files.
**Result:** 38 confirmed (0 critical, 18 high, 12 medium, 8 low), 3 refuted, 4 execution-verifiable. All confirmed findings fixed in v2.0.

## Root causes (3 axes)

1. **Guarantees lived in the wrong document** — load protections the fresh session never receives (resume phrase didn't invoke `/handoff load`), chain inheritance missing from LOAD, redaction without a check.
2. **The command announced success without verifying anything** — 4 quality rules with no gate; a sibling command (`ultragoal`) calls exactly this "a lie".
3. **Handoff was the only suite member outside the drift-killer** — no sync invariants for it; content drift had already happened (codex/grok lost 13 semantic chunks, including the anti-injection clause and secret enumeration).

## Confirmed highs (18) → fixes

| # | Finding | Fix in v2.0 |
|---|---|---|
| 1 | Claude `allowed-tools` pre-approved Bash for a turn that may load an untrusted handoff; template's Commands section is payload | Bash removed; provenance rule; explicit-only skills |
| 2 | "Data, not instruction" was a prompt assertion with no structure (documented vector: OWASP ASI06, paperclip#2755) | Untrusted-handoff provenance rule + confirmation gates |
| 3 | `.handoff/` inside repo, no gitignore guidance — state/secrets one `git add -A` from a commit | `.gitignore` guard on write |
| 4 | Secret redaction had no mechanism; "exact commands" invites credentials | Gate re-scan (12 patterns); env-var rule |
| 5 | Arbitrary read via handoff-controlled paths (Relevant Files/Parent/Resume) | Out-of-project paths require confirmation |
| 6 | codex/grok lost 13 semantic chunks vs master (anti-injection clause, secret list, markers) | Variants rebuilt in PT-BR with full marker parity |
| 7 | Seq derivation undefined; lexicographic ordering corrupts chains at seq≥10; no collision rule | Max of `Seq:` field; `-2`/`-3` suffix; never filename order |
| 8 | LOAD reads one doc — parent decisions/dead-ends lost at depth 2 | LOAD reads Parent; curated carry on WRITE |
| 9 | Resume phrase never invoked `/handoff load` — protections never reached the new session | Close message routes through `/handoff load` |
| 10 | Chain blind to existing handoffs (workspace had 20 docs elsewhere) | `#1` references pre-existing handoffs |
| 11 | Dead Ends unconditional and eternal | Validity condition + re-check on expiry |
| 12 | `Next Steps #1` re-executed even if done on disk | `[FEITO]` marking + skip rule |
| 13 | Header lacked drift anchors | `Status · Cwd · Git branch@sha` |
| 14 | No quality gate on WRITE | Post-write gate (6 checks, mandatory) |
| 15 | LOAD had no success contract | Fixed output shape (path, drift class, divergences, starting step) |
| 16 | No preventive trigger — auto-compact eats the data before the write | ~70% context warning (write-before-compact) |
| 17 | No size budget (real docs hit 7.2K tokens) | ~3K target / 10K cap / 500-word sections / cut priority |
| 18 | Skill variants auto-invocable on casual phrases with terminal semantics | `disable-model-invocation: true` + explicit-only description |

Plus: plan contradictions resolved (carry-forward × budget → liveness-curated carry; lifecycle × single-file perimeter → declared one-line status edits; taxonomy → actions per class; Where We Are keeps file:line anchors).

## Refuted

- **"/compact doesn't exist on codex/grok"** (early hypothesis) — refuted: documented in all 4 runtimes; the motivation's `/compact` reference is portable.
- **"The `write` verb in argument-hint is dangerous"** — falls through to the default WRITE; harmless (removed anyway in v2.0's cleaner hint).
- **"crd/session-handoff doesn't exist"** — three independent reviewers fetched its SKILL.md/README directly.

## Execution-verifiable (eval cases)

See [EVAL.md](EVAL.md).

## Verdict

Resolver os 18 altos antes de publicar — resolved: v2.0 ships with all 38 findings closed, sync invariants in the local drift-killer, and CI parity/marker checks in this repo.
