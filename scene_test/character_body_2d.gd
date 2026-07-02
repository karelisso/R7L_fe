extends CharacterBody2D

@export var gravity_growth = 0.01
var gravity = 5
var speed = 200.0
var acceleration = 50
var jump_velocity = -200.0


func _physics_process(_delta):
	
	gravity += gravity_growth
	
	if not is_on_floor():
		velocity.y += gravity

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)

	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().call_deferred("queue_free")
	jump_velocity -= 100
