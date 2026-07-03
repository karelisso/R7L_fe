extends Control

@onready var main_scene = preload("res://scenes/Main.tscn")
@onready var settings_menu = preload("res://scenes/settings_menu.tscn")

func _on_start_button_button_down() -> void:
	main_scene = load("res://scenes/Main.tscn")
	var instance = main_scene.instantiate()
	add_sibling(instance)
	call_deferred("queue_free")

func _on_settings_button_button_down() -> void:
	settings_menu = load("res://scenes/settings_menu.tscn")
	var instance = settings_menu.instantiate()
	instance.scene = load("res://scenes/main_menu.tscn")
	add_sibling(instance)
	call_deferred("queue_free")
