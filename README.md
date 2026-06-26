<div align="center">
  <h1>Show Desktop | Plasma</h1>
  <p><strong>Mostre a área de trabalho do Plasma e tenha uma verdadeira central de atalhos avançados no seu painel!</strong></p>
  <p>
    <strong>Powered By: O Maior de Minas</strong> <img src="images/Maior%20de%20Minas.jpg" height="24" align="absmiddle" /> 🦊💙
  </p>
  <img src="images/Maior%20de%20Minas%20Trofeus.png" height="100" />
</div>

---

O **Show Desktop | Plasma** é um widget (plasmoid) aprimorado para o KDE Plasma. Além de oferecer o comportamento clássico de "espiar" ou minimizar as janelas para ver a sua área de trabalho (estilo Windows 7), esta versão foi amplamente modificada para servir como uma **central invisível de atalhos**.

Com ele, você pode associar comandos e scripts poderosos a cliques e movimentos de rolagem (scroll) do mouse, tudo em um único botão no canto da sua tela!

## ✨ Novidades desta Versão (v1.0)

Esta versão foi redesenhada com foco na produtividade, introduzindo novas telas de configuração e dezenas de gatilhos novos:

*   **Ações Avançadas de Clique:** Configure scripts ou comandos independentes para:
    *   `Ctrl + Clique`
    *   `Alt + Clique`
    *   `Shift + Clique`
    *   `Clique com o botão do meio (Middle Click)`
*   **Clique Longo (Long Press):** Segure o botão esquerdo do mouse pressionado para executar uma ação secundária.
    *   *Customização de Cor:* Escolha uma cor de brilho customizada para indicar que o clique longo foi acionado.
    *   *Anti-Conflito Inteligente:* O widget entende quando você está dando um clique longo e bloqueia automaticamente a ação de "minimizar janelas", evitando comportamentos indesejados.
*   **Controles de Rolagem do Mouse (Scroll):**
    *   Atribua comandos nativos de `qdbus` para a roda do mouse.
    *   Configure `Ctrl + Rolagem para Cima` e `Ctrl + Rolagem para Baixo` (perfeito para trocar de áreas de trabalho virtuais rapidamente).
    *   **Cooldown Configurável:** Controle a sensibilidade da rolagem! Ajuste o tempo de espera (em milissegundos) para evitar que o mouse dispare a mesma ação dezenas de vezes em um único movimento.
*   **Layout Modernizado:** O painel de configurações internas do widget foi atualizado para utilizar o design nativo do Kirigami do KDE.

---

## 🚀 Instalação

A maneira mais fácil de instalar é utilizando o arquivo empacotado `.plasmoid` disponível na aba **Releases**.

1. Vá até a página de [Releases](../../releases) do projeto.
2. Baixe o arquivo mais recente `Show-Desktop-Plasma-1.0.plasmoid`.
3. Para instalar, você pode dar dois cliques no arquivo baixado e usar o instalador do KDE, ou usar o terminal:
   ```bash
   kpackagetool6 -i Show-Desktop-Plasma-1.0.plasmoid
   ```
4. Reinicie o seu painel do plasma (`systemctl restart --user plasma-plasmashell`) e adicione o widget "Show Desktop | Plasma" ao seu painel.

---

## 🛠️ Como Configurar

Após adicionar o widget à sua barra de tarefas:
1. Clique com o botão direito sobre ele e selecione **"Configurar Show Desktop | Plasma"**.
2. Na aba **Geral**, você poderá escolher a cor de clique, o comando padrão e o novo **Comando e Cor do Clique Longo (Long Press)**.

![Configuração Geral](images/config1.png)

3. Na aba **Advanced Actions**, você tem acesso aos campos avançados para modificadores (`Ctrl`, `Shift`, `Alt`, `Middle Click`) e os comandos exclusivos da **Rolagem do Mouse (Scroll)**.

![Configuração Avançada](images/Config%20advanced.png)

### Exemplo Útil para Scroll (Trocar Áreas de Trabalho)
Experimente colar estes comandos na aba de **Advanced Actions** para trocar de Desktop usando `Ctrl + Scroll`:
- **Ctrl+Scroll Up:** `qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut "Switch One Desktop to the Right"`
- **Ctrl+Scroll Down:** `qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut "Switch One Desktop to the Left"`

---

## 📝 Licença
Este software é open-source e está distribuído sob a licença **GPL-3.0**.  
*(Este projeto é um fork do aclamado `plasma-applet-win7showdesktop` original criado por Zren, modificado e modernizado por Leonardo Pimenta).*
