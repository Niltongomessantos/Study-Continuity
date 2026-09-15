---
type: technical
topic: Tecnologia desktop local para app de estudos
decision: Escolher a base técnica do MVP desktop local e preparar a futura integração com Google Calendar
source: Relatório importado pelo usuário, produzido no Gemini; data de produção não informada
status: complete
created: 2026-09-14
updated: 2026-09-14
claims_verified: 0
claims_unverified: 1
---

# Pesquisa técnica: app de estudos desktop

## Resumo executivo

O relatório importado recomenda **Tauri v2 + TypeScript/React + Rust + SQLite** para o MVP local. Essa direção é coerente com os requisitos de aplicativo desktop Windows, armazenamento offline, abertura de materiais externos e possibilidade de manter um processo em segundo plano para lembretes. [1]

A decisão deve ser tratada como **recomendação inicial**, não como validação técnica final: o relatório não inclui links, datas, método de medição ou fontes independentes. Portanto, as métricas de consumo, tamanho, compatibilidade de plugins, comportamento de notificações e detalhes atuais do OAuth do Google permanecem não verificadas. [1]

## Achados por dimensão

### Paisagem e maturidade

Tauri v2 foi escolhido em relação ao Electron por reduzir o peso do empacotamento e usar a WebView do sistema no Windows. Electron aparece como alternativa mais madura e simples para equipes web, enquanto .NET oferece integração nativa mais direta com Windows. [1]

O relatório não apresenta evidência suficiente para concluir que Tauri é superior em todas as dimensões ou que as faixas numéricas apresentadas sejam comparáveis. A escolha deve ser confirmada com um protótipo que meça startup, memória, notificações e instalação no ambiente alvo.

### Integração e interoperabilidade

Abrir links e materiais no navegador externo é uma boa decisão para o MVP: evita depender de iframe, cookies, login embutido e compatibilidade específica de plataformas externas. [1]

Para a futura integração com Google Calendar, o relatório recomenda prever um identificador externo de evento e armazenamento seguro de tokens. OAuth, permissões e fluxo exato de aplicativo desktop precisam ser confirmados na documentação oficial antes da implementação. [1]

### Arquitetura prática

Uma arquitetura inicial plausível é frontend TypeScript/React, comandos de sistema em Rust, SQLite local, tray e camada de notificações. O banco deve ser tratado com migrações versionadas, backups e validação de caminhos de arquivos. [1]

Para o produto, o modelo precisa distinguir aula gerenciada de bloco recorrente livre. Essa distinção é uma restrição de domínio do MVP e deve existir independentemente do framework escolhido.

### Implementação e operação

O risco operacional mais importante é o horário do computador: suspensão, hibernação, encerramento e retorno podem fazer um timer perder o instante esperado. O app precisa recalcular sessões vencidas ao retornar e registrar claramente notificações perdidas. [1]

O relatório sugere tray e inicialização com o Windows, mas não prova que isso atenderá a todos os cenários de app fechado. Esse comportamento deve ser validado em um protótipo no Windows antes de prometer lembretes confiáveis.

## Insights cruzados

O requisito de baixo consumo e o requisito de lembretes em segundo plano apontam para um processo residente pequeno, mas não eliminam a necessidade de tratar suspensão e recuperação. A escolha do framework só é boa se o fluxo de notificações for testado como comportamento do produto, não apenas como recurso da biblioteca.

Além disso, a decisão de abrir plataformas no navegador reduz o escopo de segurança e autenticação do MVP. Ela permite que o app organize o estudo sem precisar armazenar credenciais ou reproduzir o conteúdo externo.

## Recomendações

1. **Adotar Tauri v2 como hipótese técnica do MVP**, condicionada a um spike de notificações, tray, abertura de arquivos/URLs e SQLite. Confiança baixa a média, pois a recomendação veio de uma única fonte sem URLs verificáveis. [1]
2. **Usar SQLite local com migrações versionadas e backup explícito.** UUIDs e timestamps são boas decisões de preparação, mas devem ser avaliados contra a simplicidade do MVP. [1]
3. **Manter o navegador externo como padrão** para plataformas de cursos, YouTube e links pagos. Isso está alinhado ao escopo e evita login embutido e webview como dependência. [1]
4. **Implementar notificações como uma capacidade de sistema testada**, com catch-up após retorno do computador, sem assumir que um timer JavaScript será suficiente. [1]
5. **Deixar Google Calendar fora do MVP**, mas reservar um campo de referência externa e uma camada de sincronização separada para a fase seguinte. A integração deve ser pesquisada novamente com documentação oficial atual.

## Questões abertas

- Tauri v2 ou Electron entrega o melhor resultado após medir o protótipo real no Windows?
- O lembrete deve funcionar com o app encerrado ou apenas minimizado na bandeja?
- Qual mecanismo de inicialização e notificação é compatível com a distribuição escolhida?
- O MVP será distribuído por NSIS, MSIX ou apenas como build local?
- Qual biblioteca de recorrência compatível com o modelo do produto será usada?
- Como o app fará backup e restauração sem nuvem?
- Quais permissões e fluxo OAuth serão necessários para Google Calendar na fase futura?

## Source appendix

| [1] | Relatório técnico recebido do usuário e arquivado em [gemini-report.md](imports/gemini-report.md); suporta todos os achados importados | Gemini, publicação não informada | 2026-09-14 (acesso/importação) | não verificável independentemente; confiança baixa |

## Mapa de atualidade

O relatório não informa datas de publicação nem URLs. Todas as alegações dependentes de versão, plugins, compatibilidade, números de desempenho e OAuth devem ser rechecadas antes da implementação. A primeira atualização recomendada é uma pesquisa oficial direcionada a Tauri v2, notificações Windows, SQLite e Google Calendar.