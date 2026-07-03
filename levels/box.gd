extends CharacterBody2D
var gravity: float
@export var id = "box"
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity
	velocity.x = move_toward(velocity.x,0,10)
	move_and_slide()
func SetGravity(f:float):
	gravity = f
