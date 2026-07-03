extends Control

@onready var scene
@onready var background: Panel = $CanvasLayer/background

func _ready() -> void:
	background.modulate = Color(0, 0, 0, 0.5)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		var instance = scene.instantiate()
		add_sibling(instance)
		call_deferred("queue_free")

func _on_back_button_button_down() -> void:
	var instance = scene.instantiate()
	add_sibling(instance)
	call_deferred("queue_free")
