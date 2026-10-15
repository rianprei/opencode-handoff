---
description: Ativa modo de objetivo persistente — trabalha em loop até condição verificável
agent: build
---

Você acaba de entrar em **MODO GOAL** para o restante desta sessão. Objetivo bruto recebido:

<goal_bruto>
$ARGUMENTS
</goal_bruto>

Siga este protocolo até eu digitar `/goal stop`, `/goal cancel`, `/goal off` ou `/goal reset`:

## 1. Reformule antes de agir

Extraia do objetivo bruto acima (ou proponha, se faltar):

- **Escopo** — quais arquivos/pastas/sistemas podem ser tocados, e o que está fora dos limites.
- **Condição de parada verificável** — algo checável objetivamente (testes passando, comando retornando código 0, item específico presente/ausente, contagem batendo). Nada de "quando parecer bom".
- **Limite de execução** — número máximo de iterações, ou "sem limite até condição bater".

Se o objetivo bruto já tiver essas 3 partes claras, apenas confirme resumidamente e siga. Se faltar alguma, **pare aqui, mostre sua reformulação e peça minha confirmação antes do primeiro passo real.**

## 2. Execute em loop de milestones

Depois de confirmado:

- Trabalhe em milestones pequenos e verificáveis, não em um bloco monolítico.
- Ao fim de cada milestone, mostre a linha de status:

  `🎯 GOAL ATIVO — milestone N | escopo: ... | condição: ...`

- Cheque você mesmo a condição de parada contra evidência real (rodando comando, lendo arquivo, contando itens) — não declare "pronto" por impressão.
- Se um passo falhar, tente corrigir sozinho antes de me interromper. Reporte o que falhou e o que você tentou.
- Só me interrompa se: (a) a condição bateu, (b) encontrou algo genuinamente fora do escopo, ou (c) o limite de iterações foi atingido.

## 3. Controle

- `/goal status` → relate turno atual, escopo, condição e o que já foi feito.
- `/goal stop` / `/goal cancel` / `/goal off` → encerre imediatamente, sem mais nenhuma ação.
- `/goal reset` → encerre e descarte o estado do goal (não retome progresso depois).

Nunca confunda modo goal com prompt comum: aqui "pronto" só existe quando a condição de parada foi cruzada com evidência, não quando parece razoável parar.
