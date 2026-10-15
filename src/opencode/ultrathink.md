---
description: Raciocínio deliberado nível máximo — réplica do 'ultrathink' do Claude Code, sem restrição de profundidade
---

**MODO ULTRATHINK ATIVADO.** Este é o nível máximo de deliberação — reserve isso para o problema mais difícil da conversa, não para tarefas rotineiras. Custa mais tempo e mais tokens de propósito: a troca é qualidade de decisão, não velocidade.

<problema>
$ARGUMENTS
</problema>

Antes de qualquer resposta final ou ação, produza um raciocínio visível, completo e sem pressa, cobrindo:

## 1. Entendimento do problema real
Reformule o problema. Identifique o que está realmente sendo pedido por trás da pergunta — não só a superfície. O que está em jogo se a decisão sair errada? Que suposições implícitas existem que valem a pena questionar?

## 2. Exploração ampla de abordagens
Liste **pelo menos 4-5 abordagens ou hipóteses diferentes**, incluindo pelo menos uma que não seja óbvia à primeira vista. Não convirja cedo demais numa única linha de raciocínio.

## 3. Análise crítica de cada uma
Para cada abordagem: vantagens, riscos, trade-offs, casos onde ela quebra. Ataque suas próprias ideias — procure ativamente o motivo pelo qual cada abordagem pode estar errada antes de aceitar qualquer uma.

## 4. Casos extremos e coisas que dão errado
Pense explicitamente em: o que acontece no pior caso? Que suposição, se falsa, derruba a solução inteira? Há efeito colateral em segurança, performance, manutenção, ou escopo que passou despercebido?

## 5. Backtrack quando necessário
Se no meio da análise você perceber que uma direção anterior estava errada, diga isso explicitamente e volte — não force uma conclusão só porque já investiu raciocínio nela.

## 6. Síntese e decisão final
Só depois de tudo isso, converja: qual é a melhor abordagem, por que ela venceu as outras especificamente, e quais riscos residuais permanecem mesmo com ela.

## 7. Evidência antes de agir
Se a tarefa envolve executar algo (código, comando, mudança de arquivo), verifique o resultado real antes de declarar sucesso — raciocínio profundo sem verificação real não é ultrathink, é só um texto longo.

---

Regra de ouro: se em algum momento desse processo você perceber que está reservando espaço de raciocínio só para "parecer minucioso" sem realmente mudar a conclusão, pare — ultrathink serve para decisões genuinamente difíceis, não para inflar toda resposta.

Depois da análise completa, entregue a resposta final ou execute a ação com a abordagem escolhida.

---

### Nota técnica (opcional, dependendo do seu modelo/provedor)

Se o seu modelo atual no OpenCode suporta parâmetros de reasoning effort passados via configuração de provedor (comum em modelos de raciocínio, ex. OpenAI o-series), você pode reforçar este comando tecnicamente — não só via prompt — adicionando ao seu `opencode.json`, no agente que for usar `/ultrathink`:

```json
{
  "agent": {
    "build": {
      "reasoningEffort": "high"
    }
  }
}
```

O nome exato do campo e os valores aceitos variam por provedor/versão do OpenCode — confirme na documentação do seu provedor específico antes de depender disso. O prompt acima funciona independente disso, em qualquer modelo.
