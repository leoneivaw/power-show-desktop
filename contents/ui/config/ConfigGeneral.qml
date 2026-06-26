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
		Kirigami.FormData.label: i18n("Visual:")
		text: i18n("Use Icon instead of colors")
		checked: plasmoid.configuration.useIcon
		onToggled: {
			plasmoid.configuration.useIcon = checked;
			plasmoid.configuration.size = checked ? 30 : 8;
		}
	}

	QQC2.TextField {
		Kirigami.FormData.label: i18n("Icon:")
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
		Kirigami.FormData.label: i18n("Cor da Borda:")
		configKey: 'edgeColor'
	}

	LibConfig.ColorField {
		Kirigami.FormData.label: i18n("Cor ao Focar:")
		configKey: 'hoveredColor'
	}

	LibConfig.ColorField {
		Kirigami.FormData.label: i18n("Cor ao Clicar:")
		configKey: 'pressedColor'
	}

	LibConfig.ColorField {
		Kirigami.FormData.label: i18n("Cor ao Segurar:")
		configKey: 'longpressColor'
	}

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Click")
	}


	LibConfig.CommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Clique Normal:")
		id: click_command
	}

	LibConfig.CommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Segurar Clique:")
		id: longclick_command
	}

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Mouse Wheel")
	}

	LibConfig.SpinBox {
		Kirigami.FormData.label: i18n("Cooldown:")
		configKey: 'mousewheel_cooldown'
		suffix: i18n("ms")
		minimumValue: 0
		maximumValue: 2000
	}

	LibConfig.CommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Rolar Cima:")
		id: mousewheel_up
	}

	LibConfig.CommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Rolar Baixo:")
		id: mousewheel_down
	}

	//-------------------------------------------------------
	LibConfig.Heading {
		text: i18n("Peek")
	}

	LibConfig.CheckBox {
		Kirigami.FormData.label: i18n("Ativar ao focar:")
		text: i18n("Enable")
		configKey: 'peekingEnabled'
	}
	LibConfig.SpinBox {
		Kirigami.FormData.label: i18n("Atraso:")
		configKey: 'peekingThreshold'
		suffix: i18n("ms")
		stepSize: 50
		from: 0
	}
}
