extends CharacterBody2D

var gravity_growth:float = 0.01
var gravity:float = 5.0
var SPEED = 150.0
var JUMP_VELOCITY = -200.0
@onready var anim = $AnimatedSprite2D

func _init() -> void:
	gravity = 5.0
	gravity_growth = 0.01

func _physics_process(_delta):
	
	gravity += gravity_growth
	
	if not is_on_floor():
		velocity.y += gravity
		anim.play("spin")
	else:
		if velocity.x >0.2:
			anim.play("walkrigh")
		elif velocity.x < -0.2:
			anim.play("walkleft")
		else:
			anim.play("idl")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().call_deferred("queue_free")
	JUMP_VELOCITY -= 100
