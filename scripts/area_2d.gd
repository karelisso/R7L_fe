extends Area2D

@export var id = "level_loader"

#the next level loaded
@export	var lvl:int
#set position for the next level
@export var pos_x:int =50
@export var pos_y:int =50
signal LoadLevel
func loadlevel():
	get_tree().call_group("manager",
	"ChangeScene",lvl,pos_x,pos_y)
	
