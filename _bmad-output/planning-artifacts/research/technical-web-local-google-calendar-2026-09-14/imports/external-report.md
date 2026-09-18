# Relatório de Pesquisa Técnica: Arquitetura de Aplicação Web Local com Google Calendar

## 1. Resumo Executivo

Recomendação: A arquitetura mais viável e segura para este MVP é um Servidor Local em Node.js (ou binário compilado em Go) emparelhado com um banco de dados SQLite e uma interface Web (SPA). A aplicação não terá interface gráfica de sistema operacional (GUI), rodando no terminal/background e sendo acessada via http://localhost:porta no navegador padrão.

Nível de confiança: Alto para a viabilidade técnica e integração com Google Calendar. Médio-Alto para usabilidade do usuário final (depende da estratégia de inicialização adotada).

Condições principais:

- A API do Google Calendar deve ser a única responsável por notificações via reminders.overrides [1].
- O aplicativo deve ser vinculado à interface de rede loopback (127.0.0.1) para evitar exposição na rede local (LAN) [2].
- O fluxo de autenticação OAuth deve utilizar o padrão para "Native Apps" com IP de loopback (RFC 8252) [3].

Riscos que exigem protótipo:

- A sincronização bidirecional entre alterações manuais feitas pelo usuário diretamente no Google Calendar e a base local via polling de syncTokens [4].
- Sincronizar regras complexas de recorrência (RRULE) [5] e suas exceções exige validação prática detalhada.

## 2. Matriz de Decisão

Abaixo comparamos as abordagens para "aplicação web executada localmente", sem empacotamento desktop (como Electron/Tauri) e sem hospedagem em nuvem:

| Critério | 1. SPA Pura (Browser + IndexedDB) | 2. Servidor Node.js + SQLite | 3. Binário Único (Go/Rust) + SQLite | 4. Docker Container |
|---|---|---|---|---|
| Execução Local | Abre o HTML direto no browser. | Requer instalação do Node.js ou script .bat. | Executável leve, inicia servidor e abre o browser. | Requer Docker Desktop (pesado). |
| Segurança (Tokens) | Crítico: Tokens expostos a XSS. | Forte: Tokens no backend (SQLite). | Forte: Tokens no backend (SQLite). | Forte: Isolado no container. |
| Persistência | Frágil (IndexedDB pode ser limpo). | Forte: Arquivo .sqlite local. | Forte: Arquivo .sqlite local. | Exige mapeamento de volumes. |
| OAuth & GCal | JS Client (Implica consentimento frequente). | Suporte oficial (Google APIs Node.js). | Suporte oficial ou via REST. | Suporte oficial. |
| Evolução p/ Nuvem | Muito difícil (sem backend real). | Fácil: Código já é web/backend. | Fácil: Código já é web/backend. | Nativo para nuvem. |
| Facilidade (Equipe) | Alta (apenas Frontend). | Alta: JavaScript no stack inteiro. | Média (exige conhecimento de Go/Rust). | Baixa (overhead de infra). |

Decisão: A opção 2 (Servidor Node.js) é recomendada pelo ecossistema JavaScript (biblioteca oficial googleapis), facilidade para equipes Web e transição fluida para futura hospedagem em nuvem. A opção 3 (Go) é a melhor se o requisito for "não exigir que o usuário instale dependências".

## 3. Achados por Dimensão

### 3.1. Arquitetura Web Hospedada Localmente

A diferença entre "não instalar um aplicativo desktop" e "executar um servidor local" reside no motor de renderização. Em vez de embarcar o Chromium (como o Electron faz, adicionando ~150MB e alto consumo de RAM), um servidor local apenas levanta um serviço HTTP e utiliza o navegador que o usuário já possui [6].

Inicialização: Pode ser feita por um script (ex: iniciar.bat no Windows) que roda npm start (ou executa um binário em Node empacotado com ferramentas como pkg ou sea - Single Executable Application) e usa o comando start http://localhost:3000 para abrir o navegador.

Acesso a arquivos: O servidor backend local tem acesso total ao File System (Node fs), permitindo abrir PDFs chamando o comando padrão do sistema operacional sem restrições de sandbox de navegadores [7].

### 3.2. Google Calendar e OAuth

Fluxo OAuth: A documentação do Google Cloud e a RFC 8252 estabelecem que aplicações executadas localmente devem usar o fluxo OAuth com redirecionamento para IP de loopback (ex: http://127.0.0.1:porta/oauth2callback). O servidor local levanta uma porta, abre o consentimento no navegador e recebe o código de autorização [3].

Tokens: O aplicativo receberá um access_token (curta duração) e um refresh_token (longa duração). O refresh_token só é emitido no primeiro consentimento se o parâmetro prompt=consent for enviado [8].

Notificações/Lembretes: O aplicativo local não precisa emitir notificações. Na criação do evento via API, basta enviar o payload com reminders.useDefault = false e overrides = [{ method: 'popup', minutes: 15 }]. O Google Calendar (via web ou celular do usuário) assumirá a responsabilidade de alertar [1].

Quotas: A API do Calendar é gratuita até 1 milhão de consultas diárias, mais que suficiente para um aplicativo local rodando com as credenciais do próprio usuário [9].

### 3.3. Modelo de Domínio e Sincronização

O domínio interno de estudos (Aulas Gerenciadas e Blocos Livres) difere do modelo do calendário (Eventos).

Fonte de Verdade: O SQLite local deve ser a fonte de verdade para o progresso acadêmico (status, material, histórico). O Google Calendar é a fonte de verdade para a alocação de tempo e notificações [4].

Mapeamento: O banco local deve ter tabelas genéricas que possuam uma coluna gcal_event_id nula por padrão, preenchida após a sincronização bem-sucedida.

Recorrência: O Google Calendar suporta o padrão iCalendar (RFC 5545). Blocos recorrentes livres devem ser criados no GCal passando a propriedade recurrence (ex: RRULE:FREQ=WEEKLY;BYDAY=MO,WE,FR).

Sincronização Inversa (Polling): Como a aplicação não está exposta à internet, não pode receber Webhooks (Push Notifications) do Google. O servidor local deve fazer polling periódico usando syncTokens (Eventos: list API). O GCal retornará apenas os eventos alterados ou excluídos desde a última checagem [4].

### 3.4. Segurança, Privacidade e Ameaça

Executar um servidor em localhost expõe a aplicação a ataques de Cross-Site Request Forgery (CSRF) e DNS Rebinding. Se o usuário visitar um site malicioso (ex: ataque.com), o script desse site pode tentar fazer requisições para http://localhost:3000 na máquina do usuário [2].

Mitigações Obrigatórias para MVP:

- Bind exclusivo ao loopback: O servidor deve escutar em 127.0.0.1, não em 0.0.0.0 (que abriria para a rede Wi-Fi local).
- Validação do Header Host: Rejeitar qualquer requisição cujo host não seja localhost ou 127.0.0.1.
- Proteção CORS: Configurar políticas de CORS estritas. A iniciativa Private Network Access do WICG em navegadores modernos também ajuda a bloquear requisições de sites públicos para localhost, mas validações no backend continuam sendo críticas [10].
- Proteção de Tokens: O banco SQLite não deve ser versionado nem compartilhado. Embora idealmente os tokens devessem ser criptografados com chaves do SO (como DPAPI no Windows), para um MVP Web local que não é distribuído massivamente, armazenar o refresh_token no SQLite e proteger o arquivo físico de acessos externos é o limite prático [8].

### 3.5. Operação, Manutenção e Ecossistema

A biblioteca oficial googleapis para Node.js tem manutenção ativa e abstrai a complexidade do OAuth2 local e da renovação automática de tokens usando o refresh_token.

A transição futura para nuvem é natural. Um servidor Node/Express + Banco de Dados Local encapsula perfeitamente a arquitetura Cliente-Servidor padrão da Web. O esforço operacional para o desenvolvedor é baixo, pois utiliza ferramentas Web convencionais (NPM, React/Vue/Vanilla JS, Express/Fastify).

## 4. Arquitetura Recomendada

A arquitetura define uma separação clara, mas empacotada no mesmo repositório lógico:

- Frontend (SPA - Single Page Application): Construída em React, Vue ou Vanilla JS (empacotado via Vite). Compilado para arquivos estáticos HTML/CSS/JS. Não possui estado persistente nem chaves de API.
- Backend Local (Node.js + Express/Fastify): Serve os arquivos estáticos do Frontend no endpoint raiz (/); expõe uma API REST (/api/*) exclusiva para o Frontend local; executa rotinas em background (setInterval) para polling no Google Calendar usando syncToken.
- Persistência (SQLite via Better-SQLite3 ou Prisma/Drizzle): Arquivo database.sqlite salvo na pasta do usuário (ex: %APPDATA%/MyApp), contendo tabelas separadas para o Domínio e para os Metadados de Sincronização.
- Google API Adapter: Módulo isolado responsável por gerenciar a fila de atualizações.
- Fluxo de Falha: Se o app estiver offline, as alterações locais são marcadas como sync_pending = true. Quando a internet retornar, o adaptador reprocessa a fila.

## 5. Recomendação de MVP

O que deve entrar na primeira implementação:

- Servidor Node.js servindo SPA local e DB SQLite.
- Autenticação OAuth via loopback.
- Sincronização One-Way (Local -> GCal): Toda criação e edição ocorre no aplicativo local. O aplicativo reflete essas mudanças no GCal criando eventos com reminders.overrides (15 min antes).
- Geração de RRULE simples para os Blocos Recorrentes.

O que deve ser prototipado antes (Risco Técnico):

- Sincronização Two-Way (GCal -> Local): Especificamente, prototipar o que acontece se o usuário arrastar (mudar o horário) de uma única ocorrência de um Bloco Recorrente no GCal. A API do GCal gera uma exceção (evento filho com recurringEventId). É preciso validar como mapear isso de volta para o SQLite sem quebrar a série.

O que deve ficar fora do MVP:

- Polling de syncTokens (sincronização GCal -> Local) deve ser deixado para a v2. No MVP, trate o aplicativo local como o "controle remoto" do calendário. Se o usuário alterar no Google, avise-o de que o app local reescreverá a alteração na próxima sincronização.
- Criptografia complexa de banco de dados (DPAPI).
- Múltiplas contas do Google (limite a uma conta autenticada por instância local).

## 6. Evidência Contrária e Riscos

Argumento contra o Node.js Local: Usuários leigos não sabem instalar Node.js, e rodar npm install localmente é impensável para um produto B2C distribuído.

Mitigação: A menos que o MVP seja apenas para o próprio desenvolvedor ou um grupo técnico fechado, o backend Node.js precisará ser compilado num binário através de ferramentas como pkg, Node 21 Single Executable Applications (SEA), ou reescrito em Go para gerar um simples app.exe [11].

Limitações do GCal: A API do Google tem limites de requisições rápidas (Rate Limits). Atualizar 50 aulas sequenciais de uma vez pode gerar status 403 Rate Limit Exceeded. É necessário implementar Exponential Backoff no módulo de sincronização [9].

Riscos não resolvidos: Arquivos locais e PDFs. O navegador não permite que o frontend faça <a href="file:///C:/..."> por segurança. O Frontend terá que enviar uma requisição à API local (ex: POST /api/open-file { path: 'C:/...' }) e o servidor Node executa a abertura via módulo child_process (start "" no Windows).

## 7. Questões Abertas

- O MVP será distribuído para usuários não-técnicos? (Se sim, a distribuição via script Node é inviável, forçando o empacotamento do servidor em um binário único ou adoção de Go/Rust).
- Como o aplicativo lidará com a "desistência" temporária do Google Calendar em caso de revogação do token? O app deve continuar funcionando de modo 100% offline e enfileirar as edições?

## 8. Source Appendix (Referências)

| [1] | Google Calendar API Reference: Events | Google Developers | https://developers.google.com/calendar/api/v3/reference/events | Acesso: Setembro 2026 | Documentação Oficial | reminders.useDefault = false e overrides |
| [2] | Same-origin policy & Localhost Risks | MDN Web Docs / OWASP | https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy | Acesso: Setembro 2026 | Documentação Técnica | Riscos de segurança em localhost |
| [3] | RFC 8252 - OAuth 2.0 for Native Apps | IETF | https://datatracker.ietf.org/doc/html/rfc8252#section-7.3 | Acesso: Setembro 2026 | RFC | Loopback redirect |
| [4] | Synchronize Resources Efficiently (SyncTokens) | Google Developers | https://developers.google.com/calendar/api/guides/sync | Acesso: Setembro 2026 | Guia de Integração | Sincronização incremental |
| [5] | RFC 5545 - Internet Calendaring and Scheduling Core Object Specification | IETF | https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.5.3 | Acesso: Setembro 2026 | RFC | Sintaxe RRULE |
| [6] | Electron vs Native vs Web | Fontes comunitárias secundárias | Não informado | Acesso: Setembro 2026 | Secundária | Alegações de consumo de Electron |
| [7] | Node.js Child Process Documentation | Node.js Foundation | https://nodejs.org/api/child_process.html | Acesso: Setembro 2026 | Documentação Oficial | Abertura de arquivos pelo sistema |
| [8] | Using OAuth 2.0 for Web Server Applications | Google Identity | https://developers.google.com/identity/protocols/oauth2/web-server | Acesso: Setembro 2026 | Documentação Oficial | Ciclo de vida e armazenamento do refresh_token |
| [9] | Google Calendar API Quotas and Limits | Google Developers | https://developers.google.com/calendar/api/guides/quota | Acesso: Setembro 2026 | Documentação Oficial | Quotas e exponential backoff |
| [10] | Private Network Access (PNA) | WICG | https://wicg.github.io/private-network-access/ | Acesso: Setembro 2026 | Draft de padrão | Requisições de sites públicos para loopback |
| [11] | Node.js Single Executable Applications | Node.js Foundation | https://nodejs.org/api/single-executable-applications.html | Acesso: Setembro 2026 | Documentação Oficial | Empacotamento em executável |
