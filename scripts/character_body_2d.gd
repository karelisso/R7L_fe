extends CharacterBody2D

@export var gravity_growth:float = 0.02
var gravity:float = 5.0
var speed = 150.0
var acceleration = 50
var jump_velocity = -200.0

var can_walljump = true
var walljump = true
@onready var spring_sfx = $AudioStreamPlayer2
@onready var anim = $AnimatedSprite2D
@export var snapback_length = 18 # in buffer_size mult
#multiply it by interwal to get length i second
var snapback_automatic = true
var snapback_interwal = 10 #in frames
var snapback_counter=0
var pos_buffer:PackedVector2Array
func _ready() -> void:
	gravity = 5.0
	gravity_growth = 0.01
	pos_buffer.resize(snapback_length)
	pos_buffer.fill(to_global(position) )
func _process(delta: float) -> void:
	queue_redraw()
	get_tree().call_group("weighted","SetGravity",gravity)
func _physics_process(_delta):
	var direction := Input.get_axis("left", "right")
	gravity += gravity_growth
	Time
	if snapback_automatic:
		snapback_counter+=1
		if snapback_counter > snapback_interwal:
			if pos_buffer.size() > snapback_length:
				pos_buffer.remove_at(0)
			pos_buffer.append(position)
			snapback_counter = 0
		if Input.is_action_just_pressed("load"):
			position = pos_buffer[0]
	else:
		snapback_counter +=1
		if Input.is_action_just_pressed("load"):
			snapback_counter = 0
			pos_buffer.clear()
			pos_buffer.append(position)
		if snapback_counter > snapback_interwal and pos_buffer.size() <= snapback_length:
			if pos_buffer.size() == snapback_length:
				position = pos_buffer[0]
			pos_buffer.append(position)
			snapback_counter = 0	
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
		pos_buffer.clear()
		area.get_parent().call_deferred("queue_free")
	elif area.id == "spring":
		spring_sfx.play()
		gravity -= 1
		if gravity <5:
			gravity = 5
		jump_velocity -= 100
		area.get_parent().call_deferred("queue_free")
func _draw() -> void:
	if pos_buffer.size() > 0:
		if not snapback_automatic:
			if pos_buffer.size() < snapback_length -1:
				draw_circle(to_local(pos_buffer[0]) ,10,Color(1,0,0,1))
			elif not pos_buffer.size() > snapback_length:
				draw_circle(to_local(pos_buffer[0]) ,10,Color(0,1,0,1))
		else:
			draw_circle(to_local(pos_buffer[0]) ,10,Color(1,0,0,1))
