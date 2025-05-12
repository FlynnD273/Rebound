extends Node
class_name SettingsManager

var settings_res: SettingsResource
const SETTINGS_PATH = "user://settings.tres"

@export_range(0, 1, 0) var mouse_sensitivity: float:
	get:
		if settings_res:
			return settings_res.mouse_sensitivity
		return 0
	set(value):
		if settings_res:
			settings_res.mouse_sensitivity = value


func _enter_tree() -> void:
	load_settings()


## Loads settings from appdata, or load default settings if the file doesn't exist
func load_settings() -> void:
	settings_res = load(SETTINGS_PATH)
	if not settings_res:
		settings_res = SettingsResource.new()
		mouse_sensitivity = mouse_sensitivity
	settings_res.settings_changed.connect(save_settings)


## Saves settings to appdata
func save_settings() -> void:
	ResourceSaver.save(settings_res, SETTINGS_PATH)
