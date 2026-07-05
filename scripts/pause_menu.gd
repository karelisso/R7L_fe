extends Control

@onready var main_menu = preload("res://scenes/main_menu.tscn")
@onready var settings_menu = preload("res://scenes/settings_menu.tscn")
@onready var background: Panel = $CanvasLayer/background
@onready var back_button: TextureButton = $CanvasLayer/BoxContainer/BackButton
@onready var focus_goblin: TextureButton = $CanvasLayer/BoxContainer/FocusGoblin
var is_mouse_focus = false

func _ready() -> void:
	back_button.grab_focus()
	background.modulate = Color(0, 0, 0, 0.5)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		get_parent().toggle_pause()
		call_deferred("queue_free")
	if is_mouse_focus:
		focus_goblin.grab_focus()

func _on_main_menu_button_button_down() -> void:
	main_menu = load("res://scenes/main_menu.tscn")
	var instance = main_menu.instantiate()
	get_parent().add_sibling(instance)
	get_parent().call_deferred("queue_free")

func _on_settings_button_button_down() -> void:
	is_mouse_focus = false
	settings_menu = load("res://scenes/settings_menu.tscn")
	var instance = settings_menu.instantiate()
	add_child(instance)
	#instance.scene = load("res://scenes/pause_menu.tscn")
	#call_deferred("queue_free")

func _on_back_to_game_button_button_down() -> void:
	get_parent().toggle_pause()
	call_deferred("queue_free")

func _on_button_mouse_entered() -> void:
	is_mouse_focus = true

func _on_button_mouse_exited() -> void:
	is_mouse_focus = false
