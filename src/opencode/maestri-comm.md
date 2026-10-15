---
description: Comandos Maestro para comunicação entre instâncias Opencode
---

# Maestri Comm — Comunicação entre Opencode Instances

Commands facilitados para conversar com outra instância Opencode via socket Maestri.

## Pré-requisitos

Ambas as instâncias devem estar rodando no mesmo workspace Maestri. Verifique:

```
maestri list
```

Deve aparecer ambas as instâncias (ex: "OpenCode" e "OpenCode #2").

---

## Comandos Principais

### 1. Enviar mensagem para outra instância

```
mae "mensagem"
```

Envia uma mensagem de texto para a outra instância Opencode e imprime a resposta.

**Exemplo:**
```
mae "eai, o que vc está trabalhando?"
```

**Internamente executa:**
```
maestri ask "OutroNome" "mensagem"
```

---

### 2. Perguntar para outra instância e apenas ler (sem o "pensamento" em volta)

```
mae:raw "mensagem"
```

Similar ao `mae`, mas retorna apenas o texto da resposta, sem o bloco de thought/token visual.

**Exemplo:**
```
mae:raw "qual a versao atual do projeto?"
```

---

### 3. Criar nota compartilhada

```
mcn "nome-da-nota" "conteudo"
```

Cria uma nota que pode ser lida pela outra instância.

**Exemplo:**
```
mcn "ideia-main" "implementar feature x"
```

Depois na outra instância:
```
maestri note read "ideia-main"
```

---

### 4. Ler nota da outra instância

```
mrl "nome-da-nota"
```

Lê uma nota criada pela outra instância.

**Exemplo:**
```
mrl "ideia-main"
```

---

### 5. Verificar se outra instância está ativa

```
mcs "nome-ou-id"
```

Verifica o status da outra instância Opencode.

**Exemplo:**
```
mcs "OpenCode #2"
```

Retorna informações se está ativo, diretório de trabalho, etc.

---

### 6. Lista todas as notas e agentes conectados

```
mla
```

Lista agentes conectados e notas disponíveis.

---

## Atalho Rápido (adicionar ao bashrc)

Adicione ao seu `.bashrc` ou config do opencode:

```bash
mae() {
  local msg="$1"
  if [ -z "$msg" ]; then
    echo "Uso: mae \"sua mensagem\""
    return 1
  fi
  /opt/Maestri/resources/cli/maestri ask "OpenCode #2" "$msg" 2>&1 | grep -A 10 "The user" | tail -11
}
```

---

## Exemplos Práticos

```
# Saudação inicial
mae "eai, beleza? tudo funcionando por la?"

# Verificar status
mcs "OpenCode #2"

# Compartilhar uma ideia
mcn "nova-feature" "implementar autocomplete para comandos maestri"

# Ler o que a outra instância escreveu
mrl "nova-feature"

# Pergunta direta sem formatação visual
mae:raw "qual o ultimo commit?"
```