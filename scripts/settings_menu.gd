extends Control

@onready var scene
@onready var background: Panel = $CanvasLayer/background
@onready var volume_slider: HSlider = $CanvasLayer/BoxContainer/VolumeSlider

func _ready() -> void:
	volume_slider.grab_focus()
	background.modulate = Color(0, 0, 0, 1)
	volume_slider.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		#var instance = scene.instantiate()
		#add_sibling(instance)
		get_parent().is_settings_open = false
		get_parent()._ready()
		call_deferred("queue_free")

func _on_back_button_button_down() -> void:
	#var instance = scene.instantiate()
	#add_sibling(instance)
	get_parent().is_settings_open = false
	get_parent()._ready()
	call_deferred("queue_free")

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
