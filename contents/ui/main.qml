/*
	SPDX-FileCopyrightText: 2014 Ashish Madeti <ashishmadeti@gmail.com>
	SPDX-FileCopyrightText: 2016 Kai Uwe Broulik <kde@privat.broulik.de>
	SPDX-FileCopyrightText: 2019 Chris Holland <zrenfire@gmail.com>
	SPDX-FileCopyrightText: 2022 ivan (@ratijas) tkachenko <me@ratijas.tk>

	SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.3

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg

import org.kde.plasma.plasmoid

PlasmoidItem {
	id: root

	preferredRepresentation: fullRepresentation
	toolTipSubText: activeController.description

	AppletConfig {
		id: config
	}

	Plasmoid.icon: "transform-move"
	Plasmoid.title: activeController.title
	Plasmoid.onActivated: {
		if (isPeeking) {
			isPeeking = false;
			peekController.toggle();
		}
		activeController.toggle();
	}

	Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

	property int mediaExtraSize: {
		if (mediaLoader.active && mediaLoader.item && mediaLoader.item.hasActiveMedia) {
			if (Plasmoid.configuration.mediaVisualMode === "expanded" || Plasmoid.configuration.mediaVisualMode === "textOnly") {
				return root.vertical ? Plasmoid.configuration.mediaControlWidth : Math.min(mediaLoader.item.implicitWidth, Plasmoid.configuration.mediaControlWidth);
			} else if (Plasmoid.configuration.mediaVisualMode === "minimal") {
				return vertical ? Math.max(16, root.width * 0.7) : (Math.max(16, root.height * 0.7) + (Kirigami.Units.smallSpacing * 2));
			} else {
				return vertical ? Math.max(22, root.width) : Math.max(22, root.height);
			}
		}
		return 0;
	}

	Layout.minimumWidth: vertical ? Kirigami.Units.iconSizes.medium : (Math.max(1, Plasmoid.configuration.size) + mediaExtraSize)
	Layout.minimumHeight: vertical ? (Math.max(1, Plasmoid.configuration.size) + mediaExtraSize) : Kirigami.Units.iconSizes.medium

	Layout.maximumWidth: vertical ? -1 : (Math.max(1, Plasmoid.configuration.size) + mediaExtraSize)
	Layout.maximumHeight: vertical ? (Math.max(1, Plasmoid.configuration.size) + mediaExtraSize) : -1

	Layout.preferredWidth: vertical ? -1 : (Math.max(1, Plasmoid.configuration.size) + mediaExtraSize)
	Layout.preferredHeight: vertical ? (Math.max(1, Plasmoid.configuration.size) + mediaExtraSize) : (parent ? parent.height : -1)

	Behavior on Layout.minimumWidth { NumberAnimation { duration: Kirigami.Units.shortDuration; easing.type: Easing.InOutQuad } }
	Behavior on Layout.minimumHeight { NumberAnimation { duration: Kirigami.Units.shortDuration; easing.type: Easing.InOutQuad } }
	Behavior on Layout.maximumWidth { NumberAnimation { duration: Kirigami.Units.shortDuration; easing.type: Easing.InOutQuad } }
	Behavior on Layout.maximumHeight { NumberAnimation { duration: Kirigami.Units.shortDuration; easing.type: Easing.InOutQuad } }
	Behavior on Layout.preferredWidth { NumberAnimation { duration: Kirigami.Units.shortDuration; easing.type: Easing.InOutQuad } }
	Behavior on Layout.preferredHeight { NumberAnimation { duration: Kirigami.Units.shortDuration; easing.type: Easing.InOutQuad } }

	Plasmoid.constraintHints: Plasmoid.CanFillArea

	readonly property bool inPanel: [PlasmaCore.Types.TopEdge, PlasmaCore.Types.RightEdge, PlasmaCore.Types.BottomEdge, PlasmaCore.Types.LeftEdge]
			.includes(Plasmoid.location)

	readonly property bool vertical: Plasmoid.location === PlasmaCore.Types.RightEdge || Plasmoid.location === PlasmaCore.Types.LeftEdge

	readonly property Controller primaryController: {
		if (Plasmoid.configuration.click_action == "minimizeall") {
			return minimizeAllController;
		} else if (Plasmoid.configuration.click_action == "showdesktop") {
			return peekController;
		} else {
			return commandController;
		}
	}

	readonly property Controller activeController: {
		if (minimizeAllController.active) {
			return minimizeAllController;
		} else {
			return primaryController;
		}
	}

	property bool isPeeking: false

	GridLayout {
		id: mainLayout
		anchors.fill: parent
		columns: root.vertical ? 1 : 2
		rows: root.vertical ? 2 : 1
		rowSpacing: 0
		columnSpacing: 0

		MouseArea {
			id: mouseArea
			Layout.column: root.vertical ? 0 : ((Plasmoid.configuration.media_position === "left" || Plasmoid.configuration.media_position === "") ? 1 : 0)
			Layout.row: root.vertical ? ((Plasmoid.configuration.media_position === "left" || Plasmoid.configuration.media_position === "") ? 1 : 0) : 0
			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.minimumWidth: root.vertical ? 1 : Math.max(1, Plasmoid.configuration.size)
			Layout.minimumHeight: root.vertical ? Math.max(1, Plasmoid.configuration.size) : 1
			Layout.preferredWidth: root.vertical ? -1 : Math.max(1, Plasmoid.configuration.size)
			Layout.preferredHeight: root.vertical ? Math.max(1, Plasmoid.configuration.size) : -1

		acceptedButtons: Qt.LeftButton | Qt.MiddleButton
		activeFocusOnTab: true
		hoverEnabled: true

		property bool isLongPressed: false
		property bool preventClick: false

		onPressAndHold: (mouse) => {
			if (mouse.button === Qt.LeftButton) {
				isLongPressed = true;
				preventClick = true;
				if (Plasmoid.configuration.longclick_command !== "") {
					root.exec(Plasmoid.configuration.longclick_command);
				}
			}
		}

		onReleased: {
			isLongPressed = false;
		}

		onCanceled: {
			isLongPressed = false;
			preventClick = false;
		}

		onClicked: (mouse) => {
			if (preventClick) {
				preventClick = false;
				return;
			}
			if (mouse.button === Qt.MiddleButton) {
				if (Plasmoid.configuration.middle_click_command !== "") {
					root.exec(Plasmoid.configuration.middle_click_command);
				}
				return;
			}
			
			if (mouse.modifiers & Qt.ShiftModifier && Plasmoid.configuration.shift_click_command !== "") {
				root.exec(Plasmoid.configuration.shift_click_command);
				return;
			}
			if (mouse.modifiers & Qt.AltModifier && Plasmoid.configuration.alt_click_command !== "") {
				root.exec(Plasmoid.configuration.alt_click_command);
				return;
			}
			if (mouse.modifiers & Qt.ControlModifier && Plasmoid.configuration.ctrl_click_command !== "") {
				root.exec(Plasmoid.configuration.ctrl_click_command);
				return;
			}
			
			Plasmoid.activated();
		}

		onEntered: {
			if (Plasmoid.configuration.peekingEnabled)
				peekTimer.start();
		}
		onExited: {
			peekTimer.stop();
			if (isPeeking) {
				isPeeking = false;
				peekController.toggle();
			}
		}

		// org.kde.plasma.volume
		property int wheelDelta: 0
		property real lastCtrlWheelTime: 0
		property real lastWheelTime: 0
		onWheel: wheel => {
			const delta = (wheel.inverted ? -1 : 1) * (wheel.angleDelta.y ? wheel.angleDelta.y : -wheel.angleDelta.x);
			wheelDelta += delta;
			// Magic number 120 for common "one click"
			// See: https://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
			while (wheelDelta >= 120) {
				wheelDelta -= 120;
				if (wheel.modifiers & Qt.ControlModifier && Plasmoid.configuration.ctrl_mousewheel_up !== "") {
					let now = Date.now();
					if (now - lastCtrlWheelTime > Plasmoid.configuration.ctrl_mousewheel_cooldown) {
						lastCtrlWheelTime = now;
						root.exec(Plasmoid.configuration.ctrl_mousewheel_up);
					}
				} else {
					let now = Date.now();
					if (now - lastWheelTime > Plasmoid.configuration.mousewheel_cooldown) {
						lastWheelTime = now;
						performMouseWheelUp();
					}
				}
			}
			while (wheelDelta <= -120) {
				wheelDelta += 120;
				if (wheel.modifiers & Qt.ControlModifier && Plasmoid.configuration.ctrl_mousewheel_down !== "") {
					let now = Date.now();
					if (now - lastCtrlWheelTime > Plasmoid.configuration.ctrl_mousewheel_cooldown) {
						lastCtrlWheelTime = now;
						root.exec(Plasmoid.configuration.ctrl_mousewheel_down);
					}
				} else {
					let now = Date.now();
					if (now - lastWheelTime > Plasmoid.configuration.mousewheel_cooldown) {
						lastWheelTime = now;
						performMouseWheelDown();
					}
				}
			}
		}

		Keys.onPressed: {
			switch (event.key) {
			case Qt.Key_Space:
			case Qt.Key_Enter:
			case Qt.Key_Return:
			case Qt.Key_Select:
				Plasmoid.activated();
				break;
			}
		}

		Accessible.name: Plasmoid.title
		Accessible.description: toolTipSubText
		Accessible.role: Accessible.Button

		PeekController {
			id: peekController
		}

		MinimizeAllController {
			id: minimizeAllController
		}

		CommandController {
			id: commandController
		}

		Kirigami.Icon {
			anchors.fill: parent
			active: mouseArea.containsMouse || activeController.active
			visible: Plasmoid.containment.corona.editMode
			source: Plasmoid.icon
		}

		// also activate when dragging an item over the plasmoid so a user can easily drag data to the desktop
		DropArea {
			anchors.fill: parent
			onEntered: activateTimer.start()
			onExited: activateTimer.stop()
		}

		Timer {
			id: activateTimer
			interval: 250 // to match TaskManager
			onTriggered: Plasmoid.activated()
		}

		Timer {
			id: peekTimer
			interval: Plasmoid.configuration.peekingThreshold
			onTriggered: {
				if (!minimizeAllController.active && !peekController.active) {
					isPeeking = true;
					peekController.toggle();
				}
			}
		}

		state: {
			if (mouseArea.containsPress) {
				return "pressed";
			} else if (mouseArea.containsMouse || mouseArea.activeFocus) {
				return "hover";
			} else {
				return "normal";
			}
		}

		component ButtonSurface : Rectangle {
			property var containerMargins: {
				let item = this;
				while (item.parent) {
					item = item.parent;
					if (item.isAppletContainer) {
						return item.getMargins;
					}
				}
				return undefined;
			}

			anchors {
				fill: parent
				property bool returnAllMargins: true
				// The above makes sure margin is returned even for side margins
				// that would be otherwise turned off.
				topMargin: !vertical && containerMargins ? -containerMargins('top', returnAllMargins) : 0
				leftMargin: vertical && containerMargins ? -containerMargins('left', returnAllMargins) : 0
				rightMargin: vertical && containerMargins ? -containerMargins('right', returnAllMargins) : 0
				bottomMargin: !vertical && containerMargins ? -containerMargins('bottom', returnAllMargins) : 0
			}
			Behavior on opacity { OpacityAnimator { duration: Kirigami.Units.longDuration; easing.type: Easing.OutCubic } }
		}

		ButtonSurface {
			id: hoverSurface
			color: Plasmoid.configuration.hoveredColor
			opacity: (!Plasmoid.configuration.useIcon && mouseArea.state === "hover") ? 1 : 0
		}

		ButtonSurface {
			id: pressedSurface
			color: Plasmoid.configuration.pressedColor
			opacity: (!Plasmoid.configuration.useIcon && mouseArea.state === "pressed") ? 1 : 0
		}

		ButtonSurface {
			id: longPressedSurface
			color: Plasmoid.configuration.longpressColor
			opacity: (!Plasmoid.configuration.useIcon && mouseArea.isLongPressed) ? 1 : 0
		}

		ButtonSurface {
			id: edgeLine
			color: "transparent"
			border.color: Plasmoid.configuration.edgeColor
			border.width: 1
			opacity: (!Plasmoid.configuration.useIcon) ? 1 : 0
		}

		Text {
			anchors.fill: parent
			text: Plasmoid.configuration.iconName
			visible: Plasmoid.configuration.useIcon
			opacity: mouseArea.state === "pressed" ? 0.7 : 1.0
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			font.pixelSize: Math.min(parent.width, parent.height) * 0.8
		}

		// Active/not active indicator
		KSvg.FrameSvgItem {
			property var containerMargins: {
				let item = this;
				while (item.parent) {
					item = item.parent;
					if (item.isAppletContainer) {
						return item.getMargins;
					}
				}
				return undefined;
			}

			anchors {
				fill: parent
				property bool returnAllMargins: true
				// The above makes sure margin is returned even for side margins
				// that would be otherwise turned off.
				topMargin: !vertical && containerMargins ? -containerMargins('top', returnAllMargins) : 0
				leftMargin: vertical && containerMargins ? -containerMargins('left', returnAllMargins) : 0
				rightMargin: vertical && containerMargins ? -containerMargins('right', returnAllMargins) : 0
				bottomMargin: !vertical && containerMargins ? -containerMargins('bottom', returnAllMargins) : 0
			}
			imagePath: "widgets/tabbar"
			visible: opacity > 0
			prefix: {
				let prefix;
				switch (Plasmoid.location) {
				case PlasmaCore.Types.LeftEdge:
					prefix = "west-active-tab";
					break;
				case PlasmaCore.Types.TopEdge:
					prefix = "north-active-tab";
					break;
				case PlasmaCore.Types.RightEdge:
					prefix = "east-active-tab";
					break;
				default:
					prefix = "south-active-tab";
				}
				if (!hasElementPrefix(prefix)) {
					prefix = "active-tab";
				}
				return prefix;
			}
			opacity: activeController.active ? 1 : 0

			Behavior on opacity {
				NumberAnimation {
					duration: Kirigami.Units.shortDuration
					easing.type: Easing.InOutQuad
				}
			}
		}

		PlasmaCore.ToolTipArea {
			id: toolTip
			anchors.fill: parent
			mainText: Plasmoid.title
			subText: toolTipSubText
			textFormat: Text.PlainText
		}
	}

	Loader {
		id: mediaLoader
		active: Plasmoid.configuration.enableMediaControl
		source: "MediaBlock.qml"
		Layout.column: root.vertical ? 0 : ((Plasmoid.configuration.media_position === "left" || Plasmoid.configuration.media_position === "") ? 0 : 1)
		Layout.row: root.vertical ? ((Plasmoid.configuration.media_position === "left" || Plasmoid.configuration.media_position === "") ? 0 : 1) : 0
		Layout.preferredWidth: root.vertical ? -1 : root.mediaExtraSize
		Layout.preferredHeight: root.vertical ? root.mediaExtraSize : -1
		Layout.fillWidth: root.vertical ? true : false
		Layout.fillHeight: root.vertical ? false : true
		visible: active && item && item.hasActiveMedia

		Connections {
			target: mediaLoader.item
			ignoreUnknownSignals: true
			function onExecuteCommand(cmd) {
				root.exec(cmd);
			}
		}
	}
	}

	// https://invent.kde.org/plasma/plasma5support/-/tree/master/src/declarativeimports/datasource.h
	Plasma5Support.DataSource {
		id: executeSource
		engine: "executable"
		connectedSources: []

		property var listeners: ({}) // Empty Map

		signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)

		function getUniqueId(cmd) {
			// Note: we assume that 'cmd' is executed quickly so that a previous call
			// with the same 'cmd' has already finished (otherwise no new cmd will be
			// added because it is already in the list)
			// Workaround: We append spaces onto the user's command to workaround this.
			var cmd2 = cmd
			for (var i = 0; i < 10; i++) {
				if (connectedSources.includes(cmd2)) {
					cmd2 += ' '
				}
			}
			return cmd2
		}
		function exec(cmd, callback) {
			const cmdId = getUniqueId(cmd)
			if (typeof callback === 'function') {
				if (listeners[cmdId]) {
					exited.disconnect(listeners[cmdId])
					delete listeners[cmdId]
				}
				var listener = execCallback.bind(executeSource, callback)
				listeners[cmdId] = listener
			}
			connectSource(cmdId)
		}
		function execCallback(callback, cmd, exitCode, exitStatus, stdout, stderr) {
			delete listeners[cmd]
			callback(cmd, exitCode, exitStatus, stdout, stderr)
		}
		onNewData: function(sourceName, data) {
			const cmd = sourceName
			const exitCode = data["exit code"]
			const exitStatus = data["exit status"]
			const stdout = data["stdout"]
			const stderr = data["stderr"]
			const listener = listeners[cmd]
			if (listener) {
				listener(cmd, exitCode, exitStatus, stdout, stderr)
			}
			exited(cmd, exitCode, exitStatus, stdout, stderr)
			disconnectSource(sourceName) // cmd finished
		}
	}

	function exec(cmd) {
		let cmd2 = executeSource.getUniqueId(cmd)
		if (config.isOpenSUSE) {
			cmd2 = cmd2.replace(/^qdbus /, 'qdbus6 ')
		}
		executeSource.connectSource(cmd2)
	}

	function performMouseWheelUp() {
		root.exec(Plasmoid.configuration.mousewheel_up)
	}

	function performMouseWheelDown() {
		root.exec(Plasmoid.configuration.mousewheel_down)
	}

	Plasmoid.contextualActions: [
		PlasmaCore.Action {
			visible: Plasmoid.immutability != PlasmaCore.Types.SystemImmutable
			readonly property bool isLocked: Plasmoid.immutability != PlasmaCore.Types.Mutable
			text: isLocked ? i18n("Unlock Widgets") : i18n("Lock Widgets")
			icon.name: isLocked ? "object-unlocked" : "object-locked"
			onTriggered: {
				if (Plasmoid.immutability == PlasmaCore.Types.Mutable) {
					Plasmoid.containment.corona.setImmutability(PlasmaCore.Types.UserImmutable)
				} else if (Plasmoid.immutability == PlasmaCore.Types.UserImmutable) {
					Plasmoid.containment.corona.setImmutability(PlasmaCore.Types.Mutable)
				} else {
					// ignore SystemImmutable
				}
			}
		},
		PlasmaCore.Action {
			text: minimizeAllController.titleInactive
			checkable: true
			checked: minimizeAllController.active
			toolTip: minimizeAllController.description
			enabled: !peekController.active
			onTriggered: minimizeAllController.toggle()
		},
		PlasmaCore.Action {
			text: peekController.titleInactive
			checkable: true
			checked: peekController.active
			toolTip: peekController.description
			enabled: !minimizeAllController.active
			onTriggered: peekController.toggle()
		}
	]

	function detectSUSE() {
		executeSource.exec('env | grep VENDOR', function(cmd, exitCode, exitStatus, stdout, stderr) {
			if (stdout.replace(/\n/g, ' ').trim() == 'VENDOR=suse') {
				config.isOpenSUSE = true
			}
			// console.log('config.isOpenSUSE', config.isOpenSUSE)
		})
	}

	Component.onCompleted: {
		detectSUSE()
	}
}
