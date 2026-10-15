# Deep Research: OpenCode — Harness, Agentes, Plugins e Arquitetura Interna

> **Para quem é este prompt:** ChatGPT (com deep research/browsing), Gemini Deep Research, Perplexity Pro, Claude com web search, ou qualquer IA com capacidade de pesquisa web ativa. Cole este prompt inteiro como primeira mensagem da conversa.

---

## Papel e contexto

Você é um engenheiro de software sênior especializado em **AI coding agents, agent harnesses e loop engineering**. Eu preciso de uma pesquisa técnica completa e profunda sobre o **OpenCode** — o agente de codificação open-source criado pela Anomaly (https://github.com/anomalyco/opencode). Meu objetivo final é entender a arquitetura interna o suficiente pra **construir comandos customizados, agentes personalizados e plugins que modifiquem o harness de verdade**, não só instruções de prompt — e quero saber exatamente o que é possível e o que não é.

## Fontes obrigatórias (acesse e leia TODAS)

Leia o conteúdo real destas fontes antes de começar a escrever. Não use resumo de memória — acesse cada uma:

### Documentação oficial
- https://opencode.ai/docs/ (raiz da doc)
- https://opencode.ai/docs/agents/ (agentes built-in e customizados)
- https://opencode.ai/docs/commands/ (sistema de comandos)
- https://opencode.ai/docs/plugins/ (sistema de plugins — hooks, eventos, ferramentas customizadas)
- https://opencode.ai/docs/custom-tools/ (ferramentas customizadas, separadas de plugins)
- https://opencode.ai/docs/permissions/ (sistema de permissões)
- https://opencode.ai/docs/policies/ (políticas de segurança)
- https://opencode.ai/docs/sdk/ (SDK JS/TS — client, session.prompt, event.subscribe)
- https://opencode.ai/docs/server/ (arquitetura cliente/servidor)
- https://opencode.ai/docs/skills/ (agent skills)
- https://opencode.ai/docs/config/ (opencode.json, schema)
- https://opencode.ai/docs/rules/ (regras de projeto e globais)
- https://opencode.ai/docs/references/ (referências de arquivos e documentação)

### Código-fonte
- https://github.com/anomalyco/opencode (repo principal — leia a estrutura de pastas, o README, e navegue pelos diretórios `packages/`, `internal/`, `cmd/` se possível)
- https://github.com/anomalyco/opencode/releases (changelog — mudanças recentes, features novas)

### Repositório de técnicas de prompt (referência de como NÃO misturar técnicas)
- https://github.com/rianprei/claude-prompt-techniques (SKILL.md — hierarquia de técnicas por peso, quais aplicar sempre, quais são condicionais, quais são pesadas e perigosas de forçar. Use isso pra avaliar criticamente se técnicas de prompt engineering mencionadas pela comunidade se aplicam ao OpenCode ou são cargo cult.)

### Fontes secundárias (busque se as primárias não cobrirem)
- https://opencode.school/ (guias didáticos)
- https://github.com/awesome-opencode/awesome-opencode (lista curada de plugins, projetos, ferramentas)
- https://github.com/wesammustafa/opencode-primer (primer comunitário com changelogs detalhados)
- Busque no GitHub por gists com "opencode plugin" e "opencode agent" pra exemplos reais da comunidade

## O que pesquisar — seções obrigatórias

Produza um relatório estruturado cobrindo TODAS estas seções. Para cada uma, cite a fonte real de onde veio a informação (URL ou nome de arquivo no repo), e separe claramente o que é documentado vs. o que é inferido do código.

### 1. Arquitetura geral
- Cliente/servidor: como funciona a separação, qual protocolo usa, como plugins e ferramentas interagem com o servidor.
- O que roda onde: o que executa no processo do servidor vs. o que é delegado a subprocessos.
- Linguagem do core (Go), linguagem de extensão (JS/TS via Bun) — como a ponte funciona.
- O que é "harness" no contexto do OpenCode — como a sessão é gerenciada, o que controla o loop de turnos, o que decide quando o agente para ou continua.

### 2. Sistema de agentes
- Agentes built-in (`build`, `plan`, `general`) — o que cada um faz, quais ferramentas tem, como se diferenciam.
- Como criar um agente custom via `.opencode/agent/<nome>.md` — frontmatter aceito (`description`, `mode`, `model`, `tools`, `temperature`, `prompt`), o que cada campo faz de verdade.
- Modos de agente: `primary` vs. `subagent` — diferença real no runtime, não só no nome.
- Como um agente delega pra subagente (task tool) — o que o subagente pode/não pode fazer, como o estado é passado.
- Se existe um modo de agente que faz loop autônomo sem voltar ao humano (tipo o `/goal` do Claude Code ou o auto mode), ou se isso precisa ser construído por plugin.

### 3. Sistema de comandos
- Como funciona: `.opencode/command/<nome>.md` com frontmatter + corpo que vira template.
- Frontmatter aceito (`description`, `agent`, `model`, `subtask`) — o que cada campo faz.
- Placeholders no corpo (`$ARGUMENTS`, `$1`, `` !`comando` ``, `@arquivo`) — como funcionam.
- Limitações: o que um comando NÃO pode fazer (ex: persistir estado entre invocações, chamar código real, modificar o harness).

### 4. Sistema de plugins (a parte mais importante)
- Lifecycle completo: como um plugin é carregado, quando roda, em que processo.
- Hooks disponíveis: lista COMPLETA de todos os eventos documentados, com o que cada um recebe como input/output.
  - `tool.execute.before` / `tool.execute.after` — o que chega no input, o que dá pra modificar no output.
  - `session.idle` — quando exatamente dispara, o que recebe, como usar pra continuação automática.
  - `session.created`, `session.updated`, `session.compacted`, `session.error`, `session.status`, `session.diff`, `session.deleted`.
  - `message.updated`, `message.removed`, `message.part.updated`, `message.part.removed`.
  - `command.executed`, `file.edited`, `file.watcher.updated`, `permission.asked`, `permission.replied`.
  - `shell.env`, `tui.prompt.append`, `tui.command.execute`, `tui.toast.show`.
  - `chat.message`, `chat.params` — o que dá pra interceptar/modificar.
  - `experimental.session.compacting` — como funciona a compactação, como injetar contexto customizado.
  - `permission.ask` — se dá pra auto-aprovar permissões programaticamente.
- Ferramentas customizadas via plugin vs. via `.opencode/tools/` — diferença, quando usar cada uma.
- `client.session.prompt()` — parâmetros aceitos, como injetar uma mensagem nova numa sessão existente, o que é `noReply: true`, como forçar o agente a continuar trabalhando programaticamente.
- `client.session.command()` — como executar um comando por código.
- `client.tui.*` — o que dá pra controlar na interface (toast, prompt, submit).
- Estado entre turnos: como persistir dados dentro de um plugin (Map em memória, arquivo em disco — o que funciona e o que não).
- Composição de plugins: se `opencode-plugin-compose` é oficial ou comunitário.

### 5. Sistema de permissões e políticas
- `opencode.json` → `agent.<nome>.permission` — como funciona o pattern matching de bash/edit/webfetch.
- `allow`, `ask`, `deny` — semântica exata de cada um no runtime.
- Se o `permission.ask` do hook de plugin pode interceptar e auto-aprovar (e as implicações).
- Políticas (`policies`) — o que são, como se diferenciam de permissões.

### 6. Sistema de ferramentas (tools)
- Ferramentas built-in: `bash`, `read`, `write`, `edit`, `glob`, `grep`, `webfetch`, `task`, `todowrite` — o que cada uma faz, o que aceita como argumento.
- Como sobrescrever uma ferramenta built-in (plugin tool com mesmo nome toma precedência — confirmado na doc).
- Como criar ferramenta nova via `.opencode/tools/<nome>.ts`.
- A diferença real entre `tool` no plugin e `tool` no diretório tools/ — quando cada um é carregado, como interagem.

### 7. Compactação e contexto
- Como funciona a compactação de sessão (o que é descartado, o que sobrevive).
- O hook `experimental.session.compacting` — como injetar contexto que sobrevive a compactação.
- Se existe forma de persistir estado fora do contexto de conversa (arquivo, banco, variável de ambiente) acessível pelo plugin.

### 8. Loop de execução e continuação
- O que faz o agente parar após um turno (o que define "turno" no OpenCode).
- Se existe mecanismo nativo de continuação automática (auto-continue, auto mode, ou equivalente).
- Se não existe nativamente, que combinação de hooks (`session.idle` + `client.session.prompt()`) pode replicar isso — com exemplo de código real.
- O que acontece quando a sessão é compactada no meio de um loop — o plugin sobrevive? O estado em memória se mantém?

### 9. Comparação com Claude Code
- O que o Claude Code tem que o OpenCode NÃO tem (e vice-versa), focando em: `/goal`, auto mode, `--dangerously-skip-permissions`, hooks, extended thinking budget, remote control.
- O que é replicável via plugin e o que exigiria mudança no core do OpenCode.

### 10. Limitações conhecidas e gotchas
- O que NÃO dá pra fazer via plugin/comando/agente custom (com base na doc e no código).
- Bugs conhecidos ou comportamentos inesperados reportados em issues do GitHub.
- Diferenças entre a versão CLI e o Desktop App no que toca plugins/agentes/hooks.

## Formato de saída

- Um relatório técnico, sem enrolação, sem repetição.
- Cada seção com subseções claras.
- Toda afirmação tem que citar a fonte (URL da doc, path no repo, ou link de issue/gist).
- Se algo não está documentado mas você inferiu do código, marque como "[inferido do código-fonte]".
- Se algo não está disponível em nenhuma fonte e você não sabe, diga "não encontrado" — nunca invente.
- No final, uma seção "Lacunas — o que eu não consegui confirmar" listando tudo que ficou sem resposta definitiva.

## Restrições

- Não resuma superficialmente — vá fundo. Se uma seção tem 20 hooks, liste os 20 com o que cada um faz.
- Não misture opinião com fato — se é opinião da comunidade, diga isso.
- Se um recurso mudou entre versões, mencione a versão onde mudou (o changelog do repo ajuda).
- Priorize informação da doc oficial e do código-fonte sobre posts de blog de terceiros.
- Se encontrar contradição entre fontes, cite ambas e aponte a contradição.
