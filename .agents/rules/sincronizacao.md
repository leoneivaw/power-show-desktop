---
description: >-
  Diretrizes de modificação de código-fonte e sincronização obrigatória
  com o ambiente local KDE Plasma.
trigger: model_decision
---

# Regras de Desenvolvimento e Sincronização Local

## 1. Código-Fonte e Repositório
- **Diretório Raiz**: Todas as alterações de código devem ser feitas estritamente nos arquivos localizados em `/home/basis/IA/Projetos/Power Show desktop/`.
- **Repositório Git**: O controle de versão Git opera exclusivamente a partir da raiz deste projeto.

## 2. Sincronização Obrigatória com o KDE Plasma
- Toda vez que qualquer arquivo for modificado, adicionado ou removido no projeto, é **obrigatório** executar o script de sincronização local:
  ```bash
  ./install.sh
  ```
- O script é responsável por:
  1. Copiar as atualizações para o diretório de plasmoids do KDE (`~/.local/share/plasma/plasmoids/org.kde.plasma.powershowdesktop/`).
  2. Reiniciar o serviço `plasma-plasmashell` para recarregar o widget com as novas alterações.
