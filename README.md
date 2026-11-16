<div align="center">
  <h1>🧬 Power Show Desktop | Plasma</h1>
  <p><strong>Show desktop and shortcut central.</strong></p>
  <p>
    <strong>Powered By: O Maior de Minas</strong> <a href="https://www.cruzeiro.com.br/">www.cruzeiro.com.br</a> <img src="images/Maior%20de%20Minas.jpg" height="24" align="absmiddle" /> 🦊💙
  </p>
  <img src="images/Maior%20de%20Minas%20Trofeus.png" height=50 />
</div>

---

**Power Show Desktop | Plasma** is an enhanced widget (plasmoid) for KDE Plasma. In addition to offering the classic behavior of "peeking" or minimizing windows to see your desktop (Windows 7 style), this version has been heavily modified to serve as an **invisible shortcut central**.

<img width="119" height="76" alt="image" src="https://github.com/user-attachments/assets/6ab95ea6-ece5-48b2-b666-82c85efc282b" />

<img width="179" height="61" alt="image" src="https://github.com/user-attachments/assets/303880c8-b051-4f38-ad91-24157e11e5be" />


With it, you can assign powerful scripts and commands to clicks and mouse scroll movements, all in a single button at the corner of your screen!

## ✨ New in this Version (v1.5.5)

*   **Interactive Tooltip Overview:** Hovering over the widget now displays a rich-text tooltip summarizing all your configured actions and keyboard/mouse shortcuts (both General and Advanced).
*   **Native Action Presets:** Added direct presets for "Peek at Desktop (Native)" and "Minimize All Windows (Native)" in the command configuration dropdowns.
*   **ComboBox Scroll Protection:** Disabled mouse wheel scrolling on settings dropdowns to prevent accidental option changes while scrolling configuration pages.
*   **Media Playback Detection:** Improved active media detection and playback status handling in the MPRIS media block.

*(Includes all v1.5.4 features: Native MPRIS Media Control, Dynamic Media Popup, Kirigami settings layout, and Advanced Click/Scroll triggers)*

---

## 🚀 Installation

The easiest way to install is by using the packaged `.plasmoid` file available in the **Releases** tab.

1. Go to the project's [Releases](../../releases) page.
2. Download the latest `Power-Show-Desktop-1.5.5.plasmoid` file.
3. To install, you can double-click the downloaded file and use the KDE installer, or use the terminal:
   ```bash
   kpackagetool6 -i Power-Show-Desktop-1.5.5.plasmoid
   ```
4. Restart your plasma panel (`systemctl restart --user plasma-plasmashell`) and add the "Power Show Desktop | Plasma" widget to your panel.

---

## 🛠️ How to Configure

After adding the widget to your taskbar:
1. Right-click on it and select **"Configure 🧬 Power Show Desktop | Plasma"**.
2. In the **General** tab, you can choose the click color, the standard command, and the new **Long Press Command and Color**.

![General Configuration](images/config1.png)

3. In the **Advanced Actions** tab, you have access to advanced fields for modifiers (`Ctrl`, `Shift`, `Alt`, `Middle Click`) and exclusive **Mouse Scroll** commands.

![Advanced Configuration](images/Config_advanced.png)

### Useful Example for Scrolling (Switching Desktops)
Try selecting these commands from the smart Presets dropdown in the **Advanced Actions** tab to switch desktops using `Ctrl + Scroll`:
- **Ctrl+Scroll Up:** `Switch One Desktop to the Right`
- **Ctrl+Scroll Down:** `Switch One Desktop to the Left`

---

## 📝 License
This software is open-source and distributed under the **GPL-3.0** license.  
*(This project is a fork of the acclaimed original `plasma-applet-win7showdesktop` created by Zren, modified and modernized by Leonardo Pimenta).*
