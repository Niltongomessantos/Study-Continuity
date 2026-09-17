---
title: 'research: arquitetura local-first com Google Calendar'
type: technical
topic: arquitetura Web local e integração com Google Calendar para planejamento de estudos
decision: validar uma arquitetura local-first para o MVP, com domínio local isolado e Google Calendar como canal de alerta e projeção externa
source: síntese do briefing do produto e estrutura técnica fornecida pelo usuário; abordagem baseada em arquitetura local-first, persistência local e integrações com Google Calendar
status: draft
preset: standard
validation: normal
created: 2026-09-15
updated: 2026-09-15
claims_verified: 0
claims_unverified: 0
---

# Pesquisa técnica: arquitetura local-first com Google Calendar

## Resumo executivo

O produto proposto é um orquestrador local de estudos acessado via navegador, com foco em apresentar o próximo passo ao usuário, centralizar materiais e horários, e empregar o Google Calendar como único canal de lembrete e projeção visual. A direção do MVP foi endurecida para deixar explícito que a aplicação será local e acessada no navegador, sem instalador desktop e sem arquitetura de app nativo.

A principal decisão técnica é separar claramente duas camadas:

- camada local: domínio, histórico, regras de estudo, sessões, materiais, estado e sincronização
- camada externa: eventos e lembretes no Google Calendar

Essa separação reduz riscos de perda de dados, evita acoplamento duro com a API do Google e mantém o sistema resiliente a alterações de calendário, recorrência e exceções.

O projeto tem boa viabilidade como Web local, mas exige atenção especial a quatro eixos: OAuth local em localhost, persistência local confiável, sincronização de eventos e estados de sessão e disciplina de escopo. O MVP não deve buscar um modelo bidirecional complexo ou uma integração automática completa com múltiplas fontes; ele deve começar com uma operação controlada, previsível e segura.

### Endurecimentos atuais da direção do produto

1. App Web local em navegador, sem instalação desktop.
2. O Google Calendar é um canal de notificação e projeção, não a fonte de verdade do domínio.
3. O domínio do estudo permanece no app local: regras de reposição, atraso, status e recorrência.
4. O foco do MVP é continuidade de estudo, agenda, cronograma e lembrete, sem IA, mobile, nuvem e integrações amplas.
5. OAuth, sincronização e persistência local são requisitos arquiteturais do MVP, não itens opcionais.
6. As sessões devem ser criadas explicitamente como aula gerenciada ou bloco livre; o material e o conteúdo podem entrar depois.
7. A aula gerenciada tem regras locais de início, perda, conclusão e reposição; o bloco livre também tem cronômetro local, mas não assume controle da plataforma externa.


## 1. Arquitetura recomendada

### Opção 1: backend local + frontend web

Essa abordagem consiste em um executável leve, escrito em Node.js, Go ou outra linguagem, que sobe um servidor local e serve a aplicação web ao navegador. Essa opção oferece:

- controle do backend e dos tokens
- arquitetura de API interna mais clara
- melhor separação entre frontend e integração com Google
- maior facilidade para sincronização de eventos e filas de processamento

Vantagens:

- permite armazenar tokens e processos sensíveis fora do navegador
- facilita o uso de bibliotecas oficiais do Google
- reduz acoplamento entre a interface e a lógica de integração

Desvantagens:

- exige processo local para iniciar a app
- gera necessidade de distribuição/execução no Windows
- exige política clara para instalação e atualização

### Opção 2: app local-first no navegador (recomendada)

A abordagem mais alinhada ao requisito do produto é uma aplicação local-first executada em navegador, com armazenamento local e lógica de domínio no cliente. Isso atende à exigência de “sem desktop wrapper”, sem exigir Node instalado para o usuário final.

Essa solução funciona bem quando o projeto usa:

- armazenamento local persistente em SQLite via WASM ou em banco local em ambiente de browser
- serviço local opcional para autenticação e integração
- relação direta com a calendar API por meio de backend leve ou by-proxy local

A recomendação prática é tratar o navegador como a camada principal do usuário, mantendo a lógica de negócio local, enquanto a camada de sincronização do calendário é uma integração controlada. O endurecimento do brainstorm reforça que o sistema deve manter as regras do estudo no app local e não deixar que o Google Calendar absorva o domínio completo do produto.

### Regras duras definidas pelo produto

Estas regras devem orientar o restante da arquitetura:

- a criação de uma sessão exige que o usuário escolha explicitamente se ela será uma aula gerenciada ou um bloco livre
- não iniciar dentro do prazo de tolerância marca a aula como perdida automaticamente
- ao iniciar a aula, o sistema começa a contar o tempo imediatamente
- o tempo da aula é medido localmente; atraso não é compensado
- a aula termina automaticamente no horário configurado, mas pode ser ajustada manualmente após o fato
- a interrupção de uma aula iniciada normalmente só permite conclusão quando pelo menos 50% do tempo planejado tiver sido cumprido; caso contrário, ela é perdida
- o bloco livre não controla a plataforma externa, apenas mede o tempo do usuário no bloco
- a regra de conclusão nominal do MVP é 50% do tempo planejado como mínimo de validade da sessão

## 2. Persistência e modelo de domínio

O banco local deve ser a fonte de verdade. Isso é um ponto essencial do produto e da arquitetura.

### Proposta de persistência

- SQLite em ambiente local, com migrações e backup explícito
- ou armazenamento em navegador com SQLite WASM + OPFS, quando a solução local-first for a prioridade
- exportação/importação do histórico em JSON ou SQLite para evitar perda por limpeza do navegador

### Modelo de domínio sugerido

#### Sessão gerenciada

Campos essenciais:

- id da sessão
- id do material ou tópico
- título
- objetivo
- data/hora prevista
- duração
- status (pendente, iniciada, concluída, perdida, reagendada, incompleta)
- material associado
- vínculo com evento externo do Google Calendar
- tolerância de atraso configurável
- tempo mínimo de validade de 50% da duração

Regras de negócio do MVP:

- a sessão só pode começar quando o usuário aciona iniciar
- se não for iniciada dentro do prazo de tolerância, ela vira perdida automaticamente
- ao iniciar, a contagem do tempo começa no domínio local
- ao encerrar, a sessão pode ser fechada automaticamente ou ajustada manualmente depois
- se o usuário sair após iniciar a sessão, a sessão só pode ser aceita como concluída quando atingir pelo menos 50% da duração planejada

#### Bloco recorrente livre

Campos essenciais:

- id do bloco
- horário
- duração
- material associado
- link ou referência externa
- lembrete
- recorrência interna da rotina
- possibilidade de alterar uma ocorrência ou toda a série
- cronômetro local
- status de pausa/finalização/liberação

Regras de negócio do MVP:

- o bloco livre não controla a plataforma externa e não assume o progresso do conteúdo externo
- ele mede o tempo do usuário dentro do bloco local
- o cronômetro local segue a mesma lógica de início, contagem e encerramento da aula gerenciada
- o bloco livre pode ser repetitivo e pode ter exceções locais sem depender do calendário externo para regras de negócio

#### Estado da sessão

- pendente
- iniciada
- concluída
- perdida
- incompleta
- reagendada
- cancelada
- sincronizada
- pendente de sincronização
- com erro de sincronização

### Regra de ouro

O Google Calendar deve refletir o estado do domínio local, mas não deve ser a absorção completa de toda a lógica do produto. O app local é a origem do comportamento de estudo; o calendário apenas projeta os lembretes e eventos. Em termos práticos, o app decide se a sessão foi concluída, reagendada, perdida ou ajustada; o Google Calendar apenas comunica esse estado em eventos e lembretes.

## 3. Integração com Google Calendar

Esse é o eixo técnico mais relevante do MVP.

### OAuth em localhost

O fluxo de autenticação do Google precisa funcionar em ambiente local. O registro do cliente no Google Cloud Console deve permitir um redirect URI local, como:

- http://localhost
- http://localhost:3000
- http://localhost:8080

O app deve exigir:

- acesso de leitura/escrita aos eventos
- offline access para obter refresh token
- escopo mínimo, idealmente somente calendário de eventos
- state para reduzir risco de CSRF

### Recomendação de escopo

O escopo ideal para o MVP deve ser o mínimo necessário para criar e atualizar eventos. O melhor caminho é habilitar acesso apenas aos eventos do calendário, sem demandas mais amplas de conta ou configurações globais. A estratégia do produto continua sendo minimizar integrações e manter a operação do uso principal em torno do próximo passo, do material e do horário.

### Estrutura do evento

Cada evento criado no Google Calendar deve possuir identificação interna do app sobre a sessão correspondente. A forma mais simples e robusta é persistir o id local em `extendedProperties.private` do evento.

Isso permite que o app:

- recupere a sessão local correspondente
- atualize apenas o evento específico em vez de reescrever a série inteira
- detectar se um evento foi alterado externamente ou foi criado pelo próprio app

### Lembretes

O app não deve depender de notificações do navegador. Em vez disso, o GCal deve ser o mecanismo principal de alerta. Para isso, o evento precisa ter:

- reminders.useDefault: false
- reminders.overrides configurado
- lembrete de 10 ou 15 minutos antes da sessão, conforme a regra de negócio

### Recorrência e exceções

O relatório indicado pelo usuário sugere uma decisão importante: não confiar totalmente na recorrência nativa do Google Calendar para regras de negócio complexas.

A recomendação prática é:

- gerar eventos únicos para os próximos dias ou semanas
- usar a lógica do domínio local para decidir quando uma sessão deve ser reapresentada
- apenas sincronizar o evento que o app decidiu criar
- evitar depender de RRULE para exceções e regras de reposição complexas

Essa abordagem reduz problemas com eventos cancelados, ocorrências alteradas e séries que diferem do domínio de estudo local.

## 4. Segurança e privacidade

Mesmo sendo local, o projeto não deve tratar a aplicação como “insegura por ser acessada em localhost”. O risco de segurança existe e precisa ser tratado de forma ativa.

### Requisitos de segurança

- servidor local deve escutar apenas em localhost ou loopback
- validar host e origem das requisições
- aplicar CSRF para mutações
- evitar expor secret, refresh token e client secret no frontend
- usar CORS restritivo caso exista um backend local
- manter tokens fora do repositório do projeto
- tratar arquivos locais com allowlist e validação de caminhos

### Armazenamento de tokens

O app pode armazenar tokens locais em banco persistente, mas isso exige uma política explícita de risco. O nível de proteção depende de:

- ambiente do usuário
- que tipo de sistema operacional ele usa
- se a aplicação exige distribuição para usuário final

A recomendação é tratar os tokens como dados sensíveis ativos do ambiente local e nunca expô-los na interface web.

### Permissões e calendário isolado

Uma boa prática é criar um calendário específico do app, por exemplo:

- “Estudos do App”

Isso reduz riscos de interferência com eventos pessoais do usuário e facilita a sincronização.

## 5. UX e fluxo do usuário

A experiência do produto precisa ser simples e direta. O usuário deve ver o próximo passo imediatamente, sem depender de uma interface saturada.

### Fluxo principal

1. usuário abre a aplicação no navegador
2. app mostra próxima sessão, histórico e contexto do dia
3. usuário cria uma sessão escolhendo entre aula gerenciada ou bloco livre
4. app registra horário, duração e estado inicial no domínio local
5. usuário inicia a sessão por botão, acionando cronômetro local
6. se o usuário não iniciar no prazo, a sessão virou perdida automaticamente
7. usuário clica para abrir o material ou plataforma externa
8. app mede o tempo e marca conclusão ou perda conforme a regra do MVP
9. app recalcula o próximo passo e atualiza a projeção de eventos no calendario

### Pontos de interação essenciais

- próxima sessão em destaque
- materiais e links em um formato simples
- cronômetro opcional
- histórico de sessões passadas
- ação de reagendamento quando a sessão não foi iniciada
- botão de concluir ou marcar como atrasada

### Recomendações de UX

- a tela inicial deve priorizar a continuidade do estudo e não a navegação de calendário
- o evento no Google Calendar deve conter um link de retorno para a sessão correta no app
- o app deve mostrar claramente se o evento foi sincronizado e se o item está pendente

## 6. Operação e manutenção

### Estado de conexão

O app precisa reagir a:

- internet disponível
- internet indisponível
- sincronização em andamento
- sincronização falhou
- autorização revogada
- token expirado

### Fila de sincronização

Quando o usuário conclui ou altera uma sessão enquanto offline, a ação precisa entrar em fila local e ser processada assim que a conectividade voltar. O processamento deve levar em conta:

- retry
- backoff exponencial
- rate limit
- erro 429 e 403
- erro de sincronização parcial

### Distribuição no Windows

Apesar da exigência de “não instalar um desktop app”, ainda existe a necessidade de distribuir a experiência de execução. O projeto precisa decidir se o usuário final vai:

- rodar um navegador com servidor local em segundo plano
- executar um script .bat/.ps1 em um atalho
- receber um executável empacotado

Essa questão é importante para a experiência de uso e para a operação real do produto.

## 7. Pesquisa de mercado

A análise de mercado abaixo compara produtos que se relacionam com planejamento acadêmico, produtividade e integração de calendário.

| Produto | Categoria | Público | Funcionalidades principais | Calendário / lembretes | Local-first / Cloud | Vantagens | Limitações |
|---|---|---|---|---|---|---|---|
| Notion | produtividade / workspace | universitários e profissionais | banco de conhecimento, templates, tarefas, páginas | integração manual via automação | cloud-first | personalização e flexibilidade | não é focado em continuidade de estudo ou rotina temporal |
| MyStudyLife | planner escolar | estudantes | cronograma, tarefas, provas, aulas | notificações próprias e agenda integrada | cloud-first | foco no domínio acadêmico | ecossistema fechado e interface antiga |
| TickTick | produtividade | usuários gerais | tarefas, pomodoro, calendário | lembretes fortes, integrações com calendário | cloud-first | excelente fluxo de tarefas | não é específico para estudo e continuidade |
| Shovel | planejamento de carga | estudantes universitários | cálculo de tempo e volume de leitura | integração com calendários externos | cloud-first | ajuda no equilíbrio de carga | muito complexo para MVP e carece de simplicidade |
| Anki | aprendizado / revisão | estudantes e profissionais | revisão espaçada | sem calendário central | local-first / híbrido | excelente para retenção | não cobre planejamento semestral ou rotina de estudo |
| Structured | produtividade visual | usuários Apple | organização visual da rotina diária | notificações do sistema, importação de calendário | cloud / ecossistema | estética e clareza visual | preso ao ecossistema e não é focado em estudo |

### O que o mercado oferece

- produtividade genérica com calendário e lembretes
- planners acadêmicos mais focados em calendário escolar do que em continuidade de estudo
- ferramentas para revisão espaçada, mas sem visão de rotina completa
- integração de calendário, porém pouco alinhada ao conceito de “próximo passo” do estudo

### O que o mercado ainda não resolve bem

- combinar estudo, material, agenda e lembrete em uma única visão simples
- distinguir domínio do estudo de calendário externo
- manter um modelo local, local-first e resiliente sem depender de nuvem
- integrar Google Calendar como projeção do sistema sem que o app perca sua lógica interna

## 8. Lacunas e diferenciais do produto

O principal diferencial do produto é a arquitetura de “domínio local + calendário externo”. Isso cria uma vantagem clara em relação a vários concorrentes que concentram todo o “sistema” em um ecossistema fechado.

### Lacunas reais do mercado

- muitos apps tentam criar seu próprio ecossistema completo e acabam forçando o usuário a atuar em mais uma ferramenta
- apps acadêmicos focados em calendário ou revisão geralmente não resolvem bem o problema da continuidade de estudo
- pouca solução combina materiais, planejamento e lembretes em um fluxo simples e local

### Diferenciais propostos para o MVP

- foco em próximo passo de estudo
- gestão local do domínio e histórico
- uso de Google Calendar como motor de lembrete
- eventos específicos e simples para projeção
- reação por conclusão, atraso e reposição
- foco em disciplina, não em ecossistema monstruoso de dados
- manutenção clara da separação entre domínio local e calendário externo

### O que deve entrar no MVP

- criação explícita de sessão gerenciada ou bloco livre
- bloco recorrente livre com cronômetro local
- aula gerenciada com regra de início, atraso e conclusão local
- material e links
- gestão de próxima sessão
- lembrete via Google Calendar
- histórico de conclusão, perda e reagendamento
- sincronização controlada e simples
- regra de tolerância de início e mínimo de 50% de validade da sessão

### O que deve ficar fora do MVP

- tutor de IA
- múltiplas contas Google
- sincronização bidirecional complexa
- webview como padrão
- integrações avançadas com plataformas externas
- controle de progresso de plataforma externa
- escalabilidade cloud-first

## 9. Recomendação final

A solução proposta é técnica e mercadologicamente viável. O melhor caminho para o MVP é adotar uma arquitetura local-first com domínio local e integração ao Google Calendar como camada de lembrete e projeção visual.

A lógica do produto deve ser a seguinte:

- o app local decide o que deve acontecer
- o Google Calendar recebe eventos ou lembretes com base nessa decisão
- o usuário recebe alerta no valor do calendário que já usa
- ao concluir, perder, reagendar ou ajustar a sessão, o sistema atualiza o domínio local e reprojecta o calendário
- a criação da sessão exige escolher aula gerenciada ou bloco livre, e o cronômetro local controla o tempo do estudo

Esse modelo preserva simplicidade, reduz dependência do usuário em múltiplos apps e cria um MVP mais robusto e menos frágil do que projetos que tentam tornar o Google Calendar a fonte de verdade de tudo.

A principal recomendação é: começar com sincronização controlada, domínio local robusto, OAuth bem definido e eventos simples, com regras locais de tempo, início e conclusão sendo a autoridade do MVP. Isso sustenta o produto sem criar um sistema que dependa de recorrência complexa, conflitos de agenda e integrações duplicadas.

## Conclusão

A arquitetura recomendada para o MVP é:

- app web accessada via navegador
- processo local em ambiente de execução controlado
- persistência local com SQLite ou equivalente
- domínio local isolado da lógica do calendário
- Google Calendar como canal de alerta e visão externa
- sincronização controlada com fila, retry e estados visíveis

Essa abordagem combina viabilidade técnica, simplicidade de uso e melhor adequação ao requisito de “não ser um app desktop instalado” nem “não depender de notificações nativas do navegador”.
