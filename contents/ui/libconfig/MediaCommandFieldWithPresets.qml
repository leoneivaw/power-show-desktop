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
            { text: i18n("Custom / Nenhum"), value: "", isHeader: false },
            
            { text: i18n("--- Janela ---"), value: "HEADER", isHeader: true },
            { text: i18n("Abrir Player"), value: "open_player_popup", isHeader: false },

            { text: i18n("--- Controle de Reprodução ---"), value: "HEADER", isHeader: true },
            { text: i18n("Play / Pause"), value: "playPause", isHeader: false },
            { text: i18n("Forçar Play"), value: "qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut \"playmedia\"", isHeader: false },
            { text: i18n("Forçar Pause"), value: "qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut \"pausemedia\"", isHeader: false },
            { text: i18n("Parar (Stop)"), value: "qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut \"stopmedia\"", isHeader: false },

            { text: i18n("--- Navegação de Faixas ---"), value: "HEADER", isHeader: true },
            { text: i18n("Próxima Música"), value: "next", isHeader: false },
            { text: i18n("Música Anterior"), value: "previous", isHeader: false },

            { text: i18n("--- Volume da Mídia ---"), value: "HEADER", isHeader: true },
            { text: i18n("Aumentar Volume"), value: "volumeUp", isHeader: false },
            { text: i18n("Abaixar Volume"), value: "volumeDown", isHeader: false },
            { text: i18n("Aumentar Volume (DBus)"), value: "qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut \"mediavolumeup\"", isHeader: false },
            { text: i18n("Abaixar Volume (DBus)"), value: "qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut \"mediavolumedown\"", isHeader: false },

            { text: i18n("--- Linha do Tempo (Seek) ---"), value: "HEADER", isHeader: true },
            { text: i18n("Avançar (Curto)"), value: "qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut \"seekforwardmedia\"", isHeader: false },
            { text: i18n("Retroceder (Curto)"), value: "qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut \"seekbackwardmedia\"", isHeader: false },
            { text: i18n("Avançar (Longo)"), value: "qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut \"seekforwardmedialong\"", isHeader: false },
            { text: i18n("Retroceder (Longo)"), value: "qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut \"seekbackwardmedialong\"", isHeader: false }
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
