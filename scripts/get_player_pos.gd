extends TileMapLayer
#@export_flags_2d_physics var player_layer_bit: int = 3
var Ppos
func SetPos(pos:Vector2):
	Ppos = pos
	var shader_material = self.material as ShaderMaterial
	shader_material.set_shader_parameter("player_position", pos)
