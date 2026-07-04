extends TileMapLayer

func SetPos(pos:Vector2):
	var shader_material = self.material as ShaderMaterial
	shader_material.set_shader_parameter("player_position", pos)
