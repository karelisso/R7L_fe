extends Area2D

@export var id = "level_loader"

#the next level loaded
@export	var lvl:int
#set position for the next level
@export var pos_x:int =0
@export var pos_y:int =0
@export var gravity_ =5.0
@export var jump_velocty = -200
@export var door:AnimatedSprite2D
#signal LoadLevel
func  _ready() -> void:
	if door != null:
		door.play("wait") 
func loadlevel():
	get_tree().call_group("manager",
	"ChangeScene",lvl,Vector2(pos_x,pos_y) )
	


func _on_body_entered(body: Node2D) -> void:
	if "id" in body:
		if body.id == "player":
			if door != null:
				door.play("open")
