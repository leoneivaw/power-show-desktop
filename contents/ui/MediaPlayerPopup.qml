import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.private.mpris as Mpris

PlasmaCore.Dialog {
    id: rootDialog
    location: PlasmaCore.Types.Floating
    type: PlasmaCore.Dialog.AppletPopup
    hideOnWindowDeactivate: true
    
    property var mprisModel: null
    property var currentPlayer: mprisModel ? mprisModel.currentPlayer : null

    mainItem: Item {
        implicitWidth: Kirigami.Units.gridUnit * 18
        implicitHeight: layout.implicitHeight + (Kirigami.Units.largeSpacing * 2)

        ColumnLayout {
            id: layout
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.smallSpacing

            // TabBar para seleção do player
            QQC2.TabBar {
                id: playerTabBar
                Layout.fillWidth: true
                visible: playerRepeater.count > 1
                
                Repeater {
                    id: playerRepeater
                    model: rootDialog.mprisModel
                    delegate: QQC2.TabButton {
                        width: Math.max(implicitWidth, playerTabBar.width / Math.max(1, playerRepeater.count))
                        display: QQC2.AbstractButton.IconOnly
                        icon.name: index === 0 ? "rating" : "audio-x-generic"
                        icon.width: Kirigami.Units.iconSizes.smallMedium
                        icon.height: Kirigami.Units.iconSizes.smallMedium
                        
                        onClicked: {
                            if (rootDialog.mprisModel) {
                                rootDialog.mprisModel.currentIndex = index;
                            }
                        }
                    }
                }

                // Sincroniza a aba ativa com o currentIndex do modelo
                currentIndex: rootDialog.mprisModel ? rootDialog.mprisModel.currentIndex : 0
            }

            // Capa do Álbum
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: width
                Layout.topMargin: Kirigami.Units.smallSpacing
                Layout.bottomMargin: Kirigami.Units.smallSpacing

                Kirigami.Icon {
                    anchors.fill: parent
                    source: "media-optical-audio"
                    visible: coverArt.status !== Image.Ready
                    opacity: 0.2
                }

                Image {
                    id: coverArt
                    anchors.fill: parent
                    source: rootDialog.currentPlayer ? rootDialog.currentPlayer.artUrl : ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: status === Image.Ready
                    mipmap: true
                }
            }

            // Track e Artista
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                QQC2.Label {
                    Layout.fillWidth: true
                    text: rootDialog.currentPlayer && rootDialog.currentPlayer.track ? rootDialog.currentPlayer.track : "Mídia Desconhecida"
                    font.family: Kirigami.Theme.defaultFont.family
                    font.weight: Font.Bold
                    font.pixelSize: Math.round(Kirigami.Theme.defaultFont.pixelSize * 1.2)
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                }

                QQC2.Label {
                    Layout.fillWidth: true
                    text: rootDialog.currentPlayer && rootDialog.currentPlayer.artist ? rootDialog.currentPlayer.artist : "Artista Desconhecido"
                    font: Kirigami.Theme.smallFont
                    opacity: 0.7
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    visible: text !== "Artista Desconhecido"
                }
            }

            // Controles de Reprodução
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.largeSpacing

                QQC2.RoundButton {
                    icon.name: "media-skip-backward"
                    onClicked: {
                        if (rootDialog.currentPlayer) {
                            if (typeof rootDialog.currentPlayer.Previous === "function") rootDialog.currentPlayer.Previous();
                            else if (typeof rootDialog.currentPlayer.previous === "function") rootDialog.currentPlayer.previous();
                        }
                    }
                }

                QQC2.RoundButton {
                    property bool isPlaying: rootDialog.currentPlayer && (rootDialog.currentPlayer.playbackStatus === Mpris.PlaybackStatus.Playing || rootDialog.currentPlayer.playbackStatus === 0)
                    icon.name: isPlaying ? "media-playback-pause" : "media-playback-start"
                    
                    Layout.preferredWidth: implicitWidth * 1.2
                    Layout.preferredHeight: implicitHeight * 1.2
                    icon.width: Kirigami.Units.iconSizes.medium
                    icon.height: Kirigami.Units.iconSizes.medium
                    
                    onClicked: {
                        if (rootDialog.currentPlayer) {
                            if (typeof rootDialog.currentPlayer.PlayPause === "function") rootDialog.currentPlayer.PlayPause();
                            else if (typeof rootDialog.currentPlayer.playPause === "function") rootDialog.currentPlayer.playPause();
                        }
                    }
                }

                QQC2.RoundButton {
                    icon.name: "media-skip-forward"
                    onClicked: {
                        if (rootDialog.currentPlayer) {
                            if (typeof rootDialog.currentPlayer.Next === "function") rootDialog.currentPlayer.Next();
                            else if (typeof rootDialog.currentPlayer.next === "function") rootDialog.currentPlayer.next();
                        }
                    }
                }
            }
        }
    }
}
