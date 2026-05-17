# Feature Specification: QuizVerse: Forca

> Aplicativo mobile em Flutter com gameplay offline-first e sincronização
> silenciosa de perguntas. Um jogo de adivinhação de palavras (Forca) com
> progressão por níveis, sistema de troféus e múltiplos idiomas.

**Feature Branch**: `001-quizverse-forca`

**Created**: 2026-05-16

**Status**: Final

**Input**: Descrição da constituição v1.1.0, governa flutter mobile-first,
offline-first, estado testável, comunicação clara em português (Brasil), e
conteúdo confiável com progressão justa.

## Clarifications

### Session 2026-05-16

- Q: Does QuizVerse require user accounts and login? → A: Fully local/anonymous
  (no accounts, no login, progress stored only on device). Aligns with
  offline-first and keeps P1/P2 scope simple.

- Q: What is initial state when player first opens app? → A: Level 1, Score 0,
  Trophies 1. Start with 1 free trophy for fair first-game experience,
  improving engagement without over-generosity.

- Q: Target scale limits for levels and questions? → A: Unlimited levels,
  500–1000 question pool. Supports indefinite progression, fresh content via
  GitHub sync, fits storage/performance targets (< 10 MB typical).

- Q: Detailed guidelines for educational context ("1-2 frases")? → A: Strict:
  1-2 sentences, max 120 characters per language. Ensures consistency,
  simplifies localization, prevents UI overflow, makes validation testable.

- Q: Security & privacy posture (data at rest, transmission, reporting)? → A:
  Minimal for P1. HTTPS only for GitHub sync. No crash reporting, no telemetry,
  no local encryption, no privacy policy needed. Aligns with simplicity; add
  privacy features in P3+.

- Q: Como modelar `contexto_historico` para multi-idioma? → A: Objeto por
  idioma no payload (`pt_BR`, `en`, `it`) com fallback obrigatório para `pt_BR`
  quando uma chave estiver ausente.

- Q: O que fazer se 100% do payload de sincronização vier inválido? → A:
  Manter o cache local atual, registrar erro e continuar o jogo sem alerta
  modal.

- Q: O que acontece no Game Over quando o jogador tem 0 troféus? → A:
  Desabilitar "Continuar", exibir mensagem curta e permitir apenas
  "Reiniciar".

- Q: Como tratar primeira execução sem cache local de perguntas? → A:
  Embutir um conjunto mínimo de perguntas locais no app para primeiro uso
  offline.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Jogar Forca Offline (Priority: P1)

Um jogador abre o QuizVerse: Forca em seu dispositivo Android ou iOS e quer
jogar uma partida de adivinhação de palavras (Forca Moderna) completamente
offline, sem conexão de internet. O jogo deve carregar as perguntas do cache
local, permitir adivinhar letras, acompanhar erros consecutivos, avançar de
nível ao acertar 10 respostas seguidas, e oferecer contexto educativo após
cada acerto ou erro.

**Why this priority**: Esta é a funcionalidade central do app. Sem ela, não há
jogo. Ela valida que o app consegue persistir dados localmente, gerenciar estado
de forma previsível, e oferecer uma experiência fluida e offline.

**Independent Test**: Um jogador pode abrir o app sem internet, completar uma
partida inteira do Forca (do nível 1 até um nível mais avançado), e o progresso
é salvo automaticamente. O jogo encerra corretamente com Game Over após 3 erros
consecutivos, oferecendo a opção de continuar (gastando 1 troféu) ou reiniciar
(retornando ao nível 1 e zerrando pontuação).

**Acceptance Scenarios**:

1. **Given** o jogador está no nível 1 sem conexão de internet, **When** abre o
   app e vê a tela inicial, **Then** o cache local de perguntas é carregado e a
   primeira pergunta aparece em menos de 2 segundos.

2. **Given** uma pergunta está exibida com a barra de erros (inicialmente 0/3),
   **When** o jogador adivinha uma letra correta, **Then** a letra aparece nas
   posições corretas e o contador de acertos é incrementado em 1.

3. **Given** o jogador adivinhou 10 respostas corretamente no nível N, **When**
   responde a 10ª corretamente, **Then** o nível é incrementado para N+1, a
   dificuldade das próximas perguntas aumenta, e uma mensagem de celebração
   aparece.

4. **Given** o jogador errou 3 vezes consecutivas, **When** comete o 3º erro,
   **Then** a tela de Game Over aparece mostrando pontuação final e oferecendo
   "Continuar (1 troféu)" ou "Reiniciar".

5. **Given** a tela de Game Over está exibida e o jogador tem 0 troféus,
   **When** tenta clicar em "Continuar", **Then** o botão está desabilitado e
   uma mensagem explica que é preciso de 1 troféu.

6. **Given** uma resposta foi revelada, **When** o jogador vê o resultado,
   **Then** um contexto educativo curto (1-2 frases) explica a pergunta ou a
   resposta.

7. **Given** o app foi fechado durante uma partida, **When** reabre, **Then** a
   partida anterior é restaurada exatamente no mesmo estado (nível, pontuação,
   erros, pergunta atual).

---

### User Story 2 - Sincronizar Perguntas do GitHub (Priority: P2)

Um jogador está jogando normalmente, e o app busca silenciosamente novas
perguntas do GitHub a cada 24 horas ou quando o jogador avança de nível. A
sincronização ocorre sem bloquear o jogo, sem corromper o progresso local, e
mantém o cache atualizado com as perguntas mais recentes.

**Why this priority**: Garante que o conteúdo do jogo fica fresco e relevante
sem prejudicar a experiência offline. Valida que o app consegue fazer
sincronização assíncrona e segura, cumprindo os princípios de offline-first e
estado confiável.

**Independent Test**: Um jogador joga uma sessão completa (múltiplos níveis) sem
internet. Em paralelo, o app (em background) verifica a cada 24h ou quando o
nível sobe se há novas perguntas no GitHub. Se houver, baixa e integra de forma
silenciosa (sem notificação visível, sem travamento de jogo). O progresso local
nunca é perdido ou corrompido, mesmo que a sincronização falhe.

**Acceptance Scenarios**:

1. **Given** o app iniciou e 24 horas se passaram desde a última sincronização,
   **When** o jogador está jogando, **Then** em background uma requisição ao
   GitHub é disparada (sem pausar o jogo) para buscar `perguntas.json`.

2. **Given** uma sincronização está em andamento, **When** o jogador responde
   uma pergunta e avança de nível, **Then** o novo nível é registrado sem
   esperar a sincronização terminar.

3. **Given** novas perguntas foram baixadas do GitHub, **When** a sincronização
   termina, **Then** o pool local de perguntas é atualizado, mas o jogo
   continua com o cache antigo até a próxima pergunta ser sorteada.

4. **Given** a sincronização falha (rede indisponível ou erro HTTP), **When** o
   app detecta a falha, **Then** um log registra a tentativa e o jogo continua
   normalmente com o cache existente. Uma nova tentativa é agendada para a
   próxima oportunidade (próximo nível up ou próximas 24h).

5. **Given** o app sincronizou com sucesso, **When** verifica a integridade das
   novas perguntas, **Then** qualquer pergunta malformada ou faltando campos
   obrigatórios é rejeitada e não contamina o cache.

6. **Given** o jogador ganhou um nível, **When** o nível sobe, **Then** uma
   sincronização é disparada imediatamente (se ainda não tiver sido feita nesse
   período de 24h), sem bloquear a celebração do nível up.

---

### User Story 3 - Interface em Múltiplos Idiomas (Priority: P3)

Um jogador que fala Inglês, Italiano ou prefere Português (Brasil) abre o
QuizVerse e vê a interface no idioma de sua preferência. Rótulos de botões,
mensagens de erro, contextos educativos e toda a UI falam na língua correta.
Se uma tradução faltar para um texto específico, o app cai de volta para
português (Brasil) de forma silenciosa.

**Why this priority**: Expande o alcance do app para audiências internacionais.
Demonstra que o app consegue gerenciar múltiplas linguas sem complexidade
desnecessária. Conforma-se com o princípio de comunicação clara e acessibilidade
(Princípio IV).

**Independent Test**: Um jogador com o idioma do sistema configurado em
Inglês abre o app. Todos os rótulos de UI, mensagens, contextos educativos e
diálogos aparecem em Inglês. Se mudar para Italiano, a UI muda
instantaneamente. Se uma chave de tradução não existir, o texto cai de volta
para português (Brasil) sem erros.

**Acceptance Scenarios**:

1. **Given** a configuração do sistema está em English, **When** o app inicia,
   **Then** toda a UI aparece em Inglês (botões, títulos, mensagens de game over,
   contextos educativos).

2. **Given** a configuração do sistema está em Italiano, **When** o app inicia,
   **Then** toda a UI aparece em Italiano.

3. **Given** uma chave de tradução não existe em um idioma (p. ex., uma nova
   mensagem de erro), **When** o app tenta exibir essa mensagem, **Then** o
   texto em Português (Brasil) é exibido e nenhum erro é lançado.

4. **Given** o jogador está jogando em Inglês, **When** muda o idioma do
   sistema para Italiano, **Then** a tela atual é atualizada imediatamente para
   Italiano (sem fechar/reabrir o app).

5. **Given** uma pergunta ou contexto educativo é sincronizado do GitHub,
   **When** o app exibe o contexto, **Then** o idioma selecionado é respeitado
   (se o contexto tiver tradução disponível em JSON).

---

### Edge Cases

- **Rede instável ou intermitente**: O app começa a sincronizar, a conexão
  cai no meio. O app registra a tentativa, cancela graciosamente, e não corrompe
  dados.

- **Limite de armazenamento local**: Se o cache de perguntas ficar muito grande
  (novo conteúdo do GitHub), o app deve limpar cache antigo ou oferecer opção
  para deletar progresso de níveis completados (oferecendo troféus bônus como
  compensação).

- **Pergunta mal-formada no GitHub**: Um objeto de pergunta não tem `resposta`
  ou `pergunta`. O app rejeita a entrada, loga o erro, e não deixa o jogador
  ficar sem perguntas.

- **Payload totalmente inválido na sincronização**: Se 100% das entradas de
  `perguntas.json` forem inválidas, o app mantém o cache local atual, registra
  erro e continua o jogo sem exibir alerta modal.

- **Troféu insuficiente para continuar**: O jogador tenta continuar após Game
  Over mas tem 0 troféus. O app desabilita "Continuar", exibe mensagem curta
  explicativa e permite apenas "Reiniciar".

- **Jogador fecha o app durante sincronização**: O app deve salvar qualquer
  novo dado já recebido, fechar a conexão graciosamente, e na próxima abertura
  retomar o jogo sem perder progresso.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Sistema DEVE permitir ao jogador jogar Forca completamente offline,
  usando cache local de perguntas, progresso e pontuação. Na primeira execução,
  sem cache prévio, DEVE carregar um conjunto mínimo embarcado de perguntas.

- **FR-002**: Sistema DEVE sincronizar novas perguntas do GitHub
  (`https://github.com/colliplanura/quizz/perguntas.json` ou raw endpoint) de
  forma assíncrona e silenciosa, a cada 24 horas ou quando o jogador avança de
  nível, o que ocorrer primeiro.

- **FR-003**: Sistema DEVE incrementar o contador de acertos ao acertar uma
  pergunta e incrementar contador de erros consecutivos ao errar. Após 10
  acertos, o nível deve incrementar; após 3 erros consecutivos, Game Over.

- **FR-004**: Sistema DEVE exibir contexto educativo curto após cada acerto ou
  erro. O campo `contexto_historico` deve ser estruturado por idioma
  (`pt_BR`, `en`, `it`) com fallback obrigatório para `pt_BR`. Formato por
  idioma: 1-2 sentences, máximo 120 caracteres. Se conteúdo exceder, truncar
  com "..." e logar aviso. Simplifica localização e validação.

- **FR-005**: Sistema DEVE permitir ao jogador continuar após Game Over pagando
  1 troféu (mantendo nível e pontuação) ou reiniciar (retornando ao nível 1,
  pontuação zero, sem gasto de troféu). Quando o jogador tiver 0 troféus,
  "Continuar" DEVE ficar desabilitado com mensagem explicativa.

- **FR-006**: Sistema DEVE suportar no mínimo Português (Brasil), Inglês e
  Italiano na UI, com fallback automático para Português (Brasil) se tradução
  faltar.

- **FR-007**: Sistema DEVE persistir em armazenamento local (Hive, SQLite ou
  similar offline-first) o estado do jogo, progresso, pontuação, troféus, nível
  atual, timestamp da última sincronização e pool de perguntas.

- **FR-008**: Sistema DEVE recuperar uma partida anterior exatamente no mesmo
  estado se o app foi fechado e reaberto.

- **FR-009**: Sistema DEVE validar integridade de perguntas sincronizadas
  (campos obrigatórios presentes e formatação correta) antes de integrar ao
  cache local. Se 100% do payload estiver inválido, DEVE manter o cache atual,
  registrar erro e seguir sem alerta modal.

- **FR-010**: Sistema DEVE oferecer animação visual da barra de erros (0 a 3
  erros) e celebração ao avançar de nível ou terminar partida com sucesso.

### Non-Functional Requirements

- **NFR-001**: Mudanças de idioma devem refletir em todas as telas sem exigir
  reinício do app, mantendo fallback automático para Português (Brasil) quando
  faltar tradução.

- **NFR-002**: A documentação do projeto (specs, plans, tarefas, README) deve
  ser escrita em Português (Brasil) e manter linguagem clara, concisa e sem
  jargões desnecessários.

- **NFR-003**: O jogo deve continuar funcional sem internet usando o conteúdo
  em cache local, sem limitação de funcionalidade (jogar, progredir, ganhar
  troféus).

- **NFR-004**: A sincronização de perguntas deve ocorrer de forma assíncrona,
  silenciosa e sem bloquear a experiência de jogo. Não deve exibir diálogos de
  carregamento ou progresso de sincronização.

- **NFR-005**: A acessibilidade das telas principais (leitura clara, contraste
  adequado, rótulos acessíveis) deve ser considerada desde a especificação e
  coberta por testes de acessibilidade.

- **NFR-006**: Estado do jogo, progressão, regras de pontuação e regras de
  Game Over devem ser 100% testáveis, com cobertura de testes automáticos
  determinísticos usando BLoC ou Riverpod para gerenciamento de estado.

- **NFR-007**: O app deve tolerar perda de rede durante sincronização sem
  corromper progresso ou cache local. Falhas devem ser registradas em log para
  retry assíncrono. Em caso de payload 100% inválido, deve manter cache local e
  continuar execução sem bloqueio de UI.

- **NFR-008**: Carregamento de pergunta inicial e mudança de pergunta devem
  ocorrer em menos de 1 segundo (percepção de snappiness).

- **NFR-009**: Sincronização não deve consumir mais de 5 MB de banda em uma
  requisição típica (arquivo perguntas.json). Cache deve ser versionado para
  detectar duplicatas após sincronização múltipla.

- **NFR-010**: Security posture para P1 é minimal: HTTPS para GitHub sync,
  nenhum crash reporting, nenhuma telemetria, nenhuma criptografia local,
  nenhuma privacy policy obrigatória. Crash reporting and local encryption são
  features futuras (P3+).

### Key Entities

- **Pergunta**: {id, pergunta, resposta (normalizada), exibicao_resposta
  (display), categoria, dificuldade (1-10 escala), contexto_historico
  {pt_BR, en, it}}. Fonte: JSON do GitHub. Armazenagem: SQLite/Hive local.

- **Progresso do Jogador**: {nível_atual, pontuação_total, acertos_consecutivos,
  erros_consecutivos, troféus_ganhos, partida_ativa (dados da partida em
  andamento), timestamp_última_sincronização}. Armazenagem: SQLite/Hive local.

- **Partida**: {nível, acertos_neste_nível, erros_consecutivos, pergunta_atual,
  histórico_de_respostas, estado (em andamento, game over, nível completo)}.
  Escopo: volátil, não persiste entre sessions a menos que a partida esteja
  "parada" por Game Over ou conclusão.

- **Troféu**: {tipo, nome, descrição, data_ganho}. Exemplos: "First 10",
  "Level 5 Master", "Comeback Champion" (1 troféu gasto ao continuar após Game
  Over). Armazenagem: SQLite/Hive local.

- **Configuração de Idioma**: {idioma_preferido (pt_BR, en, it), data_alteração}.
  Lida com localização de strings de UI e fallback automático.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Um jogador pode completar uma partida inteira (acertar 10
  perguntas e avançar de nível) em menos de 5 minutos sem internet. Sistema
  responde em < 1 segundo por pergunta.

- **SC-002**: Sincronização de novas perguntas ocorre de forma silenciosa (zero
  notificações visíveis), e o jogo não interrompe por mais de 100ms durante
  sincronização.

- **SC-003**: Falhas de sincronização (rede indisponível ou payload inválido)
  são registradas em log, o cache local é preservado intacto, e a próxima
  tentativa é agendada corretamente (próximo level-up ou +24h). Verificável
  por teste automatizado de resiliência (T053, T080).

- **SC-004**: Todas as strings de UI carregam corretamente em Português
  (Brasil), Inglês e Italiano. Fallback para Português (Brasil) ocorre sem
  erros em < 10ms.

- **SC-005**: Progresso de jogo é persistido em < 100ms. Reload após crash
  recupera estado exatamente (0% perda de progresso).

- **SC-006**: Game Over oferece duas opções (continuar com troféu, reiniciar) e
  ambas funcionam corretamente 100% das vezes (sem travamentos ou corrupção de
  dados).

- **SC-007**: Sistema de testes cobre >= 90% de cobertura das regras de jogo
  (progressão, Game Over, troféus). Todo caminho crítico tem teste automático
  determinístico.

- **SC-008**: Perguntas sincronizadas do GitHub são validadas; 100% das
  perguntas malformadas são rejeitadas e logadas, zero perguntas corrompidas no
  cache local.

## Assumptions

- **Modelo de Usuário**: Totalmente local e anônimo. Nenhuma conta, login ou
  autenticação necessária. Progresso armazenado apenas no dispositivo do
  jogador. Sincronização de nuvem e contas são recursos futuros (P4+).

- **Estado Inicial**: Quando o jogador abre o app pela primeira vez (ou após
  limpar dados), começa no Nível 1, Pontuação 0, com 1 Troféu. Este troféu
  inicial oferece uma experiência justa na primeira partida e melhora
  engajamento.

- **Usuário alvo**: Jogadores de 13+ anos interessados em quiz e aprendizado
  (audência educativa).

- **Conectividade**: Usuários têm internet ocasional (não contínua) para
  sincronização inicial e updates de conteúdo, mas jogam majoritariamente
  offline.

- **Primeiro uso offline**: O app inclui um conjunto mínimo de perguntas
  embarcado para permitir jogar imediatamente sem internet na primeira
  execução.

- **Arquitetura Flutter**: App é Flutter 3.x ou superior, com BLoC ou Riverpod
  para state management, Hive ou SQLite para persistência local, e
  easy_localization ou similar para multi-idioma. (Detalhes de framework serão
  definidos no plano.)

- **GitHub como fonte única de verdade**: O arquivo `perguntas.json` no
  repositório GitHub é a fonte única e confiável para novas perguntas. Formato
  é JSON com estrutura [{id, pergunta, resposta, exibicao_resposta, categoria,
  dificuldade, contexto_historico: {pt_BR, en, it}}, ...]. Pool target:
  500–1000 perguntas totais. Sem cap em níveis (progressão infinita suportada).

- **Formato do Contexto Educativo**: Cada pergunta deve ter um campo
  `contexto_historico` como objeto por idioma (`pt_BR`, `en`, `it`), com máximo
  120 caracteres por idioma, contendo 1-2 sentences. Se a chave do idioma
  ativo não existir, usar `pt_BR` como fallback automático. Se conteúdo exceder,
  será truncado na exibição (com "...") e um aviso será logado durante
  sincronização. Garante consistência de UI e simplifica localização.

- **Limite de troféus**: Troféus podem ser gastos apenas ao continuar após Game
  Over. Outras formas de ganhar troféus (vídeos ad, bônus de nível, daily
  challenges) podem ser adicionadas em futuras versões (P4+).

- **Sem backend dedicado**: O app não requer servidor de backend. GitHub é usado
  diretamente para question content. Progresso do jogador é privado ao
  dispositivo (sem sincronização de nuvem nesta versão).

- **Idiomas iniciais**: Português (Brasil) é obrigatório. Inglês e Italiano são
  suportados com fallback. Outros idiomas podem ser adicionados em versões
  futuras sem redesenho da arquitetura.

- **Offline não significa "forever"**: App funciona offline com cache existente,
  mas novas perguntas só sincronizam quando conectado. Esperado que usuário
  tenha acesso a internet a cada 24h (razoável para mobile).

- **Segurança & Privacidade para P1**: Postura minimal. HTTPS para GitHub sync.
  Sem crash reporting, telemetria, criptografia local, ou privacy policy. Dados
  armazenados em plain text localmente (aceitável para jogo anônimo
  single-device offline). Criptografia e reportings são features P3+.
