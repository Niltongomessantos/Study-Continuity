# Digest: relatório externo

- claim: Um servidor Web local Node.js ou binário compilado, SQLite e SPA é tecnicamente viável para o MVP; a escolha entre Node e binário depende principalmente da distribuição e das dependências exigidas do usuário.
  source: Relatório externo, referências [7] e [11]
  publisher: Relatório recebido via ferramenta externa; evidência primária citada: Node.js
  pub_date: não informado no relatório
  accessed: 2026-09-14
  confidence: medium; recomendação comparativa não foi medida em protótipo
  class: architecture

- claim: O backend local deve escutar somente em loopback e aplicar validações adicionais de Host, origem/CORS e CSRF; PNA é uma mitigação adicional, não substituto da defesa no servidor.
  source: Relatório externo, referências [2] e [10]; checagem atual em MDN e WICG PNA
  publisher: MDN/WICG
  pub_date: MDN 2025-11-29; PNA Community Group Draft 2024-09-26
  accessed: 2026-09-14
  confidence: high para a necessidade de defesa no servidor; PNA tem status de draft
  class: security

- claim: Para aplicação Web local, a documentação do Google aceita redirect URIs em localhost para testes e recomenda fluxo de servidor Web com biblioteca de backend, escopos mínimos, state e access_type offline quando acesso sem presença do usuário é necessário.
  source: https://developers.google.com/identity/protocols/oauth2/web-server
  publisher: Google Identity
  pub_date: 2026-09-14
  accessed: 2026-09-14
  confidence: high
  class: version/compatibility

- claim: A afirmação do relatório de que o fluxo deve ser necessariamente o padrão Native Apps da RFC 8252 é excessiva; o desenho precisa escolher explicitamente entre Web Server OAuth local e Native App OAuth conforme o modelo de cliente, sem tratar os fluxos como equivalentes.
  source: https://developers.google.com/identity/protocols/oauth2/web-server; https://datatracker.ietf.org/doc/html/rfc8252#section-7.3
  publisher: Google Identity/IETF
  pub_date: Google 2026-09-14; RFC 8252 2017-10
  accessed: 2026-09-14
  confidence: high para a distinção conceitual; acesso direto à RFC retornou 403 nesta checagem
  class: version/compatibility

- claim: Eventos da Calendar API suportam reminders com overrides, recorrência RRULE, recurringEventId, originalStartTime, extendedProperties e identificadores distintos como id e iCalUID.
  source: https://developers.google.com/calendar/api/v3/reference/events; https://datatracker.ietf.org/doc/html/rfc5545#section-3.8.5.3
  publisher: Google Developers/IETF
  pub_date: Google 2026-07-07; RFC 5545 2009-09
  accessed: 2026-09-14
  confidence: high para os campos documentados; regras de domínio ainda exigem protótipo
  class: version/compatibility

- claim: A sincronização incremental exige full sync inicial, persistência de syncToken, paginação, processamento de exclusões e full resync quando a API retornar 410 por token inválido ou expirado.
  source: https://developers.google.com/calendar/api/guides/sync
  publisher: Google Developers
  pub_date: 2026-09-11
  accessed: 2026-09-14
  confidence: high
  class: version/compatibility

- claim: A API possui limites por minuto de projeto e usuário, pode retornar 403 ou 429 e recomenda exponential backoff; o limite diário de 1.000.000 não significa que uma aplicação local esteja livre de rate limiting.
  source: https://developers.google.com/calendar/api/guides/quota
  publisher: Google Developers
  pub_date: 2026-09-11
  accessed: 2026-09-14
  confidence: high
  class: quantitative

- claim: PNA é uma especificação Community Group Draft, não um padrão W3C final, e sua mitigação não elimina a necessidade de proteção própria contra CSRF e DNS rebinding.
  source: https://wicg.github.io/private-network-access/
  publisher: WICG
  pub_date: 2024-09-26
  accessed: 2026-09-14
  confidence: high
  class: security

- claim: Node child_process permite iniciar processos no Windows, mas exec interpreta comandos via shell e não deve receber entrada de usuário não sanitizada; portanto, uma API open-file precisa validar e restringir caminhos.
  source: https://nodejs.org/api/child_process.html
  publisher: Node.js
  pub_date: não informado; documentação v26.8.2 acessada
  accessed: 2026-09-14
  confidence: high
  class: security

- claim: Node Single Executable Applications pode distribuir um executável sem Node instalado, mas a documentação classifica a capacidade como Active development e impõe condições de empacotamento, módulos e plataforma.
  source: https://nodejs.org/api/single-executable-applications.html
  publisher: Node.js
  pub_date: não informado; documentação v26.8.2 acessada
  accessed: 2026-09-14
  confidence: high
  class: version/compatibility

- claim: O relatório recomenda SQLite como fonte de verdade do progresso e o Google Calendar como fonte de tempo/notificações, com sincronização Local -> Calendar no MVP e sincronização reversa posterior.
  source: Relatório externo, seções 3.3 e 5
  publisher: Relatório recebido via ferramenta externa
  pub_date: não informado
  accessed: 2026-09-14
  confidence: medium; é uma recomendação arquitetural coerente, não uma regra documentada pelas fontes do Google
  class: architecture

- claim: Recorrência, exceções e alterações manuais no Google Calendar são o maior risco de domínio; devem ser prototipadas antes de comprometer sincronização bidirecional.
  source: Relatório externo, referências [4] e [5]; Google Events API e Sync guide
  publisher: Relatório recebido via ferramenta externa/Google Developers
  pub_date: Google 2026-09-11/2026-07-07; relatório sem data de produção
  accessed: 2026-09-14
  confidence: high como risco de implementação; baixo para qualquer solução específica não testada
  class: architecture
