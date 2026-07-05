extends Control

@onready var scene
@onready var background: Panel = $CanvasLayer/background
@onready var volume_slider: HSlider = $CanvasLayer/BoxContainer/VolumeSlider

func _ready() -> void:
	background.modulate = Color(0, 0, 0, 1)
	volume_slider.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		#var instance = scene.instantiate()
		#add_sibling(instance)
		call_deferred("queue_free")

func _on_back_button_button_down() -> void:
	call_deferred("queue_free")
	#var instance = scene.instantiate()
	#add_sibling(instance)

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
