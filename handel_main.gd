extends Node2D
@export var gravity:float
@onready var text:Label = $CanvasLayer/Label
@export var stages:PackedStringArray
@onready var sceneparent:Node = $CanvasLayer/SubViewportContainer/subviewport/Parent
func _ready() -> void:
	#var some_scene = load("res://Game.tscn") # returns a PackedScene
	#var instanced_scene = some_scene.instance() # returns an instance of the scene
	#sceneparent.add_child(some_scene)
	ChangeScene(0)
func _process(delta: float) -> void:
	text.text = str(gravity) 
	if Input.is_action_just_pressed("load"):
		ChangeScene(0)

func ChangeScene(tooo:int):
	#for n in sceneparent.get_children():
	#	sceneparent.remove_child(n)
	#	n.queue_free()
	var some_scene = load(stages[0]) # returns a PackedScene
	var instanced_scene = some_scene.instantiate() # returns an instance of the scene
	sceneparent.add_child(instanced_scene)

	
