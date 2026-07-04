extends Node2D
@export var gravity:float
@export var spawn:Vector2
@onready var text:Label = $CanvasLayer/Label
@export var stages:PackedStringArray
@onready var sceneparent:Node = $CanvasLayer/SubViewportContainer/subviewport/Parent
@onready var player = $CanvasLayer/SubViewportContainer/subviewport/Character
@onready var player_anim_sprite = $CanvasLayer/SubViewportContainer/subviewport/Character/AnimatedSprite2D
@onready var gui = $CanvasLayer
var current_level: int
var power:float
var scene_loaded = false
var is_paused = false

func _ready() -> void:
	#var some_scene = load("res://Game.tscn") # returns a PackedScene
	#var instanced_scene = some_scene.instance() # returns an instance of the scene
	#sceneparent.add_child(some_scene)
	add_to_group("manager")
	if current_level:
		ChangeScene(current_level, spawn)
	else:
		ChangeScene(0,spawn)
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not is_paused:
			var pause_menu = load("res://scenes/pause_menu.tscn")
			var instanced_scene = pause_menu.instantiate()
			add_child(instanced_scene)
			toggle_pause()
	text.text = str(gravity)

func ChangeScene(tooo:int,_pos:Vector2):
	for n in sceneparent.get_children():
		sceneparent.remove_child(n)
		n.queue_free()
	current_level = tooo
	var some_scene = load(stages[tooo]) # returns a PackedScene
	var instanced_scene = some_scene.instantiate() # returns an instance of the scene
	sceneparent.add_child(instanced_scene)
	scene_loaded = false
	#player.position = pos
	for child in get_children():
		if child is Label:
			child.reparent(self.get_child(0),true)

func SetGravity(f:float):
	#if not scene_loaded:
		#for child in find_children("*", "Label", true, false):
			#if child is Label:
				#var next:RemoteTransform2D = RemoteTransform2D.new()
				#child.add_sibling(next)	
				#child.reparent(self.get_child(0),true)	
				#next.remote_path = child.get_path()
	scene_loaded = true

	gravity = f
func toggle_pause():
	if not is_paused:
		is_paused = true
		player.process_mode = Node.PROCESS_MODE_DISABLED
		sceneparent.process_mode =Node.PROCESS_MODE_DISABLED
		#player_anim_sprite.speed_scale = 0
		#player.set_process(false)
		#player.set_physics_process(false)
	else:
		is_paused = false
		player.process_mode = Node.PROCESS_MODE_INHERIT
		sceneparent.process_mode =Node.PROCESS_MODE_INHERIT
		#player_anim_sprite.speed_scale = 1
		#player.set_process(true)
		#player.set_physics_process(true)
