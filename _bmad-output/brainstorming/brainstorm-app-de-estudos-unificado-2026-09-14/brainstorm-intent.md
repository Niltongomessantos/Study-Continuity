# Intent do App de Estudos Unificado

## Visao

Criar um painel Web de continuidade, hospedado localmente e acessado pelo navegador, onde o aluno sabe imediatamente o proximo passo: organizar horarios, materiais, links e lembretes em um unico lugar.

## Problema

- O aluno tem materiais e aulas espalhados em diferentes plataformas.
- Nem sempre sabe o que estudar no horario certo.
- Precisa acessar rapidamente o material planejado.
- Pode perder aulas por falta de avisos antecipados.

## Usuario

Aluno que utiliza multiplas plataformas e precisa organizar estudos independentes com horarios flexiveis.

## Escopo do MVP

- Aplicacao Web hospedada localmente, acessada pelo navegador, sem instalacao desktop e sem hospedagem em nuvem por enquanto.
- Agenda de estudos integrada ao Google Calendar para eventos e notificacoes, com o calendario funcionando como canal de alerta e projeção visual.
- Cadastro de materias, sessoes, horarios, duracao e materiais.
- Suporte a links externos, playlists do YouTube, PDFs e arquivos locais.
- Abertura de plataformas externas no navegador.
- Painel com proxima sessao, sessoes anteriores e proximas, incluindo status.
- Armazenamento local em banco simples e persistencia local como fonte de verdade do dominio do estudo.
- Estrutura inicial para integracao com o Google Calendar, mantendo a sincronizacao separada do dominio de estudos para permitir evolucao futura.
- Sem tutor de IA, nuvem, mobile, webview ou integrações complexas no MVP.
- O foco principal do MVP e o cronograma, a agenda, a continuacao do estudo e a integracao com o Google Calendar.

## Modelo do dominio do estudo

### Aula gerenciada

Uma sessao com horario previsto, duracao, objetivo, material, status e possibilidade de reposicao quando nao iniciada. O app decide se ela deve ser reagendada ou marcada como perdida, e essa regra fica no dominio local.

Regra de negocio final do MVP:
- a aplicacao exige que o usuario escolha explicitamente se a sessao e uma aula gerenciada ou um bloco livre.
- se o usuario nao iniciar a aula dentro do prazo de tolerancia, a aula e marcada como perdida automaticamente.
- ao iniciar, o sistema comeca a contar o tempo imediatamente.
- quando o tempo configurado termina, a aula e marcada como concluida automaticamente.
- se o usuario interromper a aula durante o processo, ela e considerada concluida somente se tiver atingido pelo menos 50% do tempo planejado; caso contrario, e considerada perdida.
- atraso sem compensacao: se o usuario entrar tarde, o tempo perdido nao e compensado.
- o minimo aceitavel para a aula ser considerada concluida e 50% do tempo planejado.
- reposicao e oferecida somente para aulas nao iniciadas ou perdidas.

### Bloco recorrente livre

Um bloco de tempo recorrente com horario, duracao, lembrete, material externo e cronometro local, sem acompanhar progresso detalhado da plataforma externa. O aluno pode alterar somente uma ocorrencia ou toda a serie, pausar, finalizar e liberar o horario. O comportamento de recorrencia e excecao fica no dominio local e a projeção no calendario e uma representação externa.

Regra de negocio final do MVP:
- o bloco livre nao controla o conteudo da plataforma externa nem o progresso da mesma.
- o bloco livre mede o tempo em que o usuario esta dedicando atencao ao estudo.
- o cronometro do bloco livre segue a mesma logica da aula gerenciada: iniciar, contar tempo e registrar status.
- o bloco livre pode ter link, material externo e lembrete, mas nao assume o dominio da plataforma externa.
- a sessao pode ser recorrente e pode repetir em dias ou semanas com excecoes manuais.

## Definicao do papel do Google Calendar

- O Google Calendar e o canal principal de notificacao e lembrete.
- O calendario nao deve absorver o dominio completo do estudo nem substituir as regras internas de reposicao, atraso e status.
- O app local garante a logica das sessoes, e o calendario reflete esse estado por meio de eventos e lembretes.
- O vinculo entre app e evento deve ser mantido por identificadores locais e externos.
- O fluxo e unidirecional: do sistema local para o Google Calendar.
- Qualquer alteracao feita no evento do calendario externamente nao deve reescrever a logica local do produto no MVP.

## Fluxos principais

1. Criar uma sessao gerenciada ou um bloco recorrente livre.
2. Visualizar a proxima sessao e receber o lembrete.
3. Abrir o material no navegador ou no computador.
4. Usar o cronometro quando aplicavel.
5. Registrar a sessao como concluida, perdida ou ajustada.
6. Consultar o historico e as proximas sessoes.

## Regras operacionais

- O app nao envia notificacoes locais nem notificacoes do navegador.
- As notificacoes sao realizadas exclusivamente pelo Google Calendar, conforme a configuracao dos eventos sincronizados.
- Sessoes livres podem ser iniciadas diretamente na plataforma, sem abrir o app.
- O cronometro e opcional e fica disponivel para modos de treino ou aulas gerenciadas.
- Uma sessao incompleta fica registrada no historico e nao repoe o tempo restante.
- Reagendamento e oferecido somente para aulas nao iniciadas.
- A reposicao pode ser sugerida em horarios livres, inclusive fins de semana, ou escolhida manualmente pelo aluno.
- A reposicao mantem a duracao, o objetivo e o material da aula original.
- O sistema pode permitir ajuste manual posterior quando a aula foi interrompida ou parcialmente concluida.
- O usuario deve ter um prazo de tolerancia para iniciar a aula; fora desse prazo, ela e perdida automaticamente.

## Integracao com Google Calendar

O Google Calendar faz parte da estrutura inicial do MVP. As sessoes planejadas pelo app devem poder ser representadas como eventos no calendario, que sera o unico canal de notificacao. A implementacao deve manter a sincronizacao separada do dominio de estudos para permitir evolucao futura.

Para o MVP, o calendario e uma camada de projeção e alerta. A regra de negocio continua no app local, e o calendario apenas reflete esse estado. A sincronizacao deve ser controlada, sem tornar o calendario a fonte oficial de todo o dominio.

O calendario so deve receber o evento quando a sincronizacao estiver ativada pelo usuario.

## Materiais e plataformas externas

O app organiza links para cursos pagos, YouTube, playlists, PDFs e arquivos locais, mas nao acompanha o progresso de plataformas externas nem depende de integracao tecnica com elas. O navegador externo e o caminho padrao.

O bloco livre e o ponto de entrada para esses materiais externos; a app salva o horario e o link, mas nao toma conta do conteudo ou do progresso da plataforma externa.

## Requisitos de autenticacao e sincronizacao

- O fluxo de OAuth local deve ser definido antes da implementacao para garantir autenticacao segura em localhost.
- O app deve manter estado de sincronizacao, token, autorizacao e erro visivel para o usuario.
- O dominio local deve registrar o status de sincronizacao e os eventos externos vinculados a cada sessao.
- A sincronizacao deve priorizar eventos simples, fila local e retry controlado, sem abrir espaco para sincronizacao bidirecional complexa no MVP.
- O app deve manter fila local de sincronizacao, status, retry e estados visiveis para o usuario.

## Fora do escopo do MVP

- Tutor assistido por IA.
- Hospedagem em nuvem.
- Login automatizado ou coleta de dados de plataformas externas.
- Robo ou MCP server para navegar em plataformas.
- Iframe ou webview como caminho padrao.
- Aplicativo mobile.
- Sincronizacao bidirecional irrestrita ou regras complexas de recorrencia externo-domino.
- Dependencia de plataforma externa para controlar o tempo do estudo.

## Evolucao futura

1. Publicacao da aplicacao em hospedagem remota ou na nuvem.
2. Webview condicional para plataformas compatíveis.
3. Tutor assistido por IA para aulas e exercicios.
4. Integrações avançadas com plataformas, condicionadas a seguranca, permissoes e termos de uso.
5. Gestao aprofundada de materiais, progresso e curriculum.

## Direcao de foco do MVP

- Priorizar o proximo passo do aluno, o material e o horario.
- Manter a funcionalidade principal voltada para continuidade de estudo, nao para um ecossistema genérico de produtividade.
- Reduzir escopo para o que importa de verdade: organizacao local, cronograma, tempo de estudo e lembrete via Google Calendar.
- Manter o dominio local como autoridade de negocio e o calendario como canal de comunicacao externa.
- Garantir que o MVP resolva a agenda e a disciplina de estudo antes de expandir para materiais e IA.

## Fluxos principais

1. Criar uma sessao gerenciada ou um bloco recorrente livre.
2. Visualizar a proxima sessao e receber o lembrete.
3. Abrir o material no navegador ou no computador.
4. Usar o cronometro quando aplicavel.
5. Registrar a sessao como concluida ou nao concluida.
6. Consultar o historico e as proximas sessoes.

## Regras operacionais

- O app nao envia notificacoes locais nem notificacoes do navegador.
- As notificacoes sao realizadas exclusivamente pelo Google Calendar, conforme a configuracao dos eventos sincronizados.
- Sessoes livres podem ser iniciadas diretamente na plataforma, sem abrir o app.
- O cronometro e opcional e fica disponivel para modos de treino ou aulas gerenciadas.
- Uma sessao incompleta fica registrada no historico e nao repoe o tempo restante.
- Nos modos treino e professor, iniciar depois do horario previsto considera perdido o periodo anterior e nao cria reposicao.
- Reagendamento e oferecido somente para aulas nao iniciadas.
- A reposicao pode ser sugerida em horarios livres, inclusive fins de semana, ou escolhida manualmente pelo aluno.
- A reposicao mantem a duracao, o objetivo e o material da aula original.

## Integracao com Google Calendar

O Google Calendar faz parte da estrutura inicial do MVP. As sessoes planejadas pelo app devem poder ser representadas como eventos no calendario, que sera o unico canal de notificacao. A implementacao deve manter a sincronizacao separada do dominio de estudos para permitir evolucao futura.

Para o MVP, o calendario e uma camada de projeção e alerta. A regra de negocio continua no app local, e o calendario apenas reflete esse estado. A sincronizacao deve ser controlada, sem tornar o calendario a fonte oficial de todo o dominio.

## Materiais e plataformas externas

O app organiza links para cursos pagos, YouTube, playlists, PDFs e arquivos locais, mas nao acompanha o progresso de plataformas externas nem depende de integracao tecnica com elas. O navegador externo e o caminho padrao.

## Requisitos de autenticacao e sincronizacao

- O fluxo de OAuth local deve ser definido antes da implementacao para garantir autenticacao segura em localhost.
- O app deve manter estado de sincronizacao, token, autorizacao e erro visivel para o usuario.
- O dominio local deve registrar o status de sincronizacao e os eventos externos vinculados a cada sessao.
- A sincronizacao deve priorizar eventos simples, fila local e retry controlado, sem abrir espaco para sincronizacao bidirecional complexa no MVP.

## Fora do escopo do MVP

- Tutor assistido por IA.
- Hospedagem em nuvem.
- Login automatizado ou coleta de dados de plataformas externas.
- Robo ou MCP server para navegar em plataformas.
- Iframe ou webview como caminho padrao.
- Aplicativo mobile.
- Sincronizacao bidirecional irrestrita ou regras complexas de recorrencia externo-domino.

## Evolucao futura

1. Publicacao da aplicacao em hospedagem remota ou na nuvem.
2. Webview condicional para plataformas compatíveis.
3. Tutor assistido por IA para aulas e exercicios.
4. Integrações avançadas com plataformas, condicionadas a seguranca, permissoes e termos de uso.

## Direcao de foco do MVP

- Priorizar o proximo passo do aluno, o material e o horario.
- Manter a funcionalidade principal voltada para continuidade de estudo, nao para um ecossistema genérico de produtividade.
- Reduzir escopo para o que importa de verdade: organizacao local, cronograma e lembrete via Google Calendar.