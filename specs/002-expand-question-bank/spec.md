# Feature Specification: Expansão da Base de Perguntas

> Expande o conteúdo inicial do QuizVerse: Forca com 1000 perguntas variadas,
> distribuição por 10 níveis de dificuldade, seleção aleatória adaptativa por nível,
> regra anti-repetição por 2 horas de jogo e ajuste de tentativas de 3 para 5.

**Feature Branch**: `002-create-new-spec`

**Created**: 2026-05-16

**Status**: Draft

**Input**: User description: "inicie uma nova branch para adicionar novas features ao app. Gere uma lista variada de 1000 perguntas para compor a base inicial de perguntas do app. As perguntas geradas devem estar classificadas entre os 10 níveis de dificuldade previstos. As perguntas mais fáceis devem ser mais selecionadas para os níveis iniciais do jogo e, na medida em que o jogador avançar nos níveis, perguntas mais difíceis devem prevalecer. A seleção das perguntas deve ser aleatória. Uma pergunta já realizada não deve ser repetida nas próximas 2 horas de jogo. Altere a quantidade de tentativas de 3 para 5."

## Clarifications

### Session 2026-05-16

- Q: Como o sistema deve se comportar quando não houver perguntas elegíveis dentro da janela de anti-repeticao de 2 horas? -> A: Ao esgotar o pool, limpar todo historico recente e voltar ao sorteio normal imediatamente.
- Q: Qual estrategia de distribuicao de dificuldade deve guiar o sorteio por nivel? -> A: Distribuicao ponderada progressiva por nivel, com chance residual das demais faixas.
- Q: Qual criterio objetivo define variedade tematica minima da base inicial? -> A: Minimo de 10 categorias, com pelo menos 50 perguntas por categoria.
- Q: A janela de anti-repeticao de 2 horas deve usar tempo corrido ou tempo ativo de partida? -> A: Tempo de relogio corrido (wall-clock), mesmo com app fechado.
- Q: Quando houver conflito entre curva de dificuldade e disponibilidade de perguntas elegiveis, qual regra tem prioridade? -> A: Priorizar anti-repeticao e aleatoriedade; se faltar pergunta da faixa ideal, usar qualquer dificuldade elegivel.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Base Inicial com 1000 Perguntas (Priority: P1)

Como jogador, quero que o app tenha uma base inicial robusta e variada de
perguntas para que eu possa jogar por longos períodos sem sensação de conteúdo
limitado.

**Why this priority**: Sem uma base extensa e classificada, o jogo perde valor
logo nas primeiras sessões e compromete toda a progressão.

**Independent Test**: Validar que a base inicial contém exatamente 1000
perguntas únicas e válidas, cada uma classificada em um nível de dificuldade de
1 a 10.

**Acceptance Scenarios**:

1. **Given** o app com base inicial carregada, **When** o conteúdo é validado,
   **Then** existem exatamente 1000 perguntas válidas e utilizáveis.
2. **Given** uma pergunta da base inicial, **When** sua dificuldade é lida,
   **Then** o valor está entre 1 e 10.
3. **Given** a base completa, **When** a unicidade é verificada, **Then** não há
   perguntas duplicadas.

---

### User Story 2 - Sorteio Adaptativo por Nível (Priority: P1)

Como jogador, quero receber perguntas mais fáceis nos níveis iniciais e mais
complexas nos níveis avançados para que a curva de dificuldade acompanhe minha
progressão.

**Why this priority**: A progressão justa depende diretamente da qualidade da
seleção de perguntas por nível; isso impacta retenção e percepção de desafio.

**Independent Test**: Simular sorteios por faixas de nível e verificar se as
perguntas selecionadas respeitam a predominância de dificuldades esperada para
cada fase da progressão.

**Acceptance Scenarios**:

1. **Given** um jogador nos níveis iniciais, **When** novas perguntas são
   sorteadas, **Then** predominam perguntas de baixa dificuldade.
2. **Given** um jogador nos níveis avançados, **When** novas perguntas são
   sorteadas, **Then** predominam perguntas de alta dificuldade.
3. **Given** múltiplos sorteios no mesmo nível, **When** a seleção ocorre,
   **Then** a pergunta é escolhida aleatoriamente entre as candidatas elegíveis.

---

### User Story 3 - Anti-Repetição e Novo Limite de Erros (Priority: P2)

Como jogador, quero evitar repetição imediata de perguntas e ter até 5 erros
antes do fim de partida para uma experiência mais fluida e menos punitiva.

**Why this priority**: Evitar repetição preserva a sensação de novidade e
ajustar o limite de erros melhora acessibilidade e equilíbrio da dificuldade.

**Independent Test**: Em uma sessão contínua, verificar que uma pergunta já
respondida não reaparece nas próximas 2 horas de jogo e que o estado de derrota
só ocorre no 5º erro consecutivo.

**Acceptance Scenarios**:

1. **Given** uma pergunta já respondida pelo jogador, **When** novas perguntas
   são sorteadas dentro da janela de 2 horas de jogo, **Then** essa pergunta não
   é sorteada novamente.
2. **Given** um jogador com 4 erros consecutivos, **When** comete mais um erro,
   **Then** ocorre game over.
3. **Given** um jogador com até 4 erros consecutivos, **When** continua jogando,
   **Then** a partida permanece ativa.

### Edge Cases

- Pool de perguntas elegíveis temporariamente reduzido por causa da regra de
  anti-repetição em sessões longas.
- Concentração insuficiente de perguntas em uma faixa de dificuldade específica
  para determinado nível do jogador.
- Troca rápida de nível com histórico recente grande de perguntas respondidas.
- Retomada de sessão após interrupção do app durante a janela de 2 horas de
  jogo.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema DEVE disponibilizar uma base inicial com exatamente 1000
  perguntas válidas e utilizáveis.
- **FR-002**: O sistema DEVE garantir variedade temática na base inicial,
  evitando concentração excessiva em um único tema.
- **FR-002a**: A base inicial DEVE conter no mínimo 10 categorias, cada uma com
  pelo menos 50 perguntas válidas.
- **FR-003**: Cada pergunta DEVE possuir classificação de dificuldade inteira
  entre 1 e 10.
- **FR-004**: O sistema DEVE selecionar perguntas de forma aleatória entre as
  candidatas elegíveis no momento do sorteio.
- **FR-005**: O sistema DEVE priorizar perguntas de menor dificuldade nos níveis
  iniciais do jogo.
- **FR-006**: O sistema DEVE aumentar progressivamente a predominância de
  perguntas de maior dificuldade conforme o avanço de nível do jogador.
- **FR-006a**: O sorteio por nível DEVE usar distribuição ponderada progressiva,
  mantendo pequena probabilidade residual para faixas de dificuldade fora da
  predominante do nível atual.
- **FR-006b**: Em conflito entre faixa de dificuldade alvo e pool elegível, o
  sistema DEVE priorizar anti-repetição e aleatoriedade, permitindo sorteio em
  qualquer dificuldade elegível.
- **FR-007**: O sistema DEVE impedir que uma pergunta já respondida seja
  reapresentada ao mesmo jogador dentro das próximas 2 horas de jogo.
- **FR-008**: O sistema DEVE considerar a janela de anti-repetição em tempo de
  relógio corrido (wall-clock), incluindo períodos com o app fechado.
- **FR-009**: O sistema DEVE manter rastreio das perguntas recentes suficientes
  para aplicar a regra de anti-repetição durante toda a sessão.
- **FR-009a**: Se não houver perguntas elegíveis por causa da janela de
  anti-repetição, o sistema DEVE limpar o histórico recente e retomar o
  sorteio normal imediatamente.
- **FR-010**: O sistema DEVE alterar o limite de erros consecutivos de 3 para 5
  antes de acionar game over.
- **FR-011**: O sistema DEVE manter compatibilidade com as regras existentes de
  pontuação, avanço de nível e continuidade de partida.
- **FR-012**: O sistema DEVE garantir que os ajustes de seleção e anti-repetição
  sejam aplicados de forma consistente em reabertura de sessão.

### Non-Functional Requirements

- **NFR-001**: A lógica de seleção e anti-repetição deve ser previsível e
  auditável por testes automatizados de regras de negócio.
- **NFR-002**: A experiência de sorteio de nova pergunta deve ocorrer sem atraso
  perceptível ao jogador em uso normal.
- **NFR-003**: A especificação e documentação relacionadas a essa feature devem
  permanecer em Português (Brasil), com linguagem clara.

### Key Entities *(include if feature involves data)*

- **PerguntaBase**: Item de conteúdo jogável com enunciado, resposta,
  classificação de dificuldade (1 a 10) e metadados de categoria.
- **PerfilDeDificuldadePorNivel**: Regra de distribuição que define
  predominância esperada de faixas de dificuldade por nível do jogador.
- **HistoricoRecenteDePerguntas**: Registro temporal das perguntas já
  respondidas por jogador para bloquear repetição por 2 horas de jogo.
- **ConfiguracaoDePartida**: Conjunto de parâmetros ativos da sessão,
  incluindo limite de erros consecutivos antes de game over.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A base inicial contém 1000 perguntas válidas, únicas e
  classificadas de 1 a 10.
- **SC-001a**: A base inicial valida no mínimo 10 categorias com pelo menos 50
  perguntas por categoria.
- **SC-002**: Em amostragem representativa de partidas nos níveis 1 a 3, ao
  menos 70% das perguntas sorteadas pertencem às faixas de dificuldade 1 a 3.
- **SC-003**: Em amostragem representativa de partidas nos níveis 8 a 10, ao
  menos 70% das perguntas sorteadas pertencem às faixas de dificuldade 8 a 10.
- **SC-003a**: Nos cenários com escassez de perguntas da faixa alvo, 100% dos
  sorteios respeitam anti-repetição e mantêm seleção aleatória no pool
  elegível.
- **SC-004**: Em sessões de teste com duração de até 2 horas de jogo ativo, a
  taxa de repetição de pergunta já respondida é 0% enquanto houver pool
  elegível; ao esgotar pool, o reset de histórico é aplicado conforme regra.
- **SC-005**: O game over ocorre apenas no 5º erro consecutivo em 100% dos
  cenários de validação das regras de partida.

## Assumptions

- A nova base inicial de 1000 perguntas substituirá ou complementará o conjunto
  inicial existente sem alterar o modelo conceitual de pergunta.
- A janela de 2 horas para anti-repetição usa tempo de relógio corrido, mesmo
  quando o app está fechado.
- A progressão por níveis existente (1 a 10 como referência de dificuldade)
  permanece válida e não será redefinida nesta feature.
- A aleatoriedade deve atuar dentro do conjunto de perguntas elegíveis após a
  aplicação das regras de nível e anti-repetição.
- A criação de branch solicitada foi atendida pelo hook obrigatório antes da
  geração desta especificação.
