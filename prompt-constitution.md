/speckit.constitution /speckit.constitution
Criar a especificação e arquitetura para um aplicativo mobile em Flutter chamado "QuizVerse: Forca". O app é um jogo de quiz dinâmico baseado em perguntas de conhecimentos gerais e atualidades.
Toda a documentação do projeto deve ser elaborada no idioma Português (Brasil) e o conteúdo deve ser claro, conciso e livre de jargões técnicos desnecessários, garantindo acessibilidade para uma ampla audiência.

---

## 1. Visão Geral e Escopo

* **Tecnologia:** Flutter (foco em performance, componentes estilizados, interface limpa leve e fluida, multiplataforma Android/iOS).
* **Público-alvo:** Jovens e adultos interessados em trivia, atualidades e jogos mentais.
* **Idioma:** Multi-idioma: Pelo menos Português (Brasil), Inglês e Italiano.
* **Modo de Jogo:** Single-player offline (com cache local) e sync assíncrono para atualização do banco de perguntas.

---

## 2. Mecânicas de Jogo (Gameplay)

Cada partida consiste em uma pergunta cuja resposta deve ser descoberta através do modo Forca Moderna. Cada pergunta respondida corretamente avança o jogo para a próxima partida. Após cada resposta (correta ou incorreta), o usuário recebe um breve contexto histórico ou educativo relacionado à pergunta, enriquecendo a experiência de aprendizado. Após 10 perguntas corretas, o usuário avança para o próximo nível, onde as perguntas se tornam mais difíceis. O progresso do usuário é salvo localmente, permitindo que ele retome o jogo de onde parou a qualquer momento. O aplicativo também inclui um sistema de conquistas (troféus)e pontuação para incentivar o engajamento contínuo. A quantidade de perguntas disponíveis é dinâmica, com atualizações regulares para manter o conteúdo fresco e relevante. A quantidade de níveis é definida pela quantidade de perguntas disponíveis, com cada nível exigindo 10 acertos acertos para avançar. Após 3 erros consecutivos, o usuário é redirecionado para a tela de Game Over, onde pode optar por continuar no mesmo nível mantendo os acertos (pagando 1 troféu) ou reiniciar o nível com zero acertos (sem custo).

### Modo A: Forca Moderna

* Exibe a pergunta (dica contextualizada).
* Exibe os traços correspondentes às letras da palavra-resposta.
* Limite de 6 erros. Em vez de uma forca tradicional, utilizar uma animação de barra de energia/vida.
* O usuário insere letras para tentar adivinhar a resposta. Letras corretas preenchem os traços, enquanto letras incorretas reduzem a barra de energia.

---

## 3. Arquitetura de Software e Estado

* **Gerenciamento de Estado:** Utilizar BLoC ou Riverpod para separar estritamente a lógica de negócio da UI.
* **Arquitetura:** Clean Architecture adaptada para Flutter (Data, Domain, Presentation).
* **Banco de Dados Local:** Usar Database ou Hive para armazenar o progresso do usuário, pontuação, conquistas e o pool de perguntas baixadas.
* **Estrutura de Dados da Pergunta (Model):**

    ```json
    {
      "id": "uuid",
      "pergunta": "String",
      "resposta": "String (uppercase, sem acentos para o jogo)",
      "exibicao_resposta": "String (com acentos para mostrar ao vencer)",
      "categoria": "String",
      "dificuldade": "Number (1-10)",
      "contexto_historico": "String (breve texto educativo exibido após acertar/perder)"
    }
    ```

* **Sincronização de Perguntas:** Implementar um mecanismo de sincronização assíncrona silenciosa que baixa novas perguntas de um arquivo json localizado em [https://github.com/colliplanura/quizz/perguntas.json](https://github.com/colliplanura/quizz/perguntas.json) utilizando fetch direto do GitHub para evitar a necessidade de um backend dedicado. O aplicativo deve verificar por atualizações no pool de perguntas a cada 24 horas ou quando o usuário atingir um novo nível, garantindo que o conteúdo permaneça fresco e relevante.
