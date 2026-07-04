extends CharacterBody2D

@export var gravity_growth:float = 0.05
var gravity:float = 5.0
var total_gravity # jump_velocity is beleszámít
@export var base_speed = 150.0
var speed = base_speed
var acceleration = 50
var jump_velocity = -200.0

var can_walljump = true
var walljump = true
@onready var spring_sfx = $AudioStreamPlayer2
@onready var anim = $AnimatedSprite2D
@export var snapback_length = 60 # in buffer_size mult
#multiply it by interwal to get length i second
@export var snapback_automatic = true
var snapback_interwal = 2 #in frames
var snapback_counter=0
var id = "player"
var pos_buffer:PackedVector2Array
var death = false
@onready var carried:CharacterBody2D
func _ready() -> void:

	gravity = 5.0
	gravity_growth = 0.01
	if snapback_automatic:
		pos_buffer.resize(snapback_length)
	else:
		pos_buffer.resize(snapback_length+2)
	pos_buffer.fill(to_global(position) )
func _process(delta: float) -> void:
	queue_redraw()
	get_tree().call_group("weighted","SetGravity",gravity)
func _physics_process(_delta):
	var direction := Input.get_axis("left", "right")
	gravity += gravity_growth
	if carried != null:
		carried.global_position = global_position +Vector2(0,-20) 
		carried.velocity = Vector2.ZERO
		if not Input.is_action_pressed("pick"):
			carried.set_collision_layer_value(2,true)
			if direction == 0:
				carried.velocity += Vector2(0,-150)
			else:
				carried.velocity += Vector2(300*direction,-50)
			carried = null
	
	total_gravity = ((gravity - 5) / abs(jump_velocity / 2)) * 10 #jump_velocity is half effective, multiplied by 10 to apply to scale easily
	if total_gravity >= 2:
		die()
	if total_gravity >= 1: #gradual effects here
		scale.y = 1 - (total_gravity - 1) / 2
		speed  = base_speed - (total_gravity - 1) * 100
	
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
		#if walljump and velocity.x ==0 and Input.is_action_just_pressed("jump") and abs(direction) > 0.2:
			#velocity.y = jump_velocity- gravity
			#walljump = false
		anim.play("spin")
	else:
		walljump = true
		if Input.is_action_pressed("down"):
			$CollisionShape2D.scale = Vector2(0.7,0.7)
			$CollisionShape2D.position =Vector2(0,4)
			if velocity.x >0.2:
				anim.play("crawlright")
			elif velocity.x < -0.2:
				anim.play("crawlleft")
			else:
				anim.play("crouch")
		else:
			$CollisionShape2D.scale = Vector2(0.8,1)
			$CollisionShape2D.position =Vector2(0,0.5)
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
	
	for i in get_slide_collision_count():
		var im = get_slide_collision(i).get_collider()
		if im.is_in_group("weighted") and Input.is_action_pressed("pick") and carried == null:
			var x = 3
			carried = im
			carried.set_collision_layer_value(2,false)
	
	if Input.is_action_just_pressed("reset"):
		die()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if "id" in area:
		if area.id == "level_loader":
			area.call_deferred("loadlevel")
			gravity = 5
			jump_velocity = -200
			if snapback_automatic:
				pos_buffer.clear()
			else:
				pos_buffer.resize(snapback_length+2)
			area.get_parent().call_deferred("queue_free")
		elif area.id == "spring":
			spring_sfx.play()
			gravity -= 1
			if gravity <5:
				gravity = 5
			jump_velocity -= 100
			area.get_parent().call_deferred("queue_free")
		elif area.id == "hazard":
			die()

func _draw() -> void:
	if pos_buffer.size() > 0:
		if not snapback_automatic:
			if pos_buffer.size() < snapback_length -1:
				draw_circle(to_local(pos_buffer[0]) ,10,Color(1,0,0,1))
			elif not pos_buffer.size() > snapback_length:
				draw_circle(to_local(pos_buffer[0]) ,10,Color(0,1,0,1))
		else:
			draw_circle(to_local(pos_buffer[0]) ,10,Color(1,0,0,1))
func Setup(pos:Vector2,boundstart:Vector2,boundend:Vector2):
	global_position = pos
	#boundstart = Vector2(200,300)
	$Camera2D.limit_left = boundstart.x
	$Camera2D.limit_top = boundstart.y
	$Camera2D.limit_right = boundend.x
	$Camera2D.limit_bottom = boundend.y
func die():
	var main_menu = load("res://scenes/main_menu.tscn")
	var instance = main_menu.instantiate()
	get_tree().get_root().get_child(0).add_sibling(instance)
	get_tree().get_root().get_child(0).call_deferred("queue_free")
