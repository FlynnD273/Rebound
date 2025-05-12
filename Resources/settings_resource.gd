extends Resource
class_name SettingsResource

signal settings_changed

@export var mouse_sensitivity: float = 0.1:
	set(value):
		mouse_sensitivity = value
		settings_changed.emit()

