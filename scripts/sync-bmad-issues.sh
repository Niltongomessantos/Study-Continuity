#!/bin/bash

# Caminho para a pasta que contém as histórias em markdown
STORIES_DIR="_bmad-output/specs/spec-estudo-ai-local-first-mvp/stories"

echo "Analisando histórias na pasta $STORIES_DIR..."

# Percorre todos os arquivos .md dentro da pasta
for STORY_FILE in "$STORIES_DIR"/*.md; do
  
  # Extrai a primeira linha do arquivo para ser o título da Issue (remove o "# ")
  FIRST_LINE=$(head -n 1 "$STORY_FILE")
  ISSUE_TITLE=$(echo "$FIRST_LINE" | sed 's/^# //')
  
  # O corpo da Issue será o conteúdo completo do arquivo
  ISSUE_BODY=$(cat "$STORY_FILE")

  # Verifica se a issue já existe (busca pelo título exato)
  EXISTING_ISSUE=$(gh issue list --state all --search "$ISSUE_TITLE in:title" --json number -q '.[0].number')

  if [ -n "$EXISTING_ISSUE" ]; then
    echo "🔄 Issue #$EXISTING_ISSUE já existe. Atualizando com o conteúdo local..."
    gh issue edit "$EXISTING_ISSUE" \
      --title "$ISSUE_TITLE" \
      --body "$ISSUE_BODY"
  else
    echo "🚀 Criando nova Issue: $ISSUE_TITLE..."
    gh issue create \
      --title "$ISSUE_TITLE" \
      --body "$ISSUE_BODY" \
      --label "story"
  fi

done