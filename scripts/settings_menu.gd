extends Control

@onready var main_menu = preload("res://scenes/main_menu.tscn")

func _on_button_button_down() -> void:
	main_menu = load("res://scenes/main_menu.tscn")
	var instance = main_menu.instantiate()
	add_sibling(instance)
	call_deferred("queue_free")
