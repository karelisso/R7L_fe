extends Control

@onready var main_menu = preload("res://scenes/main_menu.tscn")
@onready var settings_menu = preload("res://scenes/settings_menu.tscn")
@onready var background: Panel = $CanvasLayer/background

func _ready() -> void:
	background.modulate = Color(0, 0, 0, 0.5)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_parent().toggle_pause()
		call_deferred("queue_free")

func _on_main_menu_button_button_down() -> void:
	main_menu = load("res://scenes/main_menu.tscn")
	var instance = main_menu.instantiate()
	get_parent().add_sibling(instance)
	get_parent().call_deferred("queue_free")

func _on_settings_button_button_down() -> void:
	settings_menu = load("res://scenes/settings_menu.tscn")
	var instance = settings_menu.instantiate()
	instance.scene = load("res://scenes/pause_menu.tscn")
	add_sibling(instance)
	call_deferred("queue_free")

func _on_back_to_game_button_button_down() -> void:
	get_parent().toggle_pause()
	call_deferred("queue_free")
