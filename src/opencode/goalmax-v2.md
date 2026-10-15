---
description: Modo Goal v2 — motor real com auditoria independente, budget accounting, schema versioning, pause/resume, segurança reforçada
agent: autopilot
---

# MODO GOALMAX v2 — Goal Runtime Layer

Esta é a versão 2 do `/goalmax`, implementando o padrão da indústria para contratos de Goal (baseado em pesquisa cruzada: Claude Code `/goal`, Codex `/goal`, Hermes, Grok Build, agosto 2026).

## Diferenças da v1

| Recurso | v1 | v2 |
|---------|-----|-----|
| **Auditoria independente** | ❌ | ✅ Modelo separado (Haiku) valida evidência a cada N milestones |
| **Budget accounting** | Milestone count apenas | ✅ Tokens, turns, tempo — hard limits |
| **Schema versioning** | ❌ Quebra sessões antigas | ✅ Migração automática v1→v2 + backup |
| **Pause/Resume** | ❌ Só blocked/complete | ✅ Estados explícitos `paused`/`resumed` |
| **Segurança verify** | Shell injection risk | ✅ `spawn` sem shell + allowlist comandos |
| **Observabilidade** | Toast + log básico | ✅ `goalmax_health`, structured logging |
| **Iteration policy** | Texto livre | ✅ Configurável + auditor valida |

---

## Ferramentas do Motor v2

| Tool | Descrição |
|------|-----------|
| `goalmax_set` | Registra contrato 6 componentes + budgets + audit config |
| `goalmax_verify` | Executa verification surface (seguro, sem shell) |
| `goalmax_complete` | Conclui — **exige verify com exit code 0** |
| `goalmax_blocked` | Marca bloqueado — para continuação |
| `goalmax_pause` | Pausa goal — preserva estado, para auto-continuação |
| `goalmax_resume` | Retoma goal pausado — reativa auto-continuação |
| `goalmax_budget` | Define/consulta budgets (tokens, turns, tempo) + reset |
| `goalmax_audit` | Configura/invoca auditor independente |
| `goalmax_status` | Mostra estado completo (contrato, budgets, auditoria, verify) |
| `goalmax_health` | Diagnóstico do plugin (sessões, warnings, hooks) |
| `goalmax_fast` / `goalmax_fast_status` | Toggle Fast Mode (perfis de velocidade do plugin fast-mode.ts) — **não são do runtime de goal**: aceleram inferência, não o loop |

---

## Contrato de 6 Componentes (Obrigatório)

1. **Outcome** — O que deve ser literalmente verdade no final
2. **Verification surface** — Comando exato que prova o Outcome (executável real, allowlist: `npm`, `pnpm`, `yarn`, `bun`, `pytest`, `python`, `python3`, `cargo`, `go`, `make`, `node`, `deno`, `git`, `grep`, `find`, `cat`, `ls`, `test`, `jq`, `sed`, `awk`, `echo`, `printf` (**sem bash/sh/zsh** — shell-escape fechado))
3. **Constraints** — O que não pode regredir
4. **Boundaries** — `boundariesAllow` (paths permitidos) + `boundariesDeny` (paths proibidos)
5. **Iteration policy** — Como decidir o próximo passo
6. **Blocked stop condition** — Quando parar e reportar sem caminho defensável

---

## Budgets (Opcionais, com Defaults)

- `tokenBudget` (default: 200000)
- `turnBudget` / `maxTurns` (default: 50)
- `timeBudgetHours` (default: 4)

Exceder qualquer budget → goal para com status `budget_exceeded`.

---

## Auditoria Independente (Opcional, Default: ON)

- `auditEnabled` (default: true)
- `auditModel` (default: `anthropic/claude-haiku`)
- `auditInterval` (default: 3 milestones)

A cada N milestones, um modelo separado avalia se o Outcome foi alcançado baseado na evidência real. Vereditos: `CONTINUE` / `COMPLETE` / `IMPOSSIBLE`.

---

## Fluxo de Execução

```
1. /goalmax-v2 "tarefa"
   ↓
2. Monte o contrato de 6 partes + budgets opcionais
   ↓
3. Chame goalmax_set (UMA VEZ) — registra no motor, inicia auto-continuação
   ↓
4. Loop:
   - Trabalhe em milestones reais
   - Chame goalmax_verify para checar progresso (comando real, sem shell)
   - Motor reinjeta continuação automaticamente quando sessão fica ociosa
   - Auditor independente roda a cada N milestones (se habilitado)
   - Budgets são checados a cada continuação
   ↓
5. Conclusão:
   - goalmax_verify (exit code 0) → goalmax_complete com resumo
   - OU goalmax_blocked com motivo se impossível
   - OU goalmax_pause se precisa input humano
   ↓
6. Controle manual:
   - goalmax_status (ou goalmax_status full=false para resumo)
   - goalmax_budget (ver/atualizar/resetar)
   - goalmax_audit (configurar/executar manual)
   - goalmax_health (diagnóstico)
   - /goal stop / /goal cancel / /goal off / /goal reset (só você manda)
```

---

## Exemplo Completo

```bash
/goalmax-v2 "Implementar login JWT com refresh token"
```

```markdown
# Contrato (preenchido pelo agente)

## Outcome
Usuário pode fazer login, receber access+refresh token, e usar refresh para novo access token

## Verification surface
pytest tests/auth/test_jwt.py -v

## Constraints
- Não quebrar testes existentes
- Não adicionar dependências externas
- Manter compatibilidade com API v1

## Boundaries
Allow: src/auth/**, tests/auth/**
Deny: src/billing/**, db/migrations/**

## Iteration policy
1. Rodar testes, ver falhas
2. Implementar menor mudança para passar
3. Repetir até suite verde

## Blocked stop condition
Se pytest não roda após 3 tentativas, ou se JWT library não disponível

## Budgets
Tokens: 150000 | Turns: 30 | Tempo: 2h

## Audit
Enabled: true | Model: anthropic/claude-haiku | Interval: 3
```

```typescript
// Chamada do agente:
goalmax_set({
  outcome: "...",
  verification: "pytest tests/auth/test_jwt.py -v",
  constraints: "...",
  boundariesAllow: ["src/auth/**", "tests/auth/**"],
  boundariesDeny: ["src/billing/**", "db/migrations/**"],
  iterationPolicy: "...",
  blockedStopCondition: "...",
  tokenBudget: 150000,
  turnBudget: 30,
  timeBudgetHours: 2,
  auditEnabled: true,
  auditModel: "anthropic/claude-haiku",
  auditInterval: 3
})
```

---

## Migração de Sessões v1

Sessões existentes em `.opencode/goal-state/*.json` são migradas automaticamente na primeira carga (backup `.v1.backup.json` criado).

Para migrar manualmente:
```bash
bun run ~/.config/opencode/scripts/migrate-goal-state.ts [--dry-run]
```

---

## Health Check

```bash
# Via tool (em sessão OpenCode)
goalmax_health

# Via script standalone
bun run ~/.config/opencode/scripts/goalmax-health.ts [--json] [--dir=PROJECT_DIR]
```

---

## Relatório Final (goalmax_complete ou goalmax_blocked)

```
🔒 GOALMAX v2 — <concluído / bloqueado / orçamento excedido>

## Outcome
<o que era, evidência do goalmax_verify que confirmou>

## Verification surface — resultado real do motor
<exit code + stdout/stderr reais, do goalmax_verify>

## Budgets consumidos
Tokens: X/Y (Z%) | Turns: A/B (C%) | Tempo: Dmin / Eh (F%)

## Auditoria
<últimos vereditos do auditor independente, se habilitado>

## Boundaries — respeitadas
<arquivos tocados, cruzados contra permitido/proibido>

## Observado, não executado
<qualquer coisa fora do Outcome original — nunca implementada, só registrada>
```

---

## Comandos de Controle (do usuário)

**Controle real do motor (via agente):** `goalmax_status` (status) · `goalmax_pause` / `goalmax_resume` · `goalmax_budget` · `goalmax_blocked` (encerra).

**⚠️ Nota de realidade:** `/goal status|stop|cancel|off|reset` NÃO controlam o motor — nenhum plugin registra esses comandos; `/goal` carrega `commands/goal.md`, um protocolo separado. Pra encerrar/pausar um goal do motor, peça ao agente ("pausa o goal", "encerra o goal") ou use `/ultragoal clear|pause|stop`.