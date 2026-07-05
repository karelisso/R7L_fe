extends Area2D

@export var id = "level_loader"

#the next level loaded
@export	var lvl:int
#set position for the next level
@export var pos_x:int =0
@export var pos_y:int =0
@export var gravity_ =5.0
@export var jump_velocty = -200

#signal LoadLevel
func loadlevel():
	get_tree().call_group("manager",
	"ChangeScene",lvl,Vector2(pos_x,pos_y) )
	
