extends CharacterBody2D

@onready var mesh = $MeshInstance2D

var offset: Vector2
var timer = 0
@export var wobble_strength = 1
@export var wobble_speed = 3

func _physics_process(delta: float) -> void:
	if not get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().is_paused:
		timer += delta * wobble_speed
		if timer > 360:
			timer -= 360
		offset = Vector2(0, sin(timer) * wobble_strength)
		mesh.position = offset
