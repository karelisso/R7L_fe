extends Node2D

@onready var main_menu = preload("res://scenes/main_menu.tscn")

func death():
	main_menu = load("res://scenes/main_menu.tscn")
	var instance = main_menu.instantiate()
	get_parent().get_parent().get_parent().get_parent().get_parent().add_sibling(instance)
	get_parent().get_parent().get_parent().get_parent().get_parent().call_deferred("queue_free")
