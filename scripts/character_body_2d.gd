extends CharacterBody2D

@export var gravity_growth:float = 0.01
var gravity:float = 5.0
var total_gravity # jump_velocity is beleszámít
@export var base_speed = 150.0
var speed = base_speed
var acceleration = 50
var jump_velocity = -200.0
var start_gravity
var star_jump
var can_walljump = false
var walljump = true
@onready var death_by_gravity = $DeathByGravity
@onready var death_sfx = $Death
@onready var spring_sfx = $spring
@onready var jump_sfx = $AudioStreamPlayerJump
@onready var walk_sfx = $AudioStreamPlayerWalk
@onready var thump_sfx = $AudioStreamPlayerThump
@onready var door_open_sfx = $AudioStreamPlayerDoorOpen
@onready var anim = $AnimatedSprite2D
@onready var bg_music_1 =$music
@onready var bg_music_2 =$Ekimusic
@export var snapback_length = 60 # in buffer_size mult
#multiply it by interwal to get length i second
@export var snapback_automatic = true
var snapback_interwal = 2 #in frames
var snapback_counter=0
var id = "player"
var pos_buffer:PackedVector2Array
var death = false
var current_lvl:int

var respawn_delay_timer = -1

@onready var carried:CharacterBody2D
@onready var touched:CharacterBody2D
func _ready() -> void:
	bg_music_1.play()
	start_gravity=gravity
	star_jump=jump_velocity
	set_physics_process(true)
	
	if snapback_automatic:
		pos_buffer.resize(snapback_length)
	else:
		pos_buffer.resize(snapback_length+2)
	pos_buffer.fill(to_global(position) )
func _process(delta: float) -> void:
	queue_redraw()
	get_tree().call_group("weighted","SetGravity",gravity)
	get_tree().call_group("weighted","SetEff",total_gravity)
	
	get_tree().call_group("playerseeker","SetPos",global_position)
	#if respawn_delay_timer > -1:
	respawn_delay_timer -= delta
	if respawn_delay_timer < 0 and death:
		respawn_delay_timer = -1
		set_physics_process(true)
		anim.modulate = Color(1, 1, 1, 1)
		death = false
		#bg_music_1.stop()
		#bg_music_2.stop()
		#if current_lvl%2 ==0:
		#	bg_music_1.play()
		#	bg_music_2.stop()
		#else:
		#	bg_music_1.stop()
		#	bg_music_2.play()
		get_tree().call_group("manager","ChangeScene",current_lvl,Vector2(0,0))


func _physics_process(_delta):
	var direction := Input.get_axis("left", "right")
	gravity += gravity_growth
	if carried != null:
		carried.global_position = global_position +Vector2(0,-20) 
		carried.velocity = Vector2.ZERO
		if not Input.is_action_pressed("pick"):
			carried.global_position = global_position
			if direction == 0:
				carried.velocity += Vector2(0,-150 -100*total_gravity)
			else:
				carried.velocity += Vector2(300*direction,-50)
			carried = null
	else:
		if Input.is_action_pressed("pick") and touched !=null:
			carried = touched
			carried.get_child(2).set_collision_layer_value(1,false)
	total_gravity = ((gravity - 5) / abs(jump_velocity / 2)) * 10 #jump_velocity is half effective, multiplied by 10 to apply to scale easily
	if total_gravity >= 2:
		die(0.2,false)
	elif total_gravity >= 1: #gradual effects here
		scale.y = 1 - (total_gravity - 1) / 2
		speed = base_speed - (total_gravity - 1) * 100
	else:
		speed = base_speed
		scale.y = 1
	
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
		if can_walljump and walljump and velocity.x ==0 and Input.is_action_just_pressed("jump") and abs(direction) > 0.2:
			velocity.y = jump_velocity- gravity
			jump_sfx.play()
			walljump = false
		anim.play("spin")
	else:
		walljump = true
		if Input.is_action_pressed("down"):
			set_collision_mask_value(4,false)
			$CollisionShape2D.scale = Vector2(0.7,0.7)
			$CollisionShape2D.position =Vector2(0,4)
			if velocity.x >0.2:
				anim.play("crawlright")
			elif velocity.x < -0.2:
				anim.play("crawlleft")
			else:
				anim.play("crouch")
		else:
			set_collision_mask_value(4,true)
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
		jump_sfx.play()

	if direction:
		if walk_sfx.playing:
			if not is_on_floor():
				walk_sfx.stop()
			if abs(velocity.x) < 0.2:
				walk_sfx.stop()
		elif not walk_sfx.playing and is_on_floor() and abs(velocity.x) > 0.2:
			walk_sfx.play()
		velocity.x = move_toward(velocity.x, direction * speed, acceleration)
	else:
		if walk_sfx.playing:
			walk_sfx.stop()
		velocity.x = move_toward(velocity.x, 0, acceleration)
	move_and_slide()
	
	for i in get_slide_collision_count():
		var im = get_slide_collision(i).get_collider()
		#if im.is_in_group("weighted") and Input.is_action_pressed("pick") and carried == null:
			#carried = im
			#carried.set_collision_layer_value(2,false)
	
	if Input.is_action_just_pressed("reset"):
		die(0.05,true)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if "id" in area:
		if area.id == "level_loader":
			start_gravity = area.gravity_
			
			star_jump = area.jump_velocty
			gravity = start_gravity
			jump_velocity = star_jump
			current_lvl = area.lvl
			velocity = Vector2.ZERO
			if snapback_automatic:
				pos_buffer.clear()
			else:
				pos_buffer.resize(snapback_length+2)
			#area.call_deferred("loadlevel")
			#area.get_parent().call_deferred("queue_free")
			door_open_sfx.play()
			die(1,true)
		elif area.id == "spring":
			spring_sfx.play()
			gravity -= 1
			if gravity <5:
				gravity = 5
			jump_velocity -= 100
			area.get_parent().call_deferred("queue_free")
		elif area.id == "hazard":
			die(0.5,false)
		else:
			thump_sfx.play()
	
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
func die(timeRRR:float,wins:bool):
		if jump_sfx.playing:
			jump_sfx.stop()
		if walk_sfx.playing:
			walk_sfx.stop()
		gravity = start_gravity
		jump_velocity = star_jump
		speed = base_speed
		total_gravity = 0
		scale.y = 1
		velocity = Vector2.ZERO
		#get_tree().call_group("manager","ChangeScene",current_lvl,Vector2(0,0) )
		respawn_delay_timer = timeRRR
		death = true
		if wins:
			anim.modulate = Color(0, 0, 0, 0)
		else:
			if total_gravity >= 2:
				death_by_gravity.play()
			else:
				death_sfx.play()
			anim.play("HeavyIsDead")
		set_physics_process(false)
		#

	#var main_menu = load("res://scenes/main_menu.tscn")
	#var instance = main_menu.instantiate()
	#get_tree().get_root().get_child(0).add_sibling(instance)
	#get_tree().get_root().get_child(0).call_deferred("queue_free")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "id" in body:
		if body.id == "box":
			#if Input.is_action_pressed("pick") and carried == null:
			touched = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if "id" in body:
		if body.id == "box":
			#if Input.is_action_pressed("pick") and carried == null:
			touched = null
