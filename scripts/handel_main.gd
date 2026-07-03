extends Node2D
@export var gravity:float
@onready var text:Label = $CanvasLayer/Label
@export var stages:PackedStringArray
@onready var sceneparent:Node = $CanvasLayer/SubViewportContainer/subviewport/Parent
@onready var player = $CanvasLayer/SubViewportContainer/subviewport/Character
var power:float
func _ready() -> void:
	#var some_scene = load("res://Game.tscn") # returns a PackedScene
	#var instanced_scene = some_scene.instance() # returns an instance of the scene
	#sceneparent.add_child(some_scene)
	add_to_group("manager")
	ChangeScene(0,313.125,-15.939)
func _process(delta: float) -> void:
	text.text = str(gravity) 
func ChangeScene(tooo:int,x:int,y:int):
	for n in sceneparent.get_children():
		sceneparent.remove_child(n)
		n.queue_free()
	var some_scene = load(stages[tooo]) # returns a PackedScene
	var instanced_scene = some_scene.instantiate() # returns an instance of the scene
	sceneparent.add_child(instanced_scene)
	player.position = Vector2(x,y)
	
