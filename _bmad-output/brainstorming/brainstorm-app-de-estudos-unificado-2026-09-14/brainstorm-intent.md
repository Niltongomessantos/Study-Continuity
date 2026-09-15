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

- Aplicacao Web hospedada localmente, sem instalacao desktop e sem hospedagem em nuvem por enquanto.
- Agenda de estudos integrada ao Google Calendar para eventos e notificacoes.
- Cadastro de materias, sessoes, horarios, duracao e materiais.
- Suporte a links externos, playlists do YouTube, PDFs e arquivos locais.
- Abertura de plataformas externas no navegador.
- Painel com proxima sessao, sessoes anteriores e proximas, incluindo status.
- Armazenamento local em banco simples.
- Estrutura inicial para integracao com o Google Calendar, incluindo sincronizacao de eventos e notificacoes por meio do calendario.
- Sem tutor de IA no MVP.

## Tipos de sessao

### Aula gerenciada

Possui horario, duracao, objetivo, material, status e possibilidade de reposicao quando nao iniciada.

### Bloco recorrente livre

Possui horario, duracao, lembrete e material externo, mas nao acompanha progresso ou conteudo da plataforma. O aluno pode alterar somente uma ocorrencia ou toda a serie, pausar, finalizar e liberar o horario.

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

## Materiais e plataformas externas

O app organiza links para cursos pagos, YouTube, playlists, PDFs e arquivos locais, mas nao acompanha o progresso de plataformas externas nem depende de integracao tecnica com elas. O navegador externo e o caminho padrao.

## Fora do escopo do MVP

- Tutor assistido por IA.
- Hospedagem em nuvem.
- Login automatizado ou coleta de dados de plataformas externas.
- Robo ou MCP server para navegar em plataformas.
- Iframe ou webview como caminho padrao.
- Aplicativo mobile.

## Evolucao futura

1. Publicacao da aplicacao em hospedagem remota ou na nuvem.
2. Webview condicional para plataformas compatíveis.
3. Tutor assistido por IA para aulas e exercicios.
4. Integrações avançadas com plataformas, condicionadas a seguranca, permissoes e termos de uso.