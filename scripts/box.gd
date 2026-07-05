extends CharacterBody2D
var gravity: float
@export var id = "box"
@export var weight:float = 3
var gr = false
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		gr = false
		velocity.y += gravity
	elif not gr:
		$CharacterBody2D.set_collision_layer_value(1,true)
		gr = true
	velocity.x = move_toward(velocity.x,0,10)
	
	move_and_slide()
	for i in get_slide_collision_count():
		var im = get_slide_collision(i).get_collider()
		if "id" in im and im.id == "player":
			velocity.x = 100
func _on_area_2d_area_entered(area: Area2D) -> void:
	var i = 2
	if "dummy_weight" in area:
		area.dummy_weight = gravity*weight

func SetGravity(f:float):
	gravity = f
