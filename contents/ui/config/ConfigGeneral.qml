import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

import ".." as Widget
import "../libconfig" as LibConfig


LibConfig.FormKCM {
	id: page

	property string cfg_click_action: 'showdesktop'
	property alias cfg_click_command: click_command.text
	property alias cfg_longclick_command: longclick_command.text

	property string cfg_mousewheel_action: 'run_commands'
	property alias cfg_mousewheel_up: mousewheel_up.text
	property alias cfg_mousewheel_down: mousewheel_down.text

	Widget.AppletConfig {
		id: config
	}

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Look")
		useThickTopMargin: false
		label.Layout.topMargin: 0
	}

	QQC2.CheckBox {
		Kirigami.FormData.label: i18n("Display:")
		text: i18n("Use Emoji/Icon instead of colors")
		checked: plasmoid.configuration.useIcon
		onToggled: {
			plasmoid.configuration.useIcon = checked;
			plasmoid.configuration.size = checked ? 30 : 8;
		}
	}

	QQC2.TextField {
		Kirigami.FormData.label: i18n("Icon / Emoji:")
		text: plasmoid.configuration.iconName
		onTextChanged: plasmoid.configuration.iconName = text
		visible: plasmoid.configuration.useIcon
	}

	LibConfig.SpinBox {
		Kirigami.FormData.label: i18n("Size:")
		configKey: 'size'
		suffix: i18n("px")
	}

	LibConfig.ColorField {
		Kirigami.FormData.label: i18n("Edge Color:")
		configKey: 'edgeColor'
	}

	LibConfig.ColorField {
		Kirigami.FormData.label: i18n("Hovered Color:")
		configKey: 'hoveredColor'
	}

	LibConfig.ColorField {
		Kirigami.FormData.label: i18n("Pressed Color:")
		configKey: 'pressedColor'
	}

	LibConfig.ColorField {
		Kirigami.FormData.label: i18n("Long Press Color:")
		configKey: 'longpressColor'
	}

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Click")
	}

	LibConfig.RadioButtonGroup {
		id: clickGroup
		spacing: 2 * Screen.devicePixelRatio
		Kirigami.FormData.isSection: true

		QQC2.RadioButton {
			text: i18nd("plasma_applet_org.kde.plasma.showdesktop", "Show Desktop")
			QQC2.ButtonGroup.group: clickGroup.group
			checked: cfg_click_action === 'showdesktop'
			onClicked: cfg_click_action = 'showdesktop'
		}
		QQC2.RadioButton {
			text: i18n("Run Command")
			QQC2.ButtonGroup.group: clickGroup.group
			checked: cfg_click_action === 'run_command'
			onClicked: cfg_click_action = 'run_command'
		}
	}

	LibConfig.CommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Click Command:")
		id: click_command
	}

	LibConfig.CommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Long Press Command:")
		id: longclick_command
	}

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Mouse Wheel")
	}

	LibConfig.CommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Scroll Up:")
		id: mousewheel_up
	}

	LibConfig.CommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Scroll Down:")
		id: mousewheel_down
	}

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Peek")
	}

	LibConfig.CheckBox {
		Kirigami.FormData.label: i18n("Show desktop on hover:")
		text: i18n("Enable")
		configKey: 'peekingEnabled'
	}
	LibConfig.SpinBox {
		Kirigami.FormData.label: i18n("Peek threshold:")
		configKey: 'peekingThreshold'
		suffix: i18n("ms")
		stepSize: 50
		from: 0
	}
}
