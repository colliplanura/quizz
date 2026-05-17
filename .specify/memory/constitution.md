<!--
Sync Impact Report

- Version change: 1.0.0 -> 1.1.0
- Modified principles:
	- Template Principle 1 -> I. Arquitetura Flutter Mobile em Primeiro Lugar
	- Template Principle 2 -> II. Jogo Offline-First e Sincronização Silenciosa
	- Template Principle 3 -> III. Estado e Regras Testáveis (NÃO NEGOCIÁVEL)
	- Template Principle 4 -> IV. Comunicação Clara, Acessibilidade e Idioma do Projeto
	- Template Principle 5 -> V. Conteúdo Confiável e Progressão Justa
- Added sections:
	- Padrões Técnicos
	- Fluxo de Trabalho e Qualidade
- Removed sections:
	- None
- Templates requiring updates:
	- ✅ updated: .specify/templates/spec-template.md
	- ✅ updated: .specify/templates/plan-template.md
	- ✅ updated: .specify/templates/tasks-template.md
	- ✅ updated: README.md
	- ⚠ pending: .specify/templates/commands/*.md (directory not present in repository)
- Follow-up TODOs:
	- None
-->

# QuizVerse: Forca Constitution

## Core Principles

### I. Arquitetura Flutter Mobile em Primeiro Lugar

Todo recurso deve nascer para Flutter, com foco em Android e iOS, e com a
lógica de negócio separada em Data, Domain e Presentation. A UI não pode conter
regras de negócio nem depender diretamente de detalhes de armazenamento.

Racional: isso mantém o app leve, testável e fácil de evoluir.

### II. Jogo Offline-First e Sincronização Silenciosa

O jogo precisa funcionar sem internet, usando cache local para progresso,
pontuação, troféus e perguntas já baixadas. A sincronização de novas perguntas
deve ser silenciosa, assíncrona e segura para o estado salvo. Se houver conflito,
o conteúdo local e o progresso do jogador nunca podem ser corrompidos.

Racional: a experiência principal do app precisa continuar disponível mesmo sem
rede.

### III. Estado e Regras Testáveis (NÃO NEGOCIÁVEL)

As regras de jogo, progresso, pontuação, conquistas e telas críticas devem ter
testes automáticos determinísticos. O gerenciamento de estado deve usar BLoC ou
Riverpod para isolar efeitos colaterais da interface. Sem testes que cubram os
fluxos centrais, o recurso não deve ser considerado pronto.

Racional: a justiça do jogo depende de regras previsíveis e verificáveis.

### IV. Comunicação Clara, Acessibilidade e Idioma do Projeto

Toda documentação do projeto deve ser escrita em Português (Brasil), com texto
claro, conciso e sem jargões desnecessários. A interface do app deve suportar,
no mínimo, Português (Brasil), Inglês e Italiano, com comportamento de reserva
quando faltar tradução. As telas também devem considerar leitura fácil,
contraste adequado e rótulos acessíveis.

Racional: o produto precisa ser compreensível para uma audiência ampla, sem
barreiras de linguagem ou de uso.

### V. Conteúdo Confiável e Progressão Justa

Cada pergunta deve guardar a resposta em formato normalizado para o jogo e a
forma de exibição com acentos. A progressão deve ser objetiva: 10 acertos por
nível, 3 erros consecutivos levam ao Game Over e a condição de continuar ou
reiniciar precisa seguir exatamente as regras definidas. Todo acerto ou erro
deve gerar um contexto educativo curto.

Racional: o valor do QuizVerse depende de progresso justo e conteúdo confiável.

## Padrões Técnicos

- Flutter é a base obrigatória do cliente mobile.
- O armazenamento local deve manter progresso, pontuação, troféus, estado de
  nível, carimbo da última sincronização e o pool de perguntas baixadas.
- A sincronização de perguntas deve buscar o arquivo JSON direto do GitHub em
  `https://github.com/colliplanura/quizz/perguntas.json` ou no endpoint bruto
  equivalente, sem backend dedicado.
- O app deve verificar novas perguntas a cada 24 horas ou sempre que o jogador
  avançar de nível, o que ocorrer primeiro.
- Se a rede estiver indisponível, o app deve continuar com o conteúdo em cache
  e registrar a tentativa de sincronização para a próxima oportunidade.
- A documentação técnica e os textos de orientação do projeto devem ser claros,
  curtos e em Português (Brasil).

## Fluxo de Trabalho e Qualidade

- Especificações, planos, tarefas e README devem ser escritos em Português
  (Brasil) e evitar jargões desnecessários.
- Todo plano deve passar por Constitution Check antes da pesquisa e depois do
  desenho da solução.
- As tarefas devem cobrir offline, sincronização, acessibilidade, idioma e
  persistência local sempre que essas capacidades existirem.
- Pull requests precisam indicar quais princípios da constituição foram afetados
  e como foram validados.
- Qualquer exceção a estes princípios deve ser temporal, justificada e aprovada
  antes de seguir para implementação.

## Governance

Esta constituição prevalece sobre preferências locais de processo quando houver
conflito. Mudanças exigem proposta documentada, revisão e atualização dos
artefatos afetados.

A versão segue SemVer:

- MAJOR: mudanças de governança ou redefinição de princípios.
- MINOR: novo princípio, nova seção ou ampliação material.
- PATCH: ajustes de texto, clareza e refinamento sem mudança de regra.

Revisões de conformidade:

- Cada ciclo de planejamento deve incluir a verificação da constituição.
- Cada conjunto de tarefas deve apontar cobertura para os princípios aplicáveis.
- Toda exceção precisa ter prazo, responsável e motivo registrados no plano.

**Version**: 1.1.0 | **Ratified**: 2026-05-16 | **Last Amended**: 2026-05-16
