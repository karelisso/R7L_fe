extends Node2D
@export var gravity:float
@onready var text:Label = $CanvasLayer/Label
func _init():
	return
func _process(delta: float) -> void:
	text.text = str(gravity) 
