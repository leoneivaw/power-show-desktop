import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

import ".." as Widget
import "../libconfig" as LibConfig

LibConfig.FormKCM {
	id: page

	property alias cfg_enableMediaControl: enableMediaControl.checked
	property alias cfg_media_position: mediaPositionCombo.currentValue
	property alias cfg_mediaVisualMode: mediaVisualModeCombo.currentValue
	property alias cfg_mediaControlWidth: mediaControlWidth.value

	property alias cfg_media_click_command: media_click_command.text
	property alias cfg_media_middle_click_command: media_middle_click_command.text
	property alias cfg_media_ctrl_click_command: media_ctrl_click_command.text
	property alias cfg_media_shift_click_command: media_shift_click_command.text
	property alias cfg_media_alt_click_command: media_alt_click_command.text
	property alias cfg_media_scroll_up_command: media_scroll_up_command.text
	property alias cfg_media_scroll_down_command: media_scroll_down_command.text
	property alias cfg_media_mousewheel_cooldown: media_mousewheel_cooldown.value

	Widget.AppletConfig {
		id: config
	}

	LibConfig.Heading {
		text: i18n("Media Integration")
		useThickTopMargin: false
		label.Layout.topMargin: 0
	}

	LibConfig.CheckBox {
		id: enableMediaControl
		Kirigami.FormData.label: i18n("Enable:")
		text: i18n("Enable Media Control (Lazy Load)")
		configKey: 'enableMediaControl'
	}

	LibConfig.Heading {
		text: i18n("Appearance")
	}

	QQC2.ComboBox {
		id: mediaPositionCombo
		Kirigami.FormData.label: i18n("Position:")
		model: [
			{ text: i18n("Left / Top"), value: "left" },
			{ text: i18n("Right / Bottom"), value: "right" }
		]
		textRole: "text"
		valueRole: "value"
		
		Component.onCompleted: {
			for (var i = 0; i < model.length; i++) {
				if (model[i].value === plasmoid.configuration.media_position) {
					currentIndex = i;
					break;
				}
			}
		}

		onActivated: {
			page.cfg_media_position = currentValue;
		}
	}

	QQC2.ComboBox {
		id: mediaVisualModeCombo
		Kirigami.FormData.label: i18n("Visual Mode:")
		model: [
			{ text: i18n("Expanded (Cover + Title)"), value: "expanded" },
			{ text: i18n("Compact (Cover Only)"), value: "compact" },
			{ text: i18n("Minimal (Play/Pause Icon)"), value: "minimal" },
			{ text: i18n("Text Only (Title + Artist)"), value: "textOnly" }
		]
		textRole: "text"
		valueRole: "value"
		
		Component.onCompleted: {
			for (var i = 0; i < model.length; i++) {
				if (model[i].value === plasmoid.configuration.mediaVisualMode) {
					currentIndex = i;
					break;
				}
			}
		}

		onActivated: {
			plasmoid.configuration.mediaVisualMode = currentValue;
		}
	}

	LibConfig.SpinBox {
		id: mediaControlWidth
		Kirigami.FormData.label: i18n("Maximum Width:")
		configKey: 'mediaControlWidth'
		suffix: i18n("px")
		minimumValue: 50
		maximumValue: 1000
	}

	LibConfig.Heading {
		text: i18n("Media Actions")
	}

	LibConfig.MediaCommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Click Action:")
		id: media_click_command
	}

	LibConfig.MediaCommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Middle Click:")
		id: media_middle_click_command
	}

	LibConfig.MediaCommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Ctrl+Click:")
		id: media_ctrl_click_command
	}

	LibConfig.MediaCommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Shift+Click:")
		id: media_shift_click_command
	}

	LibConfig.MediaCommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Alt+Click:")
		id: media_alt_click_command
	}

	LibConfig.Heading {
		text: i18n("Mouse Wheel")
	}

	LibConfig.SpinBox {
		id: media_mousewheel_cooldown
		Kirigami.FormData.label: i18n("Scroll Cooldown:")
		configKey: 'media_mousewheel_cooldown'
		suffix: i18n("ms")
		minimumValue: 0
		maximumValue: 2000
	}

	LibConfig.MediaCommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Scroll Up:")
		id: media_scroll_up_command
	}

	LibConfig.MediaCommandFieldWithPresets {
		Kirigami.FormData.label: i18n("Scroll Down:")
		id: media_scroll_down_command
	}
}
