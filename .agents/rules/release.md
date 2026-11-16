---
description: >-
  Diretrizes e procedimento obrigatório para criação e publicação de novas versões
  (releases) do plasmoid Power Show Desktop.
trigger: model_decision
---

# Regras de Release e Versionamento

Toda vez que for solicitado criar, gerar, subir ou publicar uma nova versão (release) do projeto, o fluxo abaixo deve ser seguido com rigor:

## 1. Versionamento Semântico
- Adotar o padrão **SemVer** (`MAJOR.MINOR.PATCH`):
  - **PATCH** (ex.: `1.5.5` -> `1.5.6`): correções de bugs, pequenas melhorias ou ajustes visuais.
  - **MINOR** (ex.: `1.5.6` -> `1.6.0`): novas funcionalidades compatíveis.
  - **MAJOR** (ex.: `1.6.0` -> `2.0.0`): alterações incompatíveis ou reformulação completa.

## 2. Atualização dos Arquivos de Versão
- **`metadata.json`**:
  Atualizar o campo `"Version"` dentro de `KPlugin` para a nova versão (ex.: `"Version": "1.5.6"`).
- **`README.md`**:
  - Atualizar/adicionar o bloco de novidades da versão (`## ✨ New in this Version (vX.Y.Z)`).
  - Atualizar os links e exemplos de comando do arquivo `.plasmoid` na seção de instalação (`Power-Show-Desktop-X.Y.Z.plasmoid`).

## 3. Compilação de Traduções (se aplicável)
- Caso tenham sido adicionadas novas strings traduzíveis no QML ou ajustados arquivos em `translate/`, executar:
  ```bash
  python3 build_locales.py
  ```

## 4. Empacotamento do Arquivo `.plasmoid`
- O arquivo `.plasmoid` para distribuição no KDE Plasma deve conter **estritamente**:
  - `metadata.json`
  - `icon.svg`
  - Pasta `contents/` (incluindo `ui/`, `config/` e `locale/`)
- **Proibido** incluir arquivos desnecessários no pacote (como `images/`, `translate/`, arquivos temporários `*.po~`, `README.md`, `LICENSE`, scripts ou `.git`), pois inflam o tamanho do arquivo sem utilidade para o KDE.
- Remover o arquivo `.plasmoid` da versão anterior do repositório:
  ```bash
  rm -f Power-Show-Desktop-<versao_anterior>.plasmoid
  ```
- Gerar o novo pacote compactado na raiz:
  ```bash
  zip -r Power-Show-Desktop-<nova_versao>.plasmoid metadata.json icon.svg contents/
  ```

## 5. Sincronização Local
- Executar o script de sincronização local para refletir as alterações no ambiente Plasma em uso:
  ```bash
  ./install.sh
  ```

## 6. Commit, Tag e Publicação
- Adicionar os arquivos alterados e o novo pacote ao Git:
  ```bash
  git add metadata.json README.md Power-Show-Desktop-<nova_versao>.plasmoid
  git rm Power-Show-Desktop-<versao_anterior>.plasmoid
  git commit -m "chore: release v<nova_versao>"
  ```
- Criar a tag Git anotada:
  ```bash
  git tag -a v<nova_versao> -m "Release v<nova_versao>"
  ```
- Enviar as alterações e a tag para o repositório remoto:
  ```bash
  git push origin main
  git push origin v<nova_versao>
  ```
- Publicar a Release oficial no GitHub via `gh` CLI anexando o arquivo `.plasmoid`:
  ```bash
  gh release create v<nova_versao> Power-Show-Desktop-<nova_versao>.plasmoid \
    --title "v<nova_versao>" \
    --notes "..."
  ```
