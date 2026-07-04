extends Node2D

func _ready() -> void:
	var rect_shape = $Area2D/CollisionShape2D.shape as RectangleShape2D
		# 1. Get the half-size (extents) of the rectangle
	var extents = rect_shape.size / 2.0
		
		# 2. Find the global center point of the collision shape
	var center = $Area2D/CollisionShape2D.global_position
	# Rectangle size property represents half-extents, so multiply by 2
	#Rect2(Vector2(int(center.x + extents.x),int(center.y - extents.y)),Vector2(int(center.y - extents.y),int(center.y + extents.y)))
		#limit_left = int(center.x - extents.x)
		#limit_right = int(center.x + extents.x)
		#limit_top = int(center.y - extents.y)
		#limit_bottom = int(center.y + extents.y)
	# Transform the calculated bounds into global coordinate space
	print("yiipe")
	get_tree().call_group("player","Setup",global_position,Vector2(int(center.x - extents.x),int(center.y - extents.y)),Vector2(int(center.x + extents.x),int(center.y + extents.y)))
