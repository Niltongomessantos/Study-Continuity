# Idea hardening

## Core idea
App local de estudos acessado pelo navegador, com domínio local como fonte de verdade do estudo e Google Calendar como canal exclusivo de lembrete, projeção visual e calendário externo.

## Decision locked
- O produto é um orquestrador de estudo local-first, não um app desktop e não um planner genérico.
- A aplicação será acessada via navegador, em ambiente local, sem instalação desktop e sem hospedagem em nuvem no MVP.
- O domínio da aplicação vive localmente e é a fonte de verdade do histórico, da continuidade do estudo e das regras de negócio.
- O Google Calendar funciona como camada de alerta e projeção visual. Ele não decide regras do estudo nem absorve o domínio do produto.
- O MVP deve focar em cronograma, próxima aula, agendamento, materiais e lembrete, e não em IA, mobile, nuvem, webview ou integrações complexas.
- A criação de um item deve exigir que o usuário escolha explicitamente se ele é uma aula gerenciada ou um bloco livre.
- O foco principal da experiência inicial é mostrar o próximo passo em destaque, com contexto de aulas já passadas e futuras no mesmo dia.

## Product rules
- O app não envia notificações locais nem notificações do navegador.
- As notificações são feitas exclusivamente pelo Google Calendar, conforme os eventos sincronizados.
- O calendário só reflete o estado decidido pela aplicação local; ele não reescreve o domínio do estudo.
- O app local decide a lógica de início, atraso, reagendamento, conclusão e perda de aula.
- As regras de negócio da sessão devem permanecer no domínio local mesmo quando o evento existe no calendário.
- O tipo da aula pode ser definido na criação, mas material, conteúdo e configuração detalhada podem ser adicionados depois.
- O MVP prioriza a lógica de agendamento e continuidade sobre a gestão profunda de materiais.

## Session model

### Aula gerenciada
- É a sessão em que a aplicação tem autoridade sobre início, tempo, status e impacto no progresso do estudo.
- O usuário precisa acionar um botão de iniciar para começar a aula.
- Se não iniciar dentro do prazo de tolerância, a aula é marcada como perdida automaticamente.
- Ao iniciar, o sistema começa a contar o tempo imediatamente.
- Quando o tempo configurado termina, a aula é marcada como concluída automaticamente.
- Se o usuário interromper a aula durante o processo, a aula será considerada concluída somente se tiver atingido pelo menos 50% do tempo planejado; caso contrário, será considerada perdida.
- Atraso sem compensação: se o usuário entra tarde, o tempo perdido não será compensado.
- O sistema pode permitir ajuste manual posterior, mas a conclusão não depende de forma rígida da confirmação manual do usuário.
- O mínimo aceitável para uma aula ser considerada concluída no MVP é 50% do tempo planejado.
- A reposição deve ser oferecida somente para aulas que não foram iniciadas ou que foram perdidas.
- Reagendamento e reposição devem considerar a disponibilidade do calendário local e a regra do domínio.

### Bloco recorrente livre
- É um espaço agendado para estudo em que a aplicação não controla a plataforma externa nem o progresso do conteúdo consumido fora do sistema.
- O bloco livre pode ter link, material externo, horário, lembrete e cronômetro local.
- O cronômetro do bloco livre segue a mesma lógica da aula gerenciada: iniciar, contar tempo e registrar status.
- O bloco livre não adminstra a plataforma externa; ele mede o tempo em que o usuário está dedicando atenção ao estudo naquele bloco.
- O bloco livre é o lugar para cursos, palestras, vídeos, plataformas externas e materiais externos em geral.
- A sessão pode ser recorrente, similar ao Google Calendar, e pode repetir em dias ou semanas com exceções manuais.
- O usuário pode alterar uma ocorrência ou a série inteira.
- O sistema deve manter a regra local que conduz o bloco, e a projeção no calendário é apenas representação externa.

## Calendar authority and sync
- O Google Calendar é o canal de projeção e lembrete; ele não é a origem do domínio.
- O app local define o que aconteceu: aula iniciada, finalizada, perdida, reagendada, cancelada ou concluída.
- O calendário apenas recebe eventos e lembretes a partir desse estado.
- O fluxo deve ser unidirecional: do sistema local para o Google Calendar.
- Qualquer mudança feita no evento do calendário externamente não deve reescrever a lógica local do produto no MVP.
- O app deve manter fila local de sincronização, status, retry e estados visíveis para o usuário.
- A sincronização deve ser controlada e simples; não deve haver sincronização bidirecional irrestrita.
- O app deve manter o vínculo entre o ID local e o ID externo do evento para permitir atualização correta dos eventos.

## Creation flow
- Quando o usuário cria uma sessão, o sistema deve perguntar explicitamente se ela será uma aula gerenciada ou um bloco livre.
- Os campos essenciais na criação são horário e duração.
- O tipo da aula e os materiais podem ser adicionados depois, conforme o tipo de sessão e a evolução do produto.
- Na criação, o sistema não precisa exigir todos os detalhes do conteúdo; isso pode ser adicionado em fases posteriores.
- O calendário só deve receber o evento quando a sincronização estiver ativada pelo usuário.

## MVP hard lock
Os pontos que devem permanecer rígidos no MVP são:
- agenda principal e agendamento de estudo
- aula gerenciada com regras locais de início, tempo e status
- bloco livre com cronômetro local e acesso externo
- reposição por indisponibilidade
- sincronização local → Google Calendar
- foco em continuidade e próximo passo, não em ecossistema genérico

## Rejected options
- App desktop instalado: descartado.
- Notificações do navegador ou do sistema: descartado.
- Google Calendar como fonte oficial de todo o domínio: descartado.
- MVP com IA tutor, nuvem, mobile, múltiplas integrações e sincronização bidirecional ampla: descartado.
- Planner genérico sem foco em continuidade de estudo: descartado.
- Dependência da plataforma externa para controlar o tempo do estudo: descartado, porque a lógica local do tempo deve permanecer no app.

## Weak points that still matter
- O produto pode ser confundido com um planner genérico se o foco em continuidade não ficar claro.
- A diferenciação precisa ser explicada em termos de “próximo passo”, “cronograma” e “continuidade”, e não apenas como agenda.
- O ambiente local exige estratégia de backup e recuperação para evitar perda de domínios.
- O fluxo de OAuth, tokens e sincronização precisa ser definido com clareza antes da implementação.
- A regra do mínimo de 50% do tempo planejado deve ser validada com o usuário no protótipo para confirmar que ela faz sentido em sessões de diferentes durações.

## What must happen before architecture
- Formalizar o modelo de sessão gerenciada e o modelo de bloco livre com cronômetro local.
- Definir as regras de início, perda, conclusão e reposição.
- Definir a estratégia de OAuth local, tokens e persistência local.
- Definir fila de sincronização, retry e estados do evento externo.
- Validar como o app reprojecta eventos no Google Calendar sem perder regras internas.
- Revisar o MVP para manter foco e evitar excesso de escopo.
