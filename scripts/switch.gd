extends Area2D
@export var min_range:int
@export var max_range:int
@export var permament:bool
var solved:bool = false
@export var door:StaticBody2D
@onready var anim = $AnimatedSprite2D
var dummy_weight = 0.0
var pushed:bool =false
func _physics_process(delta: float) -> void:
	#dummy_weight += 0
	
	var overlapping_things = get_overlapping_bodies()
	# 2. Check if that list has anything in it
	if overlapping_things.size() > 0:
		dummy_weight =0
		pushed = false
		for i in overlapping_things:
			if i.is_in_group("box"):
				dummy_weight = gravity * i.weight
				pushed = true
	else:
		dummy_weight = 0
		pushed = false
	door.set_collision_layer_value(2,true)
	door.set_collision_layer_value(1,true)
	
	#if dummy_weight > 100:
	#	dummy_weight = 0
	if pushed:
		if gravity < min_range:
			anim.play('lightpush')
		if gravity > max_range and max_range > min_range:
			anim.play("heavypush")
		if ( gravity < max_range or min_range > max_range ) and gravity > min_range:
			if permament:
				anim.play("permamentpush")
				solved = true
			else:
				anim.play("goodpush")
			door.set_collision_layer_value(2,false)
			door.set_collision_layer_value(1,false)
		if solved:
			anim.play("permamentpush")
			door.set_collision_layer_value(2,false)
			door.set_collision_layer_value(1,false)
	else:		
		if gravity < min_range:
			anim.play('light')
		if gravity > max_range and max_range > min_range:
			anim.play("heavy")
		if ( gravity < max_range or min_range > max_range ) and gravity > min_range:
			anim.play("goood")
			door.set_collision_layer_value(2,false)
			door.set_collision_layer_value(1,false)
		if solved:
			anim.play("permament")
			door.set_collision_layer_value(2,false)
			door.set_collision_layer_value(1,false)
		
func _on_body_entered(body: Node2D) -> void:
	# Check if the thing that stepped on the switch is in our box group
	var smt  =10
	if body.is_in_group("boxes"):
		dummy_weight = gravity
	else:
		dummy_weight = 0

func SetGravity(f:float):
	gravity = f
