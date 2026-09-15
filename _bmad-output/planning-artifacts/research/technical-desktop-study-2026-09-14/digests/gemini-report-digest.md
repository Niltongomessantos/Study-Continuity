# Digest do relatório importado

## Decisão

O relatório recomenda Tauri v2 com frontend web, Rust para capacidades de sistema e SQLite para o MVP desktop local.

## Alegações relevantes

| Alegação | Fonte no import | Data | Confiança |
| --- | --- | --- | --- |
| Tauri v2 é a opção recomendada para o MVP por eficiência de recursos e suporte a tray | Relatório Gemini, seções 2, 5 e 9 | Não informada | Não verificada |
| SQLite atende ao armazenamento local de sessões, recorrências, materiais e histórico | Relatório Gemini, seção 6 | Não informada | Média como recomendação, não como validação de implementação |
| Notificações confiáveis exigem processo em segundo plano e tratamento de suspensão/retorno | Relatório Gemini, seção 5 | Não informada | Não verificada |
| Abrir plataformas no navegador externo reduz problemas de iframe, login e cookies | Relatório Gemini, seção 8 | Não informada | Média como direção arquitetural; detalhes de plataforma não verificados |
| UUIDs, timestamps e soft delete podem facilitar sincronização futura | Relatório Gemini, seção 6 | Não informada | Recomendação arquitetural não verificada |
| Google Calendar deve usar OAuth desktop e armazenamento seguro de tokens | Relatório Gemini, seção 7 | Não informada | Não verificada |
| NSIS é uma opção de empacotamento para o MVP Windows | Relatório Gemini, seção 9 | Não informada | Não verificada |

## Lacunas

- O import não fornece URLs, autores, datas de publicação ou documentação consultada.
- As faixas de consumo de memória e tamanho de instalador não podem fundamentar a decisão sem fontes e método de medição.
- Não foi verificado o comportamento atual de notificações após suspensão, encerramento e inicialização do Windows.
- Não foi verificada a compatibilidade atual dos plugins Tauri citados nem a recomendação vigente do OAuth do Google.
- Não há comparação detalhada de manutenção, acessibilidade, testes e distribuição entre as alternativas.