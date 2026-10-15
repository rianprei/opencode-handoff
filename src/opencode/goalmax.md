---
description: "⚠️ DEPRECADO — Use /goalmax-v2. Modo goal máximo v1 (legacy). Contrato de 6 componentes, evidência forçada, auto-continuação. Migração automática para v2 na primeira carga."
agent: autopilot
---

# MODO GOALMAX v1 (LEGACY) — Use /goalmax-v2

⚠️ **Esta versão está depreciada.** Use `/goalmax-v2` para novos goals.

Esta versão (v1) ainda funciona mas falta:
- Auditoria independente (modelo separado valida evidência)
- Budget accounting (tokens, turns, tempo com hard limits)
- Schema versioning + migração automática
- Pause/Resume explícito
- Segurança: verify sem shell injection
- Observabilidade: goalmax_health, structured logging

---

## Migração automática

Sessões v1 existentes em `.opencode/goal-state/*.json` são migradas automaticamente para v2 na primeira carga do plugin v2 (backup `.v1.backup.json` criado).

Para migrar manualmente:
```bash
bun run ~/.config/opencode/scripts/migrate-goal-state.ts [--dry-run]
```

---

## Ferramentas v1 (ainda funcionam)

> **Correção histórica:** desde a v2, `goalmax_verify` roda via allowlist + spawn **sem shell** — o "shell injection risk" abaixo era da v1 e não existe mais. Tabela mantida só como registro; prefira o `/goalmax-v2`.

| Tool | Descrição |
|------|-----------|
| `goalmax_set` | Registra contrato 6 componentes |
| `goalmax_verify` | Executa verification (⚠️ shell injection risk — **obsoleto: na v2 é allowlist + spawn sem shell**) |
| `goalmax_complete` | Conclui — exige verify exit code 0 |
| `goalmax_blocked` | Marca bloqueado |
| `goalmax_status` | Mostra estado |

## Fluxo v1

```
1. /goalmax "tarefa"
2. Monte contrato 6 partes
3. goalmax_set (obrigatório)
4. Loop: trabalhe → goalmax_verify → goalmax_complete/blocked
5. Controle: /goal status, /goal stop, /goal reset
```

---

## Relatório final v1

```
🔒 GOALMAX — <concluído / bloqueado>

## Outcome
<o que era, evidência do goalmax_verify que confirmou>

## Verification surface — resultado real do motor
<exit code + stdout/stderr reais, do goalmax_verify>

## Boundaries — respeitadas
<arquivos tocados, cruzados contra o permitido>

## Observado, não executado
<qualquer coisa fora do Outcome original — nunca implementada, só registrada>
```
