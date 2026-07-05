extends Control

@onready var main_scene = preload("res://scenes/Main.tscn")
@onready var settings_menu = preload("res://scenes/settings_menu.tscn")
@onready var start_button: TextureButton = $BoxContainer/StartButton

func _ready() -> void:
	start_button.grab_focus()

func _on_start_button_button_down() -> void:
	main_scene = load("res://scenes/Main.tscn")
	var instance = main_scene.instantiate()
	add_sibling(instance)
	call_deferred("queue_free")

func _on_settings_button_button_down() -> void:
	settings_menu = load("res://scenes/settings_menu.tscn")
	var instance = settings_menu.instantiate()
	add_child(instance)
	#instance.scene = load("res://scenes/main_menu.tscn")
	#call_deferred("queue_free")

func _on_exit_button_button_down() -> void:
	get_tree().quit()
