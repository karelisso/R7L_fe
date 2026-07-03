extends CharacterBody2D
var gravity: float
@export var id = "box"
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity
	move_and_slide()
func SetGravity(f:float):
	gravity = f
