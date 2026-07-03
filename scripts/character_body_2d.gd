extends CharacterBody2D

@export var gravity_growth:float = 0.02
var gravity:float = 5.0
var speed = 150.0
var acceleration = 50
var jump_velocity = -200.0

var can_walljump = true
var walljump = true
@onready var anim = $AnimatedSprite2D
@export var snapback_length = 18 # in buffer_size mult
#multiply it by interwal to get length i second
var snapback_interwal = 10 #in frames
var snapback_counter=0
var pos_buffer:PackedVector2Array
func _init() -> void:
	gravity = 5.0
	gravity_growth = 0.01

func _process(delta: float) -> void:
	queue_redraw()
	get_tree().call_group("weighted","SetGravity",gravity)
func _physics_process(_delta):
	var direction := Input.get_axis("left", "right")
	gravity += gravity_growth
	snapback_counter+=1
	if snapback_counter > snapback_interwal:
		if pos_buffer.size() > snapback_length:
			pos_buffer.remove_at(0)
		pos_buffer.append(position)
		snapback_counter = 0
	if Input.is_action_just_pressed("load"):
		position = pos_buffer[0]
	if not is_on_floor():
		velocity.y += gravity
		if walljump and velocity.x ==0 and Input.is_action_just_pressed("jump") and abs(direction) > 0.2:
			velocity.y = jump_velocity
			walljump = false
		anim.play("spin")
	else:
		walljump = true
		if velocity.x >0.2:
			anim.play("walkrigh")
		elif velocity.x < -0.2:
			anim.play("walkleft")
		else:
			anim.play("idl")
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)

	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.id == "level_loader":
		area.call_deferred("loadlevel")
		#transition between rooms should reset gravity?
		gravity =5
		jump_velocity = -200
		area.get_parent().call_deferred("queue_free")
	elif area.id == "spring":
		gravity -= 1
		if gravity <5:
			gravity = 5
		jump_velocity -= 100
		area.get_parent().call_deferred("queue_free")
func _draw() -> void:
	if pos_buffer.size() > 1:
		draw_circle(to_local(pos_buffer[0]) ,10,Color(1,0,0,1))
