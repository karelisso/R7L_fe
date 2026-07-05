extends Node2D
func _ready() -> void:
	get_parent().get_parent().get_child(0).queue_free()
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset") or Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("jump"):
		var main_menu = load("res://scenes/main_menu.tscn")
		var instance = main_menu.instantiate()
		get_tree().get_root().add_child(instance)
		get_tree().get_root().get_child(0).call_deferred("queue_free")
