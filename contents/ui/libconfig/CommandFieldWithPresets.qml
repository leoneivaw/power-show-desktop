import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import Qt.labs.platform 1.1 as Platform

RowLayout {
    id: root

    property alias text: textField.text
    
    Layout.fillWidth: true
    spacing: 5 * Screen.devicePixelRatio

    QQC2.TextField {
        id: textField
        Layout.fillWidth: true
        wrapMode: QQC2.TextField.Wrap

        onTextChanged: {
            if (presetCombo.currentValue !== text) {
                var found = false;
                for (var i = 1; i < presetCombo.model.length; i++) {
                    if (presetCombo.model[i].value === text) {
                        presetCombo.currentIndex = i;
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    presetCombo.currentIndex = 0;
                }
            }
        }
    }

    QQC2.Button {
        icon.name: "document-open"
        onClicked: fileDialog.open()
        QQC2.ToolTip.visible: hovered
        QQC2.ToolTip.text: i18n("Select a Bash Script (.sh)")
    }

    Platform.FileDialog {
        id: fileDialog
        title: i18n("Select Script")
        nameFilters: ["Shell Scripts (*.sh)", "All Files (*)"]
        onAccepted: {
            var path = file.toString();
            // remove file:// prefix
            if (path.startsWith("file://")) {
                path = path.substring(7);
            }
            textField.text = path;
            presetCombo.currentIndex = 0;
        }
    }

    QQC2.ComboBox {
        id: presetCombo
        textRole: "text"
        valueRole: "value"

        delegate: QQC2.ItemDelegate {
            width: ListView.view ? ListView.view.width : presetCombo.width
            text: modelData.text
            font.bold: modelData.isHeader ? true : false
            enabled: !modelData.isHeader
            leftPadding: modelData.isHeader ? 12 : 24
            topPadding: modelData.isHeader ? 12 : 6
            bottomPadding: modelData.isHeader ? 4 : 6
        }

        model: [
            { text: i18n("Command"), value: "", isHeader: false },
            
            { text: i18n("--- Gerenciamento de Janelas e Telas ---"), value: "HEADER", isHeader: true },
            { text: i18n("Overview"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Overview\"", isHeader: false },
            { text: i18n("Present Windows (Current Desktop)"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Expose\"", isHeader: false },
            { text: i18n("Present Windows (All Desktops)"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"ExposeAll\"", isHeader: false },
            { text: i18n("Present Windows (Window Class)"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"ExposeClass\"", isHeader: false },
            { text: i18n("Show Desktop Grid"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"ShowDesktopGrid\"", isHeader: false },
            { text: i18n("Show Desktop"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Show Desktop\"", isHeader: false },

            { text: i18n("--- Alternância de Áreas de Trabalho ---"), value: "HEADER", isHeader: true },
            { text: i18n("Switch Desktop Right"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Switch One Desktop to the Right\"", isHeader: false },
            { text: i18n("Switch Desktop Left"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Switch One Desktop to the Left\"", isHeader: false },
            { text: i18n("Window to Next Desktop"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window to Next Desktop\"", isHeader: false },
            { text: i18n("Window to Prev Desktop"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window to Previous Desktop\"", isHeader: false },
            { text: i18n("Window to Next Screen"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window to Next Screen\"", isHeader: false },
            { text: i18n("Window to Prev Screen"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window to Previous Screen\"", isHeader: false },

            { text: i18n("--- Posicionamento e Tiling ---"), value: "HEADER", isHeader: true },
            { text: i18n("Edit Tiles"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Edit Tiles\"", isHeader: false },
            { text: i18n("Switch Window Left"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Switch Window Left\"", isHeader: false },
            { text: i18n("Switch Window Right"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Switch Window Right\"", isHeader: false },
            { text: i18n("Switch Window Up"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Switch Window Up\"", isHeader: false },
            { text: i18n("Switch Window Down"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Switch Window Down\"", isHeader: false },
            { text: i18n("Window Move Center"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Move Center\"", isHeader: false },
            { text: i18n("Quick Tile Left"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Quick Tile Left\"", isHeader: false },
            { text: i18n("Quick Tile Right"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Quick Tile Right\"", isHeader: false },
            { text: i18n("Quick Tile Top"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Quick Tile Top\"", isHeader: false },
            { text: i18n("Quick Tile Bottom"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Quick Tile Bottom\"", isHeader: false },
            { text: i18n("Quick Tile Top Left"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Quick Tile Top Left\"", isHeader: false },
            { text: i18n("Quick Tile Top Right"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Quick Tile Top Right\"", isHeader: false },
            { text: i18n("Quick Tile Bottom Left"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Quick Tile Bottom Left\"", isHeader: false },
            { text: i18n("Quick Tile Bottom Right"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Quick Tile Bottom Right\"", isHeader: false },
            { text: i18n("Pack Window Left"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Pack Left\"", isHeader: false },
            { text: i18n("Pack Window Right"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Pack Right\"", isHeader: false },
            { text: i18n("Pack Window Up"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Pack Up\"", isHeader: false },
            { text: i18n("Pack Window Down"), value: "qdbus6 org.kde.kglobalaccel /component/kwin invokeShortcut \"Window Pack Down\"", isHeader: false },

            { text: i18n("--- Áudio (amixer / Sem UI) ---"), value: "HEADER", isHeader: true },
            { text: i18n("Volume Up (amixer)"), value: "amixer -q sset Master 10%+", isHeader: false },
            { text: i18n("Volume Down (amixer)"), value: "amixer -q sset Master 10%-", isHeader: false },

            { text: i18n("--- Áudio (kmix) ---"), value: "HEADER", isHeader: true },
            { text: i18n("Mute/Unmute"), value: "qdbus6 org.kde.kglobalaccel /component/kmix invokeShortcut \"mute\"", isHeader: false },
            { text: i18n("Volume Up"), value: "qdbus6 org.kde.kglobalaccel /component/kmix invokeShortcut \"increase_volume\"", isHeader: false },
            { text: i18n("Volume Down"), value: "qdbus6 org.kde.kglobalaccel /component/kmix invokeShortcut \"decrease_volume\"", isHeader: false },
            { text: i18n("Mic Mute"), value: "qdbus6 org.kde.kglobalaccel /component/kmix invokeShortcut \"mic_mute\"", isHeader: false }
        ]

        onActivated: {
            if (currentValue !== "" && currentValue !== "HEADER") {
                textField.text = currentValue;
            }
        }
        
        Component.onCompleted: {
            if (presetCombo.currentValue !== textField.text) {
                var found = false;
                for (var i = 1; i < presetCombo.model.length; i++) {
                    if (presetCombo.model[i].value === textField.text) {
                        presetCombo.currentIndex = i;
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    presetCombo.currentIndex = 0;
                }
            }
        }
    }
}
