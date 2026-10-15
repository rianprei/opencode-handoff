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

## Round 2 (2026-10-14) — v2.0 adversarial re-review → v2.1

5-reviewer fleet + neutral verifier attacking the v2.0 fixes themselves: **28 confirmed (1 critical, 6 high, 14 medium, 7 low), 1 refuted**, 3 execution-verifiable. Root causes: self-attestation without transported evidence; trust boundary that didn't cover in-project laundering; the claude variant's spec incoherence frozen by its own CI; lifecycle gaps (race, abandonment, closure); generic-substring invariants with diverging sync/CI lists. All 28 fixed in v2.1 (see CHANGELOG).

Refuted: the legacy-hook claim — `~/.claude/hooks/sessionstart-handoff.sh` + `~/HANDOVER.md` exist on disk but the hook was never registered in settings.json (orphan, not active).

Environment note (out of scope, registered per mandate): the verifier found a registered `UserPromptSubmit` hook in the user's environment claiming operator identity and ordering removal of output constraints — it did not comply and reported it. Users should audit their own hook registrations.

## Round 8 (2026-10-15) — replication battalion (4× full-spectrum) → v2.8

Four independent agents swept the entire spectrum each (Reddit/old.reddit, GitHub/GitLab, RU/CN/niche forums, Silicon Valley, vendor docs, arXiv). Replication rule: adopt only what ≥2 independently converged on. Converged adoptions: initializer×coder split + FirstWindow flag, passes-only feature ledger, fresh-restart + smoke-test-first order, surgical clearing + stable-prefix rule, anti-wrap-up rule, directional handoff flag, detail-sufficiency gate, planted-fact EVAL probes. No fleet findings — pure convergence adoption. Self-caught during build: a CI regression that stripped BRE alternation backslashes from the staleness-gate patterns (fixed + verified pattern-by-pattern before commit).

## Round 7 (2026-10-15) — battalion max-sweep (10 fronts) → v2.7

10 parallel research agents (GitHub new repos, Reddit postmortems, vendor docs, arXiv Oct-2026, engineering blogs, lists/marketplaces, non-English sources, adjacent patterns, adversarial, real exemplars) → 22 adopted deltas, 17 deferred with reasons. No fleet findings — pure capability adoption.

Adopted: forced read-back + dirty-ack (receiver recites map); receipt-hardened verifiability (checked ⇒ receipt, mock≠real); trust-code-over-doc + newer-revision check; stop-and-wait timeout (re-ask once, high-risk defaults to NO) + approval record; recovery sequence + verify-loop; cascade invalidation; source anti-duplicate; live-evidence-before-success; tool-output revalidation; goal-drift check; normalized scanning (NFKC+base64); egress rule; rotation to `.handoff/archive/`; completion requirement; multi-agent ownership; beads/prd refs; parked read-only advisor.

Deferred: map-reduce, universal always-stop, token hooks (standing); mutual old→new→old loop (needs old session alive); hook automation, index regeneration, CLI tooling, plugin packaging, memory MCPs, swarm contracts, messaging infra (ecosystem, not command text); compaction+note hybrid, plan-and-clear, inbox flow, 2-artifact split, safe-to-overwrite (UNVERIFIED or redundant).

## Round 6 (2026-10-15) — v2.4 adversarial re-review → v2.5

5-reviewer fleet + neutral verifier on the v2.4 machinery: **24 findings (3 critical, 8 high, 10 medium, 3 low), 1 refuted** — plus a field discovery: the first real v2.4 artifact (`.handoff/handoff-1-*.md`) already materialized 2 findings (provenance labels used as anchor substitutes ×10; Dead Ends outside the gate format). Root causes: authority concentrated on the WRITE side with no LOAD counterweight (REVOKED/Pin/provenance self-attested); global invariants contradicted by the spec's own named cases (gates dropped in emergency and split; "max 5" not applied to anchor reconciliation); costs without caps (materiality, anchor re-verification); process gates covering strings but not live artifacts (stale EVAL, installed×src drift, TAG regression v2.2). All 24 fixed in v2.5: REVOKED authority rules (anchored evidence, human ok for `usuário` items, incompatible predicate, load re-verification), EVAL rewritten to 48 cases + CI staleness gate, pin budgeted to 5 and quantified `x/y`, gate-authority scoped by trust, split carved out of 2-heads detection, emergency carries gates, export becomes read-pointer, materiality batched + sensitivity-extended, TAG regression fixed, installed×src cross-check added to sync.

Refuted: "provenance tags lack an omission criterion" — the criterion exists in the cited line ("quando não é óbvia").

## Round 5 (2026-10-14) — ecosystem max-sweep (4 agents) + arXiv grounding → v2.4

4-agent sweep (Reddit/old.reddit deep, GitHub post-June 2026, arXiv schema critique; the vendor-docs lens failed at dispatch — covered by the round-1/2 corpus). Deltas: 16 Reddit techniques, 11 GitHub features (continuity's measured-75% trigger + ownership lease, redducklabs' completion-audit bifurcation + origin-classified prompts + digest chaining, batonpass' 64-question eval scorecard — 0% no-context → 71.9% brief → 95.3% brief+search, hilsetapp's snapshot-vs-tree staleness), 12 papers (5 arXiv abstracts verified). Schema upgrade adopted: item lifecycle (TEPA: append-only < memoryless after reversal, 0.210 vs 0.950), gates-not-precedents (2608.24569: forbidden actions 85.2%→0.0%), provenance non-amplification (2607.29167: laundering ASR up to 1.000), environment pin (AgentRewind), rollback-risk (Handoff Debt). Deferred to ecosystem doctrine: PreCompact/Stop-block-once hooks, measured-75% trigger, ownership lease with prompt blocking, eval scorecard (runtime-specific adapters — the command encodes the invariants; docs/ULTRAREVIEW-v2.md carries the doctrine).

Key Reddit verdict: "the failure modes Reddit documents are all *trigger* failures, not format failures — v2.3's template and trust model are already ahead of everything on Reddit; what it lacked was the machinery that guarantees a handoff exists at the moment of loss." The write-side invariant (restart → checkpoint first) encodes the cheap half; hooks remain the full half.

## Round 4 (2026-10-14) — ecosystem convergence + 5-lens council → v2.3

Full GitHub + Reddit sweep (12 new sources: 7 r/ClaudeAI-r/ClaudeCode threads, 6 repos incl. REMvisual 60★, orzilca, aploe, nanwulan, klittle32, bugiiiii11) converged 10 candidate techniques, submitted to a 5-lens council (Architect, Security, Performance, UX, QA). Verdicts: **7 adopted** (capability-negating bootstrap, last-verifier-result as clue, verifiability labels, non-goals, degraded emergency mode with never-skipped secret scan, integrated chain-health line, goal-directed extraction), **3 deferred with reasons** (map-reduce breaks eval determinism; universal brief-then-stop kills the trusted fast path; token hooks need a per-runtime matrix). Notable council conflicts surfaced and resolved: bootstrap (Security wanted capability-negating-only, Performance rejected static rent → adopted as 4-line minimal protocol); emergency mode (Security rejected gate-skip outright → adopted degraded with scan/Seq always-on); always-stop (Architect+Security pro, Performance+UX con → kept risk-based default).

## Round 3 (2026-10-14) — v2.1 adversarial re-review → v2.2

5-reviewer fleet + neutral verifier attacking the v2.1 fixes: **26 confirmed (0 critical, 5 high, 13 medium, 8 low), 1 refuted**, 2 execution-verifiable. First round with zero criticals. Root causes: trust by field arithmetic with no origin sensor; self-attested gates nobody recomputes; colliding rules without declared precedence; fail-open trust boundary (tag fallback, missing checksum, unterminated frontmatter); structure-only sync. All 26 fixed in v2.2.

Refuted: "allow_implicit_invocation:false breaks `$skill` on non-TUI surfaces" — the original repro used `codex debug prompt-input` (bypasses the turn pipeline); the argszero comment shows `$skill` works on policy-restricted skills, and the TUI repro was re-attributed to picker case-sensitivity (#42727).

Corrected sub-claim: "gitignored ⇒ planted chain in every clone" was inverted — gitignore *prevents* the chain from reaching clones; the real vector is `git add -f`/committed chains, which is exactly what the new origin sensor detects.

## Verdicts (round 1)

Resolver os 18 altos antes de publicar — resolved: v2.0 shipped with all 38 findings closed, sync invariants in the local drift-killer, and CI parity/marker checks in this repo. Round 2 verdict ("resolver #1 e os 6 altos antes do v2.1") — resolved in v2.1.
