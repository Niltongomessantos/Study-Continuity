# Relatorio recebido do Gemini

## 1. Resumo Executivo

Este relatório avalia a melhor abordagem técnica para o desenvolvimento de um aplicativo desktop local voltado para a organização de estudos no Windows (MVP). O aplicativo foca em orquestrar materiais externos e gerenciar o tempo do aluno, sem hospedar o conteúdo. A análise prioriza desempenho, baixo consumo de memória, funcionamento em segundo plano para notificações e armazenamento local seguro, sem dependência de nuvem.

## 2. Recomendação Principal

A recomendação principal para o MVP é o **Tauri v2** utilizando o frontend de sua preferência (React, Vue ou Svelte) e **SQLite** para o banco de dados.

O Tauri entrega binários extremamente reduzidos (frequentemente entre 3 MB e 15 MB) e consome muito menos memória em repouso (20 MB a 100 MB) comparado ao Electron (que consome de 100 MB a 300 MB apenas para iniciar). Como o aplicativo precisará ficar aberto em segundo plano (System Tray) para emitir notificações de horários de estudo, a eficiência de recursos do Tauri torna-se o diferencial decisivo.

## 3. Alternativas Consideradas

* **Electron:** A escolha mais madura e o padrão de mercado (usado no VS Code, Discord, etc.). Rejeitado como primeira opção devido ao alto consumo de memória e grande tamanho de instalador por empacotar o Chromium e Node.js em cada app.
* **.NET Desktop (WPF/WinUI):** Excelente integração nativa com o Windows. No entanto, rejeitado pois exige o desenvolvimento em C#/.NET, o que cria uma curva de aprendizado mais íngreme para equipes focadas em web, além de dificultar o port futuro para macOS/Linux.
* **Flutter Desktop:** Bom para UI fluida, mas o ecossistema de bibliotecas nativas de desktop (como manipulação de System Tray e SQLite robusto) ainda é inferior ao ecossistema do Rust/Tauri e do C#/.NET.
* **PWA / Tecnologias Web Empacotadas:** Rejeitadas pois falham nos requisitos de emitir notificações confiáveis com o navegador fechado e de manipular arquivos locais (PDFs) livremente.

## 4. Tabela Comparativa

| Critério | Tauri v2 | Electron | .NET (WinUI 3) |
| --- | --- | --- | --- |
| **Consumo de Memória (Repouso)** | ~20 - 100 MB | ~100 - 400 MB | ~50 - 150 MB |
| **Tamanho do Instalador** | 3 - 15 MB | 50 - 150 MB+ | 30 - 80 MB |
| **Suporte Windows** | Excelente (WebView2) | Excelente (Chromium) | Nativo |
| **Curva de Aprendizado** | Média (Rust para backend) | Baixa (Web/Node) | Alta (C#/XAML) |
| **Processo em 2º Plano (Tray)** | Nativo via Rust | Suportado (Node) | Suportado |
| **Facilidade Equipe Pequena** | Alta | Muito Alta | Média |
| **Manutenção a longo prazo** | Alta | Alta | Alta |

## 5. Análise de Notificações no Windows

Para que o aplicativo notifique o usuário 15 minutos antes da sessão, ele não pode depender de estar visível.

* **Minimizado/Fechado:** No modelo desktop padrão, clicar no "X" não deve matar o processo. O aplicativo deve ser minimizado para a Bandeja do Sistema (System Tray). O processo Rust do Tauri continuará rodando com um consumo de memória ínfimo, disparando as notificações nativas via chamadas do SO.
* **Background Tasks do Windows App SDK:** Para que o app acorde o computador ou inicie automaticamente junto com o sistema sem estar no Tray, seria necessário empacotar o aplicativo como MSIX e utilizar o `BackgroundTaskBuilder`. Porém, no MVP, a abordagem mais simples e menos propensa a erros é configurar o app para "Iniciar com o Windows" e rodar silenciosamente na bandeja.
* **Riscos de Suspensão:** Quando o computador dorme (Sleep), os temporizadores do JavaScript param. No Tauri, você pode delegar o agendamento da notificação (cron/timer) para a camada do Rust, ou escutar eventos de resume do SO para recalcular a próxima notificação imediatamente ao acordar.

## 6. Análise de Armazenamento Local

A escolha indiscutível para armazenamento local é o **SQLite** (via `@tauri-apps/plugin-sql`).

* **Corrupção:** Para evitar bloqueios ou corrupção, ative o modo WAL (Write-Ahead Logging) na string de conexão do SQLite (`PRAGMA journal_mode=WAL;`).
* **Backup:** O SQLite armazena tudo em um único arquivo (ex: `app.db`). O backup local consiste apenas em criar uma cópia deste arquivo (que pode ser disparado por um botão no app).
* **Arquivos Locais e PDFs:** O banco não deve armazenar os PDFs dentro dele (Blob). Salve os caminhos absolutos (paths) para os arquivos locais. Se o arquivo for movido ou excluído pelo usuário, o aplicativo deve fazer uma validação de existência (`fs.exists`) antes de tentar abrir, informando: "O material não foi encontrado no local original".
* **Preparação para Nuvem:** Ao modelar o schema, não use `INTEGER PRIMARY KEY` autoincremento. Use **UUIDs (v4 ou v7)** para todos os IDs (matérias, aulas, sessões) e inclua colunas de `created_at`, `updated_at` e `deleted_at` (soft delete). Isso garantirá que uma futura sincronização não cause colisão de IDs.

## 7. Análise da Futura Integração com Google Calendar

A integração com o Google Calendar a partir de apps desktop traz desafios específicos de autenticação:

* **OAuth em Desktop:** A Google depreciou o fluxo de IP de loopback (localhost) para iOS e Android, mas ele **continua sendo suportado e recomendado para aplicativos Desktop**. Isso significa que seu app levantará um pequeno servidor local (ex: `http://localhost:3000`) temporariamente apenas para receber o token de acesso após o usuário aprovar no navegador padrão.
* **Segurança dos Tokens:** Você precisará armazenar os refresh_tokens de forma encriptada. No Tauri, utilize o plugin oficial `stronghold` ou ferramentas de keyring do sistema operacional para não guardar tokens em texto plano no SQLite.
* **Preparação desde o MVP:** Identifique todas as tabelas de aulas e blocos recorrentes com um campo nulo `gcal_event_id`. Assim, quando o recurso for desenvolvido, será fácil mapear o que já está sincronizado.

## 8. Análise de Links, Webview e Plataformas Externas

A decisão de **abrir links no navegador padrão e NÃO embarcar conteúdos** é uma excelente diretriz técnica e de negócio para o MVP.

* **Limitações do Webview/Iframe:** Grandes plataformas de curso e o YouTube bloqueiam o encapsulamento do seu conteúdo por meio de cabeçalhos de segurança HTTP como `X-Frame-Options: DENY` e diretivas de `Content-Security-Policy`.
* **Privacidade e Automação:** Abrir uma plataforma via Webview interno (ou via robôs como Puppeteer/MCP) forçaria o usuário a fazer login novamente no seu aplicativo. Isso levanta atritos de segurança ("esse app vai roubar minha senha?").
* **Solução:** O Tauri fornece o comando `open` via `@tauri-apps/plugin-shell`. Quando a sessão iniciar, o aplicativo executa `open("https://plataforma.com/curso")`. O navegador padrão do usuário abrirá já logado na plataforma.

## 9. Arquitetura Inicial Recomendada

* **Framework:** Tauri v2.
* **Linguagem:** TypeScript + React (Frontend) / Rust (Backend OS e Tray).
* **Armazenamento:** SQLite (com IDs baseados em UUIDv4).
* **Camada de Notificações:** Plugin nativo de notificações do Tauri acionado pelo backend em Rust (para resistir à suspensão do Windows e timer drift do JS).
* **Estratégia de Materiais:** `shell.open_external` (para links e vídeos) e execução de arquivo local utilizando a associação padrão do SO.
* **Estratégia de Empacotamento:** Instalador NSIS (padrão do Tauri para Windows, que gera o `.exe`).

## 10. Riscos Técnicos

1. **Suspensão do Sistema (Sleep State):** Timers agendados podem não disparar exatamente no horário esperado se o PC entrou em modo de hibernação. É necessário um sistema de catch-up que verifica as aulas agendadas assim que o computador acorda.
2. **Migração de Schema do Banco:** Como o app é offline, atualizações futuras podem causar falhas se não houver um sistema de migração de banco estrito (usar ferramentas como Drizzle ORM ou Prisma lidando com o `.sqlite` localmente).

## 11. Riscos de Segurança e Privacidade

1. Caminhos locais podem ter permissões de leitura bloqueadas por antivírus ou pelo sistema.
2. Tokens do Google Calendar salvos em texto puro no SQLite poderiam ser roubados se o computador fosse comprometido.

## 12. Plano de Implementação por Etapas

* **Fase 1 - Core Local (Semanas 1-2):** Setup do Tauri, SQLite e banco de dados; CRUD de matérias e sessões pontuais.
* **Fase 2 - Recorrência e Execução (Semanas 3-4):** Blocos recorrentes, cronômetro e abertura de URLs, PDFs e YouTube.
* **Fase 3 - Background e Notificações (Semana 5):** Tray, minimizar ao fechar, notificações via Rust e lógica de reposição.
* **Fase 4 - Polimento (Semana 6):** Fallback para arquivos deletados, instalador NSIS e lançamento do MVP.

## 13. Decisão Final

Siga com o **Tauri v2**. Ele resolve o problema crítico do Electron (consumo massivo de memória e espaço em disco em aplicativos que precisam rodar no fundo 100% do tempo). A separação entre Rust para cronômetros, SO, tray e SQLite e tecnologias web para a interface atende às restrições de zero cloud do MVP.

## 14. Questões Ainda Abertas

* **MSIX vs NSIS:** Definir o formato de distribuição do MVP, pois isso altera permissões avançadas de Background Tasks no Windows 11.
* **Repetição:** Desenhar a expansão de regras recorrentes em eventos SQLite, possivelmente usando padrões como rrule (RFC 5545).