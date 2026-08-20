import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

// Model MPRIS nativo do Plasma
import org.kde.plasma.private.mpris as Mpris

Item {
    id: mediaRoot
    implicitWidth: rowLayout.implicitWidth + (Kirigami.Units.smallSpacing * 2)
    implicitHeight: rowLayout.implicitHeight + (Kirigami.Units.smallSpacing * 2)

    signal executeCommand(string cmd)

    Mpris.Mpris2Model {
        id: mprisModel
    }

    MediaPlayerPopup {
        id: mediaPopup
        visualParent: mediaRoot
        mprisModel: mprisModel
    }

    property var currentPlayer: mprisModel.currentPlayer
    property bool hasActiveMedia: currentPlayer !== null && currentPlayer !== undefined
    property string artUrl: currentPlayer ? currentPlayer.artUrl : ""
    property string track: currentPlayer ? currentPlayer.track : ""
    property string artist: currentPlayer ? currentPlayer.artist : ""

    function handleCommand(cmd) {
        if (cmd === "open_player_popup") {
            if (Plasmoid.configuration.mediaVisualMode === "minimal" && !mediaPopup.visible) {
                // Em modo minimal, alternamos o comportamento ou podemos sempre abrir. 
                // A instrução do usuário é apenas abrir o popup, então vamos abrir.
            }
            mediaPopup.visible = !mediaPopup.visible;
        } else if (cmd === "playPause") {
            if (mediaRoot.currentPlayer) {
                if (typeof mediaRoot.currentPlayer.PlayPause === "function") mediaRoot.currentPlayer.PlayPause();
                else if (typeof mediaRoot.currentPlayer.playPause === "function") mediaRoot.currentPlayer.playPause();
                else mediaRoot.executeCommand("qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut 'playpausemedia'");
            }
        } else if (cmd === "next") {
            if (mediaRoot.currentPlayer) {
                if (typeof mediaRoot.currentPlayer.Next === "function") mediaRoot.currentPlayer.Next();
                else if (typeof mediaRoot.currentPlayer.next === "function") mediaRoot.currentPlayer.next();
                else mediaRoot.executeCommand("qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut 'nextmedia'");
            }
        } else if (cmd === "previous") {
            if (mediaRoot.currentPlayer) {
                if (typeof mediaRoot.currentPlayer.Previous === "function") mediaRoot.currentPlayer.Previous();
                else if (typeof mediaRoot.currentPlayer.previous === "function") mediaRoot.currentPlayer.previous();
                else mediaRoot.executeCommand("qdbus6 org.kde.kglobalaccel /component/mediacontrol invokeShortcut 'previousmedia'");
            }
        } else if (cmd === "volumeUp") {
            if (mediaRoot.currentPlayer) {
                if (typeof mediaRoot.currentPlayer.RaiseVolume === "function") mediaRoot.currentPlayer.RaiseVolume();
                else if (mediaRoot.currentPlayer.volume !== undefined) mediaRoot.currentPlayer.volume = Math.min(mediaRoot.currentPlayer.volume + 0.05, 1.0);
            }
        } else if (cmd === "volumeDown") {
            if (mediaRoot.currentPlayer) {
                if (typeof mediaRoot.currentPlayer.LowerVolume === "function") mediaRoot.currentPlayer.LowerVolume();
                else if (mediaRoot.currentPlayer.volume !== undefined) mediaRoot.currentPlayer.volume = Math.max(mediaRoot.currentPlayer.volume - 0.05, 0.0);
            }
        } else if (cmd !== "") {
            mediaRoot.executeCommand(cmd); // Envia para o DBus/Bash
        }
    }

    MouseArea {
        id: mediaMouseArea
        anchors.fill: parent
        hoverEnabled: true
        preventStealing: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        property real lastWheelTime: 0
        property int wheelDelta: 0

        onWheel: wheel => {
            const delta = (wheel.inverted ? -1 : 1) * (wheel.angleDelta.y ? wheel.angleDelta.y : -wheel.angleDelta.x);
            wheelDelta += delta;
            while (wheelDelta >= 120) {
                wheelDelta -= 120;
                let now = Date.now();
                if (now - lastWheelTime > Plasmoid.configuration.media_mousewheel_cooldown) {
                    lastWheelTime = now;
                    handleCommand(Plasmoid.configuration.media_scroll_up_command);
                }
            }
            while (wheelDelta <= -120) {
                wheelDelta += 120;
                let now = Date.now();
                if (now - lastWheelTime > Plasmoid.configuration.media_mousewheel_cooldown) {
                    lastWheelTime = now;
                    handleCommand(Plasmoid.configuration.media_scroll_down_command);
                }
            }
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.MiddleButton) {
                handleCommand(Plasmoid.configuration.media_middle_click_command);
                return;
            }
            
            if (mouse.modifiers & Qt.ShiftModifier && Plasmoid.configuration.media_shift_click_command !== "") {
                handleCommand(Plasmoid.configuration.media_shift_click_command);
                return;
            }
            if (mouse.modifiers & Qt.AltModifier && Plasmoid.configuration.media_alt_click_command !== "") {
                handleCommand(Plasmoid.configuration.media_alt_click_command);
                return;
            }
            if (mouse.modifiers & Qt.ControlModifier && Plasmoid.configuration.media_ctrl_click_command !== "") {
                handleCommand(Plasmoid.configuration.media_ctrl_click_command);
                return;
            }
            
            handleCommand(Plasmoid.configuration.media_click_command);
        }
    }

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
        spacing: Kirigami.Units.smallSpacing

        Item {
            id: coverArtContainer
            Layout.fillHeight: true
            Layout.preferredWidth: mediaRoot.height - (Kirigami.Units.smallSpacing * 2)
            Layout.alignment: Qt.AlignVCenter
            visible: Plasmoid.configuration.mediaVisualMode !== "minimal" && Plasmoid.configuration.mediaVisualMode !== "textOnly"

            Kirigami.Icon {
                anchors.fill: parent
                source: "media-playback-start"
                visible: coverArt.status !== Image.Ready
            }

            Image {
                id: coverArt
                anchors.fill: parent
                source: mediaRoot.artUrl
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                visible: status === Image.Ready
                sourceSize: Qt.size(width, height)
                mipmap: true
            }
        }

        Kirigami.Icon {
            id: minimalIcon
            Layout.fillHeight: true
            Layout.preferredWidth: height
            Layout.alignment: Qt.AlignVCenter
            // Fallback para verificar o status se a enumeração falhar, mas geralmente 'Playing' == 0.
            source: (mediaRoot.currentPlayer && (mediaRoot.currentPlayer.playbackStatus === Mpris.PlaybackStatus.Playing || mediaRoot.currentPlayer.playbackStatus === 0)) ? "media-playback-pause" : "media-playback-start"
            visible: Plasmoid.configuration.mediaVisualMode === "minimal"
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 0
            visible: (Plasmoid.configuration.mediaVisualMode === "expanded" || Plasmoid.configuration.mediaVisualMode === "textOnly") && !root.vertical

            QQC2.Label {
                Layout.fillWidth: true
                text: mediaRoot.track ? mediaRoot.track : "Mídia"
                elide: Text.ElideRight
                maximumLineCount: 1
                font: Kirigami.Theme.smallFont
                opacity: (mediaRoot.currentPlayer && (mediaRoot.currentPlayer.playbackStatus === Mpris.PlaybackStatus.Playing || mediaRoot.currentPlayer.playbackStatus === 0)) ? 1.0 : 0.7
                Behavior on opacity { NumberAnimation { duration: Kirigami.Units.shortDuration; easing.type: Easing.InOutQuad } }
            }

            QQC2.Label {
                Layout.fillWidth: true
                text: mediaRoot.artist ? mediaRoot.artist : "Artista Desconhecido"
                elide: Text.ElideRight
                maximumLineCount: 1
                font: Kirigami.Theme.smallFont
                opacity: 0.7
                visible: mediaRoot.artist !== ""
            }
        }
    }
}
