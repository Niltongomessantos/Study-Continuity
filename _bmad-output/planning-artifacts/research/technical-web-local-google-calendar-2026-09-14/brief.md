# Prompt de Deep Research: Aplicacao Web Local com Google Calendar

## Papel

Atue como pesquisador tecnico sênior e produza uma investigação baseada em evidências para orientar uma decisão de arquitetura. Não trate conhecimento prévio, documentação fornecida neste prompt ou inferências como fatos comprovados. Toda afirmação factual deve ter fonte verificável.

## Decisão a orientar

Definir uma arquitetura viável, segura e simples para um aplicativo Web hospedado localmente e acessado pelo navegador, com integração inicial ao Google Calendar como único canal de notificações. A arquitetura deve atender um MVP de organização de estudos sem hospedagem em nuvem por enquanto, sem notificações próprias do aplicativo e sem notificações do navegador.

A investigação deve permitir decidir:

1. Como executar e acessar com segurança uma aplicação Web local.
2. Como persistir os dados do aplicativo localmente.
3. Como autenticar com o Google e sincronizar sessões com o Google Calendar.
4. Como representar recorrência, exceções, reposição e alterações feitas nos dois sistemas.
5. Como manter a operação simples, segura e sustentável para um MVP.

## Contexto funcional para delimitar a pesquisa

O produto organiza matérias, materiais, links, sessões de estudo e blocos recorrentes livres. Existem dois tipos de sessão:

- Aula gerenciada: possui objetivo, material, status, duração e possibilidade de reposição quando não foi iniciada.
- Bloco recorrente livre: possui horário, duração, lembrete e material externo, sem acompanhamento do progresso da plataforma externa.

O navegador externo continua sendo o caminho para YouTube, cursos pagos, PDFs e outros materiais. O aplicativo não deve acompanhar credenciais ou progresso de plataformas externas. As notificações não devem ser emitidas pelo aplicativo local nem pelo navegador; devem depender exclusivamente dos eventos e lembretes do Google Calendar.

Este contexto é apenas requisito de investigação, não é evidência. Não cite este prompt como fonte.

## Tipo e formato

- Tipo: pesquisa técnica.
- Forma da decisão: seleção entre alternativas arquiteturais, com recomendação condicionada a evidências.
- Público: pessoa desenvolvedora ou equipe pequena construindo um MVP local no Windows, com preocupação real de segurança, manutenção e facilidade de uso.
- Idioma do relatório: português do Brasil.

## Perguntas de pesquisa

### 1. Arquitetura Web hospedada localmente

Compare alternativas atuais para executar uma aplicação Web local acessada pelo navegador, incluindo quando pertinente:

- Frontend separado de um backend local.
- Servidor local com banco embutido.
- Docker ou outro runtime empacotado.
- Aplicação iniciada por comando/script.
- Empacotamento futuro sem transformar o produto em aplicativo desktop.

Para cada alternativa, avalie inicialização, dependências, persistência, atualização, acesso a arquivos locais, segurança de `localhost`, suporte no Windows, experiência do usuário e esforço operacional. Esclareça a diferença entre “não instalar um aplicativo desktop” e ainda precisar executar um servidor ou runtime local.

### 2. Google Calendar e OAuth

Use prioritariamente a documentação oficial atual do Google. Investigue:

- Fluxo OAuth apropriado para uma aplicação Web executada localmente.
- Redirect URIs, consentimento, escopos mínimos e verificação do aplicativo.
- Armazenamento, renovação, revogação e exclusão de tokens.
- Criação, atualização e exclusão de eventos.
- Eventos recorrentes, exceções e identificadores de correlação.
- Lembretes e notificações configuráveis pelo Google Calendar.
- Fusos horários e horário de verão.
- Quotas, limites, paginação, sincronização incremental e tratamento de erros.
- Comportamento quando o usuário altera um evento diretamente no Google Calendar.
- Comportamento quando a autorização expira, é revogada ou fica indisponível.

Não assuma que criar um evento garante uma notificação específica: verifique as regras reais da API e do produto Google Calendar.

### 3. Modelo de domínio e sincronização

Investigue padrões para separar o domínio interno de estudos do modelo de eventos do Google Calendar. Recomende, com justificativa:

- Qual sistema deve ser a fonte de verdade para sessões e status.
- Como mapear uma sessão interna para um evento externo.
- Como tratar alterações de uma ocorrência ou de uma série inteira.
- Como representar reposições sem perder o vínculo com a aula original.
- Como lidar com exclusões, duplicações, conflitos e sincronização parcial.
- Se a recorrência deve ser calculada internamente, no Calendar ou em ambos.
- Como evitar que uma falha de sincronização corrompa o histórico local.

Inclua uma máquina de estados ou tabela de transições se isso esclarecer a recomendação.

### 4. Segurança, privacidade e ameaça

Investigue riscos específicos de uma aplicação Web local que acessa uma conta Google:

- CSRF, CORS, DNS rebinding e exposição acidental além de `localhost`.
- Proteção de tokens e dados locais.
- Escopos OAuth excessivos.
- Validação de URLs externas e caminhos de arquivos.
- Autorização entre processos ou entre abas, se aplicável.
- Backup e restauração contendo tokens ou dados pessoais.
- Logs que possam vazar informações.
- Medidas mínimas para um MVP e medidas necessárias antes de distribuição para terceiros.

Priorize documentação oficial, padrões reconhecidos e análises de incidentes ou vulnerabilidades relevantes. Não transforme uma lista genérica de segurança em requisito sem explicar a ameaça que ela reduz.

### 5. Operação, manutenção e ecossistema

Compare as opções tecnológicas candidatas quanto a:

- Maturidade e manutenção atual.
- Qualidade da documentação.
- Bibliotecas oficiais ou amplamente mantidas para Google OAuth e Calendar.
- Atualizações, compatibilidade e risco de dependência abandonada.
- Testabilidade da sincronização.
- Complexidade para uma equipe pequena.
- Custo operacional e possibilidade de evolução futura para hospedagem remota.

Verifique versões e compatibilidade em fontes atuais. Não use uma reclamação antiga sem verificar se o problema foi corrigido.

## Critérios de fonte

### Preferir

1. Documentação oficial do Google Cloud, Google Identity e Google Calendar API.
2. RFCs, OWASP, NIST e documentação oficial de navegadores ou runtimes.
3. Documentação oficial e repositórios dos frameworks e bibliotecas candidatas.
4. Issue trackers, changelogs e post-mortems técnicos quando tratarem de problemas concretos.
5. Relatos de produção com contexto, limitações e números reproduzíveis.

### Não usar como evidência final

- Conteúdo gerado por IA sem fontes primárias.
- Artigos SEO, listas genéricas e comparações sem método.
- Snippets de busca.
- Marketing de fornecedor como única fonte para uma afirmação crítica.
- Uma única postagem para afirmar que uma tecnologia falhou.

Use fontes secundárias apenas para localizar evidências primárias e indique quando uma afirmação depende de fonte secundária.

## Requisitos de atualidade

- OAuth, Google Calendar API, escopos, quotas, SDKs e compatibilidade: fonte atual, preferencialmente publicada ou atualizada nos últimos 6 meses.
- Vulnerabilidades e recomendações de segurança: estado atual e confirmação em fonte oficial.
- Ecossistema e manutenção: sinais dos últimos 6 a 12 meses.
- Padrões arquiteturais: evidências dos últimos 2 anos, salvo quando um padrão mais antigo continuar vigente.

Se não houver fonte recente, declare a lacuna e não preencha com suposição.

## Método

1. Pesquise cada dimensão separadamente.
2. Para afirmações críticas de compatibilidade, segurança, performance, quota ou falha, procure pelo menos duas fontes independentes quando isso for possível.
3. Diferencie fato documentado, observação de fonte secundária, inferência e recomendação.
4. Procure evidência contrária para a alternativa recomendada.
5. Não compare métricas de desempenho sem explicar ambiente e método.
6. Não conclua que uma alternativa é melhor apenas por ser popular ou mais leve.
7. Registre fontes descartadas quando forem relevantes para evitar conclusões enganosas.

## Formato obrigatório do relatório

### 1. Resumo executivo

Comece com a decisão recomendada, o nível de confiança, as principais condições e os riscos que ainda exigem protótipo.

### 2. Matriz de decisão

Compare as alternativas arquiteturais em uma tabela com os critérios:

- Execução local.
- Segurança.
- OAuth e Google Calendar.
- Persistência.
- Recorrência e sincronização.
- Facilidade de uso.
- Manutenção.
- Evolução futura para nuvem.
- Complexidade e riscos.

Não use notas numéricas sem explicar o critério e a evidência.

### 3. Achados por dimensão

Apresente os achados nas cinco dimensões acima. Para cada afirmação importante, inclua marcador de citação `[n]` imediatamente após o texto.

### 4. Arquitetura recomendada

Descreva os componentes, limites entre frontend, backend local, banco e adaptador do Google Calendar. Inclua o fluxo de autenticação, sincronização, falha e recuperação.

### 5. Recomendação de MVP

Liste o que deve entrar na primeira implementação, o que deve ser prototipado antes e o que deve ficar fora. Inclua testes técnicos mínimos para validar a recomendação no Windows.

### 6. Evidência contrária e riscos

Mostre argumentos contra a recomendação, cenários em que outra alternativa seria melhor e riscos não resolvidos.

### 7. Questões abertas

Liste apenas perguntas que realmente possam alterar a decisão.

### 8. Source appendix

Para cada fonte citada, informe:

- Número da fonte.
- Título.
- Organização ou autor.
- URL completa.
- Data de publicação ou última atualização, quando disponível.
- Data de acesso.
- Tipo de fonte.
- Afirmação ou afirmações que ela sustenta.
- Limitações e nível de confiança.

## Regras de citação e honestidade

- Toda afirmação factual relevante precisa de URL e data de publicação ou atualização quando disponível.
- Não invente URLs, datas, versões, métricas ou resultados.
- Não apresente conhecimento não verificado como conclusão.
- Informe explicitamente quando uma fonte não informa a data.
- Diferencie “a documentação permite”, “a documentação recomenda” e “foi observado na prática”.
- Relate ausência de evidência quando ela for importante.
- Ao encontrar fontes conflitantes, apresente o conflito e explique qual fonte recebeu maior peso.

## Entrega

Entregue um relatório completo e decision-grade, seguido de uma lista curta dos 10 a 15 links mais importantes usados na pesquisa. Não resuma o pedido sem pesquisar. Não recomende implementação específica sem comparar alternativas e indicar as evidências que sustentam a escolha.
