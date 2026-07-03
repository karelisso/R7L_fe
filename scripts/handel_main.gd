extends Node2D
@export var gravity:float
@onready var text:Label = $CanvasLayer/Label
@export var stages:PackedStringArray
@onready var sceneparent:Node = $CanvasLayer/SubViewportContainer/subviewport/Parent
@onready var player = $CanvasLayer/SubViewportContainer/subviewport/Character

var is_paused = false

func _ready() -> void:
	#var some_scene = load("res://Game.tscn") # returns a PackedScene
	#var instanced_scene = some_scene.instance() # returns an instance of the scene
	#sceneparent.add_child(some_scene)
	add_to_group("manager")
	ChangeScene(0,313.125,-15.939)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not is_paused:
			var pause_menu = load("res://scenes/pause_menu.tscn")
			var instanced_scene = pause_menu.instantiate()
			add_child(instanced_scene)
			pause()
	
	text.text = str(gravity) 
	if Input.is_action_just_pressed("load"):
		ChangeScene(0,313.125,-15.939)

func ChangeScene(tooo:int,x:int,y:int):
	for n in sceneparent.get_children():
		sceneparent.remove_child(n)
		n.queue_free()
	var some_scene = load(stages[tooo]) # returns a PackedScene
	var instanced_scene = some_scene.instantiate() # returns an instance of the scene
	sceneparent.add_child(instanced_scene)
	player.position = Vector2(x,y)

func pause():
	if is_paused:
		is_paused = false
	elif not is_paused:
		is_paused = true
	print(is_paused)
